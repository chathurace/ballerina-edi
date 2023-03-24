import ballerina/io;
import chathurace/edi.core as edi;

public function main() returns error? {
    io:println("Not implemented");

    edi:EDIMapping mapping = check edi:readMappingFromFile("resources/edi-mapping4.json");
    string ediText = check io:fileReadString("resources/edi-sample4.edi");

    json ediJson = check edi:readEDIAsJson(ediText, mapping);

    json items = check ediJson.items;
    if items is json[] {
        io:println(items[0].item);
    }

    DetailedOrderS4 detailedOrder = check ediJson.cloneWithType(DetailedOrderS4);
    Items_GType item0 = detailedOrder.items[0];
    item0.supplier.supplierCode = "S300";
    io:println(detailedOrder.items[0].supplier?.supplierCode);
    io:println(detailedOrder);
}
