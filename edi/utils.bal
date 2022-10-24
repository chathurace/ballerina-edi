import ballerina/regex;

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

function getDataType(string typeString) returns EDIDataType {
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
