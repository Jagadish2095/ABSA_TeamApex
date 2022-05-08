/**

 * Unclaimed funds controller test class

 * @Author: Mbuyiseni Mbhokane
 * @Since: 06/11/2020
 */
@isTest
public class UnclaimedFundsControllerTest {

    @testSetup static void dataCreation(){

        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        List<Account> accounts = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        List<Account> accountUpdate = new List<Account>();

        for (Account acc : accounts) {
            acc.LastName = 'SKOSANA';
            acc.ID_Type__pc = 'SA Identity Document';
            acc.ID_Number__pc = '8505225522085';
            acc.CIF__c = 'ARENTAL001';
            accountUpdate.add(acc);
        }

        insert accountUpdate;

    }



    @isTest public static void getCustomerAccountsTest(){

        Account account = [SELECT ID FROM Account WHERE LastName='SKOSANA' LIMIT 1];
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});

        test.startTest();
        String getAccountDetailsResponse = UnclaimedFundsController.getAccountLinkedToClient(account.Id);
        test.stopTest();


    }

    @isTest public static void savingsGetHoldsDetailsTest(){

        Test.setMock(HttpCalloutMock.class, new SVgetAccountHoldsDetailV4_MockApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_GET_ACCOUNT_HOLDS});

        test.startTest();
        String getSavingsAccHoldDetails = UnclaimedFundsController.viewHoldsOnSavingsAccount('9050986380');

        System.assertNotEquals(getSavingsAccHoldDetails, null,'Account Details should not be null');


        test.stopTest();
    }

    @isTest public static void savingsUpdateHoldsTest(){

        Test.setMock(HttpCalloutMock.class, new SVupdateAccountHoldsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.SV_UPDATE_ACCOUNT_HOLDS});

        test.startTest();
        String updateSavingsAccHolds = UnclaimedFundsController.svUpdateHolds('9050986380','Y','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N');

        System.assertNotEquals(updateSavingsAccHolds, null,'Account Details should not be null');

        test.stopTest();
    }

    @isTest public static void chequeGetHoldsDetailsTest(){

        Test.setMock(HttpCalloutMock.class, new CQgetAcctHoldsMaintV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_GET_ACCOUNT_HOLDS});

        test.startTest();
        String getChequeAccHoldDetails = UnclaimedFundsController.viewHoldsOnchequeAccount('4047995828');

        System.assertNotEquals(getChequeAccHoldDetails, null,'Account Details should not be null');


        test.stopTest();

    }

    @isTest public static void chequeUpdateHoldsTest(){

        Test.setMock(HttpCalloutMock.class, new CQupdAcctHoldsV4_Mock_Api(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.CQ_UPDATE_ACCOUNT_HOLDS});

        test.startTest();
        String cqUpdateHoldsTest = UnclaimedFundsController.cqUpdateHolds('4047995828','N','Y','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N','N');
        test.stopTest();

        System.assertNotEquals(cqUpdateHoldsTest, null,'Account Details should not be null');



    }

    @isTest public static void chequeGetAccountClosureDetailsTest(){

        Date todaysDate = Date.today();
        String effectiveClosedDate = String.valueOf(todaysDate).replace('-', '');

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CQgetCloseAccountDetailsV4API_IH_v1_Test.POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQgetCloseAccountDetailsV4API_IH_v1.INTEGRATION_SERVICE_NAME});

        test.startTest();
        String chequeGetAccountClosureDetails = UnclaimedFundsController.cqGetCloseAccDetails('4046021840', effectiveClosedDate);
        test.stopTest();

        System.assertNotEquals(chequeGetAccountClosureDetails, null,'Account Details should not be null');



    }

    @isTest public static void chequeUpdateClosureDetailsTest(){

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, CQUpdClosureDetailsV1_IH_v1_Test.POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQUpdClosureDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});

        test.startTest();
        String chequeUpdateClosureDetails = UnclaimedFundsController.cqUpdateCloseAccDetails('4046021840', '3');
        test.stopTest();

        System.assertNotEquals(chequeUpdateClosureDetails, null,'Account Details should not be null');



    }

}