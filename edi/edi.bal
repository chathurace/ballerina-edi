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
        string[] fields = split(segmentDesc, ediMapping.delimiters.'field);
        if ediMapping.ignoreSegments.indexOf(fields[0], 0) != null {
            currentRawIndex += 1;
            continue;
        }

        boolean segmentMapped = false;
        while mappingIndex < currentMapping.length() && !segmentMapped {
            EDIUnitMapping? segMapping = currentMapping[mappingIndex];
            if (segMapping is EDISegMapping) {
                if segMapping.code != fields[0] {
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
                EDISegment ediRecord = check readEDISegment(segMapping, fields, ediMapping, segmentDesc);
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
                if firstSegMapping.code != fields[0] {
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

function readEDISegment(EDISegMapping segMapping, string[] fields, EDIMapping mapping, string segmentDesc)
    returns EDISegment|error {
    log:printDebug(string `Reading ${printSegMap(segMapping)} | Seg text: ${segmentDesc}`);
    if segMapping.truncatable {
        int minFields = getMinimumFields(segMapping);
        if fields.length() < minFields + 1 {
            return error(string `Segment mapping's field count does not match minimum field count of the truncatable segment ${fields[0]}.
                Required minimum field count (excluding the segment code): ${minFields}. Found ${fields.length() - 1} fields. 
                Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}`);
        }
    } else if (segMapping.fields.length() + 1 != fields.length()) {
        string errMsg = string `Segment mapping's field count does not match segment ${fields[0]}. 
                Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}`;
        return error(errMsg);
    }
    EDISegment ediRecord = {};
    int fieldNumber = 0;
    while (fieldNumber < fields.length() - 1) {
        EDIFieldMapping fieldMapping = segMapping.fields[fieldNumber];
        string tag = fieldMapping.tag;

        // EDI segment starts with the segment name. So we have to skip the first field.
        string fieldText = fields[fieldNumber + 1];
        if fieldText.trim().length() == 0 {
            if fieldMapping.required {
                return error(string `Required field ${fieldMapping.tag} is not provided.`);
            } else {
                if mapping.preserveEmptyFields {
                    if fieldMapping.repeat {
                        ediRecord[tag] = getArray(fieldMapping.dataType);
                    } else if fieldMapping.dataType == STRING {
                        ediRecord[tag] = fieldText;
                    } else {
                        ediRecord[tag] = null;
                    }
                }
                fieldNumber = fieldNumber + 1;
                continue;
            }
        }
        if (fieldMapping.repeat) {
            // this is a repeating field (i.e. array). can be a repeat of composites as well.
            SimpleArray|EDIComponentGroup[] repeatValues = check readEDIRepeat(fieldText, mapping.delimiters.repetition, mapping, fieldMapping);
            if repeatValues.length() > 0 || mapping.preserveEmptyFields {
                ediRecord[tag] = repeatValues;    
            } 
        } else if (fieldMapping.components.length() > 0) {
            // this is a composite field (but not a repeat)
            EDIComponentGroup? composite = check readEDIComposite(fieldText, mapping, fieldMapping);
            if (composite is EDIComponentGroup || mapping.preserveEmptyFields) {
                ediRecord[tag] = composite;
            } 
        } else {
            // this is a simple type field
            SimpleType|error value = convertToType(fieldText, fieldMapping.dataType, mapping.delimiters.decimalSeparator);
            if value is SimpleType {
                ediRecord[tag] = value;
            } else {
                string errMsg = string `EDI field: ${fieldText} cannot be converted to type: ${fieldMapping.dataType}.
                        Segment mapping: ${segMapping.toJsonString()} | Segment text: ${segmentDesc}|n${value.message()}`;
                return error(errMsg);
            }
        }
        fieldNumber = fieldNumber + 1;
    }
    return ediRecord;
}

function readEDIComposite(string compositeText, EDIMapping mapping, EDIFieldMapping emap)
            returns EDIComponentGroup|error? {
    if compositeText.trim().length() == 0 {
        // Composite value is not provided. Return null, which will cause this field to be not included.
        return null;
    }

    string[] components = split(compositeText, mapping.delimiters.component);
    if emap.truncatable {
        int minFields = getMinimumCompositeFields(emap);
        if components.length() < minFields {
            return error(string `Composite mapping's field count does not match minimum field count of the truncatable field ${emap.tag}.
                Required minimum field count: ${minFields}. Found ${components.length()} fields. 
                Composite mapping: ${emap.toJsonString()} | Composite text: ${compositeText}`);
        }
    } else if (emap.components.length() != components.length()) {
        string errMsg = string `Composite mapping's component count does not match field ${emap.tag}. 
                Composite mapping: ${emap.toJsonString()} | Composite text: ${compositeText}`;
        return error(errMsg);
    }

    EDIComponentMapping[] subMappings = emap.components;
    EDIComponentGroup composite = {};
    int componentNumber = 0;
    while (componentNumber < components.length()) {
        string component = components[componentNumber];
        EDIComponentMapping subMapping = subMappings[componentNumber];
        if component.trim().length() == 0 {
            if subMapping.required {
                return error(string `Required component ${subMapping.tag} is not provided.`);
            } else {
                if mapping.preserveEmptyFields {
                    composite[subMapping.tag] = subMapping.dataType == STRING? component : null;
                }
                componentNumber += 1;
                continue;
            }
        }

        if subMapping.subcomponents.length() > 0 {
            EDISubcomponentGroup? scGroup = check readSubcomponentGroup(component, mapping, subMapping);
            if scGroup is EDISubcomponentGroup || mapping.preserveEmptyFields {
                composite[subMapping.tag] = scGroup;
            }
        } else {
            SimpleType|error value = convertToType(component, subMapping.dataType, mapping.delimiters.decimalSeparator);
            if value is SimpleType? {
                composite[subMapping.tag] = value;
            } else {
                string errMsg = string `EDI field: ${component} cannot be converted to type: ${subMapping.dataType}.
                            Composite mapping: ${subMapping.toJsonString()} | Composite text: ${compositeText}
                            Error: ${value.message()}`;
                return error(errMsg);
            }
        }
        componentNumber = componentNumber + 1;
    }
    return composite;
}

function readSubcomponentGroup(string scGroupText, EDIMapping mapping, EDIComponentMapping emap) returns EDISubcomponentGroup|error? {
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
        string errMsg = string `Subcomponent group mapping's subcomponent count does not match field ${emap.tag}. 
                Subcomponent group mapping: ${emap.toJsonString()} | Subcomponent group text: ${scGroupText}`;
        return error(errMsg);
    }

    EDISubcomponentMapping[] subMappings = emap.subcomponents;
    EDISubcomponentGroup scGroup = {};
    int subcomponentNumber = 0;
    while (subcomponentNumber < subcomponents.length()) {
        string subcomponent = subcomponents[subcomponentNumber];
        EDISubcomponentMapping subMapping = subMappings[subcomponentNumber];
        if subcomponent.trim().length() == 0 {
            if subMapping.required {
                return error(string `Required subcomponent ${subMapping.tag} is not provided.`);
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

function readEDIRepeat(string repeatText, string repeatDelimiter, EDIMapping mapping, EDIFieldMapping fieldMapping)
        returns SimpleArray|EDIComponentGroup[]|error {
    string[] fields = split(repeatText, repeatDelimiter);
    SimpleArray|EDIComponentGroup[] repeatValues = getArray(fieldMapping.dataType);
    if (fields.length() == 0) {
        // None of the repeating values are provided. Return an empty array.
        if fieldMapping.required {
            return error(string `Required field ${fieldMapping.tag} is not provided.`);
        }
        return repeatValues;
    }
    foreach string 'field in fields {
        if (fieldMapping.dataType == COMPOSITE) {
            EDIComponentGroup? value = check readEDIComposite('field, mapping, fieldMapping);
            if (value is EDIComponentGroup) {
                repeatValues.push(value);
            } else {
                log:printWarn(string `Repeat value not provided in ${repeatText}.`);
            }
        } else {
            if 'field.trim().length() == 0 {
                continue;
            }
            SimpleType|error value = convertToType('field, fieldMapping.dataType, mapping.delimiters.decimalSeparator);
            if (value is SimpleType) {
                repeatValues.push(value);
            } else {
                string errMsg = string `EDI field: ${'field} cannot be converted to type: ${fieldMapping.dataType}.
                        field mapping: ${fieldMapping.toJsonString()} | Repeat text: ${repeatText}\n${value.message()}`;
                return error(errMsg);
            }
        }
    }
    return repeatValues;
}

function getMinimumFields(EDISegMapping segmap) returns int {
    int fieldIndex = segmap.fields.length() - 1;
    while fieldIndex > 0 {
        if segmap.fields[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}

function getMinimumCompositeFields(EDIFieldMapping emap) returns int {
    int fieldIndex = emap.components.length() - 1;
    while fieldIndex > 0 {
        if emap.components[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}

function getMinimumSubcomponentFields(EDIComponentMapping emap) returns int {
    int fieldIndex = emap.subcomponents.length() - 1;
    while fieldIndex > 0 {
        if emap.subcomponents[fieldIndex].required {
            break;
        }
        fieldIndex -= 1;
    }
    return fieldIndex;
}
