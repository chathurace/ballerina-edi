public type Transaction_Set_Header_Type record {|
   string Transaction_Set_Identifier_Code;
   string Transaction_Set_Control_Number;
   string Implementation_Convention_Reference?;
|};

public type Beginning_Segment_Type record {|
   string Transaction_Set_Purpose_Code;
   string Reference_Identification;
   string Date;
   string Time?;
   string Time_Code?;
   string Reference_Identification_1?;
   string Transaction_Type_Code?;
   string Action_Code?;
   string Security_Level_Code?;
|};

public type Reference_Identifier_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier_GType Reference_Identifier?;
|};

public type Date_or_Time_or_Period_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Monetary_Amount_Information_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Composite_Unit_of_Measure_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type Quantity_Information_Type record {|
   string Quantity_Qualifier;
   float Quantity?;
   Composite_Unit_of_Measure_GType Composite_Unit_of_Measure?;
   string Free_form_Information?;
|};

public type Party_Identification_Type record {|
   string Entity_Identifier_Code;
   string Name?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
|};

public type Additional_Name_Information_Type record {|
   string Name;
   string Name_1?;
|};

public type Party_Location_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Administrative_Communications_Contact_Type record {|
   string Contact_Function_Code;
   string Name?;
   string Communication_Number_Qualifier?;
   string Communication_Number?;
   string Communication_Number_Qualifier_1?;
   string Communication_Number_1?;
   string Communication_Number_Qualifier_2?;
   string Communication_Number_2?;
   string Contact_Inquiry_Reference?;
|};

public type Account_Identification_Type record {|
   string Account_Number;
   string Name?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Account_Number_Qualifier?;
   string Account_Number_1?;
   string Description?;
   string Payment_Method_Type_Code?;
   string Benefit_Status_Code?;
|};

public type Reference_Identifier2_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_1_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier2_GType Reference_Identifier?;
|};

public type Party_Location_1_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_1_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Administrative_Communications_Contact_1_Type record {|
   string Contact_Function_Code;
   string Name?;
   string Communication_Number_Qualifier?;
   string Communication_Number?;
   string Communication_Number_Qualifier_1?;
   string Communication_Number_1?;
   string Communication_Number_Qualifier_2?;
   string Communication_Number_2?;
   string Contact_Inquiry_Reference?;
|};

public type Date_or_Time_or_Period_1_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Monetary_Amount_Information_1_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type A_1100_Loop_GType record {|
   Account_Identification_Type Account_Identification?;
   Reference_Information_1_Type[] Reference_Information_1 = [];
   Party_Location_1_Type Party_Location_1?;
   Geographic_Location_1_Type Geographic_Location_1?;
   Administrative_Communications_Contact_1_Type[] Administrative_Communications_Contact_1 = [];
   Date_or_Time_or_Period_1_Type Date_or_Time_or_Period_1?;
   Monetary_Amount_Information_1_Type Monetary_Amount_Information_1?;
|};

public type A_1000_Loop_GType record {|
   Party_Identification_Type Party_Identification;
   Additional_Name_Information_Type[] Additional_Name_Information = [];
   Party_Location_Type[] Party_Location = [];
   Geographic_Location_Type Geographic_Location?;
   Administrative_Communications_Contact_Type[] Administrative_Communications_Contact = [];
   A_1100_Loop_GType[] A_1100_Loop = [];
|};

public type Medicare_Status_Code_GType record {|
   string Medicare_Plan_Code;
   string Eligibility_Reason_Code?;
   string Eligibility_Reason_Code_1?;
   string Eligibility_Reason_Code_2?;
|};

public type Insured_Benefit_Type record {|
   string Yes_No_Condition_or_Response_Code;
   string Individual_Relationship_Code;
   string Maintenance_Type_Code?;
   string Maintenance_Reason_Code?;
   string Benefit_Status_Code?;
   Medicare_Status_Code_GType Medicare_Status_Code?;
   string Consolidated_Omnibus_Budget_Reconciliation_Act__COBRA__Qualifying_Event_Code?;
   string Employment_Status_Code?;
   string Student_Status_Code?;
   string Yes_No_Condition_or_Response_Code_1?;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   string Confidentiality_Code?;
   string City_Name?;
   string State_or_Province_Code?;
   string Country_Code?;
   int Number?;
|};

