import ballerina/io;
public function getDataTypeForSmooksType(string typeString) returns EDIDataType {
    match typeString {
        "String" => {return STRING;}
        "int" => {return INT;}
        "float" => {return FLOAT;}
        "DABigDecimal" => {return FLOAT;}
    }
    return STRING;
}

public function readMappingFromFile(string filePath) returns EDIMapping|error {
    json mappingJson = check io:fileReadJson(filePath);
    EDIMapping mapping = check mappingJson.cloneWithType(EDIMapping);
    return mapping;
}