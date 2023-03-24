## Module Overview

EDI module provides functionality to read EDI files and map those to Ballerina records or 'json' type. Mappings for EDI files have to be provided in json format. Once a mapping is provided, EDI module can generate Ballerina records to hold data in any EDI file represented by that mapping. Then the module can read EDI files (in text format) in to generated Ballerina records or as json values, which can be accessed from Ballerina code.

## Compatibility

|                                   | Version               |
|:---------------------------------:|:---------------------:|
| Ballerina Language                | 2201.4.0              |
| Java Development Kit (JDK)        | 11                    |

## Example

A simple EDI mapping is shown below (let's assume that this is saved in edi-mapping1.json file):

````json
{
    "name": "SimpleOrder",
    "delimiters" : {"segment" : "~", "field" : "*"},
    "segments" : {
        "HDR": {
            "tag" : "header",
            "fields" : [{"tag" : "orderId"}, {"tag" : "organization"}, {"tag" : "date"}]
        },
        "ITM": {
            "tag" : "items",
            "maxOccurances" : -1,
            "fields" : [{"tag" : "item"}, {"tag" : "quantity", "dataType" : "int"}]
        }
    }
}
````

Above mapping can be used to parse EDI documents with one HDR segment (mapped to "header") and any number of ITM segments (mapped to "items"). HDR segment contains three fields, which are mapped to "orderId", "organization" and "date". Each ITM segment contains two fields mapped to "item" and "quantity". Below is a sample EDI document that can be parsed using the above mapping (let's assume that below EDI is saved in edi-sample1.edi file):

````edi
HDR*ORDER_1201*ABC_Store*2008-01-01~
ITM*A-250*12
ITM*A-45*100
ITM*D-10*58
ITM*K-80*250
ITM*T-46*28
````

### Code generation

Ballerina records for the above the EDI mapping in edi-mapping1.json can be generated as follows (generated Ballerina records will be saved in orderRecords.bal):

```
java -jar edi.jar codegen edi-mapping1.json orderRecords.bal
```

Generated Ballerina records for the above mapping are shown below:

```ballerina
type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

type Items_Type record {|
   string item?;
   int quantity?;
|};

type SimpleOrder record {|
   Header_Type header;
   Items_Type[] items?;
|};
```

### Parsing EDI files

Below code reads the edi-sample1.edi into a json variable named "orderData" and then convert the orderData json to the generated record "SimpleOrder". Once EDI documents are mapped to the SimpleOrder record, any attribute in the EDI can be accessed using record's fields as shown in the example code below.

````ballerina
import ballerina/io;
import chathurace/edi.core as edi;

public function main() returns error? {
    edi:EDIMapping mapping = check edi:readMappingFromFile("resources/edi-mapping1.json");

    string ediText = check io:fileReadString("resources/edi-sample1.edi");
    json orderData = check edi:readEDIAsJson(ediText, mapping);
    io:println(orderData.toJsonString());

    SimpleOrder order1 = check orderData.cloneWithType(SimpleOrder);
    io:println(order1.header.date);
}
````
"orderData" json variable value will be as follows (i.e. output of io:println(orderData.toJsonString())):

````json
{
  "header": {
    "orderId": "ORDER_1201",
    "organization": "ABC_Store",
    "date": "2008-01-01"
  },
  "items": [
    {
      "item": "A-250",
      "quantity": 12
    },
    {
      "item": "A-45",
      "quantity": 100
    },
    {
      "item": "D-10",
      "quantity": 58
    },
    {
      "item": "K-80",
      "quantity": 250
    },
    {
      "item": "T-46",
      "quantity": 28
    }
  ]
}
````

A sample Ballerina project which uses the EDI library is given in [here](https://github.com/chathurace/ballerina-edi/tree/main/samples/simpleEDI)

Also refer to [resources](https://github.com/chathurace/ballerina-edi/tree/main/edi/resources) section for example mapping files and edi samples.

## Converting Smooks mapping files to Ballerina compatible mappings

Smooks library is commonly used for parsing EDI files. Therefore, many organizations have already created Smooks mappings for their EDIs. Ballerina EDI module can convert such Smooks mapping to Ballerina compatible mappings, so that organizations can start using Ballerina for EDI processing without redoing any mappings.

Following command converts Smooks EDI mapping to Ballerina EDI mapping:

```
java -jar edi.jar smooksToBal <Smooks mapping xml file path> <Ballerina mapping json file path>
```

For example, the below command converts the Smooks mapping for EDIFACT [Invoice EDI](https://github.com/chathurace/ballerina-edi/blob/main/edi/resources/d3a-invoic-1/mapping.xml) to a Ballerina compatible json mapping:

```
java -jar edi.jar smooksToBal d3a-invoic-1/mapping.xml d3a-invoic-1/mapping.json
```

Generated json mapping is shown [here](https://github.com/chathurace/ballerina-edi/blob/main/edi/resources/d3a-invoic-1/mapping.json).

Then we can use the generated json mapping to generate Ballerina records and to parse invoice EDIs as shown above.

## Converting EDI Schema Language (ESL) files to Ballerina compatible mappings

ESL is another format used in EDI mapping files. Ballerina EDI tool can convert ESL mappings into Ballerina compatible mappings, so that it is possible to generate Ballerina code and process EDIs defined in ESLs without having to rework on mappings.

Following command converts ESL files to Ballerina EDI mappings. Note that segment definitions are given in a separate file, which is usually shared by multiple ESL mappings.

```
java -jar edi.jar eslToBal <ESL file path or directory> <ESL segment definitions path> <output json path or directory>
```

If a directory containing multiple ESL files are given as the input, all ESLs will be converted to Ballerina mappings and written into the output directory.

## Creating an EDI library

Usually, organizations have to work with many EDI formats, and integration developers need to have a convinient way to work on EDI data with minimum effort. EDI libraries facilitate this by allowing organizations to pack all EDI processing code for to thier EDI collections in to an importable library. Therefore, integration developers can simply import those libraries and convert EDI messages into Ballerin records in a single line of code.

Below command can be used to generate EDI libraries:

```
java -jar edi.jar libgen <org name> <library name> <EDI mappings folder> <output folder>
```

Ballerina library project will be generated in the output folder. This library can be built and published by issuing "bal pack" and "bal push" commands from the output folder.

Then the generated library can be imported into any Ballerina project and generated utility functions of the library can be invoked to parse EDI messages into Ballerin records. For example, the below Ballerina code parses an X12 834 EDI message into the corresponding Ballerina record:

```
m834:Benefit_Enrollment_and_Maintenance b = check hl71:readEDI(ediText, hl71:EDI_834).ensureType();
```



