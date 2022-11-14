type DOCUMENT_MESSAGE_NAME_Type record {|
   string Document_message_name__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Document_message_name?;
|};

type Beginning_of_message_SType record {|
   DOCUMENT_MESSAGE_NAME_Type DOCUMENT_MESSAGE_NAME?;
   string Document_message_number?;
   string Message_function__coded?;
   string Response_type__coded?;
|};

type DATE_TIME_PERIOD_Type record {|
   string Date_time_period_qualifier?;
   string Date_time_period?;
   string Date_time_period_format_qualifier?;
|};

type Date_time_period_SType record {|
   DATE_TIME_PERIOD_Type DATE_TIME_PERIOD?;
|};

type PAYMENT_INSTRUCTION_DETAILS_Type record {|
   string Payment_conditions__coded?;
   string Payment_guarantee__coded?;
   string Payment_means__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Payment_channel__coded?;
|};

type Payment_instructions_SType record {|
   PAYMENT_INSTRUCTION_DETAILS_Type PAYMENT_INSTRUCTION_DETAILS?;
|};

type Additional_information_SType record {|
   string Country_of_origin__coded?;
   string Type_of_duty_regime__coded?;
   string Special_conditions__coded?;
   string Special_conditions__coded_1?;
   string Special_conditions__coded_2?;
   string Special_conditions__coded_3?;
   string Special_conditions__coded_4?;
|};

type ITEM_DESCRIPTION_Type record {|
   string Item_description_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Item_description?;
   string Item_description_1?;
|};

type Item_description_SType record {|
   string Item_description_type__coded?;
   string Item_characteristic__coded?;
   ITEM_DESCRIPTION_Type ITEM_DESCRIPTION?;
   string Surface_layer_indicator__coded?;
|};

