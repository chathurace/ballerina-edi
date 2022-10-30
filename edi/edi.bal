import ballerina/regex;
import ballerina/log;

public function readEDIAsJson(string ediText, EDIMapping mapping) returns json|error {
    EDISegmentGroup ediDoc = check readEDI(ediText, mapping);
    return ediDoc.toJson();
}

public function readEDI(string ediText, EDIMapping ediMapping) returns EDISegmentGroup|error {
    EDIUnitMapping[] currentMapping = ediMapping.segments;
    string preparedEDIText = regex:replaceAll(ediText, "\n", "");
    string[] segmentsDesc = splitAndIgnoreLastEmptyItem(preparedEDIText, ediMapping.delimiters.segment);
    var [rootGroup, _] = check readEDISegmentGroup(currentMapping, segmentsDesc, 0, ediMapping);
    return rootGroup;
}

function readEDISegmentGroup(EDIUnitMapping[] currentMapping, string[] rawSegments, int rawIndex, EDIMapping ediMapping) returns [EDISegmentGroup, int]|error {
    int mappingIndex = 0;
    int currentRawIndex = rawIndex;
    EDISegmentGroup currentGroup = {};
    while currentRawIndex < rawSegments.length() {
        string sDesc = rawSegments[currentRawIndex];
        string segmentDesc = regex:replaceAll(sDesc, "\n", "");
        string[] elements = split(segmentDesc, ediMapping.delimiters.element);

        boolean segmentMapped = false;
        while mappingIndex < currentMapping.length() && !segmentMapped {
            EDIUnitMapping? segMapping = currentMapping[mappingIndex];
            if (segMapping is EDISegMapping) {
                if segMapping.code != elements[0] {
                    if segMapping.minOccurances > 0 {
                        return error(string `Mandatory segment ${segMapping.code} could not be found.`);
                    }
                    mappingIndex += 1;
                    continue;
                }
                currentRawIndex += 1;
                EDISegment ediRecord = check readEDISegment(segMapping, elements, ediMapping, segmentDesc);
                if (segMapping.maxOccurances == 1) {
                    mappingIndex += 1;
                    currentGroup[segMapping.tag] = ediRecord;
                } else {
                    var segments = currentGroup[segMapping.tag];
                    if (segments is EDISegment[]) {
                        segments.push(ediRecord);
                    } else if segments is null {
                        segments = [ediRecord];
                        currentGroup[segMapping.tag] = segments;
                    } else {
                        return error(string `${segMapping.code} must be a segment array.`);
                    }
                }
                segmentMapped = true;

            } else if segMapping is EDISegGroupMapping {
                EDIUnitMapping firstSegMapping = segMapping.segments[0];
                if firstSegMapping is EDISegGroupMapping {
                    return error("First item of group must be a segment.");
                }
                if firstSegMapping.code != elements[0] {
                    if segMapping.minOccurances > 0 {
                        return error(string `Mandatory segment group starting with ${firstSegMapping.code} could not be found.`);
                    }
                    mappingIndex += 1;
                    continue;
                }
                segmentMapped = true;
                var [segmentGroup, newRawIndex] = check readEDISegmentGroup(segMapping.segments, rawSegments, currentRawIndex, ediMapping);
                currentRawIndex = newRawIndex;
                if segmentGroup.length() > 0 {
                    if segMapping.maxOccurances == 1 {
                        mappingIndex += 1;
                        currentGroup[segMapping.tag] = segmentGroup;
                    } else {
                        var segmentGroups = currentGroup[segMapping.tag];
                        if segmentGroups is EDISegmentGroup[] {
                            segmentGroups.push(segmentGroup);
                        } else if segmentGroups is null {
                            segmentGroups = [segmentGroup];
                            currentGroup[segMapping.tag] = segmentGroups;
                        } else {
                            return error(string `${segMapping.tag} must be a segment group array.`);
                        }
                        
                    }
                }
            }
            if currentRawIndex == rawSegments.length() {
                break;
            }
        }
        if mappingIndex == currentMapping.length() {
            break;
        }
    }
    return [currentGroup, currentRawIndex];
}

