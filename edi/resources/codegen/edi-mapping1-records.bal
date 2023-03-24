public type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

public type Items_Type record {|
   string item?;
   int quantity?;
|};

public type SimpleOrder record {|
   Header_Type header?;
   Items_Type[] items = [];
|};

