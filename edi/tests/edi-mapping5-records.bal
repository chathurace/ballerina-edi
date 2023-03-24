public type Header_Type record {|
   string orderId?;
   string organization?;
   string date?;
|};

public type Items_Type record {|
   string item?;
   int quantity?;
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

public type Supplier_Type record {|
   string supplierCode?;
   string promotionCode?;
|};

public type Items_GType record {|
   Items_Type items?;
   Deliveries_GType[] deliveries = [];
   Supplier_Type supplier?;
|};

public type Sample5 record {|
   Header_Type header?;
   Items_GType[] items = [];
|};

