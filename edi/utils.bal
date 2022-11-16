import ballerina/regex;
import ballerina/io;

function convertToType(string value, EDIDataType dataType, string? decimalSeparator) returns SimpleType|error {
    match dataType {
        STRING => {
            return value;
        }
        INT => {
            return int:fromString(decimalSeparator != null? regex:replace(value, decimalSeparator, ".") : value);
        }
        FLOAT => {
            return float:fromString(decimalSeparator != null? regex:replace(value, decimalSeparator, ".") : value);
        }
    }
    return error("Undefined type for value:" + value);
}

function getArray(EDIDataType dataType) returns SimpleArray|EDIComposite[] {
    match dataType {
        STRING => {string[] values = []; return values;}
        INT => {int[] values = []; return values;}
        FLOAT => {float[] values = []; return values;}
        COMPOSITE => {EDIComposite[] values = []; return values;}
    }
    string[] values = []; 
    return values;
}

public function getDataType(string typeString) returns EDIDataType {
    match typeString {
        "string" => {return STRING;}
        "int" => {return INT;}
        "float" => {return FLOAT;}
    }
    return STRING;
}

function split(string text, string delimiter) returns string[] {
    string preparedText = prepareToSplit(text, delimiter);
    string validatedDelimiter = validateDelimiter(delimiter);
    return regex:split(preparedText, validatedDelimiter);
}

function splitAndIgnoreLastEmptyItem(string text, string delimiter) returns string[] {
    string validatedDelimiter = validateDelimiter(delimiter);
    return regex:split(text, validatedDelimiter);
}

function validateDelimiter(string delimeter) returns string {
    match delimeter {
        "*" => {return "\\*";}
        "^" => {return "\\^";}
        "+" => {return "\\+";}
        // "\n" => {return "\\n";}
    }
    return delimeter;
}

function prepareToSplit(string content, string delimeter) returns string {
    string preparedContent = content.trim();
    if (content.endsWith(delimeter)) {
        preparedContent = preparedContent + " ";
    }
    if (content.startsWith(delimeter)) {
        preparedContent = " " + preparedContent;
    }
    return preparedContent;
}

function printSegMap(EDISegMapping smap) returns string {
    return string `Segment ${smap.code} | Min: ${smap.minOccurances} | Max: ${smap.maxOccurances} | Trunc: ${smap.truncatable}`;
}

function printSegGroupMap(EDISegGroupMapping sgmap) returns string {
    string sgcode = "";
    foreach EDIUnitMapping umap in sgmap.segments {
        if umap is EDISegMapping {
            sgcode += umap.code + "-";
        } else if umap is EDISegGroupMapping {
            sgcode += printSegGroupMap(umap);
        }
    }

    return string `[Segment group: ${sgcode} ]`;
}


public function main(string[] args) returns error? {

    string ediText = check io:fileReadString("resources/codegen/x12-810-invoice/810-sample.edi");

    json mappingText = check io:fileReadJson("resources/codegen/x12-810-invoice/810-mapping.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    io:println("seg break: " + mapping.delimiters.segment);

    string[] a1 = regex:split(ediText, "\n");

    io:println(a1);

    // string usage = string `Usage:
    //     Ballerina code generation for edi mapping: java -jar edi.jar codegen <mapping json path> <output bal file path>
    //     Smooks to json mapping conversion: java -jar edi.jar smooksToBal <smooks mapping xml path> <mapping json path>`;
    
    // if args.length() != 3 {
    //     io:println(usage);
    //     return;
    // }

    // string mode = args[0].trim();
    // if mode == "codegen" {
    //     json mappingText = check io:fileReadJson(args[1].trim());
    //     EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);  
    //     check generateCodeToFile(mapping, args[2].trim());    
    // } else if mode == "smooksToBal" {
    //     check processMapping(args[1].trim(), args[2].trim()); 
    // } else {
    //     io:println(usage);
    // }
}
