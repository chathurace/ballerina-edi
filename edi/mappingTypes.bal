
public type EDIUnitMapping EDISegMapping|EDISegGroupMapping;

public type EDIMapping record {|
    string name;

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

    EDIUnitMapping[] segments = [];
|};

public type EDISegGroupMapping record {|
    string tag;
    int minOccurances = 0;
    int maxOccurances = 1;
    EDIUnitMapping[] segments = [];
|};

public type EDISegMapping record {|
    string code;
    string tag;
    boolean truncatable = true;
    int minOccurances = 0;
    int maxOccurances = 1;
    EDIFieldMapping[] fields = [];
|};

public type EDIFieldMapping record {|
    string tag;
    boolean repeat = false;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    EDIComponentMapping[] components = [];
|};

public type EDIComponentMapping record {|
    string tag;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    EDISubcomponentMapping[] subcomponents = [];
|};

public type EDISubcomponentMapping record {|
    string tag;
    boolean required = false;
    EDIDataType dataType = STRING;
|};