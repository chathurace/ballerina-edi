type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

type Items_Type record {|
   string item?;
   int quantity?;
|};

type Destination_Type record {|
   string addressCode?;
   string contact?;
|};

type DestinationQuantity_Type record {|
   int quantity?;
   string deliverBy?;
|};

type Deliveries_GType record {|
   Destination_Type destination?;
   DestinationQuantity_Type destinationQuantity?;
|};

type Supplier_Type record {|
   string supplierCode?;
   string promotionCode?;
|};

type Items_GType record {|
   Items_Type items?;
   Deliveries_GType[] deliveries?;
   Supplier_Type supplier?;
|};

type Sample5 record {|
   Header_Type header?;
   Items_GType[] items;
|};

