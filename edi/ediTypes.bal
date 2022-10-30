
type SimpleArray string[]|int[]|float[];

type SimpleType string|int|float;

public enum EDIDataType {
    STRING = "string", INT = "int", FLOAT = "float", COMPOSITE = "composite"
}

public type EDIDoc map<EDISegment|EDISegment[]?>;

public type EDISegmentGroup record {|
    EDISegment|EDISegment[]|EDISegmentGroup|EDISegmentGroup[]...;
|}; 

public type EDISegment map<EDIComposite|EDIComposite[]|SimpleType|SimpleArray?>;

public type EDIComposite map<SimpleType|SimpleArray>;