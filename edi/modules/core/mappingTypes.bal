
public type EDIUnitSchema EDISegSchema|EDISegGroupSchema;

public type EDISchema record {|
    string name;
    string tag = "Root mapping";

    record {|
        string segment;
        string 'field;
        string component;
        string subcomponent = "NOT_USED";
        string repetition = "NOT_USED";
        string decimalSeparator?;
    |} delimiters;

    string[] ignoreSegments = [];

    boolean preserveEmptyFields = false;

    EDIUnitSchema[] segments = [];
|};

public type EDISegGroupSchema record {|
    string tag;
    int minOccurances = 0;
    int maxOccurances = 1;
    EDIUnitSchema[] segments = [];
|};

public type EDISegSchema record {|
    string code;
    string tag;
    boolean truncatable = true;
    int minOccurances = 0;
    int maxOccurances = 1;
    EDIFieldSchema[] fields = [];
|};

public class SegSchema {
    EDISegSchema segMap = {code: "", tag: ""};
    
    function init(EDISegSchema segMap) {
        self.segMap = segMap;
    }
};

public function createSegmentMaping(string code, string tag) returns EDISegSchema {
    int minOccurs = 0;
    int maxOccurs = 0;
    EDISegSchema segMapping = {code: code, tag: tag, minOccurances: minOccurs, maxOccurances: maxOccurs};
    return segMapping;
}

public type EDIFieldSchema record {|
    string tag;
    boolean repeat = false;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    EDIComponentSchema[] components = [];
|};

public type EDIComponentSchema record {|
    string tag;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    EDISubcomponentSchema[] subcomponents = [];
|};

public type EDISubcomponentSchema record {|
    string tag;
    boolean required = false;
    EDIDataType dataType = STRING;
|};