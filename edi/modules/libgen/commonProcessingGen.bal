string commonProcessingCode = string `

function preProcess(string ediName, string mappingName, string ediText, string? ediFileName) returns error? {
    // Implement generic processing code that needs to be executed before parsing EDIs
    // E.g. EDI tracking code 

}

function postProcess(string ediName, string mappingName, string ediText, anydata targetType, string? ediFileName) returns anydata|error? {
    // Implement generic processing code that needs to be executed after parsing EDIs

    // Tracking data is written to logs in this sample code.
    // Change this code as needed to write data to the required detination.
    check tracker.track({partnerId: partnerId, ediName: ediName, ediFileName: ediFileName, schemaName: mappingName, status: "VALIDATION COMPLETED"});    

    return targetType;
}
`;
