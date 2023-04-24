
class EDIWriter {

    EDIMapping emap;
    ComponentSerializer componentSerializer;
    SegmentGroupSerializer segmentGroupSerializer;

    function init(EDIMapping emap) {
        self.emap = emap;
        self.componentSerializer = new(emap);
        self.segmentGroupSerializer = new(emap);
    }

    function writeEDI(json msg) returns string|error {
        string[] ediText = [];
        EDISegmentGroup segGroup = check msg.cloneWithType(EDISegmentGroup);
        check self.segmentGroupSerializer.serialize(segGroup, self.emap, ediText);
        string ediOutput = "";
        foreach string s in ediText {
            ediOutput += s + (self.emap.delimiters.segment == "\n"? "" : "\n");
        }
        return ediOutput;
    }
}