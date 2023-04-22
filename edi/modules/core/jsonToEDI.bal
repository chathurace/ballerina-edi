
class EDIWriter {

    EDIMapping emap;
    ComponentSerializer componentSerializer;

    function init(EDIMapping emap) {
        self.emap = emap;
        self.componentSerializer = new(emap);
    }

    function writeEDI(json msg) returns string|error {

        string[] ediText = [];
        EDISegmentGroup segGroup = check msg.cloneWithType(EDISegmentGroup);
        string[] keys = segGroup.keys();

        int msgIndex = 0;
        int mapIndex = 0;
        while mapIndex < self.emap.segments.length() {
            EDIUnitMapping umap = self.emap.segments[mapIndex];
            string unitKey = keys[msgIndex];
            EDIUnit|EDIUnit[] unit = segGroup.get(unitKey);
            if umap is EDISegMapping {
                if umap.tag != unitKey {
                    if umap.minOccurances == 0 {
                        mapIndex += 1;
                        continue;
                    } else {
                        return error(string `Mandatory segment ${umap.tag} not found in input message. Found ${unitKey}`);
                    }
                }
                if unit is EDISegment && umap.maxOccurances == 1 {
                    check self.writeSegment(unit, umap, ediText);
                } else if unit is EDISegment[] && (umap.maxOccurances > 1 || umap.maxOccurances < 0) {
                    foreach EDISegment seg in unit {
                        check self.writeSegment(seg, umap, ediText);
                    }
                } else {
                    return error(string `Cardinality of input segment ${unitKey} does not match with segment schema ${printSegMap(umap)}`);
                }
                mapIndex += 1;
                msgIndex += 1;
            } else {
                return error(string `Segment groups are not supported.`);
            }
        }
        string ediOutput = "";
        foreach string s in ediText {
            ediOutput += s + (self.emap.delimiters.segment == "\n"? "" : "\n");
            
        }
        return ediOutput;
    }

    function writeSegment(EDISegment seg, EDISegMapping segMap, string[] ediText) returns error? {
        string fd = self.emap.delimiters.'field;
        // string cd = self.emap.delimiters.component;
        string segLine = segMap.code;
        string[] fTags = seg.keys();
        if fTags.length() < segMap.fields.length() && !segMap.truncatable {
            return error(string `Segment ${segMap.code} is not truncatable. Segment schema has ${segMap.fields.length()} fields. But input segment has only ${fTags.length()} fields.`);
        }
        int fIndex = 0;
        while fIndex < segMap.fields.length() {
            EDIFieldMapping fmap = segMap.fields[fIndex];
            if fIndex >= fTags.length() {
                // Input segment is truncated. So all remaining feilds must be optional
                if fmap.required {
                    return error(string `Mandatory field ${fmap.tag} of segment ${segMap.tag} is not found in input segment ${seg.toString()}`);
                }
                fIndex += 1;
                continue;
            }
            string fTag = fTags[fIndex];
            if fmap.tag == fTag {
                if !fmap.repeat && fmap.components.length() > 0 {
                    string|error componentGroupText = self.componentSerializer.serializeComponentGroup(seg.get(fTag), segMap, fmap); 
                    if componentGroupText is string {
                        segLine += fd + componentGroupText;    
                    } else {
                        return error(string `Failed to serialize component group ${fmap.toString()} in input segment ${seg.toString()}
                        ${componentGroupText.message()}`);
                    }  
                } else if fmap.repeat {
                    string rd = self.emap.delimiters.repetition;
                    string repeatingText = "";
                    var fdata = seg.get(fTag);
                    if fdata is SimpleArray {
                        SimpleType[] s = <SimpleType[]>fdata;
                        foreach SimpleType fdataElement in s {
                            repeatingText += (repeatingText == ""? "" : rd) + fdataElement.toString();       
                        }
                    } else if fdata is EDIComponentGroup[] {
                        foreach EDIComponentGroup g in fdata {
                            string cgroupText = check self.componentSerializer.serializeComponentGroup(g, segMap, fmap);
                            repeatingText += (repeatingText == ""? "" : rd) + cgroupText;   
                        }
                    } else {
                        return error(string `Repeatable field ${fmap.tag} in segment ${printSegMap(segMap)} must match with array type. Found ${fdata.toString()}`);
                    }
                    segLine += fd + repeatingText;
                } else {
                    segLine += fd + seg.get(fTag).toString();
                }
                fIndex += 1;
            } else {
                if !fmap.required {
                    fIndex += 1;
                } else {
                    return error(string `Required field ${fmap.tag} is not found in the input segment ${segMap.tag}`);
                }
            }
        }
        segLine += self.emap.delimiters.segment;
        ediText.push(segLine);
    }

    // function writeEDIUnit(EDIUnit unit) {
    //     if EDIUnit is EDISegment
    // }
}