public type Reference_Identifier3_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_2_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier3_GType Reference_Identifier?;
|};

public type Date_or_Time_or_Period_2_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Individual_or_Organizational_Name_Type record {|
   string Entity_Identifier_Code;
   string Entity_Type_Qualifier;
   string Name_Last_or_Organization_Name?;
   string Name_First?;
   string Name_Middle?;
   string Name_Prefix?;
   string Name_Suffix?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
   string Name_Last_or_Organization_Name_1?;
|};

public type Administrative_Communications_Contact_2_Type record {|
   string Contact_Function_Code;
   string Name?;
   string Communication_Number_Qualifier?;
   string Communication_Number?;
   string Communication_Number_Qualifier_1?;
   string Communication_Number_1?;
   string Communication_Number_Qualifier_2?;
   string Communication_Number_2?;
   string Contact_Inquiry_Reference?;
|};

public type Party_Location_2_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_2_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Composite_Race_or_Ethnicity_Information_GType record {|
   string Race_or_Ethnicity_Code?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type Demographic_Information_Type record {|
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   string Gender_Code?;
   string Marital_Status_Code?;
   Composite_Race_or_Ethnicity_Information_GType Composite_Race_or_Ethnicity_Information?;
   string Citizenship_Status_Code?;
   string Country_Code?;
   string Basis_of_Verification_Code?;
   float Quantity?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type Electronic_Funds_Transfer_Information_Type record {|
   string A__DFI__Identification_Number;
   string Account_Number;
   string Yes_No_Condition_or_Response_Code;
   string Yes_No_Condition_or_Response_Code_1;
   string Account_Number_Qualifier?;
   string A__DFI__ID_Number_Qualifier?;
|};

public type Employment_Class_Type record {|
   string Employment_Class_Code?;
   string Employment_Class_Code_1?;
   string Employment_Class_Code_2?;
   float Percentage_as_Decimal?;
   string Information_Status_Code?;
   string Occupation_Code?;
|};

public type Individual_Income_Type record {|
   string Frequency_Code;
   float Monetary_Amount;
   float Quantity?;
   string Location_Identifier?;
   string Salary_Grade?;
   string Currency_Code?;
|};

public type Monetary_Amount_Information_2_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Health_Information_Type record {|
   string Health_Related_Code?;
   float Height?;
   float Weight?;
   float Weight_1?;
   string Description?;
   string Current_Health_Condition_Code?;
   string Description_1?;
|};

public type Health_Care_Code_Information_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_1_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_2_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_3_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_4_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_5_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_6_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_7_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_8_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_9_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_10_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Code_Information_11_GType record {|
   string Code_List_Qualifier_Code;
   string Industry_Code;
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   float Monetary_Amount?;
   float Quantity?;
   string Version_Identifier?;
   string Industry_Code_1?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Health_Care_Information_Codes_Type record {|
   Health_Care_Code_Information_GType Health_Care_Code_Information;
   Health_Care_Code_Information_1_GType Health_Care_Code_Information_1?;
   Health_Care_Code_Information_2_GType Health_Care_Code_Information_2?;
   Health_Care_Code_Information_3_GType Health_Care_Code_Information_3?;
   Health_Care_Code_Information_4_GType Health_Care_Code_Information_4?;
   Health_Care_Code_Information_5_GType Health_Care_Code_Information_5?;
   Health_Care_Code_Information_6_GType Health_Care_Code_Information_6?;
   Health_Care_Code_Information_7_GType Health_Care_Code_Information_7?;
   Health_Care_Code_Information_8_GType Health_Care_Code_Information_8?;
   Health_Care_Code_Information_9_GType Health_Care_Code_Information_9?;
   Health_Care_Code_Information_10_GType Health_Care_Code_Information_10?;
   Health_Care_Code_Information_11_GType Health_Care_Code_Information_11?;
|};

public type Language_Use_Type record {|
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Description?;
   string Use_of_Language_Indicator?;
   string Language_Proficiency_Indicator?;
|};

public type A_2100_Loop_GType record {|
   Individual_or_Organizational_Name_Type Individual_or_Organizational_Name?;
   Administrative_Communications_Contact_2_Type Administrative_Communications_Contact_2?;
   Party_Location_2_Type Party_Location_2?;
   Geographic_Location_2_Type Geographic_Location_2?;
   Demographic_Information_Type Demographic_Information?;
   Electronic_Funds_Transfer_Information_Type Electronic_Funds_Transfer_Information?;
   Employment_Class_Type[] Employment_Class = [];
   Individual_Income_Type Individual_Income?;
   Monetary_Amount_Information_2_Type[] Monetary_Amount_Information_2 = [];
   Health_Information_Type Health_Information?;
   Health_Care_Information_Codes_Type[] Health_Care_Information_Codes = [];
   Language_Use_Type[] Language_Use = [];
|};

public type Disability_Information_Type record {|
   string Disability_Type_Code;
   float Quantity?;
   string Occupation_Code?;
   string Work_Intensity_Code?;
   string Product_Option_Code?;
   float Monetary_Amount?;
   string Product_Service_ID_Qualifier?;
   string Medical_Code_Value?;
|};

public type Date_or_Time_or_Period_3_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Adjustment_Amount_Type record {|
   string Adjustment_Reason_Code;
   float Monetary_Amount?;
   string Adjustment_Reason_Code_Characteristic?;
   string Frequency_Code?;
   string Late_Reason_Code?;
|};

public type A_2200_Loop_GType record {|
   Disability_Information_Type Disability_Information?;
   Date_or_Time_or_Period_3_Type[] Date_or_Time_or_Period_3 = [];
   Adjustment_Amount_Type[] Adjustment_Amount = [];
|};

public type Health_Coverage_Type record {|
   string Maintenance_Type_Code;
   string Maintenance_Reason_Code?;
   string Insurance_Line_Code?;
   string Plan_Coverage_Description?;
   string Coverage_Level_Code?;
   int Count?;
   int Count_1?;
   string Underwriting_Decision_Code?;
   string Yes_No_Condition_or_Response_Code?;
   string Drug_House_Code?;
   string Yes_No_Condition_or_Response_Code_1?;
|};

public type Date_or_Time_or_Period_4_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Monetary_Amount_Information_3_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Reference_Identifier4_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_3_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier4_GType Reference_Identifier?;
|};

public type Identification_Card_Type record {|
   string Plan_Coverage_Description;
   string Identification_Card_Type_Code;
   float Quantity?;
   string Action_Code?;
|};

public type Transaction_Set_Line_Number_Type record {|
   int Assigned_Number;
|};

public type Individual_or_Organizational_Name_1_Type record {|
   string Entity_Identifier_Code;
   string Entity_Type_Qualifier;
   string Name_Last_or_Organization_Name?;
   string Name_First?;
   string Name_Middle?;
   string Name_Prefix?;
   string Name_Suffix?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
   string Name_Last_or_Organization_Name_1?;
|};

public type Party_Identification_1_Type record {|
   string Entity_Identifier_Code;
   string Name?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
|};

public type Additional_Name_Information_1_Type record {|
   string Name;
   string Name_1?;
|};

public type Party_Location_3_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_3_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Administrative_Communications_Contact_3_Type record {|
   string Contact_Function_Code;
   string Name?;
   string Communication_Number_Qualifier?;
   string Communication_Number?;
   string Communication_Number_Qualifier_1?;
   string Communication_Number_1?;
   string Communication_Number_Qualifier_2?;
   string Communication_Number_2?;
   string Contact_Inquiry_Reference?;
|};

public type Provider_Specialty_Information_GType record {|
   string Provider_Specialty_Code;
   string Agency_Qualifier_Code?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Provider_Information_Type record {|
   string Provider_Code;
   string Reference_Identification_Qualifier?;
   string Reference_Identification?;
   string State_or_Province_Code?;
   Provider_Specialty_Information_GType Provider_Specialty_Information?;
   string Provider_Organization_Code?;
|};

public type Date_or_Time_or_Period_5_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Place_or_Location_Type record {|
   string Action_Code;
   string Entity_Identifier_Code;
   string Date;
   string Time?;
   string Maintenance_Reason_Code?;
|};

public type A_2310_Loop_GType record {|
   Transaction_Set_Line_Number_Type Transaction_Set_Line_Number?;
   Individual_or_Organizational_Name_1_Type Individual_or_Organizational_Name_1?;
   Party_Identification_1_Type[] Party_Identification_1 = [];
   Additional_Name_Information_1_Type Additional_Name_Information_1?;
   Party_Location_3_Type[] Party_Location_3 = [];
   Geographic_Location_3_Type[] Geographic_Location_3 = [];
   Administrative_Communications_Contact_3_Type[] Administrative_Communications_Contact_3 = [];
   Provider_Information_Type Provider_Information?;
   Date_or_Time_or_Period_5_Type[] Date_or_Time_or_Period_5 = [];
   Place_or_Location_Type Place_or_Location?;
|};

public type Coordination_of_Benefits_Type record {|
   string Payer_Responsibility_Sequence_Number_Code?;
   string Reference_Identification?;
   string Coordination_of_Benefits_Code?;
   string Service_Type_Code?;
|};

public type Reference_Identifier5_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_4_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier5_GType Reference_Identifier?;
|};

public type Date_or_Time_or_Period_6_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Individual_or_Organizational_Name_2_Type record {|
   string Entity_Identifier_Code;
   string Entity_Type_Qualifier;
   string Name_Last_or_Organization_Name?;
   string Name_First?;
   string Name_Middle?;
   string Name_Prefix?;
   string Name_Suffix?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
   string Name_Last_or_Organization_Name_1?;
|};

public type Additional_Name_Information_2_Type record {|
   string Name;
   string Name_1?;
|};

public type Party_Location_4_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_4_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Administrative_Communications_Contact_4_Type record {|
   string Contact_Function_Code;
   string Name?;
   string Communication_Number_Qualifier?;
   string Communication_Number?;
   string Communication_Number_Qualifier_1?;
   string Communication_Number_1?;
   string Communication_Number_Qualifier_2?;
   string Communication_Number_2?;
   string Contact_Inquiry_Reference?;
|};

public type A_2330_Loop_GType record {|
   Individual_or_Organizational_Name_2_Type Individual_or_Organizational_Name_2?;
   Additional_Name_Information_2_Type Additional_Name_Information_2?;
   Party_Location_4_Type[] Party_Location_4 = [];
   Geographic_Location_4_Type Geographic_Location_4?;
   Administrative_Communications_Contact_4_Type Administrative_Communications_Contact_4?;
|};

public type A_2320_Loop_GType record {|
   Coordination_of_Benefits_Type Coordination_of_Benefits?;
   Reference_Information_4_Type[] Reference_Information_4 = [];
   Date_or_Time_or_Period_6_Type[] Date_or_Time_or_Period_6 = [];
   A_2330_Loop_GType[] A_2330_Loop = [];
|};

public type A_2300_Loop_GType record {|
   Health_Coverage_Type Health_Coverage?;
   Date_or_Time_or_Period_4_Type[] Date_or_Time_or_Period_4 = [];
   Monetary_Amount_Information_3_Type[] Monetary_Amount_Information_3 = [];
   Reference_Information_3_Type[] Reference_Information_3 = [];
   Identification_Card_Type[] Identification_Card = [];
   A_2310_Loop_GType[] A_2310_Loop = [];
   A_2320_Loop_GType[] A_2320_Loop = [];
|};

public type Life_Coverage_Type record {|
   string Maintenance_Type_Code;
   string Maintenance_Reason_Code?;
   string Insurance_Line_Code?;
   string Plan_Coverage_Description?;
   float Quantity?;
   string Product_Option_Code?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Monetary_Amount_Information_4_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Date_or_Time_or_Period_7_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Reference_Identifier6_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_5_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier6_GType Reference_Identifier?;
|};

public type Beneficiary_or_Owner_Information_Type record {|
   string Primary_or_Contingent_Code?;
   float Percentage_as_Decimal?;
   string Individual_Relationship_Code?;
   string Yes_No_Condition_or_Response_Code?;
   string Yes_No_Condition_or_Response_Code_1?;
   string Type_of_Account_Code?;
|};

public type Individual_or_Organizational_Name_3_Type record {|
   string Entity_Identifier_Code;
   string Entity_Type_Qualifier;
   string Name_Last_or_Organization_Name?;
   string Name_First?;
   string Name_Middle?;
   string Name_Prefix?;
   string Name_Suffix?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
   string Name_Last_or_Organization_Name_1?;
|};

public type Party_Identification_2_Type record {|
   string Entity_Identifier_Code;
   string Name?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
|};

public type Additional_Name_Information_3_Type record {|
   string Name;
   string Name_1?;
|};

public type Party_Location_5_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_5_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Composite_Race_or_Ethnicity_Information2_GType record {|
   string Race_or_Ethnicity_Code?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type Demographic_Information_1_Type record {|
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   string Gender_Code?;
   string Marital_Status_Code?;
   Composite_Race_or_Ethnicity_Information2_GType Composite_Race_or_Ethnicity_Information?;
   string Citizenship_Status_Code?;
   string Country_Code?;
   string Basis_of_Verification_Code?;
   float Quantity?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type A_2410_Loop_GType record {|
   Beneficiary_or_Owner_Information_Type Beneficiary_or_Owner_Information?;
   Individual_or_Organizational_Name_3_Type Individual_or_Organizational_Name_3?;
   Party_Identification_2_Type Party_Identification_2?;
   Additional_Name_Information_3_Type Additional_Name_Information_3?;
   Party_Location_5_Type Party_Location_5?;
   Geographic_Location_5_Type Geographic_Location_5?;
   Demographic_Information_1_Type Demographic_Information_1?;
|};

public type A_2400_Loop_GType record {|
   Life_Coverage_Type Life_Coverage?;
   Monetary_Amount_Information_4_Type[] Monetary_Amount_Information_4 = [];
   Date_or_Time_or_Period_7_Type[] Date_or_Time_or_Period_7 = [];
   Reference_Information_5_Type[] Reference_Information_5 = [];
   A_2410_Loop_GType[] A_2410_Loop = [];
|};

public type Flexible_Spending_Account_Type record {|
   string Maintenance_Type_Code;
   string Flexible_Spending_Account_Selection_Code?;
   string Maintenance_Reason_Code?;
   string Account_Number?;
   string Frequency_Code?;
   string Plan_Coverage_Description?;
   string Product_Option_Code?;
   string Product_Option_Code_1?;
   string Product_Option_Code_2?;
|};

public type Monetary_Amount_Information_5_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Date_or_Time_or_Period_8_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Reference_Identifier7_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_6_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier7_GType Reference_Identifier?;
|};

public type A_2500_Loop_GType record {|
   Flexible_Spending_Account_Type Flexible_Spending_Account?;
   Monetary_Amount_Information_5_Type[] Monetary_Amount_Information_5 = [];
   Date_or_Time_or_Period_8_Type[] Date_or_Time_or_Period_8 = [];
   Reference_Information_6_Type[] Reference_Information_6 = [];
|};

public type Retirement_Product_Type record {|
   string Maintenance_Type_Code;
   string Insurance_Line_Code?;
   string Maintenance_Reason_Code?;
   string Description?;
   string Participant_Status_Code?;
   string Yes_No_Condition_or_Response_Code?;
   string Special_Processing_Type?;
   string Authority?;
   string Plan_Coverage_Description?;
|};

public type Date_or_Time_or_Period_9_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Reference_Identifier8_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_7_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier8_GType Reference_Identifier?;
|};

public type Investment_Vehicle_Selection_Type record {|
   string Description;
   float Percentage_as_Decimal?;
   float Monetary_Amount?;
   float Quantity?;
   string State_or_Province_Code?;
   string Description_1?;
   float Monetary_Amount_1?;
|};

public type Monetary_Amount_Information_6_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Composite_Unit_of_Measure2_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type Quantity_Information_1_Type record {|
   string Quantity_Qualifier;
   float Quantity?;
   Composite_Unit_of_Measure2_GType Composite_Unit_of_Measure?;
   string Free_form_Information?;
|};

public type Composite_Unit_of_Measure3_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type File_Information_Type record {|
   string Fixed_Format_Information;
   string Record_Format_Code?;
   Composite_Unit_of_Measure3_GType Composite_Unit_of_Measure?;
|};

public type Relationship_Type record {|
   string Individual_Relationship_Code;
   int Number?;
|};

public type Individual_or_Organizational_Name_4_Type record {|
   string Entity_Identifier_Code;
   string Entity_Type_Qualifier;
   string Name_Last_or_Organization_Name?;
   string Name_First?;
   string Name_Middle?;
   string Name_Prefix?;
   string Name_Suffix?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
   string Name_Last_or_Organization_Name_1?;
|};

public type Additional_Name_Information_4_Type record {|
   string Name;
   string Name_1?;
|};

public type Composite_Race_or_Ethnicity_Information3_GType record {|
   string Race_or_Ethnicity_Code?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type Demographic_Information_2_Type record {|
   string Date_Time_Period_Format_Qualifier?;
   string Date_Time_Period?;
   string Gender_Code?;
   string Marital_Status_Code?;
   Composite_Race_or_Ethnicity_Information3_GType Composite_Race_or_Ethnicity_Information?;
   string Citizenship_Status_Code?;
   string Country_Code?;
   string Basis_of_Verification_Code?;
   float Quantity?;
   string Code_List_Qualifier_Code?;
   string Industry_Code?;
|};

public type Beneficiary_or_Owner_Information_1_Type record {|
   string Primary_or_Contingent_Code?;
   float Percentage_as_Decimal?;
   string Individual_Relationship_Code?;
   string Yes_No_Condition_or_Response_Code?;
   string Yes_No_Condition_or_Response_Code_1?;
   string Type_of_Account_Code?;
|};

public type Reference_Identifier9_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_8_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier9_GType Reference_Identifier?;
|};

public type Property_or_Entity_Identification_Type record {|
   string Entity_Identifier_Code;
   string Entity_Identifier_Code_1?;
   string Entity_Identifier_Code_2?;
   string Entity_Identifier_Code_3?;
   string Entity_Identifier_Code_4?;
|};

public type Party_Location_6_Type record {|
   string Address_Information;
   string Address_Information_1?;
|};

public type Geographic_Location_6_Type record {|
   string City_Name?;
   string State_or_Province_Code?;
   string Postal_Code?;
   string Country_Code?;
   string Location_Qualifier?;
   string Location_Identifier?;
   string Country_Subdivision_Code?;
|};

public type Date_or_Time_or_Period_10_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type A_2620_Loop_GType record {|
   Property_or_Entity_Identification_Type Property_or_Entity_Identification?;
   Party_Location_6_Type Party_Location_6?;
   Geographic_Location_6_Type Geographic_Location_6?;
   Date_or_Time_or_Period_10_Type[] Date_or_Time_or_Period_10 = [];
|};

public type A_2610_Loop_GType record {|
   Individual_or_Organizational_Name_4_Type Individual_or_Organizational_Name_4?;
   Additional_Name_Information_4_Type Additional_Name_Information_4?;
   Demographic_Information_2_Type Demographic_Information_2?;
   Beneficiary_or_Owner_Information_1_Type Beneficiary_or_Owner_Information_1?;
   Reference_Information_8_Type[] Reference_Information_8 = [];
   A_2620_Loop_GType[] A_2620_Loop = [];
|};

public type Financial_Contribution_Type record {|
   string Contribution_Code;
   float Percentage_as_Decimal?;
   float Monetary_Amount?;
   int Number?;
   string Yes_No_Condition_or_Response_Code?;
|};

public type Date_or_Time_or_Period_11_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Investment_Vehicle_Selection_1_Type record {|
   string Description;
   float Percentage_as_Decimal?;
   float Monetary_Amount?;
   float Quantity?;
   string State_or_Province_Code?;
   string Description_1?;
   float Monetary_Amount_1?;
|};

public type Date_or_Time_or_Period_12_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type Composite_Unit_of_Measure4_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type Quantity_Information_2_Type record {|
   string Quantity_Qualifier;
   float Quantity?;
   Composite_Unit_of_Measure4_GType Composite_Unit_of_Measure?;
   string Free_form_Information?;
|};

public type Entity_Type record {|
   int Assigned_Number?;
   string Entity_Identifier_Code?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Identifier_Code_1?;
   string Identification_Code_Qualifier_1?;
   string Identification_Code_1?;
   string Reference_Identification_Qualifier?;
   string Reference_Identification?;
|};

public type Reference_Identifier10_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_9_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier10_GType Reference_Identifier?;
|};

public type Monetary_Amount_Information_7_Type record {|
   string Amount_Qualifier_Code;
   float Monetary_Amount;
   string Credit_Debit_Flag_Code?;
|};

public type Composite_Unit_of_Measure5_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type File_Information_1_Type record {|
   string Fixed_Format_Information;
   string Record_Format_Code?;
   Composite_Unit_of_Measure5_GType Composite_Unit_of_Measure?;
|};

public type A_2640_Loop_GType record {|
   Investment_Vehicle_Selection_1_Type Investment_Vehicle_Selection_1?;
   Date_or_Time_or_Period_12_Type[] Date_or_Time_or_Period_12 = [];
   Quantity_Information_2_Type[] Quantity_Information_2 = [];
   Entity_Type[] Entity = [];
   Reference_Information_9_Type[] Reference_Information_9 = [];
   Monetary_Amount_Information_7_Type[] Monetary_Amount_Information_7 = [];
   File_Information_1_Type[] File_Information_1 = [];
|};

public type A_2630_Loop_GType record {|
   Financial_Contribution_Type Financial_Contribution?;
   Date_or_Time_or_Period_11_Type[] Date_or_Time_or_Period_11 = [];
   A_2640_Loop_GType[] A_2640_Loop = [];
|};

public type Income_Type record {|
   string Type_of_Income_Code;
   string Frequency_Code;
   float Monetary_Amount;
   float Quantity?;
   string Yes_No_Condition_or_Response_Code?;
   string Reference_Identification?;
   string Amount_Qualifier_Code?;
   string Tax_Treatment_Code?;
   float Earnings_Rate_of_Pay?;
   string Unit_or_Basis_for_Measurement_Code?;
   float Quantity_1?;
   string Industry_Code?;
   string Description?;
|};

public type Composite_Unit_of_Measure6_GType record {|
   string Unit_or_Basis_for_Measurement_Code;
   float Exponent?;
   float Multiplier?;
   string Unit_or_Basis_for_Measurement_Code_1?;
   float Exponent_1?;
   float Multiplier_1?;
   string Unit_or_Basis_for_Measurement_Code_2?;
   float Exponent_2?;
   float Multiplier_2?;
   string Unit_or_Basis_for_Measurement_Code_3?;
   float Exponent_3?;
   float Multiplier_3?;
   string Unit_or_Basis_for_Measurement_Code_4?;
   float Exponent_4?;
   float Multiplier_4?;
|};

public type Quantity_Information_3_Type record {|
   string Quantity_Qualifier;
   float Quantity?;
   Composite_Unit_of_Measure6_GType Composite_Unit_of_Measure?;
   string Free_form_Information?;
|};

public type Date_or_Time_or_Period_13_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type A_2650_Loop_GType record {|
   Income_Type Income?;
   Quantity_Information_3_Type[] Quantity_Information_3 = [];
   Date_or_Time_or_Period_13_Type[] Date_or_Time_or_Period_13 = [];
|};

public type Transaction_Set_Line_Number_1_Type record {|
   int Assigned_Number;
|};

public type Party_Identification_3_Type record {|
   string Entity_Identifier_Code;
   string Name?;
   string Identification_Code_Qualifier?;
   string Identification_Code?;
   string Entity_Relationship_Code?;
   string Entity_Identifier_Code_1?;
|};

public type Reference_Identifier11_GType record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification;
   string Reference_Identification_Qualifier_1?;
   string Reference_Identification_1?;
   string Reference_Identification_Qualifier_2?;
   string Reference_Identification_2?;
|};

