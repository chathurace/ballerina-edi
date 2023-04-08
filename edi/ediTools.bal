import ballerina/io;
import chathurace/edi.core as edi;
import chathurace/edi.codegen;
import edi.esl;
import ballerina/file;
import edi.libgen;
import chathurace/edi.mapgen;

public function main(string[] args) returns error? {

    string usage = string `Usage:
        Ballerina code generation for edi mapping: java -jar edi.jar codegen <mapping json path> <output bal file path>
        Smooks to json mapping conversion: java -jar edi.jar smooksToBal <smooks mapping xml path> <mapping json path>
        ESL to json mapping conversion: java -jar edi.jar eslToBal <ESL file path or directory> <ESL segment definitions path> <output json path or directory>
        EDI library generation: java -jar edi.jar libgen <org name> <library name> <EDI mappings folder> <output folder>`;
    
    if args.length() == 0 {
        io:println(usage);
        return;
    }

    string mode = args[0].trim();
    if mode == "codegen" {
        if args.length() != 3 {
            io:println(usage);
            return;
        }
        json mappingText = check io:fileReadJson(args[1].trim());
        edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);  
        check codegen:generateCodeToFile(mapping, args[2].trim());    
    } else if mode == "smooksToBal" {
        if args.length() != 3 {
            io:println(usage);
            return;
        }
        check mapgen:processMapping(args[1].trim(), args[2].trim()); 
    } else if mode == "eslToBal" {
        if args.length() != 4 {
            io:println(usage);
            return;
        }
        string eslDataPath = args[1];
        string eslSegmentsPath = args[2];
        string outputPath = args[3];
        if check file:test(eslDataPath, file:IS_DIR) && check file:test(outputPath, file:IS_DIR) {
            string[] segMapData = check io:fileReadLines(eslSegmentsPath);
            map<edi:EDISegMapping> segDefinitions = check esl:readSegmentDefinitions(segMapData);
            file:MetaData[] eslFiles = check file:readDir(eslDataPath);
            foreach file:MetaData eslFile in eslFiles {
                string ediName = check file:basename(eslFile.absPath);
                if ediName.endsWith(".esl") {
                    ediName = ediName.substring(0, ediName.length() - ".esl".length());
                }
                edi:EDIMapping ediMapping = check esl:eslToBal(check io:fileReadLines(eslFile.absPath), segDefinitions);
                string mappingPath = check file:joinPath(outputPath, ediName + ".json");
                check io:fileWriteJson(mappingPath, ediMapping.toJson());
            }
        } else {
            string[] eslData = check io:fileReadLines(eslDataPath);
            string[] segMapData = check io:fileReadLines(eslSegmentsPath);
            map<edi:EDISegMapping> segMap = check esl:readSegmentDefinitions(segMapData);
            edi:EDIMapping ediMapping = check esl:eslToBal(eslData, segMap);
            check io:fileWriteJson(outputPath, ediMapping.toJson());
        }
    } else if mode == "libgen" {
        if args.length() != 5 {
            io:println(usage);
            return;
        }
        string orgName = args[1];
        string libName = args[2];
        string ediMappingFolder = args[3];
        string outputPath = args[4];
        // check libgen:generateLibrary(orgName, libName, ediMappingFolder, outputPath, !excludeMappings);
        libgen:LibGen g = check new(orgName, libName, outputPath, ediMappingFolder, "");
        check g.generateLibrary();
    } else {
        io:println(usage);
    }
}
