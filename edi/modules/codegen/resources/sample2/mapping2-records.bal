type Header_Type record {|
   string orderId?;
   string date?;
|};

type Organization_Type record {|
   string partnerCode?;
   string name?;
   string address?;
   string[] contact?;
|};

type Comments_Type record {|
   string author?;
   string text?;
|};

type Items_Type record {|
   string item?;
   int quantity?;
   Comments_Type[] comments?;
|};

type PartnerOrder record {|
   Header_Type header;
   Organization_Type organization;
   Items_Type[] items;
|};

