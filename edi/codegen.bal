import ballerina/io;

map<BalType> ediToBalTypes = {
    "string": BSTRING,
    "int": BINT,
    "float": BFLOAT
};

type GenContext record {|
    map<BalRecord> typeRecords = {};    
    map<int> typeNumber = {};
|};

public function generateCodeToFile(EDIMapping mapping, string outpath) returns error? {
    BalRecord[] records = generateCode(mapping);
    string sRecords = "";
    foreach BalRecord rec in records {
        sRecords += rec.toString() + "\n";
    }
    _ = check io:fileWriteString(outpath, sRecords);
}

public function generateCode(EDIMapping mapping) returns BalRecord[] {
    GenContext context = {};
    _ = generateRecordForUnits(mapping.segments, mapping.name, context);    
    return context.typeRecords.toArray();
}

function generateRecordForSegmentGroup(EDISegGroupMapping groupmap, GenContext context) returns BalRecord {
    string sgTypeName = generateTypeName(groupmap.tag, context);
    return generateRecordForUnits(groupmap.segments, sgTypeName, context);
}

function generateRecordForUnits(EDIUnitMapping[] umaps, string typeName, GenContext context) returns BalRecord {
    BalRecord sgrec = new(typeName);
    foreach EDIUnitMapping umap in umaps {
        if umap is EDISegMapping {
            BalRecord srec = generateRecordForSegment(umap, context);
            sgrec.addField(srec, umap.tag, umap.maxOccurances != 1, umap.minOccurances == 0);
        } else {
            BalRecord srec = generateRecordForSegmentGroup(umap, context);
            sgrec.addField(srec, umap.tag, umap.maxOccurances != 1, umap.minOccurances == 0);
        }
    }
    context.typeRecords[typeName] = sgrec;
    return sgrec;
}

function generateRecordForSegment(EDISegMapping segmap, GenContext context) returns BalRecord {
    string sTypeName = startWithUppercase(segmap.tag + "_Type");
    BalRecord? erec = context.typeRecords[sTypeName];
    if erec is BalRecord {
        return erec;
    }

    BalRecord srec = new(sTypeName);
    foreach EDIFieldMapping emap in segmap.fields {
        BalType? balType = ediToBalTypes[emap.dataType]; 
        if emap.dataType == COMPOSITE {
            balType = generateRecordForComposite(emap, context);
         }

         if balType is BalType {
            srec.addField(balType, emap.tag, emap.repeat, !emap.required);
         }
    }
    context.typeRecords[sTypeName] = srec;
    return srec;
}

function generateRecordForComposite(EDIFieldMapping emap, GenContext context) returns BalRecord {
    string cTypeName = generateTypeName(emap.tag, context);
    BalRecord crec = new(cTypeName);
    foreach EDIComponentMapping submap in emap.components {
        BalType? balType = ediToBalTypes[submap.dataType];
        if balType is BalType {
            crec.addField(balType, submap.tag, false, !submap.required);
        }        
    }
    context.typeRecords[cTypeName] = crec;
    return crec;
}

function startWithUppercase(string s) returns string {
    string newS = s.trim();
    if newS.length() == 0 {
        return s;
    }
    string firstLetter = newS.substring(0, 1);
    newS = firstLetter.toUpperAscii() + newS.substring(1, newS.length());
    return newS;
}

function generateTypeName(string tag, GenContext context) returns string {
    int? num = context.typeNumber[tag];
    if num is int {
        int newNum = num + 1;
        context.typeNumber[tag] = newNum;
        return startWithUppercase(string `${tag}${newNum}_GType`);
    } else {
        int newNum = 1;
        context.typeNumber[tag] = newNum;
        return startWithUppercase(tag + "_GType");
    }
}

public class BalRecord {
    string name;
    BalField[] fields = [];
    boolean closed = true;

    function init(string name) {
        self.name = name;
    }

    function addField(BalType btype, string name, boolean array, boolean optional) {
        self.fields.push(new BalField(btype, name, array, optional));
    }

    function toString(boolean... anonymous) returns string {
        if anonymous.length() == 0 {
            anonymous.push(false);
        }
        string recString = string `record {${self.closed?"|":""}` + "\n";
        foreach BalField f in self.fields {
            recString += "   " + f.toString(anonymous[0]) + "\n";
        }
        recString += string `${self.closed?"|":""}};` + "\n";

        if !anonymous[0] {
            recString = string `type ${self.name} ${recString}`; 
        }
        return recString;
    }
}

class BalField {
    string name;
    BalType btype;
    boolean array = false;
    boolean optional = true;

    function init(BalType btype, string name, boolean array, boolean optional) {
        self.btype = btype;
        self.name = name;
        self.array = array;
        self.optional = optional;
    }

    function toString(boolean... anonymous) returns string {
        if anonymous.length() == 0 {
            anonymous.push(false);
        }

        BalType t = self.btype;
        string typeName = "";
        if t is BalRecord {
            if anonymous[0] {
                typeName = t.toString(true);
            } else {
                typeName = t.name;
            }
        } else {
            typeName = t.toString();
        }
        // string typeName = t is BalRecord? t.name : t.toString();
        return string `${typeName}${self.array?"[]":""} ${self.name}${self.optional?"?":""};`;
    }
}

public type BalType BalBasicType|BalRecord;

public enum BalBasicType {
    BSTRING = "string", BINT = "int", BFLOAT = "float", BBOOLEAN = "boolean"
}
