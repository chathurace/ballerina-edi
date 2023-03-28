import ballerina/log;
import ballerina/io;

public type ParseConext record {|
    EDIMapping ediMapping;
    int rawIndex;
    string[] rawSegments = [];
|};

public function readEDIAsJson(string ediText, EDIMapping mapping) returns json|error {
    log:printDebug(string `Reading EDI text ${ediText.substring(0,30)} ...`);
    EDISegmentGroup ediDoc = check readEDI(ediText, mapping);
    return ediDoc.toJson();
}

public function readEDI(string ediText, EDIMapping ediMapping) returns EDISegmentGroup|error {
    EDIUnitMapping[] currentMapping = ediMapping.segments;
    // string preparedEDIText = regex:replaceAll(ediText, "\n", "");
    string preparedEDIText = ediText;
    string[] segmentsDesc = splitAndIgnoreLastEmptyItem(preparedEDIText, ediMapping.delimiters.segment);
    ParseConext context = {ediMapping: ediMapping, rawIndex: 0, rawSegments: segmentsDesc};
    EDISegmentGroup rootGroup = check readEDISegmentGroup(currentMapping, context, true);
    return rootGroup;
}

public function readMappingFromFile(string filePath) returns EDIMapping|error {
    json mappingJson = check io:fileReadJson(filePath);
    EDIMapping mapping = check mappingJson.cloneWithType(EDIMapping);
    return mapping;
}
