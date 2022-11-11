type Header_SType record {|
   string orderId?;
   string date?;
|};

type Organization_SType record {|
   string partnerCode?;
   string name?;
   string address?;
   string[] contact?;
|};

type Comments_Type record {|
   string author?;
   string text?;
|};

type Items_SType record {|
   string item?;
   int quantity?;
   Comments_Type[] comments?;
|};

type PartnerOrder record {|
   Header_SType header;
   Organization_SType organization;
   Items_SType[] items;
|};

