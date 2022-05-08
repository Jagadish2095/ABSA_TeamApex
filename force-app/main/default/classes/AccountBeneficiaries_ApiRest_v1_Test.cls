/**
 * @description       : AccountBeneficiaries_ApiRest_v1 Test
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-28
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
@isTest
public class AccountBeneficiaries_ApiRest_v1_Test {


    /**
    * @description Default constructor
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
    **/
    public AccountBeneficiaries_ApiRest_v1_Test() {

    }

    /**
    * @description Create test records
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17
    **/
    @testSetup
    public static void dataCreation() {
       Account account = new Account();
        account.FirstName = 'Tom';
        account.LastName = 'Jones';
        account.Client_Type__c = 'Private Individual';
        account.cif__c = 'PIERIDO001';
        account.Telebanking_Charge_Account_Number__c = '5010111070569217';
        account.personemail = 'test@TBCostAccountControllerTest.com';
        insert account;

        Absa_Listed_Beneficiaries__c beneficiary = new Absa_Listed_Beneficiaries__c();
        beneficiary.Beneficiary_Cellphone_Number__c = '0741234567';
        beneficiary.Beneficiary_Service_Provider__c = 'Vodacom';
        beneficiary.AccountId__c = account.Id;
        insert beneficiary;

    }
    /**
    * @description 
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-17 
    **/
    @isTest
    public static void doGetTest(){

        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/GetAccountBeneficiariesByCIF/v01/PIERIDO001';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        AccountBeneficiaries_ApiRest_v1.AccountBeneficiaryResult result = AccountBeneficiaries_ApiRest_v1.doGet();
        System.assert(result != null);
        Test.stopTest(); 

        // AccountBeneficiaries_ApiRest_v1.AccountBeneficiaryResult responseBody =(AccountBeneficiaries_ApiRest_v1.AccountBeneficiaryResult)JSON.deserialize(res.responseBody.toString(), AccountBeneficiaries_ApiRest_v1.AccountBeneficiaryResult.class);
        // System.debug('responseBody: ' + responseBody);
        // // System.assertEquals(acc.Id, responseBody.accid);
        // System.assertEquals(acc.Name, responseBody.accName);
        // System.assertEquals(200, res.statusCode);

        // TBCostAccountController.getAccountEmailFromCaseResult result = new TBCostAccountController.getAccountEmailFromCaseResult() ;
        // Test.startTest();
        // Case c = getCase();
        // result = TBCostAccountController.getAccountEmailFromCase(c.Id);
        // System.assert(result != null);
        // Test.stopTest();

    }
}