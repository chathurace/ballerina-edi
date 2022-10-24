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


