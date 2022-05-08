/**
 * @description       : TBCostAccountController Test
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-29
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
@isTest
public class TBCostAccountControllerTest {


    /**
    * @description Default constructor
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    **/
    public TBCostAccountControllerTest() {

    }

    public static String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetAccountsLinkedToCIF';

    /**
    * @description Create records
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
    @testSetup
    public static void dataCreation() {
        // EmailTemplate template = new EmailTemplate();
        // template.IsActive = true;
        // template.DeveloperName = 'Cost_Account_Updated';
        // template.Name = 'Test  Email';
        // template.TemplateType = 'text';
        // template.folderID = UserInfo.getUserId();
        // template.BrandTemplateId = [SELECT Id FROM BrandTemplate][0].Id;
        // template.TemplateStyle = 'none';
        // insert template;

        Account account = new Account();
        account.FirstName = 'Tom';
        account.LastName = 'Jones';
        account.Client_Type__c = 'Private Individual';
        account.cif__c = 'PIERIDO001';
        account.Telebanking_Charge_Account_Number__c = '5010111070569217';
        account.personemail = 'test@TBCostAccountControllerTest.com';
        insert account;

        Case c = new Case();
        c.AccountId = account.Id;
        c.Description = 'TJs Case';
        c.type__c = 'Service Request';
        c.SLA_Pause_Flag__c = true;
        insert c;

    }

    /**
    * @description Test getAccountEmailFromCase
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
@isTest
    public static void getAccountEmailFromCaseTest(){

        TBCostAccountController.getAccountEmailFromCaseResult result = new TBCostAccountController.getAccountEmailFromCaseResult() ;
        Test.startTest();
        Case c = getCase();
        result = TBCostAccountController.getAccountEmailFromCase(c.Id);
        System.assert(result != null);
        Test.stopTest();

    }

    /**
    * @description Test getAccountOnCase
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
@isTest
    public static void getAccountOnCaseTest(){

        Account result = new Account() ;
        Test.startTest();
        Case c = getCase();
        result = TBCostAccountController.getAccountOnCase(c.Id);

        System.assert(result != null);
        Test.stopTest();

    }


/**
* @description Test getAllAccountsResult
* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
**/
@isTest
public static void getAllAccountsResultTest(){

    IntegrationTestDataFactory.insertIntegrationSettings(
        StringConstants.API_MANAGER,
        new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
    );

    Test.setMock(
        HttpCalloutMock.class,
        Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
    );

    TBCostAccountController.GetAllAccountsResult result = new TBCostAccountController.GetAllAccountsResult() ;
    Test.startTest();
    Case c = getCase();
    result = TBCostAccountController.getAllAccounts(c.Id);

    System.assert(result != null);
    Test.stopTest();

}

    /**
    * @description Test getCostAccounts
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
    @isTest
    public static void getCostAccountsTest(){

        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
        );

        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );
        List<TBCostAccountController.TBCostAccountResult> result;
        Account acc = [SELECT Id FROM Account][0] ;
        Test.startTest();
        //Case c = getCase();
        result = TBCostAccountController.getCostAccounts(acc.Id);

        System.assert(result != null);
        Test.stopTest();

    }

    /**
    * @description Test updateClientCostAccount
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
    @isTest
    public static void updateClientCostAccountTest(){
        Boolean result;
        Account acc = [SELECT Id FROM Account][0];

        Test.startTest();
        Case c = getCase();
        result = TBCostAccountController.updateClientCostAccount(c.Id,'123456789');
        Account updatedAccount = [SELECT Id,Telebanking_Charge_Account_Number__c FROM Account][0];

        System.assertEquals('123456789', updatedAccount.Telebanking_Charge_Account_Number__c, 'Expecting 123456789 as new account, and not ' + updatedAccount.Telebanking_Charge_Account_Number__c);
        System.assertEquals(true, result, 'Expecting update to be successful');

        Test.stopTest();

    }

    /**
    * @description Test getAccountEmail
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    **/
    @isTest
    public static void getAccountEmailTest(){
        TBCostAccountController.getAccountEmailFromCaseResult result;
        Account acc = getAccount();

        Test.startTest();
        result = TBCostAccountController.getAccountEmail(acc.Id);
        System.assert(result != null);
        Test.stopTest();

    }

    /**
    * @description Test GetFromLogsTest
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    **/
    @isTest
    public static void GetFromLogsTest(){
        List<Charge_Log__c> charges = new List<Charge_Log__c>();
        List<TBCostAccountController.GetAccountChargesByIdResult> result;
        Charge_Log__c charge = new Charge_Log__c();
        Account acc = getAccount();
        charge.Account__c = acc.Id;
        charge.Transaction_Date__c = System.now();
        charges.add(charge);
        
        Test.startTest();
        result = new TBCostAccountController.GetAccountChargesByIdResult().GetFromLogs(charges);
        System.assert(result != null);
        Test.stopTest();

    }

    /**
    * @description Test GetFromLogsTest
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    **/
    @isTest
    public static void buildAndSendTbChargesEmailTest(){
        Boolean result;
        List<TBCostAccountController.GetAccountChargesByIdResult> charges = new List<TBCostAccountController.GetAccountChargesByIdResult>();
        TBCostAccountController.GetAccountChargesByIdResult charge = new TBCostAccountController.GetAccountChargesByIdResult();
        Account acc = getAccount();
        charge.ChargeDate = String.valueOf(System.now()).substring(0,10);
        charge.ChargeTime = String.valueOf(System.now()).substring(10,19);
        charges.add(charge);
        
        Test.startTest();
        result =  TBCostAccountController.buildAndSendTbChargesEmail('test@test.com', 'Tommy', charges);
        System.assert(result);
        Test.stopTest();

    }

    /**
    * @description Test closeCaseAndEmailClient
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
    @isTest
    public static void closeCaseAndEmailClientTest(){

        // Folder folder = new Folder();
        // folder.Name = 'Test Folder';
        // folder.DeveloperName = 'Test Folder';
        // insert folder;

         TBCostAccountController.CloseCaseAndEmailResult result;
        // EmailTemplate template = new EmailTemplate();
        // template.IsActive = true;
        // template.DeveloperName = 'Cost_Account_Updated';
        // template.Name = 'Test  Email';
        // template.TemplateType = 'text';
        // template.folderID = UserInfo.getUserId();
        // template.BrandTemplateId = [SELECT Id FROM BrandTemplate][0].Id;
        // template.TemplateStyle = 'none';
        // System.debug('closeCaseAndEmailClientTest: template :' + template);
        // insert template;

        Test.startTest();
        Case c = getCase();
        result = TBCostAccountController.closeCaseAndEmailClient(c.Id,'updated@test.com');
        List<Account> accounts = [SELECT Id FROM Account];
        Account updatedAccount = accounts[0];
        Case updatedCase = getCase();

        System.assert(result != null);
        //System.assertEquals(true, result, 'Expecting update to be successful');

        Test.stopTest();

    }


    /**
    * @description Test close case
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    * @return Case
    **/
    public static Case getCase(){
        List<Case> result = [SELECT Id, accountId, description FROM Case];
        return result[0];
    }

    /**
    * @description Gets account
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    * @return Account 
    **/
    public static Account getAccount(){
        List<Account> result = [SELECT Id, Name FROM Account];
        return result[0];
    }
}