
public type EDIUnitMapping EDISegMapping|EDISegGroupMapping;

public type EDIMapping record {|
    string name;

    record {|
        string segment;
        string element;
        string subelement;
        string repetition;
        string decimalSeparator?;
    |} delimiters;

    boolean preserveEmptyFields = false;

    EDIUnitMapping[] segments = [];
|};

public type EDISegGroupMapping record {|
    string tag;
    int minOccurances = 1;
    int maxOccurances = 1;
    EDIUnitMapping[] segments = [];
|};

public type EDISegMapping record {|
    string code;
    string tag;
    boolean truncatable = true;
    int minOccurances = 1;
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
    EDIDataType dataType = STRING;
|};