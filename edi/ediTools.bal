import ballerina/io;
import chathurace/edi.core as edi;
import chathurace/edi.codegen;
import chathurace/edi.mapgen;
public function main(string[] args) returns error? {

    string usage = string `Usage:
        Ballerina code generation for edi mapping: java -jar edi.jar codegen <mapping json path> <output bal file path>
        Smooks to json mapping conversion: java -jar edi.jar smooksToBal <smooks mapping xml path> <mapping json path>`;
    
    if args.length() != 3 {
        io:println(usage);
        return;
    }

    string mode = args[0].trim();
    if mode == "codegen" {
        json mappingText = check io:fileReadJson(args[1].trim());
        edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
        check codegen:generateCodeToFile(mapping, args[2].trim());    
    } else if mode == "smooksToBal" {
        check mapgen:processMapping(args[1].trim(), args[2].trim()); 
    } else {
        io:println(usage);
    }
}