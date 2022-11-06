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
    check processMapping("resources/d3a-invoic-1/mapping.xml", 
        "resources/d3a-invoic-1/mapping.json");
}

// Negative Test function

@test:Config {}
function negativeTestFunction() {
    
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
