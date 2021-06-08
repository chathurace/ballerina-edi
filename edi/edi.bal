import ballerina/regex;
import ballerina/log;

public function readEDIAsJson(string ediText, EDIMapping mapping) returns json|error {
    EDIDoc|error ediDoc = readEDI(ediText, mapping);
    if (ediDoc is EDIDoc) {
        return ediDoc.toJson();
    }
    return ediDoc;
}

public function readEDI(string ediText, EDIMapping mapping) returns EDIDoc|error {
    EDIDoc doc = {};
    string[] segmentsDesc = regex:split(ediText, mapping.segmentDelimeter);
    foreach string sDesc in segmentsDesc {
        string segmentDesc = regex:replaceAll(sDesc, "\n", "");
        segmentDesc = prepareToSplit(segmentDesc, mapping.oElementDelimeter);
        string[] elements = regex:split(segmentDesc, mapping.elementDelimeter);
        EDISegMapping? segMapping = mapping.segmentMappings[elements[0].trim()];
        if (segMapping is EDISegMapping) {
            if (segMapping.elements.length() + 1 != elements.length()) {
                log:printError("Segment mapping's element count does not match segment: " + elements[0]);
                continue;
            }
            EDISegment ediRecord = {};
            int elementNumber = 0;
            while (elementNumber < elements.length() - 1) {
                EDIElementMapping elementMapping = segMapping.elements[elementNumber];
                string tag = elementMapping.tag;
                string elementText = elements[elementNumber + 1];
                if (elementMapping.repeat) {
                    // this is a repeating element (i.e. array). can be a repeat of composites as well.
                    ediRecord[tag] = readEDIRepeat(elementText, mapping.repeatDelimeter, mapping, elementMapping);
                } else if (elementMapping.subelements.length() > 0) {
                    // this is a composite element (but not a repeat)
                    EDIComposite|error composite = readEDIComposite(elementText, mapping, elementMapping.subelements);
                    if (composite is EDIComposite) {
                        ediRecord[tag] = composite;
                    } else {
                        log:printError(composite.toString());
                    }
                } else {
                    // this is a simple type element
                    SimpleType|error value = convertToType(elementText, elementMapping.dataType);
                    if (value is SimpleType) {
                        ediRecord[tag] = value;
                    }
                }
                elementNumber = elementNumber + 1;
            }
            if (segMapping.maxOccurances == 1) {
                doc[segMapping.tag] = ediRecord;
            } else {
                EDISegment|EDISegment[]? segments = doc[segMapping.tag];
                if (segments is EDISegment[]) {
                    segments.push(ediRecord);
                } else {
                    segments = [ediRecord];
                    doc[segMapping.tag] = segments;
                }
            }
                   
        } else {
            log:printError("Segment mapping not found for the segment: " + elements[0]);
        }
    }
    return doc;
}

function readEDIComposite(string compositeText, EDIMapping mapping, EDISubelementMapping[] subMappings) returns EDIComposite|error {
    string[] subelements = regex:split(prepareToSplit(compositeText, mapping.oCompositeDelimiter), mapping.compositeDelimiter);
    EDIComposite composite = {};
    if (subelements.length() <= 1) {
        // Composite values are not provided. Retuen an empty composite.
        return composite;
    } else if (subelements.length() != subMappings.length()) {
        return error("Subelement mapping count of the comppsite element does not match the number of subelements: " + subelements.toString());
    }
    int subelementNumber = 0;
    while (subelementNumber < subMappings.length()) {
        string subelement = subelements[subelementNumber];
        EDISubelementMapping subMapping = subMappings[subelementNumber];
        SimpleType|error value = convertToType(subelement, subMapping.dataType);
        if (value is SimpleType) {
            composite[subMapping.tag] = value;
        }
        subelementNumber = subelementNumber + 1;
    }
    return composite;
}

function readEDIRepeat(string repeatText, string repeatDelimiter, EDIMapping mapping, EDIElementMapping elementMapping) returns SimpleArray|EDIComposite[] {
    string[] elements = regex:split(repeatText, repeatDelimiter);
    SimpleArray|EDIComposite[] repeatValues = getArray(elementMapping.dataType);
    if (elements.length() == 0) {
        return repeatValues;
    }
    foreach string element in elements {
        if (elementMapping.dataType == COMPOSITE) {
            EDIComposite|error value = readEDIComposite(element, mapping, elementMapping.subelements);
            if (value is EDIComposite) {
                repeatValues.push(value);
            } else {
                log:printError(value.toString());
            }
        } else {
            SimpleType|error value = convertToType(element, elementMapping.dataType);
            if (value is SimpleType) {
                repeatValues.push(value);
            }
        }
    }
    return repeatValues;
}