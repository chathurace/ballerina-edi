import ballerina/regex;
import ballerina/log;

type ParseConext record {|
    EDIMapping mapping;
    string ediText;
    int rawIndex;
    string segmentText = "";
|};

public function readEDIAsJson(string ediText, EDIMapping mapping) returns json|error {
    log:printDebug(string `Reading ${ediText.substring(0,30)} ...`);
    EDISegmentGroup ediDoc = check readEDI(ediText, mapping);
    return ediDoc.toJson();
}

public function readEDI(string ediText, EDIMapping ediMapping) returns EDISegmentGroup|error {
    EDIUnitMapping[] currentMapping = ediMapping.segments;
    // string preparedEDIText = regex:replaceAll(ediText, "\n", "");
    string preparedEDIText = ediText;
    string[] segmentsDesc = splitAndIgnoreLastEmptyItem(preparedEDIText, ediMapping.delimiters.segment);
    var [rootGroup, _] = check readEDISegmentGroup(currentMapping, segmentsDesc, 0, ediMapping);
    return rootGroup;
}

function readSegmentGroup(EDISegGroupMapping currentMapping, string[] rawSegments, int rawIndex, EDIMapping ediMapping) returns [EDISegmentGroup, int]|error {
    log:printDebug(string `Reading segment group ${printSegGroupMap(currentMapping)}`);
    return readEDISegmentGroup(currentMapping.segments, rawSegments, rawIndex, ediMapping);
}

