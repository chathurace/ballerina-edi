import ballerina/io;
import ballerina/test;

@test:Config {}
function test_EDIFACT_D3A_Invoice() returns error? {
    check processMapping("resources/mapgen/d3a-invoic-1/mapping.xml", 
        "resources/mapgen/d3a-invoic-1/mapping.json");
    json generatedMapping = check io:fileReadJson("resources/mapgen/d3a-invoic-1/mapping.json");
    json expectedMapping = check io:fileReadJson("resources/mapgen/d3a-invoic-1/expected-mapping.json");
    test:assertEquals(generatedMapping, expectedMapping);
}

