import ballerina/io;
import ballerina/file;

function generateS3ConnectorDep(string libPath, string libName) returns error? {
    string s3con = string `
import ballerinax/aws.s3;
import ballerina/log;
import ballerina/os;

configurable string awsAccessKeyId = ?;
configurable string awsSecretAccessKey = ?;
configurable string awsRegion = "us-east2";
configurable string ediBucket = "m-${libName}-edi";
configurable string schemaBucket = "m-${libName}-schema";


s3:ConnectionConfig amazonS3Config = {
    accessKeyId: awsAccessKeyId,
    secretAccessKey: awsSecretAccessKey,
    region: awsRegion
}; 

public function main() returns error? {

    check os:setEnv("AWS_KEY", awsAccessKeyId);
    check os:setEnv("AWS_SECRET", awsSecretAccessKey);
    check os:setEnv("SCHEMA_BUCKET", schemaBucket);
    check os:setEnv("AWS_REGION", awsRegion);

    s3:Client amazonS3Client = check new (amazonS3Config);

    string ediText = check readS3File(amazonS3Client, ediBucket, "sample1_834.edi", true);
    any target = check readEDI(ediText, EDI_abc834);
    log:printInfo(target.toString());
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