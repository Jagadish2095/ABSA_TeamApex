@isTest
public class PortfolioBalanceController_Test {
    
    @testSetup 
    static void dataCreation(){
       
        
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        
        insert account;
        
        Account personAccount = new Account(lastName = 'Test', firstName = 'Account',CIF__c = '1234');
        
        insert personAccount;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
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
        
      
    }
    static testMethod void getAccountDetailsPositiveTest(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
   
        Test.startTest();
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Account acct = [SELECT ID FROM Account WHERE LastName='SKOSANA' LIMIT 1];
        
        PortfolioBalanceController.caseClose(caseRec.Id);
        PortfolioBalanceController.getAccountDetails(acct.Id);
        Test.stopTest();
        
    } 

}