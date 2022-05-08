@isTest
public class MerchantProductDetailsControllerTest {

    @isTest static void testGetData() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        Application__c app = testDataFactory.testApplication;
        List<String> picklistName = new List<String>();
        picklistName.add('Configuration__c');

        Test.startTest();
		Map<String, String> returnMap = MerchantProductDetailsController.getData(opp.Id, null, picklistName);
        Test.stopTest();
    }

    @isTest static void testDetermineFieldVisibility() {
        test.startTest();
        system.assertNotEquals(null, MerchantProductDetailsController.determineFieldVisibility('E-Commerce','MerchantProductDetails'));
        test.stopTest();
    }
}