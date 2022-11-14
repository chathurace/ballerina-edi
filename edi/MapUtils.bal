public function getDataTypeForSmooksType(string typeString) returns EDIDataType {
    match typeString {
        "String" => {return STRING;}
        "int" => {return INT;}
        "float" => {return FLOAT;}
        "DABigDecimal" => {return FLOAT;}
    }
    return STRING;
}