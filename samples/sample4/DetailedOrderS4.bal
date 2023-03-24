type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

type Item_Type record {|
   string itemId?;
   int quantity?;
|};

type Supplier_Type record {|
   string supplierCode?;
   string promotionCode?;
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

type Items_GType record {|
   Item_Type item?;
   Supplier_Type supplier?;
   Deliveries_GType[] deliveries?;
|};

type DetailedOrderS4 record {|
   Header_Type header?;
   Items_GType[] items;
|};

