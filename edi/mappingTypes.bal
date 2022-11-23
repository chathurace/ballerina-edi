
public type EDIUnitMapping EDISegMapping|EDISegGroupMapping;

public type EDIMapping record {|
    string name;

    record {|
        string segment;
        string element;
        string subelement;
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
    EDIElementMapping[] elements = [];
|};

public type EDIElementMapping record {|
    string tag;
    boolean repeat = false;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    EDISubelementMapping[] subelements = [];
|};

public type EDISubelementMapping record {|
    string tag;
    boolean required = false;
    boolean truncatable = true;
    EDIDataType dataType = STRING;
    SubcomponentMapping[] subcomponents = [];
|};

public type SubcomponentMapping record {|
    string tag;
    boolean required = false;
    EDIDataType dataType = STRING;
|};