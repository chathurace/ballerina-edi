
public enum EDIDataType {
    STRING = "string", INT = "int", FLOAT = "float", COMPOSITE = "composite"
}

type SimpleType string|int|float;

type SimpleArray string[]|int[]|float[];

public type EDIDoc map<EDISegment|EDISegment[]?>;

public type EDISegmentGroup record {|
    EDISegment|EDISegment[]|EDISegmentGroup|EDISegmentGroup[]...;
|}; 

public type EDISegment map<EDIComposite|EDIComposite[]|SimpleType|SimpleArray?>;

public type EDIComposite map<SimpleType|SimpleArray|SubcomponentGroup?>;

public type SubcomponentGroup map<SimpleType?>;