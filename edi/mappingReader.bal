import ballerina/log;
import ballerina/io;

public function loadMappingFromFile(string filePath) returns EDIMapping|error {
    json|error mappingJson = io:fileReadJson(filePath);
    if (mappingJson is json) {
        return loadMapping(mappingJson);
    } else {
        return mappingJson;
    }
}

public function loadMapping(json mappingDesc) returns EDIMapping|error {

    // Read segment and element delimiters
    json|error segD = mappingDesc.delimiters.segment;
    json|error elementD = mappingDesc.delimiters.element;
    
    if (segD is json && elementD is json) {
        EDIMapping mapping = {
            oSegmentDelimeter: segD.toString(),
            segmentDelimeter: validateDelimeter(segD.toString()), 
            oElementDelimeter: elementD.toString(),
            elementDelimeter: validateDelimeter(elementD.toString())};
    
        // Read the repeat delimiter if provided
        json|error repeatD = mappingDesc.delimiters.repetition;
        if (repeatD is json) { 
            mapping.oRepeatDelimeter = repeatD.toString();
            mapping.repeatDelimeter = validateDelimeter(repeatD.toString()); }
    
        // Read the composite delimter if provided
        json|error compositeD = mappingDesc.delimiters.subelement;    
        if (compositeD is json) { 
            mapping.oCompositeDelimiter = compositeD.toString();
            mapping.compositeDelimiter = validateDelimeter(compositeD.toString()); }

        // Iterate through segment mappings descriptions and fill in segement mappings
        json|error segments = mappingDesc.segments;
        if (segments is json[]) {
            foreach json seg in segments {
                readSegmentMapping(seg, mapping);
            }
        } else {
            log:printError("Could not find the segements section in the mapping.");
        }
        return mapping;
    } else {
        log:printError("Could not find segemnt and/or element delimeters in the mapping.");
    }
    return error("Failed to initialize the EDI mapping");
}

function readSegmentMapping(json seg, EDIMapping mapping) {
    json|error code = seg.code;
    json|error tag = seg.tag;
    if (code is json && tag is json) {
        EDISegMapping segMapping = {segCode: code.toString(), tag: tag.toString()};
        mapping.segmentMappings[code.toString()] = segMapping;

        // Read the maximum number of occurances of the segment (default is 1).
        // If this is set to any value other than 1, json array will be used to store data in the segment.
        json|error max = seg.max;
        if (max is json) { 
            int|error m = max.fromJsonWithType(int);
            if (m is int) {
                segMapping.maxOccurances = m;
            } 
        }

        // Iterate through elements in the segment mapping and fill in element mappings
        json|error elements = seg.elements;
        if (elements is json[]) {
            foreach json element in elements {
                readElementMapping(element, segMapping);
            }
        } else {
            log:printError("Could not find elements section in the segment mapping: " + seg.toString());
        }  
    } else {
        log:printError("Could not find segment code and/or tag in the segement mapping: " + seg.toString());
    }
}

function readElementMapping(json element, EDISegMapping segMapping) {
    json|error elementTag = element.tag;
    if (elementTag is json) {
        EDIElementMapping elementMapping = { tag: elementTag.toString() };

        // Read the data type of the element (default is string)
        json|error dataType = element.dataType;
        if (dataType is json) {
            elementMapping.dataType = getDataType(dataType.toString());
        }

        // Check whether this element is a repeating element (default is false)
        json|error repeat = element.repeat;
        if (repeat is json) {
            boolean|error r = repeat.fromJsonWithType(boolean);
            if (r is boolean) {
                elementMapping.repeat = r;
            }
        }

        // Read sub elements mappings if this is a composite element
        json|error subs = element.subs;
        if (subs is json[]) {
            elementMapping.dataType = COMPOSITE;
            foreach json sub in subs {
                json|error stag = sub.tag;
                if (stag is json) {
                    EDISubelementMapping subMapping = {tag : stag.toString()};
                    elementMapping.subelements.push(subMapping);
                    json|error sDataType = sub.dataType;
                    if (sDataType is json) {
                        subMapping.dataType = getDataType(sDataType.toString());
                    }
                }
            }
        }
        segMapping.elements.push(elementMapping);
    } else {
        log:printError("Could not find the element tag in the element mapping: " + element.toString());
    }
}