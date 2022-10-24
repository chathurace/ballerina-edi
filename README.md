## Module Overview

EDI module provides functionality to read EDI files and map those to Ballerina records or 'json' type. Mapping for the EDI file has to be provided in json format. Once the mapping is provided, EDI module can read EDI files (in text format) in to Ballerina records or json value, which can be accessed from Ballerina code.

## Compatibility

|                                   | Version               |
|:---------------------------------:|:---------------------:|
| Ballerina Language                | 2201.2.2              |
| Java Development Kit (JDK)        | 11                    |

## Example code

A simple EDI mapping file is shown below:

````json
{
    "delimiters" : {"segment" : "~", "element" : "*"},
    "segments" : {
        "HDR": {
            "tag" : "header",
            "elements" : [{"tag" : "orderId"}, {"tag" : "organization"}, {"tag" : "date"}]
        },
        "ITM": {
            "tag" : "items",
            "maxOccurances" : -1,
            "elements" : [{"tag" : "item"}, {"tag" : "quantity", "dataType" : "int"}]
        }
    }
}
````
Above mapping can be used to parse EDI documents with one HDR segment (mapped to "header") and any number of ITM segments (mapped to "items"). HDR segment contains three elements, which are mapped to "orderId", "organization" and "date". Each ITM segment contains two elements mapped to "item" and "quantity". Below is a sample EDI document that can be parsed using the above mapping:

````edi
HDR*ORDER_1201*ABC_Store*2008-01-01~
ITM*A-250*12
ITM*A-45*100
ITM*D-10*58
ITM*K-80*250
ITM*T-46*28
````
Using the EDI module, Ballerina programs can read EDI documents into json types (or user defined types) and access them similar to any other json or record variable.

````ballerina
import ballerina/io;
import chathurace/edi;

public function main() returns error? {
    json mappingJson = check io:fileReadJson("resources/edi-mapping1.json");
    edi:EDIMapping mapping = check mappingJson.cloneWithType(edi:EDIMapping);

    string ediText = check io:fileReadString("resources/edi-sample1.edi");
    json output = check edi:readEDIAsJson(ediText, mapping);

    io:println(output.toJsonString());
}
````
Above code will read the EDI document "edi-sample1.edi" and generates a json according to the mapping "edi-mapping1.json". Output json will be as follows:

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
It is also possible to convert generated json output to user defined types in Ballerina. Using this method, it is possible to access and change values of EDI documents as below:

````ballerina
json mappingText = check io:fileReadJson("resources/edi-mapping2.json");
edi:EDIMapping mapping = check mappingText.cloneWithType(edi:EDIMapping);

string ediText = check io:fileReadString("resources/edi-sample2.edi");
json output = check edi:readEDIAsJson(ediText, mapping);
io:println(output.toJsonString());

OrderDetails orderDetails = check output.cloneWithType(OrderDetails);
io:println("Customer's city: " + orderDetails.organization.address.city);
````

In addition to segments and basic elements, EDI documents can contain composite elements (i.e. elements with subelements) and repeating elements. Below is a sample EDI mapping file containing such composite elements and repeating elements. This has three segment types. 

1. HDR segment with two elements named "orderId" and "date"
2. ORG segment with four elements named "partnerCode", "name", "address" and "contact". Among those, "address" is a composite element containing three subelements named "streetAddress", "city" and "state". "contact" is repeating element, which can contain multiple values.
3. ITM segment with three elements. Among those, "comments" is a both a repeating and composite element. Therefore, there can be multiple comments each having two subelements named "author" and "text".

````json
{
    "delimiters" : {"segment" : "~", "element" : "*", "subelement" : ":", "repetition" : "^"},
    "segments" : { 
        "HDR": {
            "tag" : "header",
            "elements" : [{"tag" : "orderId"}, {"tag" : "date"}]
        },
        "ORG": {
            "tag" : "organization",
            "elements" : [
                {"tag" : "partnerCode"}, 
                {"tag" : "name"}, 
                {"tag" : "address", "subelements" : [{"tag" : "streetAddress"}, {"tag" : "city"}, {"tag" : "country"}]}, 
                {"tag" : "contact", "repeat" : true}]
        },
        "ITM": {
            "tag" : "items",
            "maxOccurances" : -1,
            "elements" : [
                {"tag" : "item"}, 
                {"tag" : "quantity", "dataType" : "int"}, 
                {"tag" : "comments", "repeat" : true, "dataType" : "composite", "subelements" : [{"tag" : "author"}, {"tag" : "text"}]}]
        }
    }
}
````

Below is a sample EDI file that can be parsed using the above EDI mapping:

```` edi
HDR*1201*2008-01-01~
ORG*P120*ABC Store*67, Park road:Colombo:Sri Lanka*01 678 8908^04 732 3721^04 783 6702~
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
      "orderId": "1201",
      "date": "2008-01-01"
    },
    "organization": {
      "partnerCode": "P120",
      "name": "ABC Store",
      "address": {
        "streetAddress": "67, Park road",
        "city": "Colombo",
        "country": "Sri Lanka"
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
        "comments": []
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