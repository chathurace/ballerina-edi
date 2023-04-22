class ComponentSerializer {

    EDIMapping emap = {delimiters: {segment: "", 'field: "", component: ""}, name: ""};

    function init(EDIMapping emap) {
        self.emap = emap;
    }    

    function serializeComponentGroup(anydata componentGroup, EDISegMapping segMap, EDIFieldMapping fmap) returns string|error {
        string cd = self.emap.delimiters.component;
        if componentGroup is EDIComponentGroup {
            string[] ckeys = componentGroup.keys();
            if ckeys.length() < fmap.components.length() && !fmap.truncatable {
                return error(string `Field ${fmap.tag} in segment ${segMap.code} must have ${fmap.components.length()} components. 
                Found only ${ckeys.length()} components in ${componentGroup.toString()}.`);
            }
            int cindex = 0;
            string cGroupText = "";
            while cindex < fmap.components.length() {
                EDIComponentMapping cmap = fmap.components[cindex];
                if cindex >= ckeys.length() {
                    if cmap.required {
                        return error(string `Mandatory component ${cmap.tag} not found in ${componentGroup.toString()} in segment ${segMap.code}`);
                    }
                    cindex += 1;
                    continue;
                }
                string ckey = ckeys[cindex];
                if ckey != cmap.tag {
                    return error(string `Component ${cmap.tag} - cindex: ${cindex} [segment: ${segMap.tag}, field: ${fmap.tag}] in the schema does not match with ${ckey} found in the input EDI.`);
                }
                var componentValue = componentGroup.get(ckey);
                if componentValue is SimpleType && cmap.subcomponents.length() == 0 {
                    cGroupText += (cGroupText == ""? "" : cd) + componentValue.toString();
                    cindex += 1;
                } else if componentValue is EDISubcomponentGroup && cmap.subcomponents.length() > 0 {
                    string scGroupText = check self.serializeSubcomponentGroup(componentValue, segMap, cmap);
                    cGroupText += (cGroupText == ""? "" : cd) + scGroupText;
                    cindex += 1;
                } else {
                    return error(string `Unsupported component value. Found ${componentValue.toString()}`);
                }
            }
            return cGroupText;
        } else if componentGroup is string && componentGroup.trim() == "" {
            if fmap.required {
                return error(string `Mandatory compite field ${fmap.tag} of segment ${segMap.tag} is not available in the input.`);
            } else {
                return "";
            }
        } else {
            return error(string `Input segment is not compatible with the schema ${printSegMap(segMap)}.
                Composite field ${fmap.toString()} is expected. Found ${componentGroup.toString()}`);
        }
    }

    function serializeSubcomponentGroup(anydata subcomponentGroup, EDISegMapping segMap, EDIComponentMapping compMap) returns string|error {
        string scd = self.emap.delimiters.subcomponent;
        if subcomponentGroup is EDISubcomponentGroup {
            string[] sckeys = subcomponentGroup.keys();
            if sckeys.length() < compMap.subcomponents.length() && !compMap.truncatable {
                return error(string `Component ${compMap.tag} in segment ${segMap.code} must have ${compMap.subcomponents.length()} subcomponents. 
                Found only ${sckeys.length()} subcomponents in ${subcomponentGroup.toString()}.`);
            }
            int scindex = 0;
            string scGroupText = "";
            while scindex < compMap.subcomponents.length() {
                EDISubcomponentMapping scmap = compMap.subcomponents[scindex];
                if scindex >= sckeys.length() {
                    if scmap.required {
                        return error(string `Mandatory subcomponent ${scmap.tag} not found in ${subcomponentGroup.toString()} in segment ${segMap.code}`);
                    }
                    scindex += 1;
                    continue;
                }
                string sckey = sckeys[scindex];
                if sckey != scmap.tag {
                    return error(string `Subcomponent ${scmap.tag} - scindex: ${scindex} [segment: ${segMap.tag}, component: ${compMap.tag}] in the schema does not match with ${sckey} found in the input EDI.`);
                }
                var subcomponentValue = subcomponentGroup.get(sckey);
                if subcomponentValue is SimpleType {
                    scGroupText += (scGroupText == ""? "" : scd) + subcomponentValue.toString();
                    scindex += 1;
                } else {
                    return error(string `Only primitive types are supported as subcomponent values. Found ${subcomponentValue.toString()}`);
                }
            }
            return scGroupText;
        } else if subcomponentGroup is string && subcomponentGroup.trim() == "" {
            if compMap.required {
                return error(string `Mandatory sub-compite field ${compMap.tag} of segment ${segMap.tag} is not available in the input.`);
            } else {
                return "";
            }
        } else {
            return error(string `Input segment is not compatible with the schema ${printSegMap(segMap)}.
                Sub-composite field ${compMap.toString()} is expected. Found ${subcomponentGroup.toString()}`);
        }
    }

    
}