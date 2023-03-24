import ballerina/regex;
import ballerina/log;
import chathurace/edi.core as edi;

public function readSegmentDefinitions(string[] lines) returns map<edi:EDISegMapping>|error {

    map<int> fieldNameCount = {};
    map<edi:EDIFieldMapping> fieldMaps = check readFieldMetadata(lines);
    map<edi:EDISegMapping> segMaps = {};
    edi:EDISegMapping currentSegMap = {code: "NA", tag: "NA"};

    foreach string currentline in lines {
        string line = currentline.trim();
        if line.startsWith("composites") {
            break;
        }
        if line.startsWith("- id:") {
            currentSegMap = {code: getStringValue(line), tag: "NA"};
            // initialize field name count for this segment (this is used avoid duplicate field names within a segment)
            fieldNameCount.removeAll();
            segMaps[currentSegMap.code] = currentSegMap;            
        } else if line.startsWith("name:") {
            string tag = getBalCompatibleStringValue(line);
            tag = deriveTag(fieldNameCount, tag);
            currentSegMap.tag = tag;
        } else if line.startsWith("- { idRef:") {
            map<string> vmap = processValueLine(line);
            string? fieldCode = vmap["idRef"];
            if fieldCode is string {
                edi:EDIFieldMapping? fieldMap = fieldMaps[fieldCode];
                if fieldMap is edi:EDIFieldMapping {
                    edi:EDIFieldMapping fmapcopy = fieldMap.clone();
                    fmapcopy.tag = deriveTag(fieldNameCount, fmapcopy.tag);
                    fmapcopy.required = vmap["usage"] == "M";
                    currentSegMap.fields.push(fmapcopy);
                } else {
                    return error(string `Field mapping not found for ${fieldCode}. Line: ${line}`);
                }
            }
        } else if line.startsWith("elements:") {
            break;
        }
    }
    return segMaps;
}

function readFieldMetadata(string[] lines) returns map<edi:EDIFieldMapping>|error {
    log:printDebug("Reading single value feild definitions...");
    boolean fieldsSection = false;
    map<edi:EDIFieldMapping> fieldMaps = {};
    foreach string currentLine in lines {
        string line = currentLine.trim();
        if line.startsWith("elements:") {
            fieldsSection = true;
        } else if fieldsSection && line.startsWith("- { id:") {
            map<string> vmap = processValueLine(line);
            string? fieldCode = vmap["id"];
            string? fieldTag = vmap["name"];
            string? fieldType = vmap["type"];
            if fieldCode is string && fieldTag is string {
                edi:EDIFieldMapping fieldMap = {tag: getBalCompatibleName(fieldTag)};
                if fieldType is string {
                    if fieldType == "N" || fieldType == "N0" {
                        fieldMap.dataType = edi:INT;
                    } else if fieldType == "R" || regex:matches(fieldType, "N[1-9]") {
                        fieldMap.dataType = edi:FLOAT;
                    }
                }
                fieldMaps[fieldCode] = fieldMap;
            }
        }
    }

    int singleValueFeildDefs = fieldMaps.length();
    log:printInfo(string `Completed reading single value field definitions. ${fieldMaps.length()} definitions found.`);

    // read component definitions
    map<int> componentNameCount = {};
    boolean componentsSection = false;
    int i = 0;
    while i < lines.length() {
        string line = lines[i].trim();
        if line.startsWith("composites:") {
            log:printDebug("Start of composite definitions.");
            componentsSection = true;
        } else if line.startsWith("elements:") {
            log:printDebug("End of composite definitions.");
            componentsSection = false;
            break;
        } else if componentsSection && line.startsWith("- id:") {
            componentNameCount.removeAll();
            string componentCode = getStringValue(line);
            edi:EDIFieldMapping componentFieldDefinition = {tag: componentCode, dataType: edi:COMPOSITE};
            fieldMaps[componentCode] = componentFieldDefinition;

            // read the composite field definition until the next composite is encountered
            foreach int j in i+1...lines.length() {
                string componentLine = lines[j].trim();
                log:printDebug(string `Processing line ${j}: ${componentLine}`);
                if componentLine.startsWith("name") {
                    string tag = getStringValue(componentLine);
                    componentFieldDefinition.tag = getBalCompatibleName(tag);
                } else if componentLine.startsWith("- { idRef:") {
                    map<string> fieldData = processValueLine(componentLine);
                    string? fieldCode = fieldData["idRef"];
                    if fieldCode is string {
                        edi:EDIFieldMapping? fieldDefinition = fieldMaps[fieldCode];
                        if fieldDefinition is edi:EDIFieldMapping { 
                            edi:EDIComponentMapping componentDefinition = 
                                {tag: deriveTag(componentNameCount, fieldDefinition.tag), 
                                dataType: fieldDefinition.dataType,
                                required: fieldData["usage"] == "M"? true : false}; 
                            componentFieldDefinition.components.push(componentDefinition);
                        }
                    }
                } else if componentLine.startsWith("- id:") || componentLine.startsWith("elements:") {
                    i = j - 1;
                    break;
                }
            }

        }
        i += 1;
    }
    log:printInfo(string `Completed reading composite field definitions. ${fieldMaps.length() - singleValueFeildDefs} definitions found.`);
    return fieldMaps;
}