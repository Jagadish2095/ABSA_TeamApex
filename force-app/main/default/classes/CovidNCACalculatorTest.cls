@IsTest
public class CovidNCACalculatorTest {
    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
        IntegrationTestDataFactory.insertIntegrationSettings(CIlinkAccounttoClientV4_IH_V1.INTEGRATION_API_NAME, new List<String>{CIlinkAccounttoClientV4_IH_V1.INTEGRATION_SERVICE_NAME});
    }

 	public static testMethod void testUpdateClientDetails() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Covid Onboarding' ];
        String accountObj = '{"Id":"0013N00000IOeE9QAL","FullName":"REBELLO","RegistrationNumber":"7404255133081","DateEstablished":"20180912","CountryOfIncorporation":"SO003","BusinessStartDate":"2020-07-01","DateCurrentAddressSince":"20130901","IsClientIntendsInsolvencyLiquidation":true,"IsClientDeclaredInsolvencyLiquidationPast":false,"IsClientIsStokvel":false,"IsClientIsAMunicipality":false,"IsTradingIndicator":true,"IsEmailCredit":true,"IsSMSCredit":false,"IsPhoneCredit":false,"EmailCredit":"","SMSCredit":"","PhoneCredit":"","IsEmailNonCredit":false,"IsSMSNonCredit":false,"IsPhoneNonCredit":false,"EmailNonCredit":"","SMSNonCredit":"","PhoneNonCredit":"","CIF":"REBELLO001","MDMCODE":"","CASAReferenceNumber":"0","CASAScreeningDate":"2020-08-05","TemporaryResidentPermitNumber":"","TemporaryResidentPermitExpiryDate":"20200630","DateOfBirth":"19740425","ClientType":"SOLE TRADER","IsClientANonResident":false,"IsClientATemporaryResident":false,"IsClientPartOfAnEnterpriseDevelopmentFund":false,"ClientOperatesUnderAnExistingFranchiseContractAgreement":false,"ResidentialStatusAddressOptions":[{"Address":"Physical Address (Businesses) - 8 EBURY AVENUE, 10 GRAND CHATEAUX, BRYANSTON, JOHANNESBURG, 2191"}],"FinCrimeHold":"No","ResidentialStatusAddress":"","ResidentialStatusBorder":"Select an Option"}';
        Map<String, String> actual = CovidNCACalculatorController.updateClient(opportnity.Id, accountObj);
        System.assert( actual != null);
        Test.stopTest();
    }

	public static testMethod void testUpdateOpportunityStage() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Covid Onboarding'];
        CovidNCACalculatorController.updateOpportunityStage(opportnity.Id);
        Test.stopTest();
    }

    public static testMethod void testNCARetrieve(){
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Covid Onboarding' ];
        
         Application_Product__c appProd = CovidNCACalculatorController.getApplicationProduct(opportnity.Id);
        system.debug('appProd--'+appProd);
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetNCARetrieve_IH_v1.INTEGRATION_SERVICE_NAME});

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, '{     "type": "SUCCESS",     "msg": "Container Nca successfully called.",     "result": {         "execution-results": {             "results": [                 {                     "key": "NcaDecision",                     "value": {                         "za.co.absa.brms.nca.NcaDecision": {                             "result": "In NCA",                             "juristic": "Non-Individual"                         }                     }                 }             ],             "facts": []         }     } }'));
   		 Test.startTest();
        appProd = CovidNCACalculatorController.calculateNCAFromService(appProd.Id);

        Test.stopTest();
        }

    /*public static testMethod void testLinkStockNumberToCIFNegative() {
        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Test Opp Onboarding 1' Limit 1];
        Test.startTest();
        delete app;
        String result = AllocateStockNumberController.linkStockNumberToCIF(opportnity.Id);

        System.assertEquals(result,'No Application Record Found');

        Test.stopTest();
    }*/

	/*public static testMethod void testCallToAllocateStockNo() {
        Opportunity opportunity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];

        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        app.Opportunity__c = opportunity.Id;
        update app;
        Test.startTest();

        AllocateStockNumberController.callToAllocateStockNo(opportunity.Id);
        Test.stopTest();
    }

    public static testMethod void testGetStockNumber() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Credit Onboarding' Limit 1];
        AllocateStockNumberController.getStockNumber(opportnity.Id);
        Test.stopTest();
    }*/

    public static testMethod void testgetApplicationProduct() {
        Test.startTest();
        Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name =: 'Covid Onboarding' Limit 1];
         CovidNCACalculatorController.getApplicationProduct(opportnity.Id);
        Test.stopTest();
    }

    

    static testMethod void getApplicationProductPositiveTest() {
        Opportunity newOppRecord = [SELECT Id,Name FROM Opportunity LIMIT 1];
        Test.startTest();

        try{

            Application_Product__c appCredList =  CovidNCACalculatorController.getApplicationProduct(newOppRecord.Id);

        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
    }

    

  
}