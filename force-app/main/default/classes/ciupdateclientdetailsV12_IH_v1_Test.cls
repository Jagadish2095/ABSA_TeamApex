/**
 * @description       : 
 * @author            : Monde Masiza
 * @last modified on  : 2021-12-08
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-05-26   Monde Masiza   Initial Version
**/
@isTest
public class ciupdateclientdetailsV12_IH_v1_Test {
    @isTest static void testAccountupdatePositive(){
        //Set Mock
        test.setMock(HttpCalloutMock.class, new ciupdateAccountUpdateMock_ApiRest(StringConstants.POSITIVE_STRING));
         //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
         Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {'ciupdateclientdetailv12'});
        
        Test.startTest();
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
       account.Client_Group__c = 'SOLE TRADER CLIENT';
       account.CASA_Reference_Number__c = '12233';
        account.CIF__c = 'GREENJ 154';
       account.Countries_Traded_With__c = 'South Africa';
       account.Source_of_Income__c = 'Trading Income- Sales';
        account.Client_Type__c = 'Sole Trader';

       insert account;
        
        
     Account acc = new Account();
     acc.CIF__c= 'ZUMA123';
	 acc.PersonMobilePhone= '0478956208';
	 acc.Initials__pc= 'S';
	 acc.PersonTitle= 'Mr';
	 acc.LastName= 'Mathe';
	 acc.BillingStreet= '15 Johhanesburg';
	 acc.BillingCity= 'Sandton';
	 acc.BillingPostalCode= '2001';
	 acc.ID_Type__pc= 'SA Identity Document';
	 acc.ID_Number__pc= '9202031586089';
	 acc.PersonBirthdate = Date.newInstance(1992, 2, 3);
	 acc.Client_Type__c= 'Trusts';
	 acc.Gender__pc= 'Male';
	 acc.Number_Of_Dependents__c = 2.00;
	 acc.Occupation_Category__pc= 'Actuary';
	 acc.Client_ever_been_declared_Insolvent__c = false;
	 acc.Marital_Contract_Type__pc= 'In Community Of Property';
	 acc.Home_Language__pc= 'English';
	 acc.Income_Tax_Number__pc = '1.00';
	 acc.FirstName= 'ABSA';
	 acc.Occupation_Status__pc= 'Full Time Employed';
	 acc.PersonEmail= 'test@test.com';
	 acc.Preferred_Communication_Method__pc= 'Email';
	 acc.Sic= '0000';
     acc.Client_Type__c = 'Sole Trader';
     acc.Client_Group__c = 'SOLE TRADER CLIENT';
	 acc.Source_of_Income__c= 'PENSION';
	 acc.Date_Identified__c  = Date.newInstance(2020, 12, 9);
	 acc.Nationality__pc= 'South Africa';
	 acc.Q4a_Client_affected_by_Regulation_3_1_F__c = false;
	 acc.Date_Issued__pc  = Date.newInstance(2016, 11, 9);
	 acc.CASA_Reference_Number__pc= '7877';
	 acc.Marital_Status__pc= 'Married';
	 acc.Communication_Language__pc= 'English';
	 acc.Monthly_Income__pc= 'R15000 - 19999';
     acc.Q2a_Client_affected_by_Regulation_3_1_F__c= false;
     acc.SIC_Classification_1__c = 'Almond Nuts';
     acc.SIC_Classification_2__c = 'Apples';
     acc.SIC_Classification_3__c = 'Avocados' ;
     acc.PersonHomePhone = '0115896543'; 
     acc.Q1a_Client_affected_by_Regulation_3_1_F__c= true;
     acc.Q2a_Client_affected_by_Regulation_3_1_F__c = true;
     acc.Q4a_Client_affected_by_Regulation_3_1_F__c = true;
    //acc.Q4b_How_is_the_Client_Affected__c = 'true'; 
     acc.Non_Credit_Marketing_Consent__pc = 'Yes';
     acc.Credit_Marketing_Consent__pc = 'Yes';
     acc.Q4c_Exchange_Control_Expiry_date__c = Date.newInstance(2016, 11, 9);
     acc.Phone = '0784512964';
     acc.Country_of_Operation__c = 'South Africa';
     acc.Foreign_Tax_Number__c = 0;
     insert acc; 

     
	account accs = [select Id,SIC_Classification_1__c,SIC_Classification_2__c,SIC_Classification_3__c from account where id =: acc.Id];
        String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification','Almond Nuts', StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification','Apples', StringConstants.OUTBOUND_RECORD_TYPE);
        String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'SIC Classification','Avocados', StringConstants.OUTBOUND_RECORD_TYPE);
               
     //Account acc = [SELECT id,Name From Account WHERE Client_Type__c = 'Sole Trader' LIMIT 1];
      //  system.debug('The Id of selected Account' + acc.Id );
         
     Account testAcc = new AccountsSelector().selectAllById(acc.Id);    
   
         List<Address__c> addListToBeInsert = new List<Address__c>();
        
        Address__c add1= new Address__c();
        add1.Account__c =account.id;
        add1.Address_Type__c =StringConstants.RESIDENTIAL_STRING;
        add1.Address1__c ='Address1';
        add1.Address2__c= 'Address2';
        add1.Address3__c='Address3';
        add1.Address5__c ='Address5';
        add1.Shipping_Street__c ='Address1';
        add1.Shipping_Suburb__c= 'Address2';
        add1.Shipping_City__c='Address3';
        add1.Shipping_Zip_Postal_Code__c='0124';
        add1.Shipping_State_Province__c ='Address5';
        addListToBeInsert.add(add1);
        
        Address__c  add2= new Address__c();
        add2.Account__c =account.id;
        add2.Address_Type__c =StringConstants.PHYSICAL_ADDR_STRING;
        add2.Address1__c ='Address1';
        add2.Address2__c= 'Address2';
        add2.Address3__c='Address3';
        add2.Address5__c ='Address5';
        add2.Shipping_Street__c ='Address1';
        add2.Shipping_Suburb__c= 'Address2';
        add2.Shipping_City__c='Address3';
        add2.Shipping_Zip_Postal_Code__c='0124';
        add2.Shipping_State_Province__c ='Address5';
        addListToBeInsert.add(add2);
        
        Address__c  add3 = new Address__c();
        add3.Account__c = account.id;
        add3.Address_Type__c =StringConstants.POSTAL_STRING;
        add3.Address1__c ='Address1';
        add3.Address2__c= 'Address2';
        add3.Address3__c='Address3';
        add3.Address5__c ='Address5';
        add3.Shipping_Street__c ='Address1';
        add3.Shipping_Suburb__c= 'Address2';
        add3.Shipping_City__c='Address3';
        add3.Shipping_Zip_Postal_Code__c='0124';
        add3.Shipping_State_Province__c ='Address5';
        addListToBeInsert.add(add3);
        
        insert addListToBeInsert;
        
        Integration_Translation__c translation1 = new Integration_Translation__c();
      translation1.Name = 'Investments';
      translation1.External_Value__c = '3';
      translation1.Internal_Value__c = 'Investments';
      translation1.System_Name__c = 'CIF';
      translation1.Value_Type__c = 'Source of Income';
      translation1.Direction__c = 'Outbound';
      insert translation1;
        
      Integration_Translation__c translation2 = new Integration_Translation__c();
      translation2.Name = 'Armenia';
      translation2.External_Value__c = 'AM001';
      translation2.Internal_Value__c = 'Armenia';
      translation2.System_Name__c = 'CIF';
      translation2.Value_Type__c = 'Country';
      translation2.Direction__c = 'Outbound';
      insert translation2;
        
      Integration_Translation__c translation3 = new Integration_Translation__c();
    translation3.Name = 'South Africa';
      translation3.External_Value__c = 'SO003';
      translation3.Internal_Value__c = 'South Africa';
      translation3.System_Name__c = 'CIF';
      translation3.Value_Type__c = 'Country';
      translation3.Direction__c = 'Outbound';
      insert translation3;
        
      Integration_Translation__c translation4 = new Integration_Translation__c();
      translation4.Name = 'February';
      translation4.External_Value__c = '2';
      translation4.Internal_Value__c = 'February';
      translation4.System_Name__c = 'CIF';
      translation4.Value_Type__c = 'Financial Year End';
      translation4.Direction__c = 'Outbound';
      insert translation4;
        
      Integration_Translation__c translation5 = new Integration_Translation__c();
    translation5.Name = 'Female';
      translation5.External_Value__c = '2';
      translation5.Internal_Value__c = 'Female';
      translation5.System_Name__c = 'CIF';
      translation5.Value_Type__c = 'Gender';
      translation5.Direction__c = 'Outbound';
      insert translation5;
        
      Integration_Translation__c translation6 = new Integration_Translation__c();
      translation6.Name = 'English';
      translation6.External_Value__c = 'E';
      translation6.Internal_Value__c = 'English';
      translation6.System_Name__c = 'CIF';
      translation6.Value_Type__c = 'Language';
      translation6.Direction__c = 'Outbound';
      insert translation6;
        
      Integration_Translation__c translation7 = new Integration_Translation__c();
      translation7.Name = 'Single';
      translation7.External_Value__c = '2';
      translation7.Internal_Value__c = 'Single';
      translation7.System_Name__c = 'CIF';
      translation7.Value_Type__c = 'Marital Status';
      translation7.Direction__c = 'Outbound';
      insert translation7;
        
        Integration_Translation__c translation8 = new Integration_Translation__c();
    translation8.Name = 'R500 - 999';
      translation8.External_Value__c = '5';
      translation8.Internal_Value__c = 'R500 - 999';
      translation8.System_Name__c = 'CIF';
      translation8.Value_Type__c = 'Monthly Income';
      translation8.Direction__c = 'Outbound';
      insert translation8;
        
        Integration_Translation__c translation9 = new Integration_Translation__c();
    translation9.Name = 'South Africa';
      translation9.External_Value__c = 'SOU001';
      translation9.Internal_Value__c = 'South Africa';
      translation9.System_Name__c = 'eCasa';
      translation9.Value_Type__c = 'Nationality';
      translation9.Direction__c = 'Outbound';
      insert translation9;
        
        Integration_Translation__c translation10 = new Integration_Translation__c();
    translation10.Name = 'Other';
      translation10.External_Value__c = '10';
      translation10.Internal_Value__c = 'Other';
      translation10.System_Name__c = 'CIF';
      translation10.Value_Type__c = 'Occupation Category';
      translation10.Direction__c = 'Outbound';
      insert translation10;
        
        Integration_Translation__c translation11 = new Integration_Translation__c();
    translation11.Name = 'Part Time Employed';
      translation11.External_Value__c = '8';
      translation11.Internal_Value__c = 'Part Time Employed';
      translation11.System_Name__c = 'CIF';
      translation11.Value_Type__c = 'Occupation Status';
      translation11.Direction__c = 'Outbound';
      insert translation11;
        
        Integration_Translation__c translation12 = new Integration_Translation__c();
      translation12.Name = 'Miss.';
      translation12.External_Value__c = '2';
      translation12.Internal_Value__c = 'Miss.';
      translation12.System_Name__c = 'CIF';
      translation12.Value_Type__c = 'Title';
      translation12.Direction__c = 'Outbound';
      insert translation12;
        
        Integration_Translation__c translation13 = new Integration_Translation__c();
      translation13.Name = 'Trading Income- Services';
      translation13.External_Value__c = '38';
      translation13.Internal_Value__c = 'Trading Income- Services';
      translation13.System_Name__c = 'CIF';
      translation13.Value_Type__c = 'Source of Income';
      translation13.Direction__c = 'Outbound';
      insert translation13;
        
        Integration_Translation__c translation14 = new Integration_Translation__c();
      translation14.Name = 'Trading Income- Services';
      translation14.External_Value__c = '38';
      translation14.Internal_Value__c = 'Trading Income- Services';
      translation14.System_Name__c = 'eCasa';
      translation14.Value_Type__c = 'Source of Income';
      translation14.Direction__c = 'Outbound';
      insert translation14;
       
       Integration_Translation__c translation17 = new Integration_Translation__c();
      translation17.Name = 'Trading Income- Services';
      translation17.External_Value__c = '25';
      translation17.Internal_Value__c = 'Trading Income- Services';
      translation17.System_Name__c = 'eCasa';
      translation17.Value_Type__c = 'Source of Income';
      translation17.Direction__c = 'Outbound';
      insert translation17;
        
      Integration_Translation__c translation15 = new Integration_Translation__c();
      translation15.Name = 'Retail sale of new motor vehicles';
      translation15.External_Value__c = '63121';
      translation15.Internal_Value__c = 'Retail sale of new motor vehicles';
      translation15.System_Name__c = 'CIF';
      translation15.Value_Type__c = 'Standard Industry SIC Code';
      translation15.Direction__c = 'Outbound';
      insert translation15;
        
      Integration_Translation__c translation16 = new Integration_Translation__c();
      translation16.Name = 'Sole Trader';
      translation16.External_Value__c = '08101';
      translation16.Internal_Value__c = 'Sole Trader';
      translation16.System_Name__c = 'CIF';
      translation16.Value_Type__c = 'Client Type';
      translation16.Direction__c = 'Outbound';
      insert translation16;
        
      Integration_Translation__c translation18 = new Integration_Translation__c();
      translation18.Name = 'Close Corporation';
      translation18.External_Value__c = '03101';
      translation18.Internal_Value__c = 'Close Corporation';
      translation18.System_Name__c = 'eCasa';
      translation18.Value_Type__c = 'Client Type';
      translation18.Direction__c = 'Outbound';
      insert translation18;  
        
       List<Integration_Translation__c> translation = [SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c ,Internal_Value__c
                                                        FROM Integration_Translation__c
                                                        WHERE Direction__c = :'Outbound'
                                                        AND (System_Name__c =:'CIF'
                                                             OR System_Name__c =:'eCasa')];
        Map<String,String> translations = new Map<String,String>();
        for(Integration_Translation__c translatedVars: translation ){
            String mapKey = translatedVars.Internal_value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
            translations.put(mapKey, translatedVars.External_Value__c); }
        
        AddressesSelector addrSelector = new AddressesSelector();
        List<Address__c> addressList = addrSelector.addressesRelatedToAcc(testAcc.Id); 
        //integration service
        //
        
         
        Integration_API__c api = new Integration_API__c();
        api.Name = 'ciupdatexx';
        api.Environment__c = 'UAT';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;
        
        Integration_API__c api2 = new Integration_API__c();
        api2.Name = 'ciupdatexx';
        api2.Environment__c = 'Production';
        api2.Base_URL__c = 'https://testme/';
        api2.Client_ID__c = '89797897987';
        api2.Client_Secret__c = '789798';
        insert api2;
        
        Integration_Service__c intsrv = new Integration_Service__c();
        intsrv.Integration_API_ID__c = api.Id;
        intsrv.Name = 'ciupdateclientdetailv12';
        intsrv.Method__c = 'POST';
        intsrv.URL_Extension__c = 'ciupdate';
        intsrv.Username__c = 'abc';
        intsrv.Password__c = 'zyx';
        intsrv.Content_Type__c = 'application/json';
        insert intsrv;
        
        Integration_Service__c intsrv2 = new Integration_Service__c();
        intsrv2.Integration_API_ID__c = api2.Id;
        intsrv2.Name = 'ciupdateclientdetailv12';
        intsrv2.Method__c = 'POST';
        intsrv2.URL_Extension__c = 'ciupdate';
        intsrv2.Username__c = 'abc';
        intsrv2.Password__c = 'zyx';
        intsrv2.Content_Type__c = 'application/json';
        insert intsrv2;
        
        // Call the method to test
        GetClientDetailsCIF_Resp_IB_v1 respBean = new GetClientDetailsCIF_Resp_IB_v1();
        respBean = GetClientDetailsCIF_IH_v1.getClientDetails('GREENJ 154','0','009970');
        //List<Address__c> addressList;
       ciupdateclientdetailV12_Req_IB_v1 requestBean = ciupdateclientdetailV12_Req_IB_v1.createDummy();
       ciupdateclientdetailV12_Resp_IB_v1 respBean1 = ciupdateclientdetailV12_Resp_IB_v1.dummyResponse();
       User currentUser = [SELECT Id, SiteCode__c, SiteType__c,BRID__c, Supervisor__C, ManagerId, Teller_Operator_Code__c FROM USER WHERE Id =: Userinfo.getUserId()];
        
        //user
        Profile cscUserProfile = [select Name from Profile where Name = :'System Administrator (Custom)'];
        User newUser = new User();
        newUser.Alias = 'test';
        newUser.Email = 'one@test.sbsa.co.za';
        newUser.Emailencodingkey = 'UTF-8';
        newUser.Lastname = 'UserTest';
        newUser.Languagelocalekey = 'en_US';
        newUser.City = 'Johannesburg';
        newUser.Country = 'South Africa';
        newUser.Division__c = 'CIB';
        newUser.BRID__c = '000003';
        newUser.Localesidkey = 'en_US';
        newUser.EmployeeNumber = '000003';
        newUser.Profileid = cscUserProfile.Id;
        newUser.Timezonesidkey = 'America/Los_Angeles';
        newUser.Username = 'usernam@testuser.com';
        insert newUser;
  
        system.runAs(newUser){
        system.assertEquals('one@test.sbsa.co.za', newUser.Email, 'Email does not match'); 
            
          ciupdateclientdetailV12_Resp_IB_v1 responseBean = ciupdateclientdetailV12_IH_v1.ciupdateclientdetailv12data(testAcc, addressList, translations, 'Sole Trader', '5920', '000003',respBean);
          ciupdateclientdetailV12_Resp_IB_v1 responseBean1 = ciupdateclientdetailV12_IH_v1.ciupdateclientdetailv12data(testAcc, addressList, translations, 'Close Corporation', '5920', '000003',respBean);
            ciupdateclientdetailV12_Resp_IB_v1 responseBeanSurety = ciupdateclientdetailV12_IH_v1.ciupdateclientdetailv12Onboarding(testAcc, addressList, '5920',respBean);
          map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c> responseBeanMap = ciupdateclientdetailV12_IH_v1.ciUpdateRemediateCustomer(testAcc, addressList, translations, 'Sole Trader', '5920', '000003',respBean);
            map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c> responseBeanMap1 = ciupdateclientdetailV12_IH_v1.ciUpdateRemediateCustomer(testAcc, addressList, translations, 'Close Corporation', '5920', '000003',respBean);  
            
        }
           //Insert Integration Settings
  
    	ciupdateclientdetailV12_IU_v1.getClientDetails('GREENJ 154','0','009970');
        Test.stopTest();
    }
    
        @isTest static void getClientDetailsPositive1() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsCIFMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        
        Test.startTest();
        system.assertEquals('test', 'test', 'test');
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetClientDetails_Resp_IB_v1 responseBean = ciupdateclientdetailV12_IU_v1.getClientDetails('GREENJ 154','0','009970'); 
    }
    

}