import ballerina/io;
import ballerina/test;

@test:Config {}
function testSample1() returns error? {
    json mappingText = check io:fileReadJson("resources/sample1/edi-mapping1.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/sample1/edi-sample1.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/sample1/expected-1.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample2() returns error? {
    json mappingText = check io:fileReadJson("resources/sample2/edi-mapping2.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/sample2/edi-sample2.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/sample2/expected-2.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");

    OrderDetails orderDetails = check output.cloneWithType(OrderDetails);
    test:assertEquals(orderDetails.organization.address.city, "Colombo");
}

@test:Config {}
function testSample3() returns error? {
    json mappingText = check io:fileReadJson("resources/sample3/edi-mapping3.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/sample3/edi-sample3.edi");
    json output = check readEDIAsJson(ediText, mapping);
    check io:fileWriteJson("resources/actual-3.json", output);

    json expected = check io:fileReadJson("resources/sample3/expected-3.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample4() returns error? {
    json mappingText = check io:fileReadJson("resources/sample4/edi-mapping4.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/sample4/edi-sample4.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/sample4/expected-4.json");
    test:assertEquals(output, expected, "Output json does not match the expected json.");
}

@test:Config {}
function testSample5() returns error? {
    json mappingText = check io:fileReadJson("resources/sample5/edi-mapping5.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/sample5/edi-sample5.edi");
    json output = check readEDIAsJson(ediText, mapping);

    json expected = check io:fileReadJson("resources/sample5/expected-5.json");
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



