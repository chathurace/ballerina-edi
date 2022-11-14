import ballerina/io;
import ballerina/test;
import ballerina/regex;
import edi;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("Starting codegen tests...");
}

// Test function

@test:Config {}
function testFieldGeneration() {
    BalField b1 = new(BSTRING, "firstName", false, true);
    test:assertEquals(b1.toString(false), "string firstName?;");

    BalField b2 = new(BSTRING, "employeeNames", true, true);
    test:assertEquals(b2.toString(false), "string[] employeeNames?;");
    io:println(b2.toString(false));

    BalField b3 = new(BINT, "age", false, false);
    test:assertEquals(b3.toString(false), "int age;");
}

// Negative Test function

@test:Config {}
function testBasicRecordGeneration() {
   BalRecord r1 = new("Person");
   r1.addField(BSTRING, "name", false, false);
   r1.addField(BINT, "age", false, false);
   r1.addField(BSTRING, "contact", true, true);
   io:println(r1.toString(false));
}

@test:Config {}
function testComplexRecordGeneration() {
   BalRecord r1 = new("Person");
   r1.addField(BSTRING, "name", false, false);
   r1.addField(BINT, "age", false, false);
   r1.addField(BSTRING, "contact", true, true);

   BalRecord r2 = new ("Team");
   r2.addField(BSTRING, "teamName", false, false);
   r2.addField(r1, "lead", false, true);
   r2.addField(r1, "members", true, false);
   r2.addField(r2, "subteams", true, true);
   r2.addField(BSTRING, "location", false, true);

   string expected = "type Team record {| string teamName; Person lead?; Person[] members; Team[] subteams?; string location?;|};";
   string output = regex:replaceAll(r2.toString(), "\n", "");
   output = regex:replaceAll(output, "   ", " ");
   test:assertEquals(output, expected);
}

@test:Config {}
function testCodeGenForMapping1() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/sample1/edi-mapping1.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
    check generateCodeToFile(mapping, "modules/codegen/resources/sample1/mapping1-records.bal");
}

@test:Config {}
function testCodeGenForMapping2() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/sample2/edi-mapping2.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
    check generateCodeToFile(mapping, "modules/codegen/resources/sample2/mapping2-records.bal");
}

@test:Config {}
function testCodeGenForMapping5() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/sample5/edi-mapping5.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
    check generateCodeToFile(mapping, "modules/codegen/resources/sample5/mapping5-records.bal");
}

@test:Config {}
function testCodeGenForD3A_Invoic_Mapping() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/d3a-invoic-1/mapping.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
    check generateCodeToFile(mapping, "modules/codegen/tests/d3a-invoic-1-mapping-records.bal");
}

@test:Config {}
function testSample5_Codegen() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/sample5/edi-mapping5.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);
    
    string ediText = check io:fileReadString("modules/codegen/resources/sample5/edi-sample5.edi");
    json output = check edi:readEDIAsJson(ediText, mapping);

    DetailedOrder detailedOrder = check output.cloneWithType(DetailedOrder);
    test:assertEquals(detailedOrder.items[0].supplier?.supplierCode, "S-10");
}

@test:Config {}
function testINVOIC_D93a_Codegen() returns error? {
    json mappingText = check io:fileReadJson("modules/codegen/resources/d3a-invoic-1/mapping.json");
    edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);
    
    string ediText = check io:fileReadString("modules/codegen/resources/d3a-invoic-1/input.edi");
    json outputJson = check edi:readEDIAsJson(ediText, mapping);

    INVOIC invoice = check outputJson.cloneWithType(INVOIC);
    test:assertEquals(invoice.Segment_Group_45[0].Monetary_amount.MONETARY_AMOUNT?.Monetary_amount, "274,16");
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("Completed codegen tests.");
}