function readEDISegment(EDISegMapping segMapping, string[] elements, EDIMapping mapping, string segmentDesc)
    returns EDISegment|error {
    if (segMapping.elements.length() + 1 != elements.length()) {
        string errMsg = string `Segment mapping's element count does not match segment ${elements[0]}. 
                Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}`;
        return error(errMsg);
    }
    EDISegment ediRecord = {};
    int elementNumber = 0;
    while (elementNumber < elements.length() - 1) {
        EDIElementMapping elementMapping = segMapping.elements[elementNumber];
        string tag = elementMapping.tag;

        // EDI segment starts with the segment name. So we have to skip the first element.
        string elementText = elements[elementNumber + 1];
        if (elementMapping.repeat) {
            // this is a repeating element (i.e. array). can be a repeat of composites as well.
            ediRecord[tag] = check readEDIRepeat(elementText, mapping.delimiters.repetition, mapping, elementMapping);
        } else if (elementMapping.subelements.length() > 0) {
            // this is a composite element (but not a repeat)
            EDIComposite? composite = check readEDIComposite(elementText, mapping, elementMapping.subelements);
            if (composite is EDIComposite) {
                ediRecord[tag] = composite;
            } else {
                log:printWarn(string `Value for "${tag} is not provided in ${segmentDesc}`);
            }
        } else {
            // this is a simple type element
            SimpleType|error value = convertToType(elementText, elementMapping.dataType);
            if (value is SimpleType) {
                ediRecord[tag] = value;
            } else {
                string errMsg = string `EDI field: ${elementText} cannot be converted to type: ${elementMapping.dataType}.
                        Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}|n${value.message()}`;
                return error(errMsg);
            }
        }
        elementNumber = elementNumber + 1;
    }
    return ediRecord;
}

function readEDIComposite(string compositeText, EDIMapping mapping, EDISubelementMapping[] subMappings)
            returns EDIComposite|error? {
    if compositeText.trim().length() == 0 {
        // Composite value is not provided. Return null, which will cause this element to be not included.
        return null;
    }
    string[] subelements = split(compositeText, mapping.delimiters.subelement);
    EDIComposite composite = {};
    if (subelements.length() <= 1) {
        // Composite value is needed here.
        return error(string `Composite valut is expected for ${subMappings.toJsonString()}. But found ${compositeText}`);
    } else if (subelements.length() != subMappings.length()) {
        string errMsg = string `Composite mapping's subelement count does not match subelements ${subelements.toJsonString()}. 
                Composite mapping: ${subMappings.toJsonString()} | Composite text: ${compositeText}`;
        return error(errMsg);
    }
    int subelementNumber = 0;
    while (subelementNumber < subMappings.length()) {
        string subelement = subelements[subelementNumber];
        EDISubelementMapping subMapping = subMappings[subelementNumber];
        SimpleType|error value = convertToType(subelement, subMapping.dataType);
        if (value is SimpleType) {
            composite[subMapping.tag] = value;
        } else {
            string errMsg = string `EDI field: ${subelement} cannot be converted to type: ${subMapping.dataType}.
                        Composite mapping: ${subMapping.toJsonString()} | Composite text: ${compositeText}\n${value.message()}`;
            return error(errMsg);
        }
        subelementNumber = subelementNumber + 1;
    }
    return composite;
}

function readEDIRepeat(string repeatText, string repeatDelimiter, EDIMapping mapping, EDIElementMapping elementMapping)
        returns SimpleArray|EDIComposite[]|error {
    string[] elements = split(repeatText, repeatDelimiter);
    SimpleArray|EDIComposite[] repeatValues = getArray(elementMapping.dataType);
    if (elements.length() == 0) {
        // None of the repeating values are provided. Return an empty array.
        return repeatValues;
    }
    foreach string element in elements {
        if (elementMapping.dataType == COMPOSITE) {
            EDIComposite? value = check readEDIComposite(element, mapping, elementMapping.subelements);
            if (value is EDIComposite) {
                repeatValues.push(value);
            } else {
                log:printWarn(string `Repeat value not provided in ${repeatText}.`);
            }
        } else {
            SimpleType|error value = convertToType(element, elementMapping.dataType);
            if (value is SimpleType) {
                repeatValues.push(value);
            } else {
                string errMsg = string `EDI field: ${element} cannot be converted to type: ${elementMapping.dataType}.
                        Element mapping: ${elementMapping.toJsonString()} | Repeat text: ${repeatText}\n${value.message()}`;
                return error(errMsg);
            }
        }
    }
    return repeatValues;
}
