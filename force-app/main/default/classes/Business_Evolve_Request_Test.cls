/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-25-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log  
 * Ver   Date         Author                               Modification
 * 1.0   05-25-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class Business_Evolve_Request_Test {
	@testSetup
	static void dataCreation() {
		String uniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@absa2.com.testorg';
		String email = 'UserAdmin' + '@testorg.com';
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User u = new User(
			Alias = 'standt',
			Email = email,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = p.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = uniqueUserName,
			MobilePhone = '0823389021'
		);
		insert u;

		System.runAs(u) {
			String requestString = '{"Header":{"ExecutionLayerRequestID":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91d","Timestamp":"21-11-2020 02:46:34"},"Individual":{"Account":{"ExecutionLayerRequestID__c":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91d","PersonTitle":"02","Application_Number__c":"RBD-870420","Initials__pc":"MT","FirstName":"MALEHLOHONOLO FLORENCE","LastName":"TNANDEKISO","Client_Type__c":"08101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"6808120537089","Gender__pc":"2","PersonBirthdate":"1968-08-12","Country_of_Birth__pc":"SO003","Marital_Status__pc":"2","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"63121","PersonEmail":"brinley.mcquire@absa.africa","PersonMobilePhone":"0648908995","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"E","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":10,"Occupation_Status__pc":8,"Occupation__pc":10,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"SOLE TRADER CLIENT","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SO003","Preferred_Communication_Method__pc":"Email","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__pc":"38","Source_of_Income__c":"38","Monthly_Income__pc":"05","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"63121","Nature_of_Client__c":"63121","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Postal"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Physical Address"}],"Trading_as_Name__c":[{"Name":"brinz inc"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S36","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"1","Rand_value_of_credits_per_month__c":"11","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"1","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"1","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"}],"AccountContactRelation":{"Roles":"APPLICANT;MANDATE_OFFICIAL;SIGNATORY","Share_Percentage__c":"0.0"}}]}}';
			String requestString2 = '{"Header":{"ExecutionLayerRequestID":"5baff94a-b0fc-4440-ab29-ad20cf046755","Timestamp":"21-11-2020  18:56:25"},"nonIndividual":{"Account":{"ExecutionLayerRequestID__c":"5baff94a-b0fc-4440-ab29-ad20cf046755","Name":"FUELAND INVESTMENTS CC","Client_Type__c":"03101","ID_Type__c":"Registration Number","Registration_Number__c":"111201110154623","Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SA004","Preferred_Communication_Method__c":2,"Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":true,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__c":"38","Monthly_Income__c":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"South Africa","Standard_Industry_SIC_Code__c":"42000","Nature_of_Client__c":"42000","cif__c":"","Application_Number__c":"RBD-889455"},"Address__c":[{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Business Address"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Registered"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Postal"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Head Office"}],"Trading_as_Name__c":[{"Name":"FUELAND INVESTMENTS CC"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S34","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"12","Rand_value_of_credits_per_month__c":"12","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"12","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"2","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments;Savings and Investments Products","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"RR","FirstName":"RENDANI COLLINS","LastName":"RAMABULANA","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7805175453088","Gender__pc":"1","PersonBirthdate":"1978-05-17","Country_of_Birth__pc":"SO003","Marital_Status__pc":"1","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":18,"Occupation_Status__pc":8,"Occupation__pc":18,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"APPLICANT;SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}},{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"JS","FirstName":"JOHANNES JACOBUS","LastName":"SPIES","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7404115342088","Gender__pc":"1","PersonBirthdate":"1974-04-11","Country_of_Birth__pc":"SO003","Marital_Status__pc":"","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":0,"Occupation_Status__pc":0,"Occupation__pc":0,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"eekoring","Shipping_Street_2__c":null,"Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}}],"Lead":null}}';
			String requestString3 = '{"Header":{"ExecutionLayerRequestID":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91e","Timestamp":"21-11-2020 02:46:34"},"Individual":{"Account":{"ExecutionLayerRequestID__c":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91e","PersonTitle":"02","Application_Number__c":"RBD-870420","Initials__pc":"MT","FirstName":"MALEHLOHONOLO FLORENCE","LastName":"TNANDEKISO","Client_Type__c":"08101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"6808120537089","Gender__pc":"2","PersonBirthdate":"1968-08-12","Country_of_Birth__pc":"SO003","Marital_Status__pc":"2","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"63121","PersonEmail":"brinley.mcquire@absa.africa","PersonMobilePhone":"0648908995","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"E","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":10,"Occupation_Status__pc":8,"Occupation__pc":10,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"SOLE TRADER CLIENT","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SO003","Preferred_Communication_Method__pc":"Email","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__pc":"38","Source_of_Income__c":"38","Monthly_Income__pc":"05","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"63121","Nature_of_Client__c":"63121","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":"SETONA 018"},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Postal"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Physical Address"}],"Trading_as_Name__c":[{"Name":"brinz inc"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S36","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"1","Rand_value_of_credits_per_month__c":"11","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"1","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"1","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"}],"AccountContactRelation":{"Roles":"APPLICANT;MANDATE_OFFICIAL;SIGNATORY","Share_Percentage__c":"0.0"}}]}}';
			String requestString4 = '{"Header":{"ExecutionLayerRequestID":"5baff94a-b0fc-4440-ab29-ad20cf046756","Timestamp":"21-11-2020  18:56:25"},"nonIndividual":{"Account":{"ExecutionLayerRequestID__c":"5baff94a-b0fc-4440-ab29-ad20cf046756","Name":"FUELAND INVESTMENTS CC","Client_Type__c":"03101","ID_Type__c":"Registration Number","Registration_Number__c":"111201110154623","Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SA004","Preferred_Communication_Method__c":2,"Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":true,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__c":"38","Monthly_Income__c":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"South Africa","Standard_Industry_SIC_Code__c":"42000","Nature_of_Client__c":"42000","cif__c":"FCC   1627","Application_Number__c":"RBD-889455"},"Address__c":[{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Business Address"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Registered"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Postal"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Head Office"}],"Trading_as_Name__c":[{"Name":"FUELAND INVESTMENTS CC"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S34","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"12","Rand_value_of_credits_per_month__c":"12","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"12","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"2","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments;Savings and Investments Products","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"RR","FirstName":"RENDANI COLLINS","LastName":"RAMABULANA","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7805175453088","Gender__pc":"1","PersonBirthdate":"1978-05-17","Country_of_Birth__pc":"SO003","Marital_Status__pc":"1","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":18,"Occupation_Status__pc":8,"Occupation__pc":18,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"APPLICANT;SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}},{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"JS","FirstName":"JOHANNES JACOBUS","LastName":"SPIES","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7404115342088","Gender__pc":"1","PersonBirthdate":"1974-04-11","Country_of_Birth__pc":"SO003","Marital_Status__pc":"","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":0,"Occupation_Status__pc":0,"Occupation__pc":0,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"eekoring","Shipping_Street_2__c":null,"Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}}],"Lead":null}}';
			String requestString5 = '{"Header":{"ExecutionLayerRequestID":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91f","Timestamp":"21-11-2020 02:46:34"},"Individual":{"Account":{"ExecutionLayerRequestID__c":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91f","PersonTitle":"02","Application_Number__c":"RBD-870420","Initials__pc":"MT","FirstName":"MALEHLOHONOLO FLORENCE","LastName":"TNANDEKISO","Client_Type__c":"08101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"6808120537089","Gender__pc":"2","PersonBirthdate":"1968-08-12","Country_of_Birth__pc":"SO003","Marital_Status__pc":"2","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"63121","PersonEmail":"brinley.mcquire@absa.africa","PersonMobilePhone":"0648908995","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"E","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":10,"Occupation_Status__pc":8,"Occupation__pc":10,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"SOLE TRADER CLIENT","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SO003","Preferred_Communication_Method__pc":"Email","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__pc":"38","Source_of_Income__c":"38","Monthly_Income__pc":"05","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"63121","Nature_of_Client__c":"63121","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":"ZUMA123"},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Postal"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Physical Address"}],"Trading_as_Name__c":[{"Name":"brinz inc"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S36","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"1","Rand_value_of_credits_per_month__c":"11","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"1","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"1","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"}],"AccountContactRelation":{"Roles":"APPLICANT;MANDATE_OFFICIAL;SIGNATORY","Share_Percentage__c":"0.0"}}]}}';
			String requestString6 = '{"Header":{"ExecutionLayerRequestID":"5baff94a-b0fc-4440-ab29-ad20cf046757","Timestamp":"21-11-2020  18:56:25"},"nonIndividual":{"Account":{"ExecutionLayerRequestID__c":"5baff94a-b0fc-4440-ab29-ad20cf046757","Name":"FUELAND INVESTMENTS CC","Client_Type__c":"03101","ID_Type__c":"Registration Number","Registration_Number__c":"111201110154623","Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SA004","Preferred_Communication_Method__c":2,"Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":true,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__c":"38","Monthly_Income__c":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"South Africa","Standard_Industry_SIC_Code__c":"42000","Nature_of_Client__c":"42000","cif__c":"FCC   1627","Application_Number__c":"RBD-889455"},"Address__c":[{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Business Address"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Registered"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Postal"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Head Office"}],"Trading_as_Name__c":[{"Name":"FUELAND INVESTMENTS CC"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S34","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"12","Rand_value_of_credits_per_month__c":"12","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"12","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"2","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments;Savings and Investments Products","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"RR","FirstName":"RENDANI COLLINS","LastName":"RAMABULANA","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7805175453088","Gender__pc":"1","PersonBirthdate":"1978-05-17","Country_of_Birth__pc":"SO003","Marital_Status__pc":"1","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":18,"Occupation_Status__pc":8,"Occupation__pc":18,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":"TEST   123"},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"APPLICANT;SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}},{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"JS","FirstName":"JOHANNES JACOBUS","LastName":"SPIES","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7404115342088","Gender__pc":"1","PersonBirthdate":"1974-04-11","Country_of_Birth__pc":"SO003","Marital_Status__pc":"","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":0,"Occupation_Status__pc":0,"Occupation__pc":0,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"eekoring","Shipping_Street_2__c":null,"Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}}],"Lead":null}}';

			List<Account> newAccountList = new List<Account>();
			Account acc = new Account();
			acc.CIF__c = 'ZUMA123';
			acc.PersonMobilePhone = '0478956208';
			acc.Initials__pc = 'S';
			acc.PersonTitle = 'Mr';
			acc.LastName = 'Mathe';
			acc.BillingStreet = '15 Johhanesburg';
			acc.BillingCity = 'Sandton';
			acc.BillingPostalCode = '2001';
			acc.ID_Type__pc = 'SA Identity Document';
			acc.ID_Number__pc = '9202031586089';
			acc.PersonBirthdate = Date.newInstance(1992, 2, 3);
			acc.Client_Type__c = 'Trusts';
			acc.Gender__pc = 'Male';
			acc.Number_Of_Dependents__c = 2.00;
			acc.Occupation_Category__pc = 'Actuary';
			acc.Client_ever_been_declared_Insolvent__c = false;
			acc.Marital_Contract_Type__pc = 'In Community Of Property';
			acc.Home_Language__pc = 'English';
			acc.Income_Tax_Number__pc = '1.00';
			acc.FirstName = 'ABSA';
			acc.Occupation_Status__pc = 'Full Time Employed';
			acc.PersonEmail = 'test@test.com';
			acc.Preferred_Communication_Method__pc = 'Email';
			acc.Sic = '0000';
			acc.Client_Type__c = 'Sole Trader';
			acc.Client_Group__c = 'SOLE TRADER CLIENT';
			acc.Source_of_Income__c = 'PENSION';
			acc.Date_Identified__c = Date.newInstance(2020, 12, 9);
			acc.Nationality__pc = 'South Africa';
			acc.Q4a_Client_affected_by_Regulation_3_1_F__c = false;
			acc.Date_Issued__pc = Date.newInstance(2016, 11, 9);
			acc.CASA_Reference_Number__pc = '7877';
			acc.Marital_Status__pc = 'Married';
			acc.Communication_Language__pc = 'English';
			acc.Monthly_Income__pc = 'R15000 - 19999';
			acc.Q2a_Client_affected_by_Regulation_3_1_F__c = false;
			acc.SIC_Classification_1__c = 'Almond Nuts';
			acc.SIC_Classification_2__c = 'Apples';
			acc.SIC_Classification_3__c = 'Avocados';
			acc.PersonHomePhone = '0115896543';
			acc.Q1a_Client_affected_by_Regulation_3_1_F__c = true;
			acc.Q2a_Client_affected_by_Regulation_3_1_F__c = true;
			acc.Q4a_Client_affected_by_Regulation_3_1_F__c = true;
			acc.Non_Credit_Marketing_Consent__pc = 'Yes';
			acc.Credit_Marketing_Consent__pc = 'Yes';
			acc.Q4c_Exchange_Control_Expiry_date__c = Date.newInstance(2016, 11, 9);
			acc.Phone = '0784512964';
			acc.Country_of_Operation__c = 'South Africa';
			acc.Foreign_Tax_Number__c = 0;
			insert acc;
			createPostalAddress(acc);

			Opportunity testOpp = new Opportunity();
			testOpp.Name = 'Test Opp';
			testOpp.CloseDate = Date.today();
			testOpp.StageName = 'Drafting';
			testOpp.accountId = acc.Id;
			insert testOpp;

			Account acc2 = new Account();
			acc2.CIF__c = 'FCC   1627';
			acc2.Name = 'FUELAND INVESTMENTS CC';
			acc2.ID_Type__c = 'Registration Number';
			acc2.Client_ever_been_declared_Insolvent__c = false;
			acc2.Sic = '0000';
			acc2.Client_Type__c = 'Close Corporation';
			acc2.Client_Group__c = 'Non Individual';
			acc2.Source_of_Income__c = 'Trading Income- Sales';
			acc2.CASA_Reference_Number__c = '7877';
			acc2.Monthly_Income__c = 'R15000 - 19999';
			acc2.Phone = '0784512964';
			acc2.Country_of_Operation__c = 'South Africa';
			acc2.Foreign_Tax_Number__c = 0;
			insert acc2;
			createBusinessAddress(acc2);
			Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
			testTradingAsName.Name = 'T/A Test';
			testTradingAsName.Account__c = acc2.id;
			insert testTradingAsName;

			List<Integration_Translation__c> newIntTransList = new List<Integration_Translation__c>();

			Integration_Translation__c translation1 = new Integration_Translation__c();
			translation1.Name = 'Investments';
			translation1.External_Value__c = '3';
			translation1.Internal_Value__c = 'Investments';
			translation1.System_Name__c = 'CIF';
			translation1.Value_Type__c = 'Source of Income';
			translation1.Direction__c = 'Outbound';
			newIntTransList.add(translation1);

			Integration_Translation__c translation2 = new Integration_Translation__c();
			translation2.Name = 'Armenia';
			translation2.External_Value__c = 'AM001';
			translation2.Internal_Value__c = 'Armenia';
			translation2.System_Name__c = 'CIF';
			translation2.Value_Type__c = 'Country';
			translation2.Direction__c = 'Outbound';
			newIntTransList.add(translation2);

			Integration_Translation__c translation3 = new Integration_Translation__c();
			translation3.Name = 'South Africa';
			translation3.External_Value__c = 'SO003';
			translation3.Internal_Value__c = 'South Africa';
			translation3.System_Name__c = 'CIF';
			translation3.Value_Type__c = 'Country';
			translation3.Direction__c = 'Outbound';
			newIntTransList.add(translation3);

			Integration_Translation__c translation4 = new Integration_Translation__c();
			translation4.Name = 'February';
			translation4.External_Value__c = '2';
			translation4.Internal_Value__c = 'February';
			translation4.System_Name__c = 'CIF';
			translation4.Value_Type__c = 'Financial Year End';
			translation4.Direction__c = 'Outbound';
			newIntTransList.add(translation4);

			Integration_Translation__c translation5 = new Integration_Translation__c();
			translation5.Name = 'Female';
			translation5.External_Value__c = '2';
			translation5.Internal_Value__c = 'Female';
			translation5.System_Name__c = 'CIF';
			translation5.Value_Type__c = 'Gender';
			translation5.Direction__c = 'Outbound';
			newIntTransList.add(translation5);

			Integration_Translation__c translation6 = new Integration_Translation__c();
			translation6.Name = 'English';
			translation6.External_Value__c = 'E';
			translation6.Internal_Value__c = 'English';
			translation6.System_Name__c = 'CIF';
			translation6.Value_Type__c = 'Language';
			translation6.Direction__c = 'Outbound';
			newIntTransList.add(translation6);

			Integration_Translation__c translation7 = new Integration_Translation__c();
			translation7.Name = 'Single';
			translation7.External_Value__c = '2';
			translation7.Internal_Value__c = 'Single';
			translation7.System_Name__c = 'CIF';
			translation7.Value_Type__c = 'Marital Status';
			translation7.Direction__c = 'Outbound';
			newIntTransList.add(translation7);

			Integration_Translation__c translation8 = new Integration_Translation__c();
			translation8.Name = 'R500 - 999';
			translation8.External_Value__c = '5';
			translation8.Internal_Value__c = 'R500 - 999';
			translation8.System_Name__c = 'CIF';
			translation8.Value_Type__c = 'Monthly Income';
			translation8.Direction__c = 'Outbound';
			newIntTransList.add(translation8);

			Integration_Translation__c translation9 = new Integration_Translation__c();
			translation9.Name = 'South Africa';
			translation9.External_Value__c = 'SOU001';
			translation9.Internal_Value__c = 'South Africa';
			translation9.System_Name__c = 'eCasa';
			translation9.Value_Type__c = 'Nationality';
			translation9.Direction__c = 'Outbound';
			newIntTransList.add(translation9);

			Integration_Translation__c translation10 = new Integration_Translation__c();
			translation10.Name = 'Other';
			translation10.External_Value__c = '10';
			translation10.Internal_Value__c = 'Other';
			translation10.System_Name__c = 'CIF';
			translation10.Value_Type__c = 'Occupation Category';
			translation10.Direction__c = 'Outbound';
			newIntTransList.add(translation10);

			Integration_Translation__c translation11 = new Integration_Translation__c();
			translation11.Name = 'Part Time Employed';
			translation11.External_Value__c = '8';
			translation11.Internal_Value__c = 'Part Time Employed';
			translation11.System_Name__c = 'CIF';
			translation11.Value_Type__c = 'Occupation Status';
			translation11.Direction__c = 'Outbound';
			newIntTransList.add(translation11);

			Integration_Translation__c translation12 = new Integration_Translation__c();
			translation12.Name = 'Miss.';
			translation12.External_Value__c = '2';
			translation12.Internal_Value__c = 'Miss.';
			translation12.System_Name__c = 'CIF';
			translation12.Value_Type__c = 'Title';
			translation12.Direction__c = 'Outbound';
			newIntTransList.add(translation12);

			Integration_Translation__c translation13 = new Integration_Translation__c();
			translation13.Name = 'Trading Income- Services';
			translation13.External_Value__c = '38';
			translation13.Internal_Value__c = 'Trading Income- Services';
			translation13.System_Name__c = 'CIF';
			translation13.Value_Type__c = 'Source of Income';
			translation13.Direction__c = 'Outbound';
			newIntTransList.add(translation13);

			Integration_Translation__c translation14 = new Integration_Translation__c();
			translation14.Name = 'Trading Income- Services';
			translation14.External_Value__c = '38';
			translation14.Internal_Value__c = 'Trading Income- Services';
			translation14.System_Name__c = 'eCasa';
			translation14.Value_Type__c = 'Source of Income';
			translation14.Direction__c = 'Outbound';
			newIntTransList.add(translation14);

			Integration_Translation__c translation17 = new Integration_Translation__c();
			translation17.Name = 'Trading Income- Services';
			translation17.External_Value__c = '25';
			translation17.Internal_Value__c = 'Trading Income- Services';
			translation17.System_Name__c = 'eCasa';
			translation17.Value_Type__c = 'Source of Income';
			translation17.Direction__c = 'Outbound';
			newIntTransList.add(translation17);

			Integration_Translation__c translation15 = new Integration_Translation__c();
			translation15.Name = 'Retail sale of new motor vehicles';
			translation15.External_Value__c = '63121';
			translation15.Internal_Value__c = 'Retail sale of new motor vehicles';
			translation15.System_Name__c = 'CIF';
			translation15.Value_Type__c = 'Standard Industry SIC Code';
			translation15.Direction__c = 'Outbound';
			newIntTransList.add(translation15);

			Integration_Translation__c translation16 = new Integration_Translation__c();
			translation16.Name = 'Sole Trader';
			translation16.External_Value__c = '08101';
			translation16.Internal_Value__c = 'Sole Trader';
			translation16.System_Name__c = 'CIF';
			translation16.Value_Type__c = 'Client Type';
			translation16.Direction__c = 'Outbound';
			newIntTransList.add(translation16);

			Integration_Translation__c translation18 = new Integration_Translation__c();
			translation18.Name = 'Close Corporation';
			translation18.External_Value__c = '03101';
			translation18.Internal_Value__c = 'Close Corporation';
			translation18.System_Name__c = 'eCasa';
			translation18.Value_Type__c = 'Client Type';
			translation18.Direction__c = 'Outbound';
			newIntTransList.add(translation18);

			insert newIntTransList;

			Product2 product1 = new Product2();
			product1.Name = 'Business Evolve';
			product1.Family = 'Cheque';
			product1.ProductCode = '11021';
			product1.IsActive = true;
			insert product1;

			Product2 product2 = new Product2();
			product2.Name = 'Business Evolve Package';
			product2.Product_Classification__c = 'Package';
			insert product2;

			Product2 product3 = new Product2();
			product3.Name = 'Business Evolve';
			product3.Family = 'Savings';
			product3.ProductCode = '11020';
			product3.IsActive = true;
			insert product3;

			List<Pricebook2> listOfPriceBook2T = new List<Pricebook2>();
			listOfPriceBook2T = [SELECT Id, Name, isActive FROM PriceBook2];

			PriceBook2 pb = new PriceBook2();
			pb.name = 'Standard';
			pb.isActive = true;
			insert pb;

			Id pricebookId = Test.getStandardPricebookId();

			Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '1234');
			insert prod;
			Pricebook2 standardPricebook = new Pricebook2(Id = pricebookId, IsActive = true);
			PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod.Id);
			update standardPricebook;

			PricebookEntry standardPriceBookEntry = new PricebookEntry(
				Pricebook2Id = Test.getStandardPricebookId(),
				Product2Id = product1.Id,
				UnitPrice = 10000,
				IsActive = true
			);
			insert standardPriceBookEntry;

			PricebookEntry standardPriceBookEntrySav = new PricebookEntry(
				Pricebook2Id = Test.getStandardPricebookId(),
				Product2Id = product3.Id,
				UnitPrice = 20000,
				IsActive = true
			);
			insert standardPriceBookEntrySav;

			Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
			insert customPB;
			List<Pricebook2> listOfPriceBook2 = new List<Pricebook2>();
			listOfPriceBook2 = [SELECT Id, Name, isActive FROM PriceBook2];

			Product_Product_Entry__c firstPack = new Product_Product_Entry__c();
			firstPack.Parent_Product__c = product2.Id;
			firstPack.Related_Product__c = product1.Id;
			insert firstPack;

			Price_Scheme__c priceScheme = new Price_Scheme__c();
			priceScheme.Name = 'Business Evolve 60 - CQT02S36';
			priceScheme.No_End_Date__c = true;
			priceScheme.Start_Date__c = date.today();
			priceScheme.Scheme_Code__c = 'CQT02S36';
			priceScheme.Product_Code__c = '11021';
			priceScheme.Package_Name__c = 'Business Evolve Package';
			insert priceScheme;

			PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
			insert customPrice;

			OpportunityLineItem oppLineItem = new OpportunityLineItem();
			oppLineItem.OpportunityId = testOpp.id;
			oppLineItem.Product2Id = prod.id;
			oppLineItem.PricebookEntryId = customPrice.id;
			oppLineItem.Quantity = 1;
			oppLineItem.TotalPrice = 100;
			insert oppLineItem;
		}

	}

	@isTest
	public static void test1() {
		User uA = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					uA = u;
				}
			}
		}
		System.runAs(uA) {
			String requestString = '{"Header":{"ExecutionLayerRequestID":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91d","Timestamp":"21-11-2020 02:46:34"},"Individual":{"Account":{"ExecutionLayerRequestID__c":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91d","PersonTitle":"02","Application_Number__c":"RBD-870420","Initials__pc":"MT","FirstName":"MALEHLOHONOLO FLORENCE","LastName":"TNANDEKISO","Client_Type__c":"08101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"6808120537089","Gender__pc":"2","PersonBirthdate":"1968-08-12","Country_of_Birth__pc":"SO003","Marital_Status__pc":"2","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"63121","PersonEmail":"brinley.mcquire@absa.africa","PersonMobilePhone":"0648908995","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"E","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":10,"Occupation_Status__pc":8,"Occupation__pc":10,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"SOLE TRADER CLIENT","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SO003","Preferred_Communication_Method__pc":"Email","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__pc":"38","Source_of_Income__c":"38","Monthly_Income__pc":"05","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"63121","Nature_of_Client__c":"63121","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Postal"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Physical Address"}],"Trading_as_Name__c":[{"Name":"brinz inc"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S36","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"1","Rand_value_of_credits_per_month__c":"11","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"1","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"1","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"}],"AccountContactRelation":{"Roles":"APPLICANT;MANDATE_OFFICIAL;SIGNATORY","Share_Percentage__c":"0.0"}}]}}';
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/services/apexrest/business-evolve/v1/';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(requestString);
			RestContext.request = req;
			RestContext.response = res;
			Business_Evolve_Response test1Business_Evolve_Response = Business_Evolve_RestApi.createObjects();
			System.assertEquals('SFDC', test1Business_Evolve_Response.SourceID, 'test1Business_Evolve_Response failed');
			System.debug('test1Business_Evolve_Response - ' + test1Business_Evolve_Response);
		}
	}
	@isTest
	public static void test2() {
		User uA = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					uA = u;
				}
			}
		}
		System.runAs(uA) {
			String requestString2 = '{"Header":{"ExecutionLayerRequestID":"5baff94a-b0fc-4440-ab29-ad20cf046755","Timestamp":"21-11-2020  18:56:25"},"nonIndividual":{"Account":{"ExecutionLayerRequestID__c":"5baff94a-b0fc-4440-ab29-ad20cf046755","Name":"FUELAND INVESTMENTS CC","Client_Type__c":"03101","ID_Type__c":"Registration Number","Registration_Number__c":"111201110154623","Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SA004","Preferred_Communication_Method__c":2,"Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":true,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__c":"38","Monthly_Income__c":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"South Africa","Standard_Industry_SIC_Code__c":"42000","Nature_of_Client__c":"42000","cif__c":"","Application_Number__c":"RBD-889455"},"Address__c":[{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Business Address"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Registered"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Postal"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Head Office"}],"Trading_as_Name__c":[{"Name":"FUELAND INVESTMENTS CC"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S34","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"12","Rand_value_of_credits_per_month__c":"12","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"12","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"2","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments;Savings and Investments Products","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"RR","FirstName":"RENDANI COLLINS","LastName":"RAMABULANA","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7805175453088","Gender__pc":"1","PersonBirthdate":"1978-05-17","Country_of_Birth__pc":"SO003","Marital_Status__pc":"1","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":18,"Occupation_Status__pc":8,"Occupation__pc":18,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"APPLICANT;SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}},{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"JS","FirstName":"JOHANNES JACOBUS","LastName":"SPIES","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7404115342088","Gender__pc":"1","PersonBirthdate":"1974-04-11","Country_of_Birth__pc":"SO003","Marital_Status__pc":"","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":0,"Occupation_Status__pc":0,"Occupation__pc":0,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"eekoring","Shipping_Street_2__c":null,"Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}}],"Lead":null}}';
			RestRequest req2 = new RestRequest();
			RestResponse res2 = new RestResponse();
			req2.requestURI = '/services/apexrest/business-evolve/v1/';
			req2.httpMethod = 'POST';
			req2.requestBody = Blob.valueof(requestString2);
			RestContext.request = req2;
			RestContext.response = res2;
			Business_Evolve_Response test2Business_Evolve_Response = Business_Evolve_RestApi.createObjects();
			System.assertEquals('SFDC', test2Business_Evolve_Response.SourceID, 'test2Business_Evolve_Response failed');
			System.debug('test2Business_Evolve_Response - ' + test2Business_Evolve_Response);

			try {
				Opportunity oppRec = [SELECT id, accountId FROM Opportunity LIMIT 1];
				System.enqueueJob(new queableRikScreening(oppRec.Id, '', '', oppRec.accountId));
			} catch (ListException ex) {
				system.debug(ex);
			}
		}
	}
	@isTest
	public static void test3() {
		User uA = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					uA = u;
				}
			}
		}
		System.runAs(uA) {
			Test.setMock(HttpCalloutMock.class, new GetClientDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
			IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.GET_CLIENT_DETAILS });

			String requestString3 = '{"Header":{"ExecutionLayerRequestID":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91e","Timestamp":"21-11-2020 02:46:34"},"Individual":{"Account":{"ExecutionLayerRequestID__c":"bf44c923-a3c9-4ebe-ae6b-835fc4d1b91e","PersonTitle":"02","Application_Number__c":"RBD-870420","Initials__pc":"MT","FirstName":"MALEHLOHONOLO FLORENCE","LastName":"TNANDEKISO","Client_Type__c":"08101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"6808120537089","Gender__pc":"2","PersonBirthdate":"1968-08-12","Country_of_Birth__pc":"SO003","Marital_Status__pc":"2","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"63121","PersonEmail":"brinley.mcquire@absa.africa","PersonMobilePhone":"0648908995","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"E","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":10,"Occupation_Status__pc":8,"Occupation__pc":10,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"SOLE TRADER CLIENT","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SO003","Preferred_Communication_Method__pc":"Email","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"05","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"63121","Nature_of_Client__c":"63121","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":"ZUMA123"},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Postal"},{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"Some Value","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Physical Address"}],"Trading_as_Name__c":[{"Name":"brinz inc"}],"OpportunityLineItem":[{"Product2":"11020","Fee_Structure_code__c":"CQT02S36","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"1","Rand_value_of_credits_per_month__c":"11","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"1","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"1","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Sole Trader","Address_Type__c":"Business Address"}],"AccountContactRelation":{"Roles":"APPLICANT;MANDATE_OFFICIAL;SIGNATORY","Share_Percentage__c":"0.0"}}]}}';
			RestRequest req3 = new RestRequest();
			RestResponse res3 = new RestResponse();
			req3.requestURI = '/services/apexrest/business-evolve/v1/';
			req3.httpMethod = 'POST';
			req3.requestBody = Blob.valueof(requestString3);
			RestContext.request = req3;
			RestContext.response = res3;
			Business_Evolve_Response test3Business_Evolve_Response = Business_Evolve_RestApi.createObjects();
			System.assertEquals('SFDC', test3Business_Evolve_Response.SourceID, 'test3Business_Evolve_Response failed');
			System.debug('test3Business_Evolve_Response - ' + test3Business_Evolve_Response);
		}
	}

	/*   @isTest
  public static void test4() {
    User uA = new User();
    Set<String> userEmails = new Set<String>();
    userEmails.add('UserAdmin@testorg.com');
    List<User> userList = new UsersSelector().selectByEmail(userEmails);
    if (userList.size() > 0) {
      for (User u : userList) {
        if (u.Email == 'UserAdmin@testorg.com') {
          uA = u;
        }
      }
    }
    System.runAs(uA) {
      String requestString2 = '{"Header":{"ExecutionLayerRequestID":"5baff94a-b0fc-4440-ab29-ad20cf046755","Timestamp":"21-11-2020  18:56:25"},"nonIndividual":{"Account":{"ExecutionLayerRequestID__c":"5baff94a-b0fc-4440-ab29-ad20cf046755","Name":"FUELAND INVESTMENTS CC","Client_Type__c":"03101","ID_Type__c":"Registration Number","Registration_Number__c":"111201110154623","Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"AM001","Country_of_Operation__c":"SA004","Preferred_Communication_Method__c":2,"Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":true,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":"","Financial_Year_End__c":"2","Source_of_Income__c":"38","":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"South Africa","Standard_Industry_SIC_Code__c":"42000","Nature_of_Client__c":"42000","cif__c":"TEST   123","Application_Number__c":"RBD-889455"},"Address__c":[{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Business Address"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Registered"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Postal"},{"Shipping_City__c":"","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"0850","Shipping_Street__c":"PLAAS JAFFRAY","Shipping_Street_2__c":"TZANEEN","Shipping_Suburb__c":"","Client_Entity_Type__c":"03101","Address_Type__c":"Head Office"}],"Trading_as_Name__c":[{"Name":"FUELAND INVESTMENTS CC"}],"OpportunityLineItem":[{"Product2":"11021","Fee_Structure_code__c":"CQT02S34","Policy_Number__c":"","All_transaction_type__c":"Y","Absa_online_for_business_BIB__c":"N","Cell_phone_banking__c":"N"}],"Application__c":{"Source_of_Funds_Savings__c":25,"Expected_number_of_credits_per_month__c":"12","Rand_value_of_credits_per_month__c":"12","Credits_received_via__c":"eft","Where_will_the_credits_be_coming_from__c":"sales","Number_of_debits_per_month__c":"12","Number_of_staff_members__c":"12","Payment_date_of_staff__c":"2020-11-04","Number_of_supplier_payments_per_month__c":"2","Where_are_the_suppliers_located__c":"AM001","Reason_for_debit_orders__c":"debit","Product_Interest__c":"Short-and-medium term funding solutions;Asset Finance;Make and Receive Payments;Savings and Investments Products","Agreed_to_BCA__c":true,"Agreed_to_Terms_and_Conditions__c":"true","Merchant__c":"N","Merchant_Products__c":"","Overdraft__c":"N","Overdraft_Limit__c":""},"relatedParties":[{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"RR","FirstName":"RENDANI COLLINS","LastName":"RAMABULANA","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7805175453088","Gender__pc":"1","PersonBirthdate":"1978-05-17","Country_of_Birth__pc":"SO003","Marital_Status__pc":"1","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":18,"Occupation_Status__pc":8,"Occupation__pc":18,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"brinley.mcquire@absa.africa","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__c":"03","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"amatole","Shipping_Street_2__c":"","Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"APPLICANT;SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}},{"type":"Individual","Account":{"ExecutionLayerRequestID__c":"","PersonTitle":"01","Application_Number__c":null,"Initials__pc":"JS","FirstName":"JOHANNES JACOBUS","LastName":"SPIES","Client_Type__c":"00101","ID_Type__pc":"SA Identity Document","ID_Type__c":"SA Identity Document","ID_Number__pc":"7404115342088","Gender__pc":"1","PersonBirthdate":"1974-04-11","Country_of_Birth__pc":"SO003","Marital_Status__pc":"","Marital_Contract_Type__pc":"","Nationality__pc":"SOU01","Industry":"","PersonEmail":"","PersonMobilePhone":"","PersonHomePhone":"","Home_Language__pc":"E","Communication_Language__pc":"","Country_of_Citizenship__c":"SOU01","Manager_other_than_the_Sole_Trader__c":true,"Occupation_Category__pc":0,"Occupation_Status__pc":0,"Occupation__pc":0,"Client_list_may_be_Sold_or_Distributed__c":true,"Client_Group__c":"Non Individual","Business_Unit__c":"Virtual Channel","Countries_Traded_With__c":"","Country_of_Operation__c":"","Preferred_Communication_Method__pc":"","Preferred_Communication_Info__c":"","Language__c":"E","Preferred_delivery_method_Legal_Notices__c":"","Is_Marketing_Consent_Email__c":false,"Is_Marketing_Consent_Phone__c":false,"Is_Marketing_Consent_SMS__c":false,"Is_Marketing_Consent_voice_rec__c":false,"Income_Tax_Number__c":"","VAT_Registration_Number__c":0,"Financial_Year_End__c":"2","Source_of_Income__pc":"","Source_of_Income__c":"","Monthly_Income__pc":"","Foreign_Tax_Number__c":"","Country_of_Foreign_tax__c":"","Country_of_Incorporation__c":"SOUTH AFRICA","Standard_Industry_SIC_Code__c":"","Nature_of_Client__c":"","Is_the_Client_a_Temporary_Resident__c":false,"Is_the_Client_a_Non_resident__c":false,"Reason_For_Not_Providing_SA_Tax_Number__c":"","cif__c":""},"Address__c":[{"Shipping_City__c":"JOHANNESBURG","Shipping_Country__c":"SO003","Shipping_Zip_Postal_Code__c":"1449","Shipping_Street__c":"eekoring","Shipping_Street_2__c":null,"Shipping_Suburb__c":"ALBERTON","Client_Entity_Type__c":"Individual","Address_Type__c":"Physical Address"}],"AccountContactRelation":{"Roles":"SHAREHOLDER;SIGNATORY","Share_Percentage__c":"50.0"}}],"Lead":null}}';
      RestRequest req2 = new RestRequest();
      RestResponse res2 = new RestResponse();
      req2.requestURI = '/services/apexrest/business-evolve/v1/';
      req2.httpMethod = 'POST';
      req2.requestBody = Blob.valueof(requestString2);
      RestContext.request = req2;
      RestContext.response = res2;
      Business_Evolve_Response test2Business_Evolve_Response = Business_Evolve_RestApi.createObjects();
      System.assertEquals('SFDC', test2Business_Evolve_Response.SourceID, 'test2Business_Evolve_Response failed');
      System.debug('test2Business_Evolve_Response - ' + test2Business_Evolve_Response);
    }
  }*/

	/**
	 *  @description createEmployersAddress
	 *  @param accountP
	 */
	public static void createEmployersAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Employers';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

	/**
	 *  @description createPhysicalEmployersAddress
	 *  @param accountP
	 */
	public static void createPhysicalEmployersAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Physical Address';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

	/**
	 *  @description createBusinessAddress
	 *  @param accountP
	 */
	public static void createBusinessAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Business Address';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

	/**
	 *  @description create PostalAddress
	 *  @param accountP
	 */
	public static void createPostalAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Postal';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}
}