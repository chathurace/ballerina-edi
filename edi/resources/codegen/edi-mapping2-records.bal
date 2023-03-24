public type Header_Type record {|
   string orderId?;
   string date?;
|};

public type Organization_Type record {|
   string partnerCode?;
   string name?;
   string address?;
   string[] contact = [];
|};

public type Comments_GType record {|
   string author?;
   string text?;
|};

public type Items_Type record {|
   string item?;
   int quantity?;
   Comments_GType[] comments = [];
|};

public type PartnerOrder record {|
   Header_Type header?;
   Organization_Type organization?;
   Items_Type[] items = [];
|};

