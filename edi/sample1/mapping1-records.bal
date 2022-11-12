type Header_SType record {|
   string orderId?;
   string organization?;
   string date?;
|};

type Items_SType record {|
   string item?;
   int quantity?;
|};

type SimpleOrder record {|
   Header_SType header;
   Items_SType[] items;
|};

