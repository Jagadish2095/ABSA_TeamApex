/**
 * Test class for CovidBankGuaranteeController
 *
 * @author Ketelo Makalela
 * @created 2020-12-01
 */
@isTest
public class CovidBankGuaranteeControllerTest {
	@testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ABFCreateAndLinkAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    public static testMethod void testCallToAllocateStockNo() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, getABFCreateAndLinkAccountDummyResponsePositive()));
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        String accNum = CovidBankGuaranteeController.callToAllocateStockNo(opportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, accNum);
    }
    
    public static testMethod void testCallToAllocateStockNoError() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, getABFCreateAndLinkAccountDummyResponseNegative()));
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        String accNum = CovidBankGuaranteeController.callToAllocateStockNo(opportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, accNum);
    }
    
    public static testMethod void testGetStockNumber() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        Application__c application = CovidBankGuaranteeController.getStockNumber(opportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, application);
    }
    
    public static testMethod void testLinkStockNumberToCIF() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        String accNum = CovidBankGuaranteeController.linkStockNumberToCIF(opportunity.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, accNum);
    }
    
    
    private static String getABFCreateAndLinkAccountDummyResponsePositive(){
        String responseBody = '{"statusCode":200,"status":"OK","message":null,"Fault":null,"plpa00o":{"eddRiskHoldInd":null,"accountNumber":"00000003001538918","accOrigChannel":null},';
        responseBody += '"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":null},"nbsapdpo":{"version":null,"serviceVersion":"BUSO004",';
        responseBody += '"returnCode":"0","reasonCode":"0","echoKey":null}}';
        
        return responseBody;
    }
    
    private static String getABFCreateAndLinkAccountDummyResponseNegative(){
        String responseBody = '{"statusCode":200,"status":"OK","message":null,"Fault":null,"plpa00o":{"eddRiskHoldInd":null,"accountNumber":"00000000000000000","accOrigChannel":null},';
        responseBody += '"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgTxt":"INV SITE TYPE FOR CAPTURE","msgErrInd":"E",';
        responseBody += '"msgCode":"0099","msgClass":"PLSMGC01"}]},"nbsapdpo":{"version":null,"serviceVersion":"BUSO004","returnCode":"0","reasonCode":"0","echoKey":null}}';
        
        return responseBody;
    }
}