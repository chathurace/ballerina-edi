public type DOCUMENT_MESSAGE_NAME_GType record {|
   string Document_message_name__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Document_message_name?;
|};

public type Beginning_of_message_Type record {|
   DOCUMENT_MESSAGE_NAME_GType DOCUMENT_MESSAGE_NAME?;
   string Document_message_number?;
   string Message_function__coded?;
   string Response_type__coded?;
|};

public type DATE_TIME_PERIOD_GType record {|
   string Date_time_period_qualifier?;
   string Date_time_period?;
   string Date_time_period_format_qualifier?;
|};

public type Date_time_period_Type record {|
   DATE_TIME_PERIOD_GType DATE_TIME_PERIOD?;
|};

public type PAYMENT_INSTRUCTION_DETAILS_GType record {|
   string Payment_conditions__coded?;
   string Payment_guarantee__coded?;
   string Payment_means__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Payment_channel__coded?;
|};

public type Payment_instructions_Type record {|
   PAYMENT_INSTRUCTION_DETAILS_GType PAYMENT_INSTRUCTION_DETAILS?;
|};

public type Additional_information_Type record {|
   string Country_of_origin__coded?;
   string Type_of_duty_regime__coded?;
   string Special_conditions__coded?;
   string Special_conditions__coded_1?;
   string Special_conditions__coded_2?;
   string Special_conditions__coded_3?;
   string Special_conditions__coded_4?;
|};

public type ITEM_DESCRIPTION_GType record {|
   string Item_description_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Item_description?;
   string Item_description_1?;
|};

public type Item_description_Type record {|
   string Item_description_type__coded?;
   string Item_characteristic__coded?;
   ITEM_DESCRIPTION_GType ITEM_DESCRIPTION?;
   string Surface_layer_indicator__coded?;
|};

