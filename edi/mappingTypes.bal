public type EDISubelementMapping record {|
    string tag;
    EDIDataType dataType = STRING;
|};

public type EDIElementMapping record {|
    string tag;
    boolean repeat = false;
    EDIDataType dataType = STRING;
    EDISubelementMapping[] subelements = [];
|};

public type EDIMapping record {|
    string segmentDelimeter;
    string oSegmentDelimeter;
    string elementDelimeter;    
    string oElementDelimeter;    
    string compositeDelimiter = ":";
    string oCompositeDelimiter = ":";
    string repeatDelimeter = "\\^";
    string oRepeatDelimeter = "^";
    map<EDISegMapping> segmentMappings = {};
|};


public type EDISegMapping record {|
    string segCode;
    string tag;
    int maxOccurances = 1;
    EDIElementMapping[] elements = [];
|};