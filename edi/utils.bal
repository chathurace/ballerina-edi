import ballerina/regex;
import ballerina/io;

function convertToType(string value, EDIDataType dataType) returns SimpleType|error {
    match dataType {
        STRING => {
            return value;
        }
        INT => {
            return int:fromString(value);
        }
        FLOAT => {
            return float:fromString(value);
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


public function main() returns error? {
    json mappingText = check io:fileReadJson("resources/d3a-invoic-1/mapping.json");
    EDIMapping mapping = check mappingText.cloneWithType(EDIMapping);
    
    string ediText = check io:fileReadString("resources/d3a-invoic-1/input.edi");
    json output = check readEDIAsJson(ediText, mapping);
    io:println(output);
    // check io:fileWriteJson("resources/d3a-invoic-1/expected.json", output);
}
