import ballerina/io;
import ballerina/test;

@test:Config {}
function testSample1() returns error? {
    json mappingText = check io:fileReadJson("resources/edi-mapping1.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/edi-sample1.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/expected-1.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample2() returns error? {
    json mappingText = check io:fileReadJson("resources/edi-mapping2.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/edi-sample2.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/expected-2.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");

    OrderDetails orderDetails = check output.cloneWithType(OrderDetails);
    test:assertEquals(orderDetails.organization.address.city, "Colombo");
}

@test:Config {}
function testSample3() returns error? {
    json mappingText = check io:fileReadJson("resources/edi-mapping3.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/edi-sample3.edi");
    json output = check readEDIAsJson(ediText, mapping);
    check io:fileWriteJson("resources/actual-3.json", output);

    json expected = check io:fileReadJson("resources/expected-3.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample4() returns error? {
    json mappingText = check io:fileReadJson("resources/edi-mapping4.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/edi-sample4.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/expected-4.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample5() returns error? {
    json mappingText = check io:fileReadJson("resources/edi-mapping5.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/edi-sample5.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/expected-5.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testINVOIC_D93a() returns error? {
    json mappingText = check io:fileReadJson("resources/d3a-invoic-1/mapping.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/d3a-invoic-1/input.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/d3a-invoic-1/expected.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}



