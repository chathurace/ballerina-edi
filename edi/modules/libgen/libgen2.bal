import ballerina/io;
import ballerina/file;
import chathurace/edi.core as edi;
import chathurace/edi.codegen;

public class LibGen {

    string orgName = "";
    string libName = "";
    string outputPath = "";
    string schemaPath = "";
    string libPath = "";
    string importsBlock = "";
    string exportsBlock = "";
    string enumBlock = "";
    string selectionBlocks = "";
    string token = "";
    string[] ediNames = [];

    public function init(string orgName, string libName, string outputPath, string schemaPath, string token) returns error? {
        self.orgName = orgName;
        self.libName = libName;
        self.schemaPath = schemaPath;
        self.outputPath = outputPath;
        self.libPath =  check file:joinPath(outputPath, libName);
        self.exportsBlock = "export=[\"" + libName + "\"";
        self.token = token;
    }

    public function generateLibrary() returns error? {
        check self.createLibStructure();
        check self.generateCodeFromFileBasedSchemas();
        check self.createBalLib();
        check generateS3Connector(self.libPath, self.libName);
    }

    function generateCodeFromFileBasedSchemas() returns error? {
        file:MetaData[] mappingFiles = check file:readDir(self.schemaPath);
        foreach file:MetaData mappingFile in mappingFiles {
            string ediName = check file:basename(mappingFile.absPath);
            if ediName.endsWith(".json") {
                ediName = ediName.substring(0, ediName.length() - ".json".length());
            }
            json mappingJson = check io:fileReadJson(mappingFile.absPath);
            check self.generateEDIFileSpecificCode(ediName, mappingJson);
        }
    }

    function createBalLib() returns error? {
        string selectorCode = self.generateLibraryMainCode();
        string mainBalName = check file:joinPath(self.libPath, self.libName + ".bal");
        check io:fileWriteString(mainBalName, selectorCode, io:OVERWRITE);        

        check io:fileWriteString(check file:joinPath(self.libPath, "commonProcessing.bal"), generateGenericProcessors());

        // add export package names to the Ballerina.toml file
        string ballerinaTomlPath = check file:joinPath(self.libPath, "Ballerina.toml");
        self.exportsBlock += "]";
        check io:fileWriteString(ballerinaTomlPath, self.exportsBlock, io:APPEND);
    }

    function generateEDIFileSpecificCode(string ediName, json mappingJson) returns error? {
        self.ediNames.push(ediName);
        edi:EDIMapping ediMapping = check mappingJson.cloneWithType(edi:EDIMapping);

        string modulePath = check file:joinPath(self.libPath, "modules", "m" + ediName);
        check file:createDir(modulePath, file:RECURSIVE);

        string recordsPath = check file:joinPath(modulePath, "G_" + ediName + ".bal");
        check codegen:generateCodeToFile(ediMapping, recordsPath);

        string transformer = self.generateTransformerCode(ediName, ediMapping.name);
        check io:fileWriteString(check file:joinPath(modulePath, "transformer.bal"), transformer);

        self.selectionBlocks += self.generateEDISelectionBlock(ediName, ediMapping.name);
        self.importsBlock += string `
import ${self.libName}.m${ediName};`;
        self.exportsBlock += ",\"" + self.libName + ".m" + ediName + "\"";
        self.enumBlock += string `${self.enumBlock.length() > 0? ", ":""}EDI_${ediName} = "${ediName}"`;    
    }

    function generateLibraryMainCode() returns string {
        string codeBlock = string `
import chathurace/edi.core as edi;
import ballerina/http;
${self.importsBlock}

public enum EDI_NAMES {
    ${self.enumBlock}
}

public class EDIReader {
    string schemaURL = "";
    string schemaAccessToken = "";

    public function init(string schemaURL, string schemaAccessToken) {
        self.schemaURL = schemaURL;
        self.schemaAccessToken = schemaAccessToken;
    }

    public function readEDI(string ediText, EDI_NAMES ediName, string? ediFileName) returns anydata|error {
        string|error mappingText = self.getEDISchemaText(ediName);
        if mappingText is error {
            return error("Schema for the EDI " + ediName + " not found in URL " + schemaURL);
        }
        
        match ediName {
            ${self.selectionBlocks}
        }
    }

    public function getEDINames() returns string[] {
        return ${self.ediNames.toString()};
    }

    function getEDISchemaText(string ediName) returns string|error {
        http:Client sclient = check new(schemaURL);
        string fileName = ediName + ".json";
        string authHeader = "Bearer" + self.schemaAccessToken;
        string schemaContent = check sclient->/[fileName]({
            Authorization: authHeader, 
            Accept: "application/vnd.github.raw"});
        return schemaContent;
    }
}
        `;
        return codeBlock;        
    }

    function generateEDISelectionBlock(string ediName, string mainRecordName) returns string {
        string block = string `
            EDI_${ediName} => {
                check preProcess(ediName, "${mainRecordName}", ediText, ediFileName);
                edi:EDIMapping mapping = check edi:readMappingFromString(mappingText);
                json jb = check edi:readEDIAsJson(ediText, mapping);
                m${ediName}:${mainRecordName} b = check jb.cloneWithType(m${ediName}:${mainRecordName});
                anydata targetEDI = m${ediName}:process(b);
                return check postProcess(ediName, mapping.name, ediText, targetEDI, ediFileName);
            }`;
        return block;
    }

    function createLibStructure() returns error? {
        self.libPath = check file:joinPath(self.outputPath, self.libName);
        if check file:test(self.libPath, file:EXISTS) {
            file:MetaData[] files = check file:readDir(self.libPath);
            if files.length() > 0 {
                return error(string `Target library path ${self.libPath} is not empty. Please provide an empty directory to create the library.`);
            } 
        } else {
            check file:createDir(self.libPath, file:RECURSIVE);
        }

        string balTomlContent = string `
[package]
org = "${self.orgName}"
name = "${self.libName}"
version = "0.1.0"
distribution = "2201.3.1"
`;
        string balTomlPath = check file:joinPath(self.libPath, "Ballerina.toml");
        check io:fileWriteString(balTomlPath, balTomlContent);

        string packageMdContent = string `
    EDI Library

# Package Overview
This EDI library contains EDI schema files, generated Ballerina types and functions to convert EDI messages to Ballerina types.`;
    
        check io:fileWriteString(check file:joinPath(self.libPath, "Package.md"), packageMdContent);

        string moduleMdContent = string `
    EDI Library

# Module Overview
This EDI library contains EDI schema files, generated Ballerina types and functions to convert EDI messages to Ballerina types.`;
        check io:fileWriteString(check file:joinPath(self.libPath, "Module.md"), moduleMdContent);
    }

    function generateTransformerCode(string ediName, string mainRecordName) returns string {
        string transformer = string `

type SourceType ${mainRecordName};
type TargetType ${mainRecordName};

function transform(SourceType sourceType) returns TargetType => sourceType;

public function process(SourceType sourceType) returns TargetType {
    // Implement EDI type specific processing code here

    return transform(sourceType);
}
    `;

        return transformer;
    }
}