@isTest
public class Link_DelinkAccountCBCardController_Test {
    @testSetup 
    static void dataCreation(){
       
        
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        
        insert account;
        
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account',CIF__c = '1234');
        
        insert personAccount;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'normal case',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        Case personAccCaseRec = new Case(Communication_Method__c = 'Email',
                                         Status = 'New',
                                         Origin = 'Email', 
                                         AccountId = personAccount.Id,
                                         Risk_Management_Centre__c = 'Digital Fraud',
                                         Email__c = 'test@test.com',
                                         recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                         Subject = 'person Acc',
                                         Description = 'test',
                                         Expectation_of_the_Customer__c = 'test',
                                         Incident_Date__c = date.today());
        insert personAccCaseRec;
    }
    static testMethod void getAccountDetailsPositiveTest(){
       // CIgetAcctLinkedToClientCode_Req_IB_v1 dummyBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();
       // dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
   
        Test.startTest();
              
        
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
        Account personAccount = [SELECT Id, Name, Source__c FROM Account WHERE Id =: personAccCaseRec.AccountId];

        Link_DelinkAccountCBCardController.getAccountDetails(personAccCaseRec.Id);
        Link_DelinkAccountCBCardController.getAccountDetails(caseRec.Id);
    }   
    static testMethod void getAccountNameTest(){
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
         Link_DelinkAccountCBCardController.getAccountName(personAccCaseRec.Id);
    }
    static testMethod void linkUpdateCallPostivieTest(){
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReq = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cclinkaccounttocombicardv3_Resp_IB_v1 dummyResponseBean = cclinkaccounttocombicardv3_Resp_IB_v1.dummyResponse();
       // cclinkaccounttocombicardv3_IU_v1.mapRequestFields('04483850000284469','4048276744','COMBIK 002');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cclinkaccounttocombicardv3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> { StringConstants.cclinkaccounttocombicardv3_STRING});
        Test.startTest();
      //  cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
         List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'Link',accountNumbers,'04483850000284469');
        Test.stopTest();
    }
    static testMethod void linkUpdateCallNegaivieTest(){
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReq = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1 dummyReqBean = dummyReq.createDummyBean();
        cclinkaccounttocombicardv3_Resp_IB_v1 dummyResponseBean = cclinkaccounttocombicardv3_Resp_IB_v1.dummyResponse();
        cclinkaccounttocombicardv3_IU_v1.mapRequestFields('04483850000284469','4048276744','COMBIK 002');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new cclinkaccounttocombicardv3_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        Test.startTest();
        cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        Test.stopTest();
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
         List<String> actionItem = new List<String>();
        actionItem.add('DeLink');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'Link',actionItem,'1234');
    }
    static testMethod void DelinkUpdateCallPostivieTest(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
       IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.ccdelinkaccountsv1_STRING});
        Test.startTest();
       // cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
          List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'DeLink',accountNumbers,'04483850000284469');
        Test.stopTest();
    }
    static testMethod void DelinkUpdateCallNegaivieTest(){
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
       IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        Test.startTest();
       // cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
          List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'DeLink',accountNumbers,'04483850000284469');
        
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'DeLink',new List<String>(),'04483850000284469');
       Test.stopTest();
    }
    static testMethod void DelinkUpdateCallNegaivieTest1(){
       // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ccdelinkaccountsv1_Mock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit('Jitterbit', new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING,'Jitterbit Auth Path'});
       IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {StringConstants.cclinkaccounttocombicardv3_STRING});
        Test.startTest();
       // cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3('04483850000284469','4048276744','COMBIK 002',true);
        
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
          List<String> accountNumbers = new List<String>();
        accountNumbers.add('4048276744');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(personAccCaseRec.Id,'DeLink',accountNumbers,'04483850000284469');
         Link_DelinkAccountCBCardController.linkDelinkUpdateCall(null,'DeLink',accountNumbers,'04483850000284469');
       
        Test.stopTest();
    }
}