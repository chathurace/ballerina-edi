string configText = string `

# DO NOT store this file in a public github repository or any publically accessible location.
# Use secret value provisioning mechanism such as Kubernetes secrets or Choreo secrets to provide provide these
# values to the library runtime.

# -- EDI schema location --
# EDI schemas used for generating this module needs to be accessible during runtime. 
# Provide an HTTP(S) URL to access those schemas and an access token if authentication is required.
# For example, schemas can be stored in a Github repository and Github access URL and token can
# be provided as below.
schemaURL = "https://api.github.com/repos/<org name>/<repo name>/contents/<path>/<to>/<schema>/<location>"
schemaAccessToken = "<github token>"

# -- Amazon S3 connector configuration --
# S3 buckets are used for receiving EDI files, and for storing processed and failed EDI files.
# Provide AWS credentials, region (e.g. us-east-2) and bucket names below if the generated S3 connector is used.
awsAccessKeyId = ""
awsAccessSecret = ""
awsRegion = ""
inputBucket = "m-<partnerId>-input"
processedBucket = "m-<partnerId>-processed"
failedBucket = "m-<partnerId>-failed"

# Polling interval for reading input S3 bucket for EDI files.
# If this library is scheduled for periodic execution by an external mechanism (e.g. Choreo scheduled component),
# provide -1 as the polling interval.
pollingInterval = 5

# Connector will send processed EDI content (as JSON) to the below application endpoint
applicationEndpoint = "https://<host>:<port>/path"
applicationToken = "access token for application endpoint if required"
`;