
public type EDIUnitMapping EDISegMapping|EDISegGroupMapping;

public type EDIMapping record {|
    record {|
        string segment;
        string element;
        string subelement = ":";
        string repetition = "^";
    |} delimiters;

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
    int minOccurances = 1;
    int maxOccurances = 1;
    EDIElementMapping[] elements = [];
|};

public type EDIElementMapping record {|
    string tag;
    boolean repeat = false;
    EDIDataType dataType = STRING;
    EDISubelementMapping[] subelements = [];
|};

public type EDISubelementMapping record {|
    string tag;
    EDIDataType dataType = STRING;
|};