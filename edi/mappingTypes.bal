
public type EDIMapping record {|
    record {|
        string segment;
        string element;
        string subelement = ":";
        string repetition = "^";
    |} delimiters;

    map<EDISegMapping> segments = {};
|};


public type EDISegMapping record {|
    // string code;
    string tag;
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