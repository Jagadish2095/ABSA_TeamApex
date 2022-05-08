/* Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020 
 */
@isTest
public class ViewAccountHolds_Test {

   
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
    }
    

   @isTest 
    public static void testCIGetAccount(){
        
        Account acct = [SELECT ID FROM Account WHERE LastName='SKOSANA' LIMIT 1];
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = ViewAccountHoldsController.getAccountDetails(acct.Id);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
   
    @isTest 
    public static void testSVgetaccountholdsdetail(){
        
        Test.setMock(HttpCalloutMock.class, new SVgetAccountHoldsDetailV4_MockApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_GET_ACCOUNT_HOLDS});
        
        Test.startTest();  
        String res = ViewAccountHoldsController.svgetaccountholdsdetail('9050986380');
        system.assertNotEquals(null, res);
        Test.stopTest();
        
    }
    
    @isTest 
    public static void testSVUpdateaccountholds(){
        
        Test.setMock(HttpCalloutMock.class, new SVupdateAccountHoldsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_UPDATE_ACCOUNT_HOLDS});
        
        Test.startTest();  
        String res = ViewAccountHoldsController.svUpdateaccountholds('9050986380','Y','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N');
       // system.assertNotEquals(null, res);
        Test.stopTest();
        
        
    }
    
        @isTest 
    public static void testCQgetaccountholdsdetail(){
        Test.setMock(HttpCalloutMock.class, new CQgetAcctHoldsMaintV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_GET_ACCOUNT_HOLDS});
        
        
        Test.startTest();  
        String res = ViewAccountHoldsController.cqgetaccountholdsdetail('4047995828');                                                                 
        system.assertNotEquals(null, res);
        Test.stopTest();
        
    }

    @isTest 
    public static void testvalidateChequeHolds(){
        Test.setMock(HttpCalloutMock.class, new CQupdAcctHoldsV4_Mock_Api(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_UPDATE_ACCOUNT_HOLDS});
        

        Test.startTest();  
        String res = ViewAccountHoldsController.validateChequeHolds('4047995828','N','Y','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N'); 
        system.assertNotEquals(null, res);
        Test.stopTest();
        
    }


}