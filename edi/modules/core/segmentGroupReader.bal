import ballerina/log;
import ballerina/regex;

function readSegmentGroup(EDISegGroupMapping currentMapping, string[] rawSegments, int rawIndex, EDIMapping ediMapping) returns [EDISegmentGroup, int]|error {
    log:printDebug(string `Reading segment group ${printSegGroupMap(currentMapping)}`);
    return readEDISegmentGroup(currentMapping.segments, rawSegments, rawIndex, ediMapping);
}

function readEDISegmentGroup(EDIUnitMapping[] currentMapping, string[] rawSegments, int rawIndex, EDIMapping ediMapping) returns [EDISegmentGroup, int]|error {
    int mappingIndex = 0;
    int currentRawIndex = rawIndex;
    EDISegmentGroup currentGroup = {};
    while currentRawIndex < rawSegments.length() {
        string sDesc = rawSegments[currentRawIndex];
        string segmentDesc = regex:replaceAll(sDesc, "\n", "");
        string[] fields = split(segmentDesc, ediMapping.delimiters.'field);
        if ediMapping.ignoreSegments.indexOf(fields[0], 0) != null {
            currentRawIndex += 1;
            continue;
        }

        boolean segmentMapped = false;
        while mappingIndex < currentMapping.length() && !segmentMapped {
            EDIUnitMapping? segMapping = currentMapping[mappingIndex];
            if (segMapping is EDISegMapping) {
                if segMapping.code != fields[0] {
                    if segMapping.minOccurances == 0 {
                        // this is an optional segment. so we can ignore
                        log:printDebug(string `Ignoring optional segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }

                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegment[]) {
                            if segments.length() > 0 {
                                // this repeatable segment has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    } 

                    return error(string `Mandatory segment ${segMapping.code} could not be found.
                    Current segment mapping: ${segMapping.code}
                    Current segment text: ${sDesc}
                    Current mapping index: ${mappingIndex}`);
                }
                currentRawIndex += 1;
                EDISegment ediRecord = check readEDISegment(segMapping, fields, ediMapping, segmentDesc);
                if (segMapping.maxOccurances == 1) {
                    log:printDebug(string `Completed reading non-repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                    mappingIndex += 1;
                    currentGroup[segMapping.tag] = ediRecord;
                } else {
                    var segments = currentGroup[segMapping.tag];
                    if (segments is EDISegment[]) {
                        segments.push(ediRecord);
                    } else if segments is null {
                        segments = [ediRecord];
                        currentGroup[segMapping.tag] = segments;
                    } else {
                        return error(string `${segMapping.code} must be a segment array.`);
                    }
                }
                segmentMapped = true;

            } else if segMapping is EDISegGroupMapping {
                EDIUnitMapping firstSegMapping = segMapping.segments[0];
                if firstSegMapping is EDISegGroupMapping {
                    return error("First item of group must be a segment.");
                }
                if firstSegMapping.code != fields[0] {
                    if segMapping.minOccurances == 0 {
                        // this is an optional segment. so we can ignore
                        log:printDebug(string `Ignoring optional segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }
                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegmentGroup[]) {
                            if segments.length() > 0 {
                                // this repeatable segment group has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    } 
                    return error(string `Mandatory segment group ${printSegGroupMap(segMapping)} could not be found.`);
                }
                segmentMapped = true;
                var [segmentGroup, newRawIndex] = check readSegmentGroup(segMapping, rawSegments, currentRawIndex, ediMapping);
                currentRawIndex = newRawIndex;
                if segmentGroup.length() > 0 {
                    if segMapping.maxOccurances == 1 {
                        log:printDebug(string `Completed reading non-repeating segment group ${printSegGroupMap(segMapping)} | Current segment text: ${segmentDesc}`);
                        mappingIndex += 1;
                        currentGroup[segMapping.tag] = segmentGroup;
                    } else {
                        var segmentGroups = currentGroup[segMapping.tag];
                        if segmentGroups is EDISegmentGroup[] {
                            segmentGroups.push(segmentGroup);
                        } else if segmentGroups is null {
                            segmentGroups = [segmentGroup];
                            currentGroup[segMapping.tag] = segmentGroups;
                        } else {
                            return error(string `${segMapping.tag} must be a segment group array.`);
                        }
                        
                    }
                }
            }
            if currentRawIndex == rawSegments.length() {
                break;
            }
        }
        if mappingIndex == currentMapping.length() {
            break;
        }
    }
    return [currentGroup, currentRawIndex];
}