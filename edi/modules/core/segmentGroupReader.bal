import ballerina/log;
import ballerina/regex;

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
                log:printDebug(string `Trying to match with segment mapping ${printSegMap(segMapping)}`);
                if segMapping.code != fields[0] {
                    // Current segment does not match with the current mapping. There can be 3 reasons for this.
                    // 1. Current mapping is optional
                    // 2. Current mapping is a repeatable one and it has already occured at least once
                    // 3. There is an error in the EDI doc

                    // If the current segment mapping is optional, we can ignore the current mapping and compare the 
                    // current segment with the next mapping.
                    if segMapping.minOccurances == 0 {
                        log:printDebug(string `Ignoring optional segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }

                    // If the current segment mapping represents a repeatable segment, and we have already encountered 
                    // at least one such segment, we can ignore the current mapping and compare the current segment with 
                    // the next mapping.
                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegment[]) {
                            if segments.length() > 0 {
                                // This repeatable segment has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    } 

                    // If above two conditions does not hold, then we are missing a mandory segment, 
                    // which is an error in the EDI doc.
                    return error(string `Mandatory segment ${segMapping.code} could not be found.
                    Current segment mapping: ${segMapping.code}
                    Current segment text: ${sDesc}
                    Current mapping index: ${mappingIndex}`);
                }

                // If we are here, that means the current row's segment has matched the current mapping.
                // So we can move to the next row in the next round.
                currentRawIndex += 1;
                EDISegment ediRecord = check readEDISegment(segMapping, fields, ediMapping, segmentDesc);
                if (segMapping.maxOccurances == 1) {
                    // Current segment as matched with the current mapping AND current segment is not repeatable.
                    // So we can move to the next mapping.
                    log:printDebug(string `Completed reading non-repeatable segment: ${printSegMap(segMapping)} | Segment text: ${sDesc}`);
                    mappingIndex += 1;
                    currentGroup[segMapping.tag] = ediRecord;
                } else {
                    // Current mapping points to a repeatable segment. So we are using a EDISegment[] array to hold segments.
                    // Also we can't increment the mapping index here as next segment can also match with the current mapping
                    // as the segment is repeatable.
                    var segments = currentGroup[segMapping.tag];
                    if (segments is EDISegment[]) {
                        if (segments.length() >= segMapping.maxOccurances) {
                            return error(string `${segMapping.code} is repeatable segment with maximum limit of ${segMapping.maxOccurances}.
                            EDI document contains more such segments than the allowed limit. Current row: ${currentRawIndex}`);
                        }
                        segments.push(ediRecord);
                    } else if segments is null {
                        segments = [ediRecord];
                        currentGroup[segMapping.tag] = segments;
                    } else {
                        return error(string `${segMapping.code} must be a segment array.`);
                    }
                }
                // Mark the current row's segment as mapped, so that we can take the next row's segment and run the mapping loop.
                // Note that this is used to break the inner loop (i.e. mapping loop).
                // TODO: consider using break;
                segmentMapped = true;

            } else if segMapping is EDISegGroupMapping {
                log:printDebug(string `Trying to match with segment group mapping ${printSegGroupMap(segMapping)}`);

                // Segment group's first segment is always mandatory. Therefore, if a segment S1 maps to a "new" segment group SG1,
                // then S1 should match the first segment (mapping) of SG1
                EDIUnitMapping firstSegMapping = segMapping.segments[0];
                if firstSegMapping is EDISegGroupMapping {
                    return error("First item of segment group must be a segment. Found a segment group.");
                }
                if firstSegMapping.code != fields[0] {
                    // Current segment does not match with the current mapping. There can be 3 reasons for this.
                    // 1. Current mapping is optional
                    // 2. Current mapping is a repeatable one and it has already occured at least once
                    // 3. There is an error in the EDI doc

                    if segMapping.minOccurances == 0 {
                        // This is an optional segment group mapping. So we can ignore
                        log:printDebug(string `Ignoring optional segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                        mappingIndex += 1;
                        continue;
                    }
                    if segMapping.maxOccurances != 1 {
                        var segments = currentGroup[segMapping.tag];
                        if (segments is EDISegmentGroup[]) {
                            if segments.length() > 0 {
                                // This repeatable segment group has already occured at least once.
                                log:printDebug(string `Completed reading repeatable segment group: ${printSegGroupMap(segMapping)} | Segment text: ${sDesc}`);
                                mappingIndex += 1;
                                continue;
                            } 
                        }   
                    }

                    // Both above conditions does not hold. So there is an error in the EDI doc. 
                    return error(string `Mandatory segment group ${printSegGroupMap(segMapping)} could not be found.`);
                }

                // As current row's segment has mapped, we can break the inner loop
                segmentMapped = true;

                // Recursively call this function to read the child segment group.
                // Note that we provide current segment group mapping as the segment mapping (which is a child mapping 
                // of this function instance's mapping) and the current row index as the start row of the child segment group.
                // As the child segment group can have multiple segment and group mappings, it can match with multiple rows.
                // Therefore, the recursive function call returns the new row index to match with the first segment mapping 
                // that comes after this segment or segment group
                var [segmentGroup, newRawIndex] = check readEDISegmentGroup(segMapping.segments, rawSegments, currentRawIndex, ediMapping);
                currentRawIndex = newRawIndex;
                if segmentGroup.length() > 0 {
                    if segMapping.maxOccurances == 1 {
                        // This is a non-repeatable mapping. So we have to compare the next segment with the next mapping.
                        log:printDebug(string `Completed reading non-repeating segment group ${printSegGroupMap(segMapping)} | Current segment text: ${segmentDesc}`);
                        mappingIndex += 1;
                        currentGroup[segMapping.tag] = segmentGroup;
                    } else {
                        // This is a repeatable mapping. So we compare the next segment also with the current mapping.
                        // i.e. we don't increment the mapping index.
                        var segmentGroups = currentGroup[segMapping.tag];
                        if segmentGroups is EDISegmentGroup[] {
                            if segmentGroups.length() >= segMapping.maxOccurances {
                                return error(string `${printSegGroupMap(segMapping)} is repeatable segment group with maximum limit of ${segMapping.maxOccurances}.
                                EDI document contains more such segment groups than the allowed limit. Current row: ${currentRawIndex}`);    
                            }
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
                // We have reached the last row of the input EDI file.
                // If all mappings after this point are not optional, there are some mandatory mappings
                // missing in the input EDI file.
                // TODO: Iterate through all remaining mappings and verify the above condition.
                break;
            }
        }
        if mappingIndex == currentMapping.length() {
            // We have reached the end of the mapping file.
            // If there are more segments in the input EDI file, then it could be an error.
            // TODO: Check if all remaining segments are included in the ignoreSegments
            break;
        }
    }
    return [currentGroup, currentRawIndex];
}