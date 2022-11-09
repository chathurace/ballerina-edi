import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function

@test:Config {}
function testFunction() returns error? {
    check processMapping("modules/mapgen/resources/d3a-invoic-1/mapping.xml", 
        "modules/mapgen/resources/d3a-invoic-1/mapping.json");
    json generatedMapping = check io:fileReadJson("modules/mapgen/resources/d3a-invoic-1/mapping.json");
    json expectedMapping = check io:fileReadJson("modules/mapgen/resources/d3a-invoic-1/expected-mapping.json");
    test:assertEquals(generatedMapping, expectedMapping);
}


// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}