public type Reference_Information_10_Type record {|
   string Reference_Identification_Qualifier;
   string Reference_Identification?;
   string Description?;
   Reference_Identifier11_GType Reference_Identifier?;
|};

public type Date_or_Time_or_Period_14_Type record {|
   string Date_Time_Qualifier;
   string Date_Time_Period_Format_Qualifier;
   string Date_Time_Period;
|};

public type A_2750_Loop_GType record {|
   Party_Identification_3_Type Party_Identification_3;
   Reference_Information_10_Type Reference_Information_10;
   Date_or_Time_or_Period_14_Type Date_or_Time_or_Period_14?;
|};

public type A_2700_Loop_GType record {|
   Transaction_Set_Line_Number_1_Type Transaction_Set_Line_Number_1?;
   A_2750_Loop_GType[] A_2750_Loop = [];
|};

public type A_2600_Loop_GType record {|
   Retirement_Product_Type Retirement_Product?;
   Date_or_Time_or_Period_9_Type[] Date_or_Time_or_Period_9 = [];
   Reference_Information_7_Type[] Reference_Information_7 = [];
   Investment_Vehicle_Selection_Type[] Investment_Vehicle_Selection = [];
   Monetary_Amount_Information_6_Type[] Monetary_Amount_Information_6 = [];
   Quantity_Information_1_Type[] Quantity_Information_1 = [];
   File_Information_Type[] File_Information = [];
   Relationship_Type Relationship?;
   A_2610_Loop_GType[] A_2610_Loop = [];
   A_2630_Loop_GType[] A_2630_Loop = [];
   A_2650_Loop_GType[] A_2650_Loop = [];
   A_2700_Loop_GType[] A_2700_Loop = [];
|};

