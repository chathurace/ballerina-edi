type Header_SType record {|
   string orderId?;
   string organization?;
   string date?;
|};

type Items_SType record {|
   string item?;
   int quantity?;
|};

type Destination_SType record {|
   string addressCode?;
   string contact?;
|};

type DestinationQuantity_SType record {|
   int quantity?;
   string deliverBy?;
|};

type Deliveries_Type record {|
   Destination_SType destination?;
   DestinationQuantity_SType destinationQuantity?;
|};

type Supplier_SType record {|
   string supplierCode?;
   string promotionCode?;
|};

type Items_Type record {|
   Items_SType items?;
   Deliveries_Type[] deliveries?;
   Supplier_SType supplier?;
|};

type DetailedOrder record {|
   Header_SType header?;
   Items_Type[] items;
|};

