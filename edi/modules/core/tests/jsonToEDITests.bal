import ballerina/test;
import ballerina/io;

@test:Config {}
function testJ2ESample1() returns error? {
    json mappingText = check io:fileReadJson("resources/sample1/edi-mapping1.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    EDIWriter ediWriter = new(mapping);

    json inputMsg = check io:fileReadJson("resources/sample1/expected-1.json");
    string ediText = check ediWriter.writeEDI(inputMsg);
    io:println(ediText);
    
    // string ediText = check io:fileReadString("resources/sample5/edi-sample5.edi");
    // json output = check readEDIAsJson(ediText, mapping);

    
    // test:assertEquals(output, inputMsg, "Output json does not match the expected json.");
}

@test:Config {}
function testJ2ESample2_1() returns error? {
    json mappingText = check io:fileReadJson("resources/sample2_1/edi-mapping2.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    EDIWriter ediWriter = new(mapping);

    json inputMsg = check io:fileReadJson("resources/sample2_1/expected-2.json");
    string ediText = check ediWriter.writeEDI(inputMsg);
    io:println(ediText);
}

@test:Config {}
function testJ2ESample2_2() returns error? {
    json mappingText = check io:fileReadJson("resources/sample2/edi-mapping2.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    EDIWriter ediWriter = new(mapping);

    json inputMsg = check io:fileReadJson("resources/sample2/expected-2.json");
    string ediText = check ediWriter.writeEDI(inputMsg);
    io:println(ediText);
}

@test:Config {}
function testJ2ESample4() returns error? {
    json mappingText = check io:fileReadJson("resources/sample5/edi-mapping5.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    EDIWriter ediWriter = new(mapping);

    json inputMsg = check io:fileReadJson("resources/sample5/expected-5.json");
    string ediText = check ediWriter.writeEDI(inputMsg);
    io:println(ediText);
}