import chathurace/edi.core as edi;

type SegGroupLevel record {|
    int level;
    edi:EDISegGroupSchema segGroup;
|};

final int tagSpaces = 2;

public function eslToBal(string[] esl, map<edi:EDISegSchema> segMap) returns edi:EDISchema|error  {
    map<int> segGroupNameCount = {};
    map<int> segNameCount = {};
    SegGroupLevel[] openSegGroups = [];
    edi:EDISchema ediMapping = {name: "NOT_ASSIGNED", delimiters: {segment: "~", 'field: "*", component: ""}};
    int i = 0;
    while i < esl.length() {
        string currentLine = esl[i];
        int level = getLevel(currentLine);
        string line = currentLine.trim();
        if line.startsWith("name:") {
            string name = getStringValue(line);
            name = getBalCompatibleName(name);
            ediMapping.name = name;
        } else if line.startsWith("- groupId") {
            string name = getStringValue(line);
            name = getBalCompatibleName(name);
            name = deriveTag(segGroupNameCount, name);
            edi:EDISegGroupSchema currentSegGroup = {tag: name};

            string countLine = esl[i+1].trim();
            if (countLine.startsWith("count:")) {
                string sCount = getStringValue(countLine);
                if sCount == ">1" {
                    currentSegGroup.maxOccurances = -1;
                } else {
                    var c = int:fromString(sCount);
                    if c is int {
                        currentSegGroup.maxOccurances = c;
                    } else {
                        return error(string `Invalid value given for segment group count. Segment group: ${name}, Given count value: ${sCount}`);
                    }
                }
            }
            SegGroupLevel currentSegGroupLevel = {level: level, segGroup: currentSegGroup};

            // find the parent segment group, if any
            boolean parentFound = false;
            while !parentFound && openSegGroups.length() > 0 {
                SegGroupLevel lastOpenSegGroup = openSegGroups.pop();
                if level <= lastOpenSegGroup.level {
                    continue;
                }

                // found parent
                lastOpenSegGroup.segGroup.segments.push(currentSegGroup);
                openSegGroups.push(lastOpenSegGroup);
                openSegGroups.push(currentSegGroupLevel);
                parentFound = true;
            }

            if !parentFound {
                openSegGroups.push(currentSegGroupLevel);
                ediMapping.segments.push(currentSegGroup);
            }

        } else if line.startsWith("- { idRef:") {
            edi:EDISegSchema seg = check processSegment(line, segMap);
            // In ESL, it is not possible to have the same segment twice in the same group.
            // So we can just use the segment name as the tag.
            // seg.tag = deriveTag(segNameCount, seg.tag);
            boolean parentFound = false;
            while !parentFound && openSegGroups.length() > 0 {
                SegGroupLevel lastOpenSegGroup = openSegGroups.pop();
                if level <= lastOpenSegGroup.level {
                    continue;
                }

                // found parent
                lastOpenSegGroup.segGroup.segments.push(seg);
                openSegGroups.push(lastOpenSegGroup);
                parentFound = true;
            }

            if !parentFound {
                ediMapping.segments.push(seg);
            }
        }
        i += 1;
    }
    return ediMapping;
}

function processSegment(string line, map<edi:EDISegSchema> segMap) returns edi:EDISegSchema|error {

    map<string> segdata = processValueLine(line);
    string? segCode = segdata["idRef"];
    if segCode is string {
        edi:EDISegSchema? ediSeg = segMap[segCode];
        if (ediSeg is null) {
            return error("Unknown EDI segment: " + segCode);
        } else {
            edi:EDISegSchema seg = ediSeg.clone();
            int minOccur = segdata["usage"] == "M" ? 1 : 0;
            seg.minOccurances = minOccur;
            string? sCount = segdata["count"];
            if sCount is string {
                if sCount == ">1" {
                    seg.maxOccurances = -1;
                } else {
                    var c = int:fromString(sCount);
                    if c is int {
                        seg.maxOccurances = c;
                    } else {
                        return error(string `Invalid value given for segment count. Segment: ${seg.tag}, Given count value: ${sCount}`);
                    }
                }
            }
            return seg;
        }
    }
    return error("Not implemented");
}