type TEXT_REFERENCE_Type record {|
   string Free_text__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type TEXT_LITERAL_Type record {|
   string Free_text?;
   string Free_text_1?;
   string Free_text_2?;
   string Free_text_3?;
   string Free_text_4?;
|};

type Free_text_SType record {|
   string Text_subject_qualifier?;
   string Text_function__coded?;
   TEXT_REFERENCE_Type TEXT_REFERENCE?;
   TEXT_LITERAL_Type TEXT_LITERAL?;
   string Language__coded?;
|};

type REFERENCE_Type record {|
   string Reference_qualifier?;
   string Reference_number?;
   string Line_number?;
   string Reference_version_number?;
|};

type Reference_SType record {|
   REFERENCE_Type REFERENCE?;
|};

type Segment_Group_1_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type PARTY_IDENTIFICATION_DETAILS_Type record {|
   string Party_id_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type NAME_AND_ADDRESS_Type record {|
   string Name_and_address_line?;
   string Name_and_address_line_1?;
   string Name_and_address_line_2?;
   string Name_and_address_line_3?;
   string Name_and_address_line_4?;
|};

type PARTY_NAME_Type record {|
   string Party_name?;
   string Party_name_1?;
   string Party_name_2?;
   string Party_name_3?;
   string Party_name_4?;
   string Party_name_format__coded?;
|};

type STREET_Type record {|
   string Street_and_number_P_O__Box?;
   string Street_and_number_P_O__Box_1?;
   string Street_and_number_P_O__Box_2?;
|};

type Name_and_address_SType record {|
   string Party_qualifier?;
   PARTY_IDENTIFICATION_DETAILS_Type PARTY_IDENTIFICATION_DETAILS?;
   NAME_AND_ADDRESS_Type NAME_AND_ADDRESS?;
   PARTY_NAME_Type PARTY_NAME?;
   STREET_Type STREET?;
   string City_name?;
   string Country_sub_entity_identification?;
   string Postcode_identification?;
   string Country__coded?;
|};

type LOCATION_IDENTIFICATION_Type record {|
   string Place_location_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Place_location?;
|};

type RELATED_LOCATION_ONE_IDENTIFICATION_Type record {|
   string Related_place_location_one_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Related_place_location_one?;
|};

type RELATED_LOCATION_TWO_IDENTIFICATION_Type record {|
   string Related_place_location_two_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Related_place_location_two?;
|};

type Place_location_identification_SType record {|
   string Place_location_qualifier?;
   LOCATION_IDENTIFICATION_Type LOCATION_IDENTIFICATION?;
   RELATED_LOCATION_ONE_IDENTIFICATION_Type RELATED_LOCATION_ONE_IDENTIFICATION?;
   RELATED_LOCATION_TWO_IDENTIFICATION_Type RELATED_LOCATION_TWO_IDENTIFICATION?;
   string Relation__coded?;
|};

type ACCOUNT_IDENTIFICATION_Type record {|
   string Account_holder_number?;
   string Account_holder_name?;
   string Account_holder_name_1?;
   string Currency__coded?;
|};

type INSTITUTION_IDENTIFICATION_Type record {|
   string Institution_name_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Institution_branch_number?;
   string Code_list_qualifier_1?;
   string Code_list_responsible_agency__coded_1?;
   string Institution_name?;
   string Institution_branch_place?;
|};

type Financial_institution_information_SType record {|
   string Party_qualifier?;
   ACCOUNT_IDENTIFICATION_Type ACCOUNT_IDENTIFICATION?;
   INSTITUTION_IDENTIFICATION_Type INSTITUTION_IDENTIFICATION?;
   string Country__coded?;
|};

type Segment_Group_3_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type DOCUMENT_MESSAGE_NAME2_Type record {|
   string Document_message_name__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Document_message_name?;
|};

type DOCUMENT_MESSAGE_DETAILS_Type record {|
   string Document_message_number?;
   string Document_message_status__coded?;
   string Document_message_source?;
   string Language__coded?;
|};

type Document_message_details_SType record {|
   DOCUMENT_MESSAGE_NAME2_Type DOCUMENT_MESSAGE_NAME?;
   DOCUMENT_MESSAGE_DETAILS_Type DOCUMENT_MESSAGE_DETAILS?;
   string Communication_channel_identifier__coded?;
   string Number_of_copies_of_document_required?;
   string Number_of_originals_of_document_required?;
|};

type Segment_Group_4_Type record {|
   Document_message_details_SType Document_message_details;
   Date_time_period_SType[] Date_time_period?;
|};

type DEPARTMENT_OR_EMPLOYEE_DETAILS_Type record {|
   string Department_or_employee_identification?;
   string Department_or_employee?;
|};

type Contact_information_SType record {|
   string Contact_function__coded?;
   DEPARTMENT_OR_EMPLOYEE_DETAILS_Type DEPARTMENT_OR_EMPLOYEE_DETAILS?;
|};

type COMMUNICATION_CONTACT_Type record {|
   string Communication_number?;
   string Communication_channel_qualifier?;
|};

type Communication_contact_SType record {|
   COMMUNICATION_CONTACT_Type COMMUNICATION_CONTACT?;
|};

type Segment_Group_5_Type record {|
   Contact_information_SType Contact_information;
   Communication_contact_SType[] Communication_contact?;
|};

type Segment_Group_2_Type record {|
   Name_and_address_SType Name_and_address;
   Place_location_identification_SType[] Place_location_identification?;
   Financial_institution_information_SType[] Financial_institution_information?;
   Segment_Group_3_Type[] Segment_Group_3?;
   Segment_Group_4_Type[] Segment_Group_4?;
   Segment_Group_5_Type[] Segment_Group_5?;
|};

type DUTY_TAX_FEE_TYPE_Type record {|
   string Duty_tax_fee_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Duty_tax_fee_type?;
|};

type DUTY_TAX_FEE_ACCOUNT_DETAIL_Type record {|
   string Duty_tax_fee_account_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type DUTY_TAX_FEE_DETAIL_Type record {|
   string Duty_tax_fee_rate_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Duty_tax_fee_rate?;
   string Duty_tax_fee_rate_basis_identification?;
   string Code_list_qualifier_1?;
   string Code_list_responsible_agency__coded_1?;
|};

type Duty_tax_fee_details_SType record {|
   string Duty_tax_fee_function_qualifier?;
   DUTY_TAX_FEE_TYPE_Type DUTY_TAX_FEE_TYPE?;
   DUTY_TAX_FEE_ACCOUNT_DETAIL_Type DUTY_TAX_FEE_ACCOUNT_DETAIL?;
   string Duty_tax_fee_assessment_basis?;
   DUTY_TAX_FEE_DETAIL_Type DUTY_TAX_FEE_DETAIL?;
   string Duty_tax_fee_category__coded?;
   string Party_tax_identification_number?;
|};

type MONETARY_AMOUNT_Type record {|
   string Monetary_amount_type_qualifier?;
   string Monetary_amount?;
   string Currency__coded?;
   string Currency_qualifier?;
   string Status__coded?;
|};

type Monetary_amount_SType record {|
   MONETARY_AMOUNT_Type MONETARY_AMOUNT?;
|};

type Segment_Group_6_Type record {|
   Duty_tax_fee_details_SType Duty_tax_fee_details;
   Monetary_amount_SType Monetary_amount?;
   Place_location_identification_SType[] Place_location_identification?;
|};

type CURRENCY_DETAILS_Type record {|
   string Currency_details_qualifier?;
   string Currency__coded?;
   string Currency_qualifier?;
   string Currency_rate_base?;
|};

type CURRENCY_DETAILS_1_Type record {|
   string Currency_details_qualifier?;
   string Currency__coded?;
   string Currency_qualifier?;
   string Currency_rate_base?;
|};

type Currencies_SType record {|
   CURRENCY_DETAILS_Type CURRENCY_DETAILS?;
   CURRENCY_DETAILS_1_Type CURRENCY_DETAILS_1?;
   string Rate_of_exchange?;
   string Currency_market_exchange__coded?;
|};

type Segment_Group_7_Type record {|
   Currencies_SType Currencies;
   Date_time_period_SType[] Date_time_period?;
|};

type PAYMENT_TERMS_Type record {|
   string Terms_of_payment_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Terms_of_payment?;
   string Terms_of_payment_1?;
|};

type TERMS_TIME_INFORMATION_Type record {|
   string Payment_time_reference__coded?;
   string Time_relation__coded?;
   string Type_of_period__coded?;
   string Number_of_periods?;
|};

type Payment_terms_basis_SType record {|
   string Payment_terms_type_qualifier?;
   PAYMENT_TERMS_Type PAYMENT_TERMS?;
   TERMS_TIME_INFORMATION_Type TERMS_TIME_INFORMATION?;
|};

type PERCENTAGE_DETAILS_Type record {|
   string Percentage_qualifier?;
   string Percentage?;
   string Percentage_basis__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type Percentage_details_SType record {|
   PERCENTAGE_DETAILS_Type PERCENTAGE_DETAILS?;
|};

type Segment_Group_8_Type record {|
   Payment_terms_basis_SType Payment_terms_basis;
   Date_time_period_SType[] Date_time_period?;
   Percentage_details_SType Percentage_details?;
   Monetary_amount_SType Monetary_amount?;
|};

type MODE_OF_TRANSPORT_Type record {|
   string Mode_of_transport__coded?;
   string Mode_of_transport?;
|};

type TRANSPORT_MEANS_Type record {|
   string Type_of_means_of_transport_identification?;
   string Type_of_means_of_transport?;
|};

type CARRIER_Type record {|
   string Carrier_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Carrier_name?;
|};

type EXCESS_TRANSPORTATION_INFORMATION_Type record {|
   string Excess_transportation_reason__coded?;
   string Excess_transportation_responsibility__coded?;
   string Customer_authorization_number?;
|};

type TRANSPORT_IDENTIFICATION_Type record {|
   string Id_of_means_of_transport_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Id_of_the_means_of_transport?;
   string Nationality_of_means_of_transport__coded?;
|};

type Details_of_transport_SType record {|
   string Transport_stage_qualifier?;
   string Conveyance_reference_number?;
   MODE_OF_TRANSPORT_Type MODE_OF_TRANSPORT?;
   TRANSPORT_MEANS_Type TRANSPORT_MEANS?;
   CARRIER_Type CARRIER?;
   string Transit_direction__coded?;
   EXCESS_TRANSPORTATION_INFORMATION_Type EXCESS_TRANSPORTATION_INFORMATION?;
   TRANSPORT_IDENTIFICATION_Type TRANSPORT_IDENTIFICATION?;
|};

type Segment_Group_10_Type record {|
   Place_location_identification_SType Place_location_identification;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_9_Type record {|
   Details_of_transport_SType Details_of_transport;
   Segment_Group_10_Type[] Segment_Group_10?;
|};

type TERMS_OF_DELIVERY_Type record {|
   string Terms_of_delivery__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Terms_of_delivery?;
   string Terms_of_delivery_1?;
|};

type Terms_of_delivery_SType record {|
   string Terms_of_delivery_function__coded?;
   string Transport_charges_method_of_payment__coded?;
   TERMS_OF_DELIVERY_Type TERMS_OF_DELIVERY?;
|};

type Segment_Group_11_Type record {|
   Terms_of_delivery_SType Terms_of_delivery;
   Place_location_identification_SType[] Place_location_identification?;
|};

type PACKAGING_DETAILS_Type record {|
   string Packaging_level__coded?;
   string Packaging_related_information__coded?;
   string Packaging_terms_and_conditions__coded?;
|};

type PACKAGE_TYPE_Type record {|
   string Type_of_packages_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Type_of_packages?;
|};

type PACKAGE_TYPE_IDENTIFICATION_Type record {|
   string Item_description_type__coded?;
   string Type_of_packages?;
   string Item_number_type__coded?;
   string Type_of_packages_1?;
   string Item_number_type__coded_1?;
|};

type RETURNABLE_PACKAGE_DETAILS_Type record {|
   string Returnable_package_freight_payment_responsibility__coded?;
   string Returnable_package_load_contents__coded?;
|};

type Package_SType record {|
   string Number_of_packages?;
   PACKAGING_DETAILS_Type PACKAGING_DETAILS?;
   PACKAGE_TYPE_Type PACKAGE_TYPE?;
   PACKAGE_TYPE_IDENTIFICATION_Type PACKAGE_TYPE_IDENTIFICATION?;
   RETURNABLE_PACKAGE_DETAILS_Type RETURNABLE_PACKAGE_DETAILS?;
|};

type MEASUREMENT_DETAILS_Type record {|
   string Measurement_dimension__coded?;
   string Measurement_significance__coded?;
   string Measurement_attribute__coded?;
|};

type VALUE_RANGE_Type record {|
   string Measure_unit_qualifier?;
   string Measurement_value?;
   string Range_minimum?;
   string Range_maximum?;
|};

type Measurements_SType record {|
   string Measurement_application_qualifier?;
   MEASUREMENT_DETAILS_Type MEASUREMENT_DETAILS?;
   VALUE_RANGE_Type VALUE_RANGE?;
   string Surface_layer_indicator__coded?;
|};

type MARKS___LABELS_Type record {|
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

type Package_identification_SType record {|
   string Marking_instructions__coded?;
   MARKS___LABELS_Type MARKS___LABELS?;
   string Container_package_status__coded?;
|};

type IDENTITY_NUMBER_RANGE_Type record {|
   string Identity_number?;
   string Identity_number_1?;
|};

type IDENTITY_NUMBER_RANGE_1_Type record {|
   string Identity_number?;
   string Identity_number_1?;
|};

type IDENTITY_NUMBER_RANGE_2_Type record {|
   string Identity_number?;
   string Identity_number_1?;
|};

type IDENTITY_NUMBER_RANGE_3_Type record {|
   string Identity_number?;
   string Identity_number_1?;
|};

type IDENTITY_NUMBER_RANGE_4_Type record {|
   string Identity_number?;
   string Identity_number_1?;
|};

type Goods_identity_number_SType record {|
   string Identity_number_qualifier?;
   IDENTITY_NUMBER_RANGE_Type IDENTITY_NUMBER_RANGE?;
   IDENTITY_NUMBER_RANGE_1_Type IDENTITY_NUMBER_RANGE_1?;
   IDENTITY_NUMBER_RANGE_2_Type IDENTITY_NUMBER_RANGE_2?;
   IDENTITY_NUMBER_RANGE_3_Type IDENTITY_NUMBER_RANGE_3?;
   IDENTITY_NUMBER_RANGE_4_Type IDENTITY_NUMBER_RANGE_4?;
|};

type Segment_Group_13_Type record {|
   Package_identification_SType Package_identification;
   Reference_SType Reference?;
   Date_time_period_SType[] Date_time_period?;
   Goods_identity_number_SType[] Goods_identity_number?;
|};

type Segment_Group_12_Type record {|
   Package_SType Package;
   Measurements_SType[] Measurements?;
   Segment_Group_13_Type[] Segment_Group_13?;
|};

type ALLOWANCE_CHARGE_INFORMATION_Type record {|
   string Allowance_or_charge_number?;
   string Charge_allowance_description__coded?;
|};

type SPECIAL_SERVICES_IDENTIFICATION_Type record {|
   string Special_services__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
   string Special_service?;
|};

type Allowance_or_charge_SType record {|
   string Allowance_or_charge_qualifier?;
   ALLOWANCE_CHARGE_INFORMATION_Type ALLOWANCE_CHARGE_INFORMATION?;
   string Settlement__coded?;
   string Calculation_sequence_indicator__coded?;
   SPECIAL_SERVICES_IDENTIFICATION_Type SPECIAL_SERVICES_IDENTIFICATION?;
|};

type Segment_Group_15_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type QUANTITY_DETAILS_Type record {|
   string Quantity_qualifier?;
   string Quantity?;
   string Measure_unit_qualifier?;
|};

type Quantity_SType record {|
   QUANTITY_DETAILS_Type QUANTITY_DETAILS?;
|};

type RANGE_Type record {|
   string Measure_unit_qualifier?;
   string Range_minimum?;
   string Range_maximum?;
|};

type Range_details_SType record {|
   string Range_type_qualifier?;
   RANGE_Type RANGE?;
|};

type Segment_Group_16_Type record {|
   Quantity_SType Quantity;
   Range_details_SType Range_details?;
|};

type Segment_Group_17_Type record {|
   Percentage_details_SType Percentage_details;
   Range_details_SType Range_details?;
|};

type Segment_Group_18_Type record {|
   Monetary_amount_SType Monetary_amount;
   Range_details_SType Range_details?;
|};

type RATE_DETAILS_Type record {|
   string Rate_type_qualifier?;
   string Rate_per_unit?;
   string Unit_price_basis?;
   string Measure_unit_qualifier?;
|};

type Rate_details_SType record {|
   RATE_DETAILS_Type RATE_DETAILS?;
|};

type Segment_Group_19_Type record {|
   Rate_details_SType Rate_details;
   Range_details_SType Range_details?;
|};

type Segment_Group_20_Type record {|
   Duty_tax_fee_details_SType Duty_tax_fee_details;
   Monetary_amount_SType Monetary_amount?;
|};

type Segment_Group_14_Type record {|
   Allowance_or_charge_SType Allowance_or_charge;
   Additional_information_SType[] Additional_information?;
   Segment_Group_15_Type[] Segment_Group_15?;
   Segment_Group_16_Type Segment_Group_16?;
   Segment_Group_17_Type Segment_Group_17?;
   Segment_Group_18_Type[] Segment_Group_18?;
   Segment_Group_19_Type Segment_Group_19?;
   Segment_Group_20_Type[] Segment_Group_20?;
|};

type REQUIREMENT_CONDITION_IDENTIFICATION_Type record {|
   string Requirement_condition_identification?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type Requirements_and_conditions_SType record {|
   string Sector_subject_identification_qualifier?;
   REQUIREMENT_CONDITION_IDENTIFICATION_Type REQUIREMENT_CONDITION_IDENTIFICATION?;
   string Action_request_notification__coded?;
|};

type Segment_Group_21_Type record {|
   Requirements_and_conditions_SType Requirements_and_conditions;
   Reference_SType[] Reference?;
   Date_time_period_SType[] Date_time_period?;
   Free_text_SType[] Free_text?;
|};

type ITEM_NUMBER_IDENTIFICATION_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type Line_item_SType record {|
   string Line_item_number?;
   string Action_request_notification__coded?;
   ITEM_NUMBER_IDENTIFICATION_Type ITEM_NUMBER_IDENTIFICATION?;
   string Sub_line_indicator__coded?;
   string Configuration_level?;
   string Configuration__coded?;
|};

type ITEM_NUMBER_IDENTIFICATION2_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type ITEM_NUMBER_IDENTIFICATION_1_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type ITEM_NUMBER_IDENTIFICATION_2_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type ITEM_NUMBER_IDENTIFICATION_3_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type ITEM_NUMBER_IDENTIFICATION_4_Type record {|
   string Item_number?;
   string Item_number_type__coded?;
   string Code_list_qualifier?;
   string Code_list_responsible_agency__coded?;
|};

type Additional_product_id_SType record {|
   string Product_id_function_qualifier?;
   ITEM_NUMBER_IDENTIFICATION2_Type ITEM_NUMBER_IDENTIFICATION?;
   ITEM_NUMBER_IDENTIFICATION_1_Type ITEM_NUMBER_IDENTIFICATION_1?;
   ITEM_NUMBER_IDENTIFICATION_2_Type ITEM_NUMBER_IDENTIFICATION_2?;
   ITEM_NUMBER_IDENTIFICATION_3_Type ITEM_NUMBER_IDENTIFICATION_3?;
   ITEM_NUMBER_IDENTIFICATION_4_Type ITEM_NUMBER_IDENTIFICATION_4?;
|};

type IDENTIFICATION_NUMBER_Type record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

type IDENTIFICATION_NUMBER_1_Type record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

type IDENTIFICATION_NUMBER_2_Type record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

type IDENTIFICATION_NUMBER_3_Type record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

type IDENTIFICATION_NUMBER_4_Type record {|
   string Identity_number?;
   string Identity_number_qualifier?;
|};

type Related_identification_numbers_SType record {|
   string Set_identification_qualifier?;
   IDENTIFICATION_NUMBER_Type IDENTIFICATION_NUMBER?;
   IDENTIFICATION_NUMBER_1_Type IDENTIFICATION_NUMBER_1?;
   IDENTIFICATION_NUMBER_2_Type IDENTIFICATION_NUMBER_2?;
   IDENTIFICATION_NUMBER_3_Type IDENTIFICATION_NUMBER_3?;
   IDENTIFICATION_NUMBER_4_Type IDENTIFICATION_NUMBER_4?;
|};

type QUANTITY_DIFFERENCE_INFORMATION_Type record {|
   string Quantity_difference?;
   string Quantity_qualifier?;
|};

type REASON_FOR_CHANGE_Type record {|
   string Change_reason__coded?;
   string Change_reason?;
|};

type Quantity_variances_SType record {|
   QUANTITY_DIFFERENCE_INFORMATION_Type QUANTITY_DIFFERENCE_INFORMATION?;
   string Discrepancy__coded?;
   REASON_FOR_CHANGE_Type REASON_FOR_CHANGE?;
|};

type Segment_Group_23_Type record {|
   Monetary_amount_SType Monetary_amount;
   Currencies_SType Currencies?;
|};

type Segment_Group_24_Type record {|
   Payment_terms_basis_SType Payment_terms_basis;
   Date_time_period_SType[] Date_time_period?;
   Percentage_details_SType Percentage_details?;
   Monetary_amount_SType Monetary_amount?;
|};

type PRICE_INFORMATION_Type record {|
   string Price_qualifier?;
   string Price?;
   string Price_type__coded?;
   string Price_type_qualifier?;
   string Unit_price_basis?;
   string Measure_unit_qualifier?;
|};

type Price_details_SType record {|
   PRICE_INFORMATION_Type PRICE_INFORMATION?;
   string Sub_line_price_change__coded?;
|};

type PRICE_MULTIPLIER_INFORMATION_Type record {|
   string Price_multiplier?;
   string Price_multiplier_qualifier?;
|};

type REASON_FOR_CHANGE2_Type record {|
   string Change_reason__coded?;
   string Change_reason?;
|};

type Additional_price_information_SType record {|
   string Class_of_trade__coded?;
   PRICE_MULTIPLIER_INFORMATION_Type PRICE_MULTIPLIER_INFORMATION?;
   REASON_FOR_CHANGE2_Type REASON_FOR_CHANGE?;
|};

type Segment_Group_25_Type record {|
   Price_details_SType Price_details;
   Additional_price_information_SType Additional_price_information?;
   Range_details_SType Range_details?;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_26_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_28_Type record {|
   Package_identification_SType Package_identification;
   Reference_SType Reference?;
   Date_time_period_SType[] Date_time_period?;
   Goods_identity_number_SType[] Goods_identity_number?;
|};

type Segment_Group_27_Type record {|
   Package_SType Package;
   Measurements_SType[] Measurements?;
   Segment_Group_28_Type[] Segment_Group_28?;
|};

type Segment_Group_29_Type record {|
   Place_location_identification_SType Place_location_identification;
   Quantity_SType Quantity?;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_30_Type record {|
   Duty_tax_fee_details_SType Duty_tax_fee_details;
   Monetary_amount_SType Monetary_amount?;
   Place_location_identification_SType[] Place_location_identification?;
|};

type Segment_Group_32_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_33_Type record {|
   Document_message_details_SType Document_message_details;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_34_Type record {|
   Contact_information_SType Contact_information;
   Communication_contact_SType[] Communication_contact?;
|};

type Segment_Group_31_Type record {|
   Name_and_address_SType Name_and_address;
   Place_location_identification_SType[] Place_location_identification?;
   Segment_Group_32_Type[] Segment_Group_32?;
   Segment_Group_33_Type[] Segment_Group_33?;
   Segment_Group_34_Type[] Segment_Group_34?;
|};

type Segment_Group_36_Type record {|
   Quantity_SType Quantity;
   Range_details_SType Range_details?;
|};

type Segment_Group_37_Type record {|
   Percentage_details_SType Percentage_details;
   Range_details_SType Range_details?;
|};

type Segment_Group_38_Type record {|
   Monetary_amount_SType Monetary_amount;
   Range_details_SType Range_details?;
|};

type Segment_Group_39_Type record {|
   Rate_details_SType Rate_details;
   Range_details_SType Range_details?;
|};

type Segment_Group_40_Type record {|
   Duty_tax_fee_details_SType Duty_tax_fee_details;
   Monetary_amount_SType Monetary_amount?;
|};

type Segment_Group_35_Type record {|
   Allowance_or_charge_SType Allowance_or_charge;
   Additional_information_SType[] Additional_information?;
   Segment_Group_36_Type Segment_Group_36?;
   Segment_Group_37_Type Segment_Group_37?;
   Segment_Group_38_Type[] Segment_Group_38?;
   Segment_Group_39_Type Segment_Group_39?;
   Segment_Group_40_Type[] Segment_Group_40?;
|};

type Segment_Group_42_Type record {|
   Place_location_identification_SType Place_location_identification;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_41_Type record {|
   Details_of_transport_SType Details_of_transport;
   Segment_Group_42_Type[] Segment_Group_42?;
|};

type Segment_Group_43_Type record {|
   Terms_of_delivery_SType Terms_of_delivery;
   Place_location_identification_SType[] Place_location_identification?;
|};

type Segment_Group_44_Type record {|
   Requirements_and_conditions_SType Requirements_and_conditions;
   Reference_SType[] Reference?;
   Date_time_period_SType[] Date_time_period?;
   Free_text_SType[] Free_text?;
|};

type Segment_Group_22_Type record {|
   Line_item_SType Line_item;
   Additional_product_id_SType[] Additional_product_id?;
   Item_description_SType[] Item_description?;
   Measurements_SType[] Measurements?;
   Quantity_SType[] Quantity?;
   Percentage_details_SType Percentage_details?;
   Additional_information_SType[] Additional_information?;
   Date_time_period_SType[] Date_time_period?;
   Goods_identity_number_SType[] Goods_identity_number?;
   Related_identification_numbers_SType[] Related_identification_numbers?;
   Quantity_variances_SType Quantity_variances?;
   Free_text_SType[] Free_text?;
   Segment_Group_23_Type[] Segment_Group_23?;
   Segment_Group_24_Type[] Segment_Group_24?;
   Segment_Group_25_Type[] Segment_Group_25?;
   Segment_Group_26_Type[] Segment_Group_26?;
   Segment_Group_27_Type[] Segment_Group_27?;
   Segment_Group_29_Type[] Segment_Group_29?;
   Segment_Group_30_Type[] Segment_Group_30?;
   Segment_Group_31_Type[] Segment_Group_31?;
   Segment_Group_35_Type[] Segment_Group_35?;
   Segment_Group_41_Type[] Segment_Group_41?;
   Segment_Group_43_Type[] Segment_Group_43?;
   Segment_Group_44_Type[] Segment_Group_44?;
|};

type Section_control_SType record {|
   string SECTION_IDENTIFICATION?;
|};

type CONTROL_Type record {|
   string Control_qualifier?;
   string Control_value?;
   string Measure_unit_qualifier?;
|};

type Control_total_SType record {|
   CONTROL_Type CONTROL?;
|};

type Segment_Group_46_Type record {|
   Reference_SType Reference;
   Date_time_period_SType[] Date_time_period?;
|};

type Segment_Group_45_Type record {|
   Monetary_amount_SType Monetary_amount;
   Segment_Group_46_Type Segment_Group_46?;
|};

type Segment_Group_47_Type record {|
   Duty_tax_fee_details_SType Duty_tax_fee_details;
   Monetary_amount_SType[] Monetary_amount?;
|};

type Segment_Group_48_Type record {|
   Allowance_or_charge_SType Allowance_or_charge;
   Additional_information_SType Additional_information?;
   Monetary_amount_SType[] Monetary_amount?;
|};

type INVOIC record {|
   Beginning_of_message_SType Beginning_of_message;
   Date_time_period_SType[] Date_time_period;
   Payment_instructions_SType Payment_instructions?;
   Additional_information_SType[] Additional_information?;
   Item_description_SType Item_description?;
   Free_text_SType[] Free_text?;
   Segment_Group_1_Type[] Segment_Group_1?;
   Segment_Group_2_Type[] Segment_Group_2?;
   Segment_Group_6_Type[] Segment_Group_6?;
   Segment_Group_7_Type[] Segment_Group_7?;
   Segment_Group_8_Type[] Segment_Group_8?;
   Segment_Group_9_Type[] Segment_Group_9?;
   Segment_Group_11_Type[] Segment_Group_11?;
   Segment_Group_12_Type[] Segment_Group_12?;
   Segment_Group_14_Type[] Segment_Group_14?;
   Segment_Group_21_Type[] Segment_Group_21?;
   Segment_Group_22_Type[] Segment_Group_22?;
   Section_control_SType Section_control;
   Control_total_SType[] Control_total?;
   Segment_Group_45_Type[] Segment_Group_45;
   Segment_Group_47_Type[] Segment_Group_47?;
   Segment_Group_48_Type[] Segment_Group_48?;
|};

