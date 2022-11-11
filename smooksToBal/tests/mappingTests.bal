import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("Starting smooks to Ballerina mapping tests...");
}

// Test function

@test:Config {}
function testFunction() returns error? {
    check processMapping("resources/d3a-invoic-1/mapping.xml", 
        "resources/d3a-invoic-1/mapping.json");
    json generatedMapping = check io:fileReadJson("resources/d3a-invoic-1/mapping.json");
    json expectedMapping = check io:fileReadJson("resources/d3a-invoic-1/expected-mapping.json");
    test:assertEquals(generatedMapping, expectedMapping);
}


// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("Completed smooks to Ballerina mapping tests.");
}
