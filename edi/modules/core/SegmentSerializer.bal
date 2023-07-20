class SegmentSerializer {

    EDISchema emap;
    ComponentSerializer componentSerializer;

    function init(EDISchema emap) {
        self.emap = emap;
        self.componentSerializer = new(emap);
    }

    function serialize(map<json> seg, EDISegSchema segMap, string[] ediText) returns error? {
        string fd = self.emap.delimiters.'field;
        // string cd = self.emap.delimiters.component;
        string segLine = segMap.code;
        string[] fTags = seg.keys();
        if fTags.length() < segMap.fields.length() && !segMap.truncatable {
            return error(string `Segment ${segMap.code} is not truncatable. Segment schema has ${segMap.fields.length()} fields. But input segment has only ${fTags.length()} fields.`);
        }
        int fIndex = 0;
        while fIndex < segMap.fields.length() {
            EDIFieldSchema fmap = segMap.fields[fIndex];
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
                    var fdata = seg.get(fTag);
                    if !(fdata is json[]) {
                        return error(string `Field ${fmap.tag} in segment ${segMap.code} must have an array as the value. Found: ${fdata.toString()}`);
                    }
                    if fdata.length() == 0 {
                        if fmap.required {
                            return error(string `Mandatory field ${fmap.tag} in segment ${segMap.code} not provided.`);
                        } else {
                            segLine += fd + "";
                            fIndex += 1;
                            continue;                                
                        }
                    }
                    string rd = self.emap.delimiters.repetition;
                    string repeatingText = "";
                    if fmap.components.length() == 0 {
                        if fdata is SimpleType[] {
                            foreach SimpleType fdataElement in fdata {
                                repeatingText += (repeatingText == ""? "" : rd) + fdataElement.toString();   
                            }    
                        } else {
                            return error(string `Repeatable field ${fmap.tag} in segment ${segMap.tag} must be a primitive type array. Found: ${fdata.toString()}`);
                        }
                    } else if fmap.components.length() > 0 {
                        foreach json g in fdata {
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
}