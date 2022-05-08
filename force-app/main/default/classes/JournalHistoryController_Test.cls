@isTest
public class JournalHistoryController_Test {
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
    }
    
   @isTest 
    public static void testCIGetAccount(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = TransactionListHistoryController.getAccountDetails(accountList[0].Id);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
    
    @isTest 
    public static void testtransactionHistory(){
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'ABSA TEST';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='9302212347096';
        accountList[0].AccountNumber ='4047995828';

        insert accountList;

        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        caseList[0].Subject = 'TESTCASE123';

        Date sla = Date.today().addDays(15);
        caseList[0].External_SLA_End_Date__c = sla;
        caseList[0].AccountId = accountList[0].Id;

        insert caseList;

        Transaction_Filter_List__c trans = new Transaction_Filter_List__c();

        trans.Processing_Date__c = Date.today().addDays(-15);
        trans.Effective_Date__c = Date.today().addDays(-15);
        trans.Description1__c = 'TEST1232';
        trans.Description2__c = 'TEST1232';
        trans.Description3__c = 'TEST1232'; 
        trans.Transaction_Amount__c = '2000';
        trans.Transaction_Cost__c = '10';
        trans.Balance_After_Transaction__c = '25400'; 
        trans.Transaction_Type__c = '21';
        trans.Event_Number__c = '1';
        trans.Line_Number__c = '12';
        trans.Transaction_Category__c ='12';

        insert trans;
        
        Test.setMock(HttpCalloutMock.class, new NhlistAcctTransHIstoryv5_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings( StringConstants.JITTERBIT2 , new list<String> {StringConstants.GET_TRANSACTION_HISTORY});
        //IntegrationTestDataFactory.insertIntegrationTranslations();
       
       
        Test.startTest();

            String res = TransactionListHistoryController.viewTransactionHistory('4047995828', '20191101','20200317');
            system.assertNotEquals(null, res);
            
            Date fromDate = Date.today().addDays(-60);
            Date toDate = Date.today();

            JournalHistoryController.loadTransactions('4047995828', fromDate, toDate);

           List<Transaction_Filter_List__c> filterList = JournalHistoryController.filterTransactions('', Date.today().addDays(-15), 
                                                                                                            'TEST1232', 'TEST1232',
                                                                                                            'TEST1232', 'TEST1232', 'TEST1232','TEST1232','TEST1232','TEST1232','TEST1232','TEST1232');
            

            System.assertEquals(0, filterList.size());

            JournalHistoryController.caseClose(caseList[0].Id);
        
        Test.stopTest();
        
    }
}