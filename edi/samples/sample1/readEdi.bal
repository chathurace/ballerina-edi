import ballerina/io;
import chathurace/edi;

public function main() {

    json|error mappingText = io:fileReadJson("edi-mapping1.json");
    if (mappingText is json) {
        edi:EDIMapping|error mapping = edi:loadMapping(mappingText);
        if (mapping is edi:EDIMapping) {
            string|error ediText = io:fileReadString("edi-sample1.edi");
            if (ediText is string) {
                edi:EDIDoc|error doc = edi:readEDI(ediText, mapping);
                if (doc is edi:EDIDoc) {
                    io:println(doc.toJson());
                    edi:EDISegment|edi:EDISegment[]? segments = doc["items"];
                    if (segments is edi:Segment[]) {
                        foreach edi:Segment r in segments {
                            r["quantity"] = 12;
                        }
                    }
                    io:println(doc.toJson());
                }
            }
            
        }
    }
}
