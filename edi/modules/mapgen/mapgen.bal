// import ballerina/xmldata;
import edi;
import ballerina/io;

xmlns "http://www.milyn.org/schema/edi-message-mapping-1.5.xsd" as s;

public function processMapping(string xmlMappingPath, string jsonOutputPath) returns error? {
    xml xmap = check io:fileReadXml(xmlMappingPath);
    edi:EDIMapping edimap = check transformEDIMapping(xmap);
    check io:fileWriteJson(jsonOutputPath, edimap.toJson());
}

public function transformEDIMapping(xml xmlMapping) returns edi:EDIMapping|error {
    xml delimiters = xmlMapping/<s:delimiters>;
    edi:EDIMapping mapping = {delimiters: {segment: check delimiters.segment, element: check delimiters.'field, subelement: check delimiters.component, repetition: "^"}};
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

function readSegmentMapping(xml seg) returns edi:EDISegMapping|error {
    edi:EDISegMapping segmap = {code: check seg.segcode, tag: check seg.xmltag};
    string|error minOccurs = seg.minOccurs;
    if minOccurs is string {
        segmap.minOccurances = check int:fromString(minOccurs);
    }
    string|error maxOccurs = seg.maxOccurs;
    if maxOccurs is string {
        segmap.maxOccurances = check int:fromString(maxOccurs);
    }

    xml fields = seg/<s:'field>;
    foreach xml f in fields {
        edi:EDIElementMapping emap = {tag: check f.xmltag};
        var dataType = f.dataType;
        if dataType is error {
            // this can be a composite field
            xml components = f/<s:component>;
            foreach xml component in components {
                edi:EDISubelementMapping submap = 
                    {tag: check component.xmltag, dataType: edi:getDataType(check component.dataType)};   
                emap.subelements.push(submap); 
            } 
        } else {
            // this is a simple type element
            emap.dataType = edi:getDataType(dataType);
        }
        segmap.elements.push(emap);
    }
    return segmap;
}

function readSegmentGroupMapping(xml seg) returns edi:EDISegGroupMapping|error {
    edi:EDISegGroupMapping groupmap = {tag: check seg.xmltag};
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
