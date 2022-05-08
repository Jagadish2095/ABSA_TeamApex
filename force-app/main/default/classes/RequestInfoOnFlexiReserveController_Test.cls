@isTest
public class RequestInfoOnFlexiReserveController_Test {
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

       RequestInfoOnFlexiReserveController.getAccountDetails(personAccCaseRec.Id);
       RequestInfoOnFlexiReserveController.getAccountDetails(caseRec.Id);
       RequestInfoOnFlexiReserveController.getAccountInfo(caseRec.Id,personAccCaseRec.AccountId);
       RequestInfoOnFlexiReserveController.caseClose(caseRec.Id);
       RequestInfoOnFlexiReserveController.getNHAccountInfo(personAccCaseRec.AccountId);
    } 
}