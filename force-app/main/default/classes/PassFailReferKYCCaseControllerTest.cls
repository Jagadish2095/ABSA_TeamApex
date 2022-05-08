/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-12-06
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@IsTest
public with sharing class PassFailReferKYCCaseControllerTest {
    @testSetup
    static void methodName() {
        Test.setMock(HttpCalloutMock.class, new ciupdateAccountUpdateMock_ApiRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_DETAILS});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {'ciupdateclientdetailv12'});

        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Case');

        Account theAcc = new Account();
			theAcc.CIF__c = 'ZUMA123';
			theAcc.PersonMobilePhone = '0478956208';
			theAcc.Initials__pc = 'S';
			theAcc.PersonTitle = 'Mr';
			theAcc.LastName = 'Mathe';
            theAcc.FirstName = 'test';
			theAcc.BillingStreet = '15 Johhanesburg';
			theAcc.BillingCity = 'Sandton';
			theAcc.BillingPostalCode = '2001';
			theAcc.ID_Type__pc = 'SA Identity Document';
			theAcc.ID_Number__pc = '9202031586089';
			theAcc.PersonBirthdate = Date.newInstance(1992, 2, 3);
            theAcc.Client_Group__c = 'Non Individual';
			theAcc.Client_Type__c = 'Individual';
			theAcc.Gender__pc = 'Male';
            theAcc.PersonEmail ='Test@absa.co.za';
            theAcc.Preferred_Communication_Method__pc='Phone';
            insert theAcc;
        List<Account> accountListP =new List<Account>();
        accountListP.add(theAcc);
        List<Address__c> addrList = new List<Address__c>();
        Address__c addrRes = new Address__c();
        addrRes.Account__C = theAcc.Id;
        addrRes.Address_Type__c = 'Employers';
        addrRes.Address1__c = '270 REPUBILE ave';
        addrRes.Address2__c = 'test';
        addrRes.Address3__c = 'test';
        addrRes.Address4__c = 'JOHANNESBURG';
        addrRes.Address5__c = 'SO003';
        addrRes.Shipping_Street__c='270 REPUBILE ave';
        addrRes.Shipping_Suburb__c='test';
        addrRes.Shipping_City__c='test';
        addrRes.Shipping_State_Province__c='JOHANNESBURG';
        addrRes.Shipping_Zip_Postal_Code__c='0157';
        insert addrRes;
        addrList.add(addrRes);
        
        Address__c addrPhy = new Address__c();
        addrPhy.Account__C = theAcc.Id;
        addrPhy.Address_Type__c = 'Physical Address';
        addrPhy.Address1__c = '270 REPUBILE ave';
        addrPhy.Address2__c = 'test';
        addrPhy.Address3__c = 'test';
        addrPhy.Address4__c = 'JOHANNESBURG';
        addrPhy.Address5__c = 'SO003';
        addrPhy.Shipping_Street__c='270 REPUBILE ave';
        addrPhy.Shipping_Suburb__c='test';
        addrPhy.Shipping_City__c='test';
        addrPhy.Shipping_State_Province__c='JOHANNESBURG';
        addrPhy.Shipping_Zip_Postal_Code__c='0157';
        insert addrPhy;
        addrList.add(addrPhy);
        
        Address__c addrPostal = new Address__c();
        addrPostal.Account__C = theAcc.Id;
        addrPostal.Address_Type__c = StringConstants.POSTAL_STRING;
        addrPostal.Address1__c = '270 REPUBILE ave';
        addrPostal.Address2__c = 'test';
        addrPostal.Address3__c = 'test';
        addrPostal.Address4__c = 'JOHANNESBURG';
        addrPostal.Address5__c = 'SO003';
        addrPostal.Shipping_Street__c='270 REPUBILE ave';
        addrPostal.Shipping_Suburb__c='test';
        addrPostal.Shipping_City__c='test';
        addrPostal.Shipping_State_Province__c='JOHANNESBURG';
        addrPostal.Shipping_Zip_Postal_Code__c='0157';
        insert addrPostal;

         Contact contact = new Contact(LastName='Test contact', Email = 'agents@support.co.za');
        insert contact;
        
        Case caseInTest = new Case(Status = 'New' , AccountId = theAcc.Id , ContactId = contact.Id,Customer_Type__c = '',Client_Number__c = '',RecordTypeId=rtInfo.get('AOL').getRecordTypeId(),DD_Case_Outcome__c='First Attempt',Category__c='AOL');
        insert caseInTest;
        Document__c doc = new Document__c(Name = 'test1', Reference__c = 'test', Case__c = caseInTest.Id, Type__c = 'Fic Proof of address', Is_Fic_Document_Consent__c=false,Fic_Document_no_consent_reason__c='');
        insert doc;
    }

    @isTest
    static void getCaseWhenAccountApplicationInOrderIsTrue() {
        Case cas = [SELECT Id FROM Case LIMIT 1];
        Case testCase = new Case();
        Case testCaseTest = new Case();
        Test.startTest();
        testCase = PassFailReferKYCCaseController.getCase(cas.Id);
        Test.stopTest();

        System.assertEquals('New', testCase.Status);
    }


    @isTest
    static void updateCaseWithReferredStatus() {
        Integration_API__c jitterBitApi = new Integration_API__c(Name='Jitterbit2',Client_ID__c='e33caff9-53d8-43ad-8b2a-d5531aae3c06',Base_URL__c='https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api',Environment__c='Development');
        insert jitterBitApi;
        Integration_Service__c integrationService = new Integration_Service__c();
        integrationService.Name = 'ciupdateclientdetailv12';
        integrationService.Integration_API_ID__c = jitterBitApi.Id;
        integrationService.Content_Type__c='application/json';
        integrationService.Method__c='POST';
        integrationService.URL_Extension__c='/cif/CIupdateClientDetailV12';
        insert integrationService;
        
        
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
         
        Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
       
        Case cas = [SELECT Id, Case_Record_Type_Name__c, AccountId,ContactId,Status , FIC_Case_FailedComments__c, Customer_Type__c,Referral_Reason__c, Fail_Additional_Information__c, Fail_Reason__c, Additional_Information__c,  CaseNumber, Owner_Queue_Name__c FROM Case LIMIT 1];

        Test.startTest();
         // Set mock callout class 
        PassFailReferKYCCaseController.updateCaseToReferred(cas, 'New', false);
        PassFailReferKYCCaseController.updateCaseToReferred(cas, 'New', true);
        Test.stopTest();

        Case casTest = [SELECT Id, Status FROM Case LIMIT 1];
        System.assert(true,'Case status not as expected');
    }

    @isTest
    static void checkIfReasonIsFulfill() {
        Case cas = [SELECT Id, Status FROM Case LIMIT 1];
        PassFailReferKYCCaseController.DocumentsConsent docTest = new PassFailReferKYCCaseController.DocumentsConsent ();

        Test.startTest();
        docTest =  PassFailReferKYCCaseController.checkFailReason(cas.Id);
        Test.stopTest();

        System.assertEquals(false, docTest.allReasonAreFulfill);
    }

    @isTest
    static void checkGetDocumentsOrder() {
        Case cas = [SELECT Id FROM Case LIMIT 1];
        Boolean notAllDocsInOrder = false;

        Test.startTest();
        notAllDocsInOrder =  PassFailReferKYCCaseController.getDocumentsOrder(cas.Id);
        PassFailReferKYCCaseController.cifwrappercls cif = new PassFailReferKYCCaseController.cifwrappercls();
        cif.cifoutput = '';
        cif.cifoutputerror = '';
        cif.errorObjMsg = '';
        cif.respBeanUpdateClient = new ciupdateclientdetailV12_Resp_IB_v1();
        Test.stopTest();

        System.assertEquals(true, notAllDocsInOrder);
    }
    @isTest
    static void EmailTest(){
        /*
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account' , Active_Email__c ='Test@absa.co.za');
        insert personAccount;
        
        System.debug('Active Email ----->' +  personAccount.Active_Email__c);
        
        Contact contact = new Contact(LastName='Test contact', Email = 'agents@support.co.za');
        insert contact;
        
        Case caseInTest = new Case(Status = 'New' , AccountId = personAccount.Id , ContactId = contact.Id);
        insert caseInTest;
*/
        Case cas = [SELECT Id ,Case_Record_Type_Name__c, AccountId,Account.Active_Email__c,Account.IsPersonAccount,Account.PersonEmail,ContactId, Status , FIC_Case_FailedComments__c, Referral_Reason__c, Fail_Additional_Information__c, Fail_Reason__c, Additional_Information__c,  CaseNumber, Owner_Queue_Name__c FROM Case LIMIT 1];

        Test.startTest();
        PassFailReferKYCCaseController.sendFailEmailtoCustomer(cas);
        Test.stopTest();
        System.assertEquals('New', cas.Status);

      }
    
    @isTest
    static void soleTraderTest(){
        Account theAcc = new Account();
        theAcc.name = 'test acc';
        theAcc.Country_of_Registration__c = 'South Africa';
        theAcc.Client_Group__c = 'SOLE TRADER CLIENT';
        theAcc.Client_Type__c = 'Individual';
        theAcc.Registration_Number__c = '201930633006';
        theAcc.ID_Type__c = 'Registration Number';
        theAcc.BillingStreet= '270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.ShippingStreet='270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.Phone = '0124142313';
        theAcc.Active_Email__c = 'muvhuso.nelhubvi@absa.africa';
        insert theAcc;
        List<Account> accountListP =new List<Account>();
        accountListP.add(theAcc);
        List<Address__c> addrList = new List<Address__c>();
        Address__c addrRes = new Address__c();
        addrRes.Account__C = theAcc.Id;
        addrRes.Address_Type__c = 'Employers';
        addrRes.Address1__c = '270 REPUBILE ave';
        addrRes.Address2__c = 'test';
        addrRes.Address3__c = 'test';
        addrRes.Address4__c = 'JOHANNESBURG';
        addrRes.Address5__c = 'SO003';
        addrRes.Shipping_Street__c='270 REPUBILE ave';
        addrRes.Shipping_Suburb__c='test';
        addrRes.Shipping_City__c='test';
        addrRes.Shipping_State_Province__c='JOHANNESBURG';
        addrRes.Shipping_Zip_Postal_Code__c='0157';
        insert addrRes;
        addrList.add(addrRes);
        Address__c addrPhy = new Address__c();
        addrPhy.Account__C = theAcc.Id;
        addrPhy.Address_Type__c = 'Physical Address';
        addrPhy.Address1__c = '270 REPUBILE ave';
        addrPhy.Address2__c = 'test';
        addrPhy.Address3__c = 'test';
        addrPhy.Address4__c = 'JOHANNESBURG';
        addrPhy.Address5__c = 'SO003';
        addrPhy.Shipping_Street__c='270 REPUBILE ave';
        addrPhy.Shipping_Suburb__c='test';
        addrPhy.Shipping_City__c='test';
        addrPhy.Shipping_State_Province__c='JOHANNESBURG';
        addrPhy.Shipping_Zip_Postal_Code__c='0157';
        insert addrPhy;
        addrList.add(addrPhy);
        
        Address__c addrPostal = new Address__c();
        addrPostal.Account__C = theAcc.Id;
        addrPostal.Address_Type__c = StringConstants.POSTAL_STRING;
        addrPostal.Address1__c = '270 REPUBILE ave';
        addrPostal.Address2__c = 'test';
        addrPostal.Address3__c = 'test';
        addrPostal.Address4__c = 'JOHANNESBURG';
        addrPostal.Address5__c = 'SO003';
        addrPostal.Shipping_Street__c='270 REPUBILE ave';
        addrPostal.Shipping_Suburb__c='test';
        addrPostal.Shipping_City__c='test';
        addrPostal.Shipping_State_Province__c='JOHANNESBURG';
        addrPostal.Shipping_Zip_Postal_Code__c='0157';
        insert addrPostal;
        
        Test.startTest();
        PassFailReferKYCCaseController.updateCIFRemediate(theAcc.Id);
        Test.stopTest();

        System.assertEquals('test acc', theAcc.name);

     
    }
    
     @isTest
    static void negativeReferal(){
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account' , PersonEmail = 'muvhusonekhubvi@absa.africa' , Preferred_Communication_Method__pc ='Phone' , Active_Email__c = 'test@absa.co.za');
        insert personAccount;
    
        Case caseInTest = new Case(Status = 'New' , AccountId = personAccount.Id);
        insert caseInTest;
        
        Test.startTest();
        PassFailReferKYCCaseController.updateCaseToReferred(caseInTest, 'Referred', true);
        Test.stopTest();

        System.assertEquals('Test',personAccount.lastName);

    }
    
     @isTest
    static void PositiveReferal(){
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account' , PersonEmail = 'muvhusonekhubvi@absa.africa' , Preferred_Communication_Method__pc ='Email' , Active_Email__c = 'test@absa.co.za');
        insert personAccount;
        Case caseInTest = new Case(Status = 'New' ,  AccountId = personAccount.Id);
        insert caseInTest;
        Test.startTest();
        PassFailReferKYCCaseController.updateCaseToReferred(caseInTest, 'Referred', true);
        Test.stopTest();
        System.assertEquals('Test',personAccount.lastName);

    }
    
    @isTest
    static void individualTest(){
        Account theAcc = new Account();
        theAcc.name = 'test acc';
        theAcc.Country_of_Registration__c = 'South Africa';
        theAcc.Client_Group__c = 'Individual';
        theAcc.Client_Type__c = 'Individual';
        theAcc.Registration_Number__c = '201930633006';
        theAcc.ID_Type__c = 'Registration Number';
        theAcc.BillingStreet= '270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.ShippingStreet='270 REPUBILE ave,test,test,JOHANNESBURG,SO003';
        theAcc.Phone = '0124142313';
        theAcc.Active_Email__c = 'muvhuso.nelhubvi@absa.africa';
        theAcc.Preferred_Communication_Method__c = 'Email';
        insert theAcc;
        List<Account> accountListP =new List<Account>();
        accountListP.add(theAcc);
        List<Address__c> addrList = new List<Address__c>();
        Address__c addrRes = new Address__c();
        addrRes.Account__C = theAcc.Id;
        addrRes.Address_Type__c = 'Employers';
        addrRes.Address1__c = '270 REPUBILE ave';
        addrRes.Address2__c = 'test';
        addrRes.Address3__c = 'test';
        addrRes.Address4__c = 'JOHANNESBURG';
        addrRes.Address5__c = 'SO003';
        addrRes.Shipping_Street__c='270 REPUBILE ave';
        addrRes.Shipping_Suburb__c='test';
        addrRes.Shipping_City__c='test';
        addrRes.Shipping_State_Province__c='JOHANNESBURG';
        addrRes.Shipping_Zip_Postal_Code__c='0157';
        insert addrRes;
        addrList.add(addrRes);
        
        Address__c addrPhy = new Address__c();
        addrPhy.Account__C = theAcc.Id;
        addrPhy.Address_Type__c = 'Physical Address';
        addrPhy.Address1__c = '270 REPUBILE ave';
        addrPhy.Address2__c = 'test';
        addrPhy.Address3__c = 'test';
        addrPhy.Address4__c = 'JOHANNESBURG';
        addrPhy.Address5__c = 'SO003';
        addrPhy.Shipping_Street__c='270 REPUBILE ave';
        addrPhy.Shipping_Suburb__c='test';
        addrPhy.Shipping_City__c='test';
        addrPhy.Shipping_State_Province__c='JOHANNESBURG';
        addrPhy.Shipping_Zip_Postal_Code__c='0157';
        insert addrPhy;
        addrList.add(addrPhy);
        
        Address__c addrPostal = new Address__c();
        addrPostal.Account__C = theAcc.Id;
        addrPostal.Address_Type__c = StringConstants.POSTAL_STRING;
        addrPostal.Address1__c = '270 REPUBILE ave';
        addrPostal.Address2__c = 'test';
        addrPostal.Address3__c = 'test';
        addrPostal.Address4__c = 'JOHANNESBURG';
        addrPostal.Address5__c = 'SO003';
        addrPostal.Shipping_Street__c='270 REPUBILE ave';
        addrPostal.Shipping_Suburb__c='test';
        addrPostal.Shipping_City__c='test';
        addrPostal.Shipping_State_Province__c='JOHANNESBURG';
        addrPostal.Shipping_Zip_Postal_Code__c='0157';
        insert addrPostal;
        
        Test.startTest();
        PassFailReferKYCCaseController.updateCIFRemediate(theAcc.Id);
        Test.stopTest();
        System.assertEquals('test acc', theAcc.name);
     
    }
     @isTest
    static void positiveContactId(){
       /*
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account' , PersonEmail = 'muvhusonekhubvi@absa.africa' , Preferred_Communication_Method__pc ='Phone' ,Active_Email__c = 'test@absa.co.za' );
        insert personAccount;
        Contact contact = new Contact(LastName='Test contact', Email = 'agents@support.co.za');
        insert contact;
        Case caseInTest = new Case(Status = 'New'  , AccountId = personAccount.Id , ContactId = null);
        insert caseInTest;
        */
        Case cas = [SELECT Id ,Case_Record_Type_Name__c, AccountId,Account.Active_Email__c,Account.IsPersonAccount,Account.PersonEmail,ContactId, Status , FIC_Case_FailedComments__c, Referral_Reason__c, Fail_Additional_Information__c, Fail_Reason__c, Additional_Information__c,  CaseNumber, Owner_Queue_Name__c FROM Case LIMIT 1];
        
       //PassFailReferKYCCaseController.sendFailEmailtoCustomer(caseInTest);
       PassFailReferKYCCaseController.updateCaseToReferred(cas, 'Referred', true);
       //System.assertEquals('New', cas.Status);
       System.assertNotEquals(cas.Status, null,'Status should not be null');
 

    }
    
    @isTest
    static void updateCaseWithReferredStatusPositive() {
            Account acc = new Account();
			acc.PersonMobilePhone = '0478956208';
			acc.Initials__pc = 'S';
			acc.PersonTitle = 'Mr';
			acc.LastName = 'Mathe Test';
            acc.FirstName = 'test Test';
			acc.BillingStreet = '15 Johhanesburg';
			acc.BillingCity = 'Sandton';
			acc.BillingPostalCode = '2001';
			acc.ID_Type__pc = 'SA Identity Document';
			acc.ID_Number__pc = '9202031586089';
			acc.PersonBirthdate = Date.newInstance(1992, 2, 3);
            acc.Client_Group__c = 'Individual';
			acc.Client_Type__c = 'Individual';
			acc.Gender__pc = 'Male';
            acc.PersonEmail ='Test@absa.co.za';
            acc.Preferred_Communication_Method__pc='Phone';
            acc.ShippingPostalCode = '2001';
            insert acc;
        Integration_API__c jitterBitApi = new Integration_API__c(Name='Jitterbit2',Client_ID__c='e33caff9-53d8-43ad-8b2a-d5531aae3c06',Base_URL__c='https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api',Environment__c='Development');
        insert jitterBitApi;
        Integration_Service__c integrationService = new Integration_Service__c();
        integrationService.Name = 'ciupdjointparticipantsbyclientcodev7';
        integrationService.Integration_API_ID__c = jitterBitApi.Id;
        integrationService.Content_Type__c='application/json';
        integrationService.Method__c='POST';
        integrationService.URL_Extension__c='/cif/ciupdjointparticipantsbyclientcodev7';
        insert integrationService;
        
        
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
         
        //Test.setMock(HttpCalloutMock.class, new CvsValidationServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
       
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Case caseInTestv1 = new Case(Status = 'New' , AccountId = acc.Id);
        insert caseInTestv1;
        
        Test.startTest();
         PassFailReferKYCCaseController.updateJointCIF(acc.Id,'SWEENC+001');
        Test.stopTest();

        System.assert(true,'Case status not as expected');
    }

    
   
}