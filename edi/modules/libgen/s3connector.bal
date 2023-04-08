import ballerina/io;
import ballerina/file;

function generateS3Connector(string libPath, string libName) returns error? {

    string s3con = string `

import ballerinax/aws.s3;
import ballerina/http;
import ballerina/regex;
import ballerina/lang.runtime;
import ballerina/log;

configurable string awsAccessKeyId = ?;
configurable string awsAccessSecret = ?;
configurable string awsRegion = ?;
configurable string inputBucket = "m-${libName}-input";
configurable string processedBucket = "m-${libName}-processed";
configurable string failedBucket = "m-${libName}-failed";
configurable decimal pollingInterval = 5000;

configurable string schemaURL = ?;
configurable string schemaAccessToken = ?;

configurable string applicationEndpoint = ?;

s3:ConnectionConfig amazonS3Config = {
    accessKeyId: awsAccessKeyId,
    secretAccessKey: awsAccessSecret,
    region: awsRegion
}; 

http:Client httpClient = check new(applicationEndpoint);

public function main() {
    EDIReader ediReader = new(schemaURL, schemaAccessToken);
    s3:Client|error s3Client = new (amazonS3Config);    
    if s3Client is error {
        log:printError("Failed to iniitalize Amazon S3 client. " + s3Client.message());
        return;
    }

    while true {
        error? e = readEDIs(ediReader, s3Client);
        if e is error {
            log:printError("Couldn't read EDIs.\n" + e.message());
        }
        if pollingInterval < 0d {
            // Negative values for polling interval forces this to run one time.
            // Can be used with external schedulars.
            break;
        }
        runtime:sleep(pollingInterval);
    }
}


public function readEDIs(EDIReader ediReader, s3:Client s3Client) returns error? {

    string[] edis = ediReader.getEDINames();
    s3:S3Object[] listObjects = check s3Client->listObjects(inputBucket);
    foreach s3:S3Object o in listObjects {
        string? fileName = o.objectName;
        if fileName is string {
            string[] parts = regex:split(fileName.trim(), "/");
            if parts.length() != 2 || edis.indexOf(parts[0], 0) is null {
                continue;
            }
            string ediName = parts[0];
            string|error ediText = readS3File(s3Client, inputBucket, fileName, true);
            if ediText is error {
                log:printError("Couldn't read EDI file " + fileName + " from bucket " + inputBucket);
                continue;
            }
            var result = processEDI(ediReader, s3Client, ediName, ediText, parts[1]);
            if result is error {
                log:printError(result.message());
                error? e = s3Client->createObject(failedBucket, fileName, ediText);
                if e is error {
                    log:printError("Failed to copy invalid EDI " + fileName + " to bucket " + failedBucket + ". " + e.message());
                    continue;
                }
            } else {
                error? e2 = s3Client->createObject(processedBucket, fileName, ediText);
                if e2 is error {
                    log:printError("Failed to copy processed EDI " + fileName + " to bucket " + processedBucket + ". " + e2.message());
                    continue;
                }
            }
            error? e3 = s3Client->deleteObject(inputBucket, fileName);
            if e3 is error {
                log:printError("Failed to delete the processed EDI file: " + fileName + " from bucket " + inputBucket + ". " + e3.message());
            }
        } else {
            log:printError("Object/file does not contain a valid name in EDI input bucket: " + inputBucket);
        }    
    }
}

function processEDI(EDIReader ediReader, s3:Client s3Client, string ediName, string ediText, string? ediFileName) returns error? {
    EDI_NAMES ediCode = check ediName.ensureType();
    anydata target = check ediReader.readEDI(ediText, ediCode, ediFileName);
    json response = check httpClient->/edis/[ediName].post(target.toJson());
    log:printInfo(response.toString());    
}

function readS3File(s3:Client amazonS3Client, string bucketName, string fileName, boolean lineBreaks) returns string|error {
    string ediText = "";
    stream<byte[], error?>|error getObjectResponse = check amazonS3Client->getObject(bucketName, fileName);
    if (getObjectResponse is stream<byte[], error?>) {
        while true {
            any|error a = getObjectResponse.next();    
            if a is record {|byte[] value;|} {
                ediText += check string:fromBytes(a.value) + (lineBreaks?"\n":"");
            } else {
                break;
            }
        }
    } else {
        return error("Failed to connect with S3 bucket: " + bucketName, getObjectResponse);
    } 
    return ediText;   
}
    
`;
    
    check io:fileWriteString(check file:joinPath(libPath, "s3-connector.bal"), s3con);
}