public type TEXT_REFERENCE_GType record {|
   string Free_text__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type TEXT_LITERAL_GType record {|
   string Free_text?;
   string Free_text_1?;
   string Free_text_2?;
   string Free_text_3?;
   string Free_text_4?;
|};

public type Free_text_Type record {|
   string Text_subject_qualifier?;
   string Text_function__coded?;
   TEXT_REFERENCE_GType TEXT_REFERENCE?;
   TEXT_LITERAL_GType TEXT_LITERAL?;
   string Language__coded?;
|};

public type REFERENCE_GType record {|
   string Reference_qualifier?;
   string Reference_number?;
   string Line_number?;
   string Reference_version_number?;
|};

public type Reference_Type record {|
   REFERENCE_GType REFERENCE?;
|};

public type Segment_Group_1_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type PARTY_IDENTIFICATION_DETAILS_GType record {|
   string Party_id_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type NAME_AND_ADDRESS_GType record {|
   string Name_and_address_line?;
   string Name_and_address_line_1?;
   string Name_and_address_line_2?;
   string Name_and_address_line_3?;
   string Name_and_address_line_4?;
|};

public type PARTY_NAME_GType record {|
   string Party_name?;
   string Party_name_1?;
   string Party_name_2?;
   string Party_name_3?;
   string Party_name_4?;
   string Party_name_format__coded?;
|};

public type STREET_GType record {|
   string Street_and_number_P_O__Box?;
   string Street_and_number_P_O__Box_1?;
   string Street_and_number_P_O__Box_2?;
|};

public type Name_and_address_Type record {|
   string Party_qualifier?;
   PARTY_IDENTIFICATION_DETAILS_GType PARTY_IDENTIFICATION_DETAILS?;
   NAME_AND_ADDRESS_GType NAME_AND_ADDRESS?;
   PARTY_NAME_GType PARTY_NAME?;
   STREET_GType STREET?;
   string City_name?;
   string Country_sub_entity_identification?;
   string Postcode_identification?;
   string Country__coded?;
|};

public type LOCATION_IDENTIFICATION_GType record {|
   string Place_location_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Place_location?;
|};

public type RELATED_LOCATION_ONE_IDENTIFICATION_GType record {|
   string Related_place_location_one_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Related_place_location_one?;
|};

public type RELATED_LOCATION_TWO_IDENTIFICATION_GType record {|
   string Related_place_location_two_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Related_place_location_two?;
|};

public type Place_location_identification_Type record {|
   string Place_location_qualifier?;
   LOCATION_IDENTIFICATION_GType LOCATION_IDENTIFICATION?;
   RELATED_LOCATION_ONE_IDENTIFICATION_GType RELATED_LOCATION_ONE_IDENTIFICATION?;
   RELATED_LOCATION_TWO_IDENTIFICATION_GType RELATED_LOCATION_TWO_IDENTIFICATION?;
   string Relation__coded?;
|};

public type ACCOUNT_IDENTIFICATION_GType record {|
   string Account_holder_number?;
   string Account_holder_name?;
   string Account_holder_name_1?;
   string Currency__coded?;
|};

public type INSTITUTION_IDENTIFICATION_GType record {|
   string Institution_name_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Institution_branch_number?;
   string Code_list_qualifier_1?;
   string Code_list_responsible_agency__coded_1?;
   string Institution_name?;
   string Institution_branch_place?;
|};

public type Financial_institution_information_Type record {|
   string Party_qualifier?;
   ACCOUNT_IDENTIFICATION_GType ACCOUNT_IDENTIFICATION?;
   INSTITUTION_IDENTIFICATION_GType INSTITUTION_IDENTIFICATION?;
   string Country__coded?;
|};

public type Segment_Group_3_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type DOCUMENT_MESSAGE_NAME2_GType record {|
   string Document_message_name__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Document_message_name?;
|};

public type DOCUMENT_MESSAGE_DETAILS_GType record {|
   string Document_message_number?;
   string Document_message_status__coded?;
   string Document_message_source?;
   string Language__coded?;
|};

public type Document_message_details_Type record {|
   DOCUMENT_MESSAGE_NAME2_GType DOCUMENT_MESSAGE_NAME?;
   DOCUMENT_MESSAGE_DETAILS_GType DOCUMENT_MESSAGE_DETAILS?;
   string Communication_channel_identifier__coded?;
   float Number_of_copies_of_document_required?;
   float Number_of_originals_of_document_required?;
|};

public type Segment_Group_4_GType record {|
   Document_message_details_Type Document_message_details;
   Date_time_period_Type[] Date_time_period = [];
|};

public type DEPARTMENT_OR_EMPLOYEE_DETAILS_GType record {|
   string Department_or_employee_identification?;
   string Department_or_employee?;
|};

public type Contact_information_Type record {|
   string Contact_function__coded?;
   DEPARTMENT_OR_EMPLOYEE_DETAILS_GType DEPARTMENT_OR_EMPLOYEE_DETAILS?;
|};

public type COMMUNICATION_CONTACT_GType record {|
   string Communication_number?;
   string Communication_channel_qualifier?;
|};

public type Communication_contact_Type record {|
   COMMUNICATION_CONTACT_GType COMMUNICATION_CONTACT?;
|};

public type Segment_Group_5_GType record {|
   Contact_information_Type Contact_information;
   Communication_contact_Type[] Communication_contact = [];
|};

public type Segment_Group_2_GType record {|
   Name_and_address_Type Name_and_address;
   Place_location_identification_Type[] Place_location_identification = [];
   Financial_institution_information_Type[] Financial_institution_information = [];
   Segment_Group_3_GType[] Segment_Group_3 = [];
   Segment_Group_4_GType[] Segment_Group_4 = [];
   Segment_Group_5_GType[] Segment_Group_5 = [];
|};

public type DUTY_TAX_FEE_TYPE_GType record {|
   string Duty_tax_fee_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Duty_tax_fee_type?;
|};

public type DUTY_TAX_FEE_ACCOUNT_DETAIL_GType record {|
   string Duty_tax_fee_account_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type DUTY_TAX_FEE_DETAIL_GType record {|
   string Duty_tax_fee_rate_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Duty_tax_fee_rate?;
   string Duty_tax_fee_rate_basis_identification?;
   string Code_list_qualifier_1?;
   string Code_list_responsible_agency__coded_1?;
|};

public type Duty_tax_fee_details_Type record {|
   string Duty_tax_fee_function_qualifier?;
   DUTY_TAX_FEE_TYPE_GType DUTY_TAX_FEE_TYPE?;
   DUTY_TAX_FEE_ACCOUNT_DETAIL_GType DUTY_TAX_FEE_ACCOUNT_DETAIL?;
   string Duty_tax_fee_assessment_basis?;
   DUTY_TAX_FEE_DETAIL_GType DUTY_TAX_FEE_DETAIL?;
   string Duty_tax_fee_category__coded?;
   string Party_tax_identification_number?;
|};

public type MONETARY_AMOUNT_GType record {|
   string Monetary_amount_type_qualifier?;
   float Monetary_amount?;
   string Currency__coded?;
   string Currency_qualifier?;
   string Status__coded?;
|};

public type Monetary_amount_Type record {|
   MONETARY_AMOUNT_GType MONETARY_AMOUNT?;
|};

public type Segment_Group_6_GType record {|
   Duty_tax_fee_details_Type Duty_tax_fee_details;
   Monetary_amount_Type Monetary_amount?;
   Place_location_identification_Type[] Place_location_identification = [];
|};

public type CURRENCY_DETAILS_GType record {|
   string Currency_details_qualifier?;
   string Currency__coded?;
   string Currency_qualifier?;
   float Currency_rate_base?;
|};

public type CURRENCY_DETAILS_1_GType record {|
   string Currency_details_qualifier?;
   string Currency__coded?;
   string Currency_qualifier?;
   float Currency_rate_base?;
|};

public type Currencies_Type record {|
   CURRENCY_DETAILS_GType CURRENCY_DETAILS?;
   CURRENCY_DETAILS_1_GType CURRENCY_DETAILS_1?;
   float Rate_of_exchange?;
   string Currency_market_exchange__coded?;
|};

public type Segment_Group_7_GType record {|
   Currencies_Type Currencies;
   Date_time_period_Type[] Date_time_period = [];
|};

public type PAYMENT_TERMS_GType record {|
   string Terms_of_payment_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Terms_of_payment?;
   string Terms_of_payment_1?;
|};

public type TERMS_TIME_INFORMATION_GType record {|
   string Payment_time_reference__coded?;
   string Time_relation__coded?;
   string Type_of_period__coded?;
   float Number_of_periods?;
|};

public type Payment_terms_basis_Type record {|
   string Payment_terms_type_qualifier?;
   PAYMENT_TERMS_GType PAYMENT_TERMS?;
   TERMS_TIME_INFORMATION_GType TERMS_TIME_INFORMATION?;
|};

public type PERCENTAGE_DETAILS_GType record {|
   string Percentage_qualifier?;
   float Percentage?;
   string Percentage_basis__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type Percentage_details_Type record {|
   PERCENTAGE_DETAILS_GType PERCENTAGE_DETAILS?;
|};

public type Segment_Group_8_GType record {|
   Payment_terms_basis_Type Payment_terms_basis;
   Date_time_period_Type[] Date_time_period = [];
   Percentage_details_Type Percentage_details?;
   Monetary_amount_Type Monetary_amount?;
|};

public type MODE_OF_TRANSPORT_GType record {|
   string Mode_of_transport__coded?;
   string Mode_of_transport?;
|};

public type TRANSPORT_MEANS_GType record {|
   string Type_of_means_of_transport_identification?;
   string Type_of_means_of_transport?;
|};

public type CARRIER_GType record {|
   string Carrier_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Carrier_name?;
|};

public type EXCESS_TRANSPORTATION_INFORMATION_GType record {|
   string Excess_transportation_reason__coded?;
   string Excess_transportation_responsibility__coded?;
   string Customer_authorization_number?;
|};

public type TRANSPORT_IDENTIFICATION_GType record {|
   string Id_of_means_of_transport_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Id_of_the_means_of_transport?;
   string Nationality_of_means_of_transport__coded?;
|};

public type Details_of_transport_Type record {|
   string Transport_stage_qualifier?;
   string Conveyance_reference_number?;
   MODE_OF_TRANSPORT_GType MODE_OF_TRANSPORT?;
   TRANSPORT_MEANS_GType TRANSPORT_MEANS?;
   CARRIER_GType CARRIER?;
   string Transit_direction__coded?;
   EXCESS_TRANSPORTATION_INFORMATION_GType EXCESS_TRANSPORTATION_INFORMATION?;
   TRANSPORT_IDENTIFICATION_GType TRANSPORT_IDENTIFICATION?;
|};

public type Segment_Group_10_GType record {|
   Place_location_identification_Type Place_location_identification;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_9_GType record {|
   Details_of_transport_Type Details_of_transport;
   Segment_Group_10_GType[] Segment_Group_10 = [];
|};

public type TERMS_OF_DELIVERY_GType record {|
   string Terms_of_delivery__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Terms_of_delivery?;
   string Terms_of_delivery_1?;
|};

public type Terms_of_delivery_Type record {|
   string Terms_of_delivery_function__coded?;
   string Transport_charges_method_of_payment__coded?;
   TERMS_OF_DELIVERY_GType TERMS_OF_DELIVERY?;
|};

public type Segment_Group_11_GType record {|
   Terms_of_delivery_Type Terms_of_delivery;
   Place_location_identification_Type[] Place_location_identification = [];
|};

public type PACKAGING_DETAILS_GType record {|
   string Packaging_level__coded?;
   string Packaging_related_information__coded?;
   string Packaging_terms_and_conditions__coded?;
|};

public type PACKAGE_TYPE_GType record {|
   string Type_of_packages_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Type_of_packages?;
|};

public type PACKAGE_TYPE_IDENTIFICATION_GType record {|
   string Item_description_type__coded?;
   string Type_of_packages?;
   string Item_number_type__coded?;
   string Type_of_packages_1?;
   string Item_number_type__coded_1?;
|};

public type RETURNABLE_PACKAGE_DETAILS_GType record {|
   string Returnable_package_freight_payment_responsibility__coded?;
   string Returnable_package_load_contents__coded?;
|};

public type Package_Type record {|
   float Number_of_packages?;
   PACKAGING_DETAILS_GType PACKAGING_DETAILS?;
   PACKAGE_TYPE_GType PACKAGE_TYPE?;
   PACKAGE_TYPE_IDENTIFICATION_GType PACKAGE_TYPE_IDENTIFICATION?;
   RETURNABLE_PACKAGE_DETAILS_GType RETURNABLE_PACKAGE_DETAILS?;
|};

public type MEASUREMENT_DETAILS_GType record {|
   string Measurement_dimension__coded?;
   string Measurement_significance__coded?;
   string Measurement_attribute__coded?;
|};

public type VALUE_RANGE_GType record {|
   string Measure_unit_qualifier?;
   float Measurement_value?;
   float Range_minimum?;
   float Range_maximum?;
|};

public type Measurements_Type record {|
   string Measurement_application_qualifier?;
   MEASUREMENT_DETAILS_GType MEASUREMENT_DETAILS?;
   VALUE_RANGE_GType VALUE_RANGE?;
   string Surface_layer_indicator__coded?;
|};

public type MARKS___LABELS_GType record {|
   string Shipping_marks?;
   string Shipping_marks_1?;
   string Shipping_marks_2?;
   string Shipping_marks_3?;
   string Shipping_marks_4?;
   string Shipping_marks_5?;
   string Shipping_marks_6?;
   string Shipping_marks_7?;
   string Shipping_marks_8?;
   string Shipping_marks_9?;
|};

public type Package_identification_Type record {|
   string Marking_instructions__coded?;
   MARKS___LABELS_GType MARKS___LABELS?;
   string Container_package_status__coded?;
|};

public type IDENTITY_NUMBER_RANGE_GType record {|
   string Identity_number?;
   string Identity_number_1?;
|};

public type IDENTITY_NUMBER_RANGE_1_GType record {|
   string Identity_number?;
   string Identity_number_1?;
|};

public type IDENTITY_NUMBER_RANGE_2_GType record {|
   string Identity_number?;
   string Identity_number_1?;
|};

public type IDENTITY_NUMBER_RANGE_3_GType record {|
   string Identity_number?;
   string Identity_number_1?;
|};

public type IDENTITY_NUMBER_RANGE_4_GType record {|
   string Identity_number?;
   string Identity_number_1?;
|};

public type Goods_identity_number_Type record {|
   string Identity_number_qualifier?;
   IDENTITY_NUMBER_RANGE_GType IDENTITY_NUMBER_RANGE?;
   IDENTITY_NUMBER_RANGE_1_GType IDENTITY_NUMBER_RANGE_1?;
   IDENTITY_NUMBER_RANGE_2_GType IDENTITY_NUMBER_RANGE_2?;
   IDENTITY_NUMBER_RANGE_3_GType IDENTITY_NUMBER_RANGE_3?;
   IDENTITY_NUMBER_RANGE_4_GType IDENTITY_NUMBER_RANGE_4?;
|};

public type Segment_Group_13_GType record {|
   Package_identification_Type Package_identification;
   Reference_Type Reference?;
   Date_time_period_Type[] Date_time_period = [];
   Goods_identity_number_Type[] Goods_identity_number = [];
|};

public type Segment_Group_12_GType record {|
   Package_Type Package;
   Measurements_Type[] Measurements = [];
   Segment_Group_13_GType[] Segment_Group_13 = [];
|};

public type ALLOWANCE_CHARGE_INFORMATION_GType record {|
   string Allowance_or_charge_number?;
   string Charge_allowance_description__coded?;
|};

public type SPECIAL_SERVICES_IDENTIFICATION_GType record {|
   string Special_services__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Special_service?;
|};

public type Allowance_or_charge_Type record {|
   string Allowance_or_charge_qualifier?;
   ALLOWANCE_CHARGE_INFORMATION_GType ALLOWANCE_CHARGE_INFORMATION?;
   string Settlement__coded?;
   string Calculation_sequence_indicator__coded?;
   SPECIAL_SERVICES_IDENTIFICATION_GType SPECIAL_SERVICES_IDENTIFICATION?;
|};

public type Segment_Group_15_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type QUANTITY_DETAILS_GType record {|
   string Quantity_qualifier?;
   float Quantity?;
   string Measure_unit_qualifier?;
|};

public type Quantity_Type record {|
   QUANTITY_DETAILS_GType QUANTITY_DETAILS?;
|};

public type RANGE_GType record {|
   string Measure_unit_qualifier?;
   float Range_minimum?;
   float Range_maximum?;
|};

public type Range_details_Type record {|
   string Range_type_qualifier?;
   RANGE_GType RANGE?;
|};

public type Segment_Group_16_GType record {|
   Quantity_Type Quantity;
   Range_details_Type Range_details?;
|};

public type Segment_Group_17_GType record {|
   Percentage_details_Type Percentage_details;
   Range_details_Type Range_details?;
|};

public type Segment_Group_18_GType record {|
   Monetary_amount_Type Monetary_amount;
   Range_details_Type Range_details?;
|};

public type RATE_DETAILS_GType record {|
   string Rate_type_qualifier?;
   float Rate_per_unit?;
   float Unit_price_basis?;
   string Measure_unit_qualifier?;
|};

public type Rate_details_Type record {|
   RATE_DETAILS_GType RATE_DETAILS?;
|};

public type Segment_Group_19_GType record {|
   Rate_details_Type Rate_details;
   Range_details_Type Range_details?;
|};

public type Segment_Group_20_GType record {|
   Duty_tax_fee_details_Type Duty_tax_fee_details;
   Monetary_amount_Type Monetary_amount?;
|};

public type Segment_Group_14_GType record {|
   Allowance_or_charge_Type Allowance_or_charge;
   Additional_information_Type[] Additional_information = [];
   Segment_Group_15_GType[] Segment_Group_15 = [];
   Segment_Group_16_GType Segment_Group_16?;
   Segment_Group_17_GType Segment_Group_17?;
   Segment_Group_18_GType[] Segment_Group_18 = [];
   Segment_Group_19_GType Segment_Group_19?;
   Segment_Group_20_GType[] Segment_Group_20 = [];
|};

public type REQUIREMENT_CONDITION_IDENTIFICATION_GType record {|
   string Requirement_condition_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type Requirements_and_conditions_Type record {|
   string Sector_subject_identification_qualifier?;
   REQUIREMENT_CONDITION_IDENTIFICATION_GType REQUIREMENT_CONDITION_IDENTIFICATION?;
   string Action_request_notification__coded?;
|};

public type Segment_Group_21_GType record {|
   Requirements_and_conditions_Type Requirements_and_conditions;
   Reference_Type[] Reference = [];
   Date_time_period_Type[] Date_time_period = [];
   Free_text_Type[] Free_text = [];
|};

public type ITEM_NUMBER_IDENTIFICATION_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type Line_item_Type record {|
   float Line_item_number?;
   string Action_request_notification__coded?;
   ITEM_NUMBER_IDENTIFICATION_GType ITEM_NUMBER_IDENTIFICATION?;
   string Sub_line_indicator__coded?;
   float Configuration_level?;
   string Configuration__coded?;
|};

public type ITEM_NUMBER_IDENTIFICATION2_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type ITEM_NUMBER_IDENTIFICATION_1_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type ITEM_NUMBER_IDENTIFICATION_2_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type ITEM_NUMBER_IDENTIFICATION_3_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type ITEM_NUMBER_IDENTIFICATION_4_GType record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

public type Additional_product_id_Type record {|
   string Product_id_function_qualifier?;
   ITEM_NUMBER_IDENTIFICATION2_GType ITEM_NUMBER_IDENTIFICATION?;
   ITEM_NUMBER_IDENTIFICATION_1_GType ITEM_NUMBER_IDENTIFICATION_1?;
   ITEM_NUMBER_IDENTIFICATION_2_GType ITEM_NUMBER_IDENTIFICATION_2?;
   ITEM_NUMBER_IDENTIFICATION_3_GType ITEM_NUMBER_IDENTIFICATION_3?;
   ITEM_NUMBER_IDENTIFICATION_4_GType ITEM_NUMBER_IDENTIFICATION_4?;
|};

public type IDENTIFICATION_NUMBER_GType record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

public type IDENTIFICATION_NUMBER_1_GType record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

public type IDENTIFICATION_NUMBER_2_GType record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

public type IDENTIFICATION_NUMBER_3_GType record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

public type IDENTIFICATION_NUMBER_4_GType record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

public type Related_identification_numbers_Type record {|
   string Set_identification_qualifier?;
   IDENTIFICATION_NUMBER_GType IDENTIFICATION_NUMBER?;
   IDENTIFICATION_NUMBER_1_GType IDENTIFICATION_NUMBER_1?;
   IDENTIFICATION_NUMBER_2_GType IDENTIFICATION_NUMBER_2?;
   IDENTIFICATION_NUMBER_3_GType IDENTIFICATION_NUMBER_3?;
   IDENTIFICATION_NUMBER_4_GType IDENTIFICATION_NUMBER_4?;
|};

public type QUANTITY_DIFFERENCE_INFORMATION_GType record {|
   float Quantity_difference?;
   string Quantity_qualifier?;
|};

public type REASON_FOR_CHANGE_GType record {|
   string Change_reason__coded?;
   string Change_reason?;
|};

public type Quantity_variances_Type record {|
   QUANTITY_DIFFERENCE_INFORMATION_GType QUANTITY_DIFFERENCE_INFORMATION?;
   string Discrepancy__coded?;
   REASON_FOR_CHANGE_GType REASON_FOR_CHANGE?;
|};

public type Segment_Group_23_GType record {|
   Monetary_amount_Type Monetary_amount;
   Currencies_Type Currencies?;
|};

public type Segment_Group_24_GType record {|
   Payment_terms_basis_Type Payment_terms_basis;
   Date_time_period_Type[] Date_time_period = [];
   Percentage_details_Type Percentage_details?;
   Monetary_amount_Type Monetary_amount?;
|};

public type PRICE_INFORMATION_GType record {|
   string Price_qualifier?;
   float Price?;
   string Price_type__coded?;
   string Price_type_qualifier?;
   float Unit_price_basis?;
   string Measure_unit_qualifier?;
|};

public type Price_details_Type record {|
   PRICE_INFORMATION_GType PRICE_INFORMATION?;
   string Sub_line_price_change__coded?;
|};

public type PRICE_MULTIPLIER_INFORMATION_GType record {|
   float Price_multiplier?;
   string Price_multiplier_qualifier?;
|};

public type REASON_FOR_CHANGE2_GType record {|
   string Change_reason__coded?;
   string Change_reason?;
|};

public type Additional_price_information_Type record {|
   string Class_of_trade__coded?;
   PRICE_MULTIPLIER_INFORMATION_GType PRICE_MULTIPLIER_INFORMATION?;
   REASON_FOR_CHANGE2_GType REASON_FOR_CHANGE?;
|};

public type Segment_Group_25_GType record {|
   Price_details_Type Price_details;
   Additional_price_information_Type Additional_price_information?;
   Range_details_Type Range_details?;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_26_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_28_GType record {|
   Package_identification_Type Package_identification;
   Reference_Type Reference?;
   Date_time_period_Type[] Date_time_period = [];
   Goods_identity_number_Type[] Goods_identity_number = [];
|};

public type Segment_Group_27_GType record {|
   Package_Type Package;
   Measurements_Type[] Measurements = [];
   Segment_Group_28_GType[] Segment_Group_28 = [];
|};

public type Segment_Group_29_GType record {|
   Place_location_identification_Type Place_location_identification;
   Quantity_Type Quantity?;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_30_GType record {|
   Duty_tax_fee_details_Type Duty_tax_fee_details;
   Monetary_amount_Type Monetary_amount?;
   Place_location_identification_Type[] Place_location_identification = [];
|};

public type Segment_Group_32_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_33_GType record {|
   Document_message_details_Type Document_message_details;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_34_GType record {|
   Contact_information_Type Contact_information;
   Communication_contact_Type[] Communication_contact = [];
|};

public type Segment_Group_31_GType record {|
   Name_and_address_Type Name_and_address;
   Place_location_identification_Type[] Place_location_identification = [];
   Segment_Group_32_GType[] Segment_Group_32 = [];
   Segment_Group_33_GType[] Segment_Group_33 = [];
   Segment_Group_34_GType[] Segment_Group_34 = [];
|};

public type Segment_Group_36_GType record {|
   Quantity_Type Quantity;
   Range_details_Type Range_details?;
|};

public type Segment_Group_37_GType record {|
   Percentage_details_Type Percentage_details;
   Range_details_Type Range_details?;
|};

public type Segment_Group_38_GType record {|
   Monetary_amount_Type Monetary_amount;
   Range_details_Type Range_details?;
|};

public type Segment_Group_39_GType record {|
   Rate_details_Type Rate_details;
   Range_details_Type Range_details?;
|};

public type Segment_Group_40_GType record {|
   Duty_tax_fee_details_Type Duty_tax_fee_details;
   Monetary_amount_Type Monetary_amount?;
|};

public type Segment_Group_35_GType record {|
   Allowance_or_charge_Type Allowance_or_charge;
   Additional_information_Type[] Additional_information = [];
   Segment_Group_36_GType Segment_Group_36?;
   Segment_Group_37_GType Segment_Group_37?;
   Segment_Group_38_GType[] Segment_Group_38 = [];
   Segment_Group_39_GType Segment_Group_39?;
   Segment_Group_40_GType[] Segment_Group_40 = [];
|};

public type Segment_Group_42_GType record {|
   Place_location_identification_Type Place_location_identification;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_41_GType record {|
   Details_of_transport_Type Details_of_transport;
   Segment_Group_42_GType[] Segment_Group_42 = [];
|};

public type Segment_Group_43_GType record {|
   Terms_of_delivery_Type Terms_of_delivery;
   Place_location_identification_Type[] Place_location_identification = [];
|};

public type Segment_Group_44_GType record {|
   Requirements_and_conditions_Type Requirements_and_conditions;
   Reference_Type[] Reference = [];
   Date_time_period_Type[] Date_time_period = [];
   Free_text_Type[] Free_text = [];
|};

public type Segment_Group_22_GType record {|
   Line_item_Type Line_item;
   Additional_product_id_Type[] Additional_product_id = [];
   Item_description_Type[] Item_description = [];
   Measurements_Type[] Measurements = [];
   Quantity_Type[] Quantity = [];
   Percentage_details_Type Percentage_details?;
   Additional_information_Type[] Additional_information = [];
   Date_time_period_Type[] Date_time_period = [];
   Goods_identity_number_Type[] Goods_identity_number = [];
   Related_identification_numbers_Type[] Related_identification_numbers = [];
   Quantity_variances_Type Quantity_variances?;
   Free_text_Type[] Free_text = [];
   Segment_Group_23_GType[] Segment_Group_23 = [];
   Segment_Group_24_GType[] Segment_Group_24 = [];
   Segment_Group_25_GType[] Segment_Group_25 = [];
   Segment_Group_26_GType[] Segment_Group_26 = [];
   Segment_Group_27_GType[] Segment_Group_27 = [];
   Segment_Group_29_GType[] Segment_Group_29 = [];
   Segment_Group_30_GType[] Segment_Group_30 = [];
   Segment_Group_31_GType[] Segment_Group_31 = [];
   Segment_Group_35_GType[] Segment_Group_35 = [];
   Segment_Group_41_GType[] Segment_Group_41 = [];
   Segment_Group_43_GType[] Segment_Group_43 = [];
   Segment_Group_44_GType[] Segment_Group_44 = [];
|};

public type Section_control_Type record {|
   string SECTION_IDENTIFICATION?;
|};

public type CONTROL_GType record {|
   string Control_qualifier?;
   float Control_value?;
   string Measure_unit_qualifier?;
|};

public type Control_total_Type record {|
   CONTROL_GType CONTROL?;
|};

public type Segment_Group_46_GType record {|
   Reference_Type Reference;
   Date_time_period_Type[] Date_time_period = [];
|};

public type Segment_Group_45_GType record {|
   Monetary_amount_Type Monetary_amount;
   Segment_Group_46_GType Segment_Group_46?;
|};

public type Segment_Group_47_GType record {|
   Duty_tax_fee_details_Type Duty_tax_fee_details;
   Monetary_amount_Type[] Monetary_amount = [];
|};

public type Segment_Group_48_GType record {|
   Allowance_or_charge_Type Allowance_or_charge;
   Additional_information_Type Additional_information?;
   Monetary_amount_Type[] Monetary_amount = [];
|};

public type INVOIC record {|
   Beginning_of_message_Type Beginning_of_message;
   Date_time_period_Type[] Date_time_period = [];
   Payment_instructions_Type Payment_instructions?;
   Additional_information_Type[] Additional_information = [];
   Item_description_Type Item_description?;
   Free_text_Type[] Free_text = [];
   Segment_Group_1_GType[] Segment_Group_1 = [];
   Segment_Group_2_GType[] Segment_Group_2 = [];
   Segment_Group_6_GType[] Segment_Group_6 = [];
   Segment_Group_7_GType[] Segment_Group_7 = [];
   Segment_Group_8_GType[] Segment_Group_8 = [];
   Segment_Group_9_GType[] Segment_Group_9 = [];
   Segment_Group_11_GType[] Segment_Group_11 = [];
   Segment_Group_12_GType[] Segment_Group_12 = [];
   Segment_Group_14_GType[] Segment_Group_14 = [];
   Segment_Group_21_GType[] Segment_Group_21 = [];
   Segment_Group_22_GType[] Segment_Group_22 = [];
   Section_control_Type Section_control;
   Control_total_Type[] Control_total = [];
   Segment_Group_45_GType[] Segment_Group_45 = [];
   Segment_Group_47_GType[] Segment_Group_47 = [];
   Segment_Group_48_GType[] Segment_Group_48 = [];
|};

