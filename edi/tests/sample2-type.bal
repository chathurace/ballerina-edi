type OrderDetails record {|
    record {|
        string orderId;
        string date;
    |} header;

    record {|
        string partnerCode;
        string name;
        record {|string streetAddress; string city; string country; |} address;
        string[] contact;
    |} organization;

    record {|
        string item;
        int quantity;
        record {|
            string author;
            string text;
        |}[] comments;
    |}[] items;
|};