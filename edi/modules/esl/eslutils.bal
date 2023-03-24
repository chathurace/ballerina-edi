import ballerina/regex;
import chathurace/edi.core as edi;


function getValue(string kv) returns string {
    var value = edi:split(kv, ":")[1].trim();
    return value;
}

function getStringValue(string kv) returns string {
    var value = edi:split(kv, ":")[1];
    value = regex:replaceAll(value, "'", "").trim();
    return value;
}

function getBalCompatibleStringValue(string kv) returns string {
    var value = edi:split(kv, ":")[1];
    value = regex:replaceAll(value, "'", "").trim();
    value = getBalCompatibleName(value);
    return value;
}

function getBalCompatibleName(string rawName) returns string {
    string name = regex:replaceAll(rawName, "[ ,\\,/,\\-,\\.,(,)]", "_");
    if !regex:matches(name, "^[a-zA-Z].*") {
        name = "A_" + name;
    }
    return name;
}

function getLevel(string line) returns int {
    int prefixSpaces = 0;
    foreach int i in 0...line.length() {
        if (line.substring(i, i + 1) == " ") {
            prefixSpaces = prefixSpaces + 1;
        } else {
            break;
        }
    }
    return prefixSpaces / tagSpaces;
}

function processValueLine(string line) returns map<string> {
    map<string> valueMap = {};
    int? i1 = line.indexOf("{", 0);
    int? i2 = line.indexOf("}", 0);
    if (i1 is int && i2 is int) {
        string l = line.substring(i1 + 1, i2).trim();
        string[] fields = edi:split(l, ",");
        foreach string f in fields {
            string[] kv = edi:split(f, ":");
            if (kv.length() == 2) {
                string k = kv[0].trim();
                string v = regex:replaceAll(kv[1], "'", "").trim();
                // string v = kv[1].trim();
                valueMap[k] = v;
            }
        }
    }
    return valueMap;
}

function deriveTag(map<int>? tagCounts, string tag) returns string {
    string newTag = tag;
    if tagCounts is map<int> {
        int? count = tagCounts[tag];
        if count is int {
            int newCount = count + 1;
            tagCounts[tag] = newCount;
            newTag = string `${tag}_${newCount}`;
        } else {
            tagCounts[tag] = 0;
            newTag = tag;
        }
    }

    // make the tag name compatible with Ballerina field names. this is required for code generation.
    newTag = getBalCompatibleName(newTag);
    return newTag;
}