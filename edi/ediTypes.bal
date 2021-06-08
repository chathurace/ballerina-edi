
type SimpleArray string[]|int[]|float[];

type SimpleType string|int|float;

public enum EDIDataType {
    STRING, INT, FLOAT, COMPOSITE
}

public type EDIDoc record {|        
    EDISegment|EDISegment[]...;
|};

public type EDISegment record {|
    EDIComposite|EDIComposite[]|SimpleType|SimpleArray...;
|};

public type EDIComposite record {|
    SimpleType|SimpleArray...;
|};