public type A_2000_Loop_GType record {|
   Insured_Benefit_Type Insured_Benefit?;
   Reference_Information_2_Type[] Reference_Information_2 = [];
   Date_or_Time_or_Period_2_Type[] Date_or_Time_or_Period_2 = [];
   A_2100_Loop_GType[] A_2100_Loop = [];
   A_2200_Loop_GType[] A_2200_Loop = [];
   A_2300_Loop_GType[] A_2300_Loop = [];
   A_2400_Loop_GType[] A_2400_Loop = [];
   A_2500_Loop_GType[] A_2500_Loop = [];
   A_2600_Loop_GType[] A_2600_Loop = [];
|};

public type Transaction_Set_Trailer_Type record {|
   int Number_of_Included_Segments;
   string Transaction_Set_Control_Number;
|};

public type Benefit_Enrollment_and_Maintenance record {|
   Transaction_Set_Header_Type Transaction_Set_Header;
   Beginning_Segment_Type Beginning_Segment;
   Reference_Information_Type[] Reference_Information = [];
   Date_or_Time_or_Period_Type[] Date_or_Time_or_Period = [];
   Monetary_Amount_Information_Type[] Monetary_Amount_Information = [];
   Quantity_Information_Type[] Quantity_Information = [];
   A_1000_Loop_GType[] A_1000_Loop = [];
   A_2000_Loop_GType[] A_2000_Loop = [];
   Transaction_Set_Trailer_Type Transaction_Set_Trailer;
|};

