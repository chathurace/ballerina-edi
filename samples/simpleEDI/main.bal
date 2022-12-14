import ballerina/io;
import chathurace/edi.core as edi;

public function main() returns error? {
    edi:EDIMapping mapping = check edi:readMappingFromFile("resources/edi-mapping1.json");

    string ediText = check io:fileReadString("resources/edi-sample1.edi");
    json orderData = check edi:readEDIAsJson(ediText, mapping);
    io:println(orderData.toJsonString());

    SimpleOrder order1 = check orderData.cloneWithType(SimpleOrder);
    io:println(order1.header.date);
}
