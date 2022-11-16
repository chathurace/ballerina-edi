import ballerina/io;
import chathurace/edi;

public function main() returns error? {
    json mappingJson = check io:fileReadJson("resources/edi-mapping1.json");
    edi:EDIMapping mapping = check mappingJson.cloneWithType(edi:EDIMapping);

    string ediText = check io:fileReadString("resources/edi-sample1.edi");
    json orderData = check edi:readEDIAsJson(ediText, mapping);

    SimpleOrder order1 = check orderData.cloneWithType(SimpleOrder);
    io:println("Order date: " + (order1.header.date?:"Not given"));
}
