import ballerina/log;
import ballerina/regex;
import ballerina/io;
import chathurace/edi.core as edi;

xmlns "http://www.milyn.org/schema/edi-message-mapping-1.5.xsd" as s;

public function processMapping(string xmlMappingPath, string jsonOutputPath) returns error? {
    xml xmap = check io:fileReadXml(xmlMappingPath);
    edi:EDIMapping edimap = check transformEDIMapping(xmap);
    check io:fileWriteJson(jsonOutputPath, edimap.toJson());
}

public function transformEDIMapping(xml xmlMapping) returns edi:EDIMapping|error {
    log:printInfo("*** Note: Mapping for sub-components are not currently supported. ***");
    xml rootSeg = xmlMapping/<s:segments>;
    string name = deriveTag(null, edi:getString(rootSeg.xmltag, "Mapping"));
    xml delimiters = xmlMapping/<s:delimiters>;
    edi:EDIMapping mapping = {name: name, delimiters: {segment: check delimiters.segment, 'field: check delimiters.'field, component: check delimiters.component, subcomponent: edi:getString(delimiters.subcomponent, "NOT_USED"), repetition: edi:getString(delimiters.repetition, "NOT_USED")}};
    xml segments = xmlMapping/<s:segments>/*;
    foreach xml seg in segments {
        if seg is xml:Element {
            if seg.getName().endsWith("segment") {
                edi:EDISegMapping segmap = check readSegmentMapping(seg);
                mapping.segments.push(segmap);
            } else if seg.getName().endsWith("segmentGroup") {
                edi:EDISegGroupMapping segmap = check readSegmentGroupMapping(seg);
                mapping.segments.push(segmap);
            }
        }
    }
    return mapping;
}

function deriveTag(map<int>? tagCounts, string tag) returns string {
    string newTag = tag;
    if tagCounts is map<int> {
        int? count = tagCounts[tag];
        if count is int {
            int newCount = count + 1;
            tagCounts[tag] = newCount;
            newTag = string `${tag}_${newCount}`;
        } else {
            tagCounts[tag] = 0;
            newTag = tag;
        }
    }

    // make the tag name compatible with Ballerina field names. this is required for code generation.
    newTag = regex:replaceAll(newTag, "\\.", "_");
    newTag = regex:replaceAll(newTag, "\\-", "_");
    return newTag;
}

function readSegmentMapping(xml seg) returns edi:EDISegMapping|error {
    edi:EDISegMapping segmap = {code: check seg.segcode, tag: deriveTag(null, check seg.xmltag)};
    string|error minOccurs = seg.minOccurs;
    if minOccurs is string {
        segmap.minOccurances = check int:fromString(minOccurs);
    }
    string|error maxOccurs = seg.maxOccurs;
    if maxOccurs is string {
        segmap.maxOccurances = check int:fromString(maxOccurs);
    }

    map<int> fieldTagCounts = {};
    xml fields = seg/<s:'field>;
    foreach xml f in fields {
        edi:EDIFieldMapping emap = {tag: deriveTag(fieldTagCounts, check f.xmltag)};

        // if this field has components, map them as subelements.
        xml components = f/<s:component>;
        map<int> subelementTagCounts = {};
        foreach xml component in components {
            edi:EDIComponentMapping submap = 
                {tag: deriveTag(subelementTagCounts, check component.xmltag), dataType: getDataTypeForSmooksType(check component.dataType)};   
            emap.components.push(submap); 
        } 

        // if no subelements have been found, this should be a basic field
        if emap.components.length() == 0 {
            var dataType = f.dataType;
            if dataType is string {
                emap.dataType = getDataTypeForSmooksType(dataType);   
            } else {
                log:printDebug(string `Data type not provided for ${emap.tag} in ${segmap.code} Mapping it as a string type... `);   
                emap.dataType = getDataTypeForSmooksType("string");   
            }
        } else {
            emap.dataType = edi:COMPOSITE;
        }

        segmap.fields.push(emap);
    }
    return segmap;
}

function readSegmentGroupMapping(xml seg) returns edi:EDISegGroupMapping|error {
    string sgTag = "SegmentGroup";
    string|error groupTag = seg.xmltag;
    if groupTag is string {
        sgTag = groupTag;
    }
    edi:EDISegGroupMapping groupmap = {tag: deriveTag(null, sgTag)};
    string|error minOccurs = seg.minOccurs;
    if minOccurs is string {
        groupmap.minOccurances = check int:fromString(minOccurs);
    }
    string|error maxOccurs = seg.maxOccurs;
    if maxOccurs is string {
        groupmap.maxOccurances = check int:fromString(maxOccurs);
    }

    xml chileSegments = seg/*;
    foreach xml s in chileSegments {
        if s is xml:Element {
            if s.getName().endsWith("segment") {
                edi:EDISegMapping segmap = check readSegmentMapping(s);
                groupmap.segments.push(segmap);
            } else if s.getName().endsWith("segmentGroup") {
                edi:EDISegGroupMapping segmap = check readSegmentGroupMapping(s);
                groupmap.segments.push(segmap);
            }
        }
    }
    return groupmap;
}