function readEDISegmentGroup(EDIUnitMapping[] currentMapping, string[] rawSegments, int rawIndex, EDIMapping ediMapping) returns [EDISegmentGroup, int]|error {
    int mappingIndex = 0;
    int currentRawIndex = rawIndex;
    EDISegmentGroup currentGroup = {};
    while currentRawIndex < rawSegments.length() {
        string sDesc = rawSegments[currentRawIndex];
        string segmentDesc = regex:replaceAll(sDesc, "\n", "");
        string[] elements = split(segmentDesc, ediMapping.delimiters.element);
        if ediMapping.ignoreSegments.indexOf(elements[0], 0) != null {
            currentRawIndex += 1;
            continue;
        }

        boolean segmentMapped = false;
        while mappingIndex < currentMapping.length() && !segmentMapped {
            EDIUnitMapping? segMapping = currentMapping[mappingIndex];
            if (segMapping is EDISegMapping) {
                if segMapping.code != elements[0] {
                    if segMapping.minOccurances == 0 {
                        // this is an optional segment. so we can ignore
                        log:printDebug(string `Ignoring optional segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }

                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegment[]) {
                            if segments.length() > 0 {
                                // this repeatable segment has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    } 

                    return error(string `Mandatory segment ${segMapping.code} could not be found.
                    Current segment mapping: ${segMapping.code}
                    Current segment text: ${sDesc}
                    Current mapping index: ${mappingIndex}`);
                }
                currentRawIndex += 1;
                EDISegment ediRecord = check readEDISegment(segMapping, elements, ediMapping, segmentDesc);
                if (segMapping.maxOccurances == 1) {
                    log:printDebug(string `Completed reading non-repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
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
                    if segMapping.minOccurances == 0 {
                        // this is an optional segment. so we can ignore
                        log:printDebug(string `Ignoring optional segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }
                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegmentGroup[]) {
                            if segments.length() > 0 {
                                // this repeatable segment group has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    } 
                    return error(string `Mandatory segment group ${printSegGroupMap(segMapping)} could not be found.`);
                }
                segmentMapped = true;
                var [segmentGroup, newRawIndex] = check readSegmentGroup(segMapping, rawSegments, currentRawIndex, ediMapping);
                currentRawIndex = newRawIndex;
                if segmentGroup.length() > 0 {
                    if segMapping.maxOccurances == 1 {
                        log:printDebug(string `Completed reading non-repeating segment group ${printSegGroupMap(segMapping)} | Current segment text: ${segmentDesc}`);
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
    log:printDebug(string `Reading ${printSegMap(segMapping)} | Seg text: ${segmentDesc}`);
    if segMapping.truncatable {
        int minFields = getMinimumFields(segMapping);
        if elements.length() < minFields + 1 {
            return error(string `Segment mapping's field count does not match minimum field count of the truncatable segment ${elements[0]}.
                Required minimum field count (excluding the segment code): ${minFields}. Found ${elements.length() - 1} fields. 
                Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}`);
        }
    } else if (segMapping.elements.length() + 1 != elements.length()) {
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
        if elementText.trim().length() == 0 {
            if elementMapping.required {
                return error(string `Required element ${elementMapping.tag} is not provided.`);
            } else {
                if mapping.preserveEmptyFields {
                    if elementMapping.repeat {
                        ediRecord[tag] = getArray(elementMapping.dataType);
                    } else if elementMapping.dataType == STRING {
                        ediRecord[tag] = elementText;
                    } else {
                        ediRecord[tag] = null;
                    }
                }
                elementNumber = elementNumber + 1;
                continue;
            }
        }
        if (elementMapping.repeat) {
            // this is a repeating element (i.e. array). can be a repeat of composites as well.
            SimpleArray|EDIComposite[] repeatValues = check readEDIRepeat(elementText, mapping.delimiters.repetition, mapping, elementMapping);
            if repeatValues.length() > 0 || mapping.preserveEmptyFields {
                ediRecord[tag] = repeatValues;    
            } 
        } else if (elementMapping.subelements.length() > 0) {
            // this is a composite element (but not a repeat)
            EDIComposite? composite = check readEDIComposite(elementText, mapping, elementMapping);
            if (composite is EDIComposite || mapping.preserveEmptyFields) {
                ediRecord[tag] = composite;
            } 
        } else {
            // this is a simple type element
            SimpleType|error value = convertToType(elementText, elementMapping.dataType, mapping.delimiters.decimalSeparator);
            if value is SimpleType {
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

function readEDIComposite(string compositeText, EDIMapping mapping, EDIElementMapping emap)
            returns EDIComposite|error? {
    if compositeText.trim().length() == 0 {
        // Composite value is not provided. Return null, which will cause this element to be not included.
        return null;
    }

    string[] subelements = split(compositeText, mapping.delimiters.subelement);
    if emap.truncatable {
        int minFields = getMinimumCompositeFields(emap);
        if subelements.length() < minFields {
            return error(string `Composite mapping's field count does not match minimum field count of the truncatable field ${emap.tag}.
                Required minimum field count: ${minFields}. Found ${subelements.length()} fields. 
                Composite mapping: ${emap.toJsonString()} | Composite text: ${compositeText}`);
        }
    } else if (emap.subelements.length() != subelements.length()) {
        string errMsg = string `Composite mapping's element count does not match field ${emap.tag}. 
                Composite mapping: ${emap.toJsonString()} | Composite text: ${compositeText}`;
        return error(errMsg);
    }

    EDISubelementMapping[] subMappings = emap.subelements;
    EDIComposite composite = {};
    int subelementNumber = 0;
    while (subelementNumber < subelements.length()) {
        string subelement = subelements[subelementNumber];
        EDISubelementMapping subMapping = subMappings[subelementNumber];
        if subelement.trim().length() == 0 {
            if subMapping.required {
                return error(string `Required element ${subMapping.tag} is not provided.`);
            } else {
                if mapping.preserveEmptyFields {
                    composite[subMapping.tag] = subMapping.dataType == STRING? subelement : null;
                }
                subelementNumber += 1;
                continue;
            }
        }

        if subMapping.subcomponents.length() > 0 {
            SubcomponentGroup? scGroup = check readSubcomponentGroup(subelement, mapping, subMapping);
            if scGroup is SubcomponentGroup || mapping.preserveEmptyFields {
                composite[subMapping.tag] = scGroup;
            }
        } else {
            SimpleType|error value = convertToType(subelement, subMapping.dataType, mapping.delimiters.decimalSeparator);
            if value is SimpleType? {
                composite[subMapping.tag] = value;
            } else {
                string errMsg = string `EDI field: ${subelement} cannot be converted to type: ${subMapping.dataType}.
                            Composite mapping: ${subMapping.toJsonString()} | Composite text: ${compositeText}
                            Error: ${value.message()}`;
                return error(errMsg);
            }
        }
        subelementNumber = subelementNumber + 1;
    }
    return composite;
}

function readSubcomponentGroup(string scGroupText, EDIMapping mapping, EDISubelementMapping emap) returns SubcomponentGroup|error? {
    if scGroupText.trim().length() == 0 {
        // Composite value is not provided. Return null, which will cause this element to be not included.
        return null;
    }

    string[] subcomponents = split(scGroupText, mapping.delimiters.subcomponent);
    if emap.truncatable {
        int minFields = getMinimumSubcomponentFields(emap);
        if subcomponents.length() < minFields {
            return error(string `Subcomponent group's mapping's field count does not match minimum field count of the truncatable field ${emap.tag}.
                Required minimum field count: ${minFields}. Found ${subcomponents.length()} fields. 
                Subcomponent group mapping: ${emap.toJsonString()} | Subcomponent group text: ${scGroupText}`);
        }
    } else if (emap.subcomponents.length() != subcomponents.length()) {
        string errMsg = string `Subcomponent group mapping's element count does not match field ${emap.tag}. 
                Subcomponent group mapping: ${emap.toJsonString()} | Subcomponent group text: ${scGroupText}`;
        return error(errMsg);
    }

    SubcomponentMapping[] subMappings = emap.subcomponents;
    SubcomponentGroup scGroup = {};
    int subcomponentNumber = 0;
    while (subcomponentNumber < subcomponents.length()) {
        string subcomponent = subcomponents[subcomponentNumber];
        SubcomponentMapping subMapping = subMappings[subcomponentNumber];
        if subcomponent.trim().length() == 0 {
            if subMapping.required {
                return error(string `Required element ${subMapping.tag} is not provided.`);
            } else {
                if mapping.preserveEmptyFields {
                    scGroup[subMapping.tag] = subMapping.dataType == STRING? subcomponent : null;
                }
                subcomponentNumber += 1;
                continue;
            }
        }

        SimpleType|error value = convertToType(subcomponent, subMapping.dataType, mapping.delimiters.decimalSeparator);
        if value is SimpleType? {
            scGroup[subMapping.tag] = value;
        } else {
            string errMsg = string `EDI field: ${subcomponent} cannot be converted to type: ${subMapping.dataType}.
                        Subcomponent group mapping: ${subMapping.toJsonString()} | Subcomponent group text: ${scGroupText}
                        Error: ${value.message()}`;
            return error(errMsg);
        }
        subcomponentNumber = subcomponentNumber + 1;
    }
    return scGroup;
}

function readEDIRepeat(string repeatText, string repeatDelimiter, EDIMapping mapping, EDIElementMapping elementMapping)
        returns SimpleArray|EDIComposite[]|error {
    string[] elements = split(repeatText, repeatDelimiter);
    SimpleArray|EDIComposite[] repeatValues = getArray(elementMapping.dataType);
    if (elements.length() == 0) {
        // None of the repeating values are provided. Return an empty array.
        if elementMapping.required {
            return error(string `Required element ${elementMapping.tag} is not provided.`);
        }
        return repeatValues;
    }
    foreach string element in elements {
        if (elementMapping.dataType == COMPOSITE) {
            EDIComposite? value = check readEDIComposite(element, mapping, elementMapping);
            if (value is EDIComposite) {
                repeatValues.push(value);
            } else {
                log:printWarn(string `Repeat value not provided in ${repeatText}.`);
            }
        } else {
            if element.trim().length() == 0 {
                continue;
            }
            SimpleType|error value = convertToType(element, elementMapping.dataType, mapping.delimiters.decimalSeparator);
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

function getMinimumFields(EDISegMapping segmap) returns int {
    int fieldIndex = segmap.elements.length() - 1;
    while fieldIndex > 0 {
        if segmap.elements[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}

function getMinimumCompositeFields(EDIElementMapping emap) returns int {
    int fieldIndex = emap.subelements.length() - 1;
    while fieldIndex > 0 {
        if emap.subelements[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}

function getMinimumSubcomponentFields(EDISubelementMapping emap) returns int {
    int fieldIndex = emap.subcomponents.length() - 1;
    while fieldIndex > 0 {
        if emap.subcomponents[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}
