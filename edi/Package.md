EDI processing capability for Ballerina.

## Module Overview

EDI module provides functionality to read EDI files and map those to Ballerina records or 'json' type. Mapping for the EDI file has to be provided in json format. Once the mapping is provided, EDI module can read EDI files (in text format) in to Ballerina records or json value, which can be accessed from Ballerina code.

## Compatibility

|                                   | Version               |
|:---------------------------------:|:---------------------:|
| Ballerina Language                | Swan Lake Beta 1      |
| Java Development Kit (JDK)        | 11                    |

## Example code

A simple EDI mapping file is shown below:

````json
{
    "delimiters" : {"segment" : "~", "element" : "*"},
    "segments" : [
        {
            "code" : "HDR", 
            "tag" : "header",
            "elements" : [{"tag" : "order-id"}, {"tag" : "organization"}, {"tag" : "date"}]
        },
        {
            "code" : "ITM",
            "tag" : "items",
            "max" : -1,
            "elements" : [{"tag" : "item"}, {"tag" : "quantity", "dataType" : "int"}]
        }
    ]
}
````
Above mapping can be used to parse EDI documents with one HDR segment (mapped to "header") and any number of ITM segments (mapped to "items"). HDR segment contains three elements, which are mapped to "order-id", "organization" and "date". Each ITM segment contains two elements mapped to "item" and "quantity". Below is a sample EDI document that can be parsed using the above mapping:

````edi
HDR*ORDER_1201*ABC_Store*2008-01-01~
ITM*A-250*12
ITM*A-45*100
ITM*D-10*58
ITM*K-80*250
ITM*T-46*28
````
Using the EDI module, Ballerina programs can read EDI documents into json types and access them similar to accessing any json variable.

````ballerina
import ballerina/io;
import chathurace/edi;

public function main() {
    
    // Read EDI mapping
    edi:EDIMapping|error mapping = edi:loadMappingFromFile("edi-mapping1.json");
    if (mapping is edi:EDIMapping) {

        // Read EDI as Ballerina record structure
        string|error ediText = io:fileReadString("edi-sample1.edi");
        if (ediText is string) {
            json|error doc = edi:readEDIAsJson(ediText, mapping);
            if (doc is json) {

                // Print organization name in the header segment
                io:println(doc.header.organization);
            }
        }
    }
}
````
The json value resulting from the 'json|error doc = edi:readEDIAsJson(ediText, mapping)' statement would look like the following:

````json
{
  "header": {
    "order-id": "ORDER_1201",
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
Furthermore, it is also possible to access parsed EDI documents as Ballerina records. Using this method, it is possible to change values of EDI document as below:

````ballerina
edi:EDIDoc|error doc = edi:readEDI(ediText, mapping);
if (doc is edi:EDIDoc) {

    // Change quantity of item "D-10" to 12
    edi:EDISegment|edi:EDISegment[]? records = doc["items"];
    if (records is edi:EDISegment[]) {
        foreach edi:EDISegment r in records {
            if (r["item"] == "D-10") {
                r["quantity"] = 12;
            }
        }
    }
}
````

In addition to segments and basic elements, EDI documents can contain composite elements (i.e. elements with subelements) and repeating elements. Below is a sample EDI mapping file containing such composite elements and repeating elements. This has three segment types. 

1. HDR segment with two elements named "order-id" and "date"
2. ORG segment with four elements named "partner-code", "name", "address" and "contact". Among those, "address" is a composite element containing three subelements named "street-address", "city" and "state". "contact" is repeating element, which can contain multiple values.
3. ITM segment with three elements. Among those, "comments" is a both a repeating and composite element. Therefore, there can be multiple comments each having two subelements named "author" and "text".

````json
{
    "delimiters" : {"segment" : "~", "element" : "*", "subelement" : ":", "repetition" : "^"},
    "segments" : [
        {
            "code" : "HDR", 
            "tag" : "header",
            "elements" : [{"tag" : "order-id"}, {"tag" : "date"}]
        },
        {
            "code" : "ORG", 
            "tag" : "organization",
            "elements" : [{"tag" : "partner-code"}, 
                {"tag" : "name"}, 
                {"tag" : "address", "subs" : [{"tag" : "street-address"}, {"tag" : "city"}, {"tag" : "state"}]}, 
                {"tag" : "contact", "repeat" : true}]
        },
        {
            "code" : "ITM",
            "tag" : "items",
            "max" : -1,
            "elements" : [
                {"tag" : "item"}, 
                {"tag" : "quantity", "dataType" : "int"}, 
                {"tag" : "comments", "repeat" : true, "subs" : [{"tag" : "author"}, {"tag" : "text"}]}]
        }
    ]
}
````

Below is a sample EDI file that can be parsed using the above EDI mapping:

```` edi
HDR*1201*2008-01-01~
ORG*P120*ABC Store*67, Park road:Colombo 7:Sri Lanka*01 678 8908^04 732 3721^04 783 6702~
ITM*A-250*12*N/A~
ITM*A-45*100*Kevin:Urgent~
ITM*D-10*58*Smith:REF 10053^Steven:Pre orders~
ITM*K-80*250*Steven:Before December~
ITM*T-46*28*Smith:Discount code AA1200~
````
Same Ballerina code used in the previous example, can be used to parse this EDI document as well by updating the EDI mapping. Once parsed, it will generate a json variable as below:

````json
{
  "header": {
    "order-id": "1201",
    "date": "2008-01-01"
  },
  "organization": {
    "partner-code": "P120",
    "name": "ABC Store",
    "address": {
      "street-address": "67, Park road",
      "city": "Colombo 7",
      "state": "Sri Lanka"
    },
    "contact": [
      "01 678 8908",
      "04 732 3721",
      "04 783 6702"
    ]
  },
  "items": [
    {
      "item": "A-250",
      "quantity": 12,
      "comments": [
        {
          "author": "Mike",
          "text": "Notify if not available"
        }
      ]
    },
    {
      "item": "A-45",
      "quantity": 100,
      "comments": [
        {
          "author": "Kevin",
          "text": "Urgent"
        }
      ]
    },
    {
      "item": "D-10",
      "quantity": 58,
      "comments": [
        {
          "author": "Smith",
          "text": "REF 10053"
        },
        {
          "author": "Steven",
          "text": "Pre orders"
        }
      ]
    },
    {
      "item": "K-80",
      "quantity": 250,
      "comments": [
        {
          "author": "Steven",
          "text": "Before December"
        }
      ]
    },
    {
      "item": "T-46",
      "quantity": 28,
      "comments": [
        {
          "author": "Smith",
          "text": "Discount code AA1200"
        }
      ]
    }
  ]
}
````