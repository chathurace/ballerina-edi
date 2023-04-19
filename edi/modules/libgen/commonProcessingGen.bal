string commonProcessingCode = string `

function preProcess(string ediName, string mappingName, string ediText, string? ediFileName) returns error? {
    // Implement generic processing code that needs to be executed before parsing EDIs


}

function postProcess(string ediName, string mappingName, string ediText, anydata targetType, string? ediFileName) returns anydata|error? {
    // Implement generic processing code that needs to be executed after parsing EDIs


    return targetType;
}
`;
