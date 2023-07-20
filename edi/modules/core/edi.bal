import ballerina/log;
import ballerina/io;

public type ParseConext record {|
    EDISchema ediMapping;
    int rawIndex;
    string[] rawSegments = [];
|};

public function jsonToEDI(EDISchema mapping, json msg) returns string|error {
    return "";
}

public function readEDIAsJson(string ediText, EDISchema mapping) returns json|error {
    log:printDebug(string `Reading EDI text ${ediText.substring(0,30)} ...`);
    EDISegmentGroup ediDoc = check readEDI(ediText, mapping);
    return ediDoc.toJson();
}

public function readEDI(string ediText, EDISchema ediMapping) returns EDISegmentGroup|error {
    EDIUnitSchema[] currentMapping = ediMapping.segments;
    // string preparedEDIText = regex:replaceAll(ediText, "\n", "");
    string preparedEDIText = ediText;
    string[] segmentsDesc = splitSegments(preparedEDIText, ediMapping.delimiters.segment);
    ParseConext context = {ediMapping: ediMapping, rawIndex: 0, rawSegments: segmentsDesc};
    EDISegmentGroup rootGroup = check readEDISegmentGroup(currentMapping, context, true);
    return rootGroup;
}

public function readMappingFromFile(string filePath) returns EDISchema|error {
    json mappingJson = check io:fileReadJson(filePath);
    EDISchema mapping = check mappingJson.cloneWithType(EDISchema);
    return mapping;
}

public function readMappingFromString(string mappingString) returns EDISchema|error {
    io:StringReader sr = new(mappingString);
    json mappingJson = check sr.readJson();
    EDISchema mapping = check mappingJson.cloneWithType(EDISchema);
    return mapping;
}
