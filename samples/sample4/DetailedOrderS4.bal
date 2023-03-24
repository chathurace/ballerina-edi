public type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

public type Item_Type record {|
   string itemId?;
   int quantity?;
|};

public type Supplier_Type record {|
   string supplierCode?;
   string promotionCode?;
|};

public type Destination_Type record {|
   string addressCode?;
   string contact?;
|};

public type DestinationQuantity_Type record {|
   int quantity?;
   string deliverBy?;
|};

public type Deliveries_GType record {|
   Destination_Type destination?;
   DestinationQuantity_Type destinationQuantity?;
|};

public type Items_GType record {|
   Item_Type item?;
   Supplier_Type supplier?;
   Deliveries_GType[] deliveries = [];
|};

public type DetailedOrderS4 record {|
   Header_Type header?;
   Items_GType[] items = [];
|};

