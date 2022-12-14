import chathurace/edi.core as edi;

public function getDataTypeForSmooksType(string typeString) returns edi:EDIDataType {
    match typeString {
        "String" => {return edi:STRING;}
        "int" => {return edi:INT;}
        "float" => {return edi:FLOAT;}
        "DABigDecimal" => {return edi:FLOAT;}
    }
    return edi:STRING;
}

