import ballerina/file;
import ballerina/io;
import chathurace/edi.core as edi;
import edi.codegen;

public function generateLibrary(string orgName, string libName, string ediMappingFolder, string outputPath, boolean includeMappings) returns error? {
    check createBalLib(outputPath, orgName, libName);
    string libPath = check file:joinPath(outputPath, libName);
    string importsBlock = "";
    string exportsBlock = "export=[\"" + libName + "\"";
    string enumBlock = "";
    string selectionBlocks = "";
    file:MetaData[] mappingFiles = check file:readDir(ediMappingFolder);
    foreach file:MetaData mappingFile in mappingFiles {
        string ediName = check file:basename(mappingFile.absPath);
        if ediName.endsWith(".json") {
            ediName = ediName.substring(0, ediName.length() - ".json".length());
        }
        json mappingJson = check io:fileReadJson(mappingFile.absPath);
        edi:EDIMapping ediMapping = check mappingJson.cloneWithType(edi:EDIMapping);

        string modulePath = check file:joinPath(libPath, "modules", "m" + ediName);
        check file:createDir(modulePath, file:RECURSIVE);

        string recordsPath = check file:joinPath(modulePath, "G_" + ediName + ".bal");
        check codegen:generateCodeToFile(ediMapping, recordsPath);

        string transformer = generateTransformerCode(libName, ediName, ediMapping.name);
        check io:fileWriteString(check file:joinPath(modulePath, "transformer.bal"), transformer);

        string resourcesPath = check file:joinPath(libPath, "resources");
        check file:createDir(check file:joinPath(resourcesPath, libName), file:RECURSIVE);
        check file:copy(mappingFile.absPath, check file:joinPath(resourcesPath, libName, check file:basename(mappingFile.absPath)));

        selectionBlocks += generateEDISelectionBlock(libName, ediName, ediMapping.name);
        importsBlock += string `
import ${libName}.m${ediName};`;
        exportsBlock += ",\"" + libName + ".m" + ediName + "\"";
        enumBlock += string `${enumBlock.length() > 0? ", ":""}EDI_${ediName} = "${ediName}"`;
    }

    string selectorCode = generateRecordSelectionCode(libName, importsBlock, enumBlock, selectionBlocks);
    string mainBalName = check file:joinPath(libPath, libName + ".bal");
    check io:fileWriteString(mainBalName, selectorCode, io:OVERWRITE);

    check io:fileWriteString(check file:joinPath(libPath, "commonProcessing.bal"), generateGenericProcessors());

    // add export package names to the Ballerina.toml file
    string ballerinaTomlPath = check file:joinPath(libPath, "Ballerina.toml");
    exportsBlock += "]";
    check io:fileWriteString(ballerinaTomlPath, exportsBlock, io:APPEND);    
}

function generateRecordSelectionCode(string libName, string importsBlock, string enumBlock, string selectionBlocks) returns string {
    string codeBlock = string `
import chathurace/edi.core as edi;
import ballerina/file;
import ballerina/os;
${importsBlock}

public enum EDI_NAMES {
    ${enumBlock}
}

public function readEDI(string ediText, EDI_NAMES ediName) returns any|error {
    string mappingDirectory = os:getEnv("EDI_MAPPING_PATH");
    if mappingDirectory.trim().length() == 0 {
        mappingDirectory = check file:joinPath("resources", "${libName}");
    }
    match ediName {
        ${selectionBlocks}
    }
}`;
    return codeBlock;        
}

function generateEDISelectionBlock(string libName, string ediName, string mainRecordName) returns string {
    string selectionBlock = string `
        EDI_${ediName} => {
            check preProcess(ediName, "${mainRecordName}", ediText);
            string mappingPath = check file:joinPath(mappingDirectory, ediName + ".json");
            if !check file:test(mappingPath, file:EXISTS) {
                return error("Unknown EDI " + ediName + "\nMissing EDI mapping file: " + check file:getAbsolutePath(mappingPath));    
            }
            edi:EDIMapping mapping = check edi:readMappingFromFile(mappingPath);
            json jb = check edi:readEDIAsJson(ediText, mapping);
            m${ediName}:${mainRecordName} b = check jb.cloneWithType(m${ediName}:${mainRecordName});
            any targetEDI = m${ediName}:process(b);
            return check postProcess(ediName, mapping.name, ediText, targetEDI);
        }`;
    return selectionBlock;
}

function createBalLib(string outputPath, string orgName, string libName) returns error? {
    string libPath = check file:joinPath(outputPath, libName);
    if check file:test(libPath, file:EXISTS) {
        file:MetaData[] files = check file:readDir(libPath);
        if files.length() > 0 {
            return error(string `Target library path ${libPath} is not empty. Please provide an empty directory to create the library.`);
        } 
    } else {
        check file:createDir(libPath, file:RECURSIVE);
    }

    string balTomlContent = string `
[package]
org = "${orgName}"
name = "${libName}"
version = "0.1.0"
distribution = "2201.3.1"
`;
    string balTomlPath = check file:joinPath(libPath, "Ballerina.toml");
    check io:fileWriteString(balTomlPath, balTomlContent);

    string packageMdContent = string `
    EDI Library

# Package Overview
This EDI library contains EDI schema files, generated Ballerina types and functions to convert EDI messages to Ballerina types.`;
    check io:fileWriteString(check file:joinPath(libPath, "Package.md"), packageMdContent);

    string moduleMdContent = string `
    EDI Library

# Module Overview
This EDI library contains EDI schema files, generated Ballerina types and functions to convert EDI messages to Ballerina types.`;
    check io:fileWriteString(check file:joinPath(libPath, "Module.md"), moduleMdContent);
}