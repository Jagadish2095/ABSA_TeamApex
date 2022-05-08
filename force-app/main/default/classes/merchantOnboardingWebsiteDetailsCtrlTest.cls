/*
* Test class written by Tinashe Shoko
* 
*/
@isTest
public class merchantOnboardingWebsiteDetailsCtrlTest {
    @isTest
    public static void documentTriggerFunctionsTest() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        test.startTest();
        String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
        Id fileId = merchantOnboardingWebsiteDetailsCtrl.saveChunk(opp.Id, 'Test.txt', chunk1, 'txt', '', false,'Will', true, '');
		System.assert(fileId != null);
        merchantOnboardingWebsiteDetailsCtrl.getWebsiteURL(opp.Id);
        Map<String,String> strMap = new Map<String,String>();
        strMap.put('Id',opp.Id);
        strMap.put('Website_URL__c','http://www.test.com');
        merchantOnboardingWebsiteDetailsCtrl.updateURLs(opp.Id, 'Opportunity', strMap, 'Website_URL__c' );
        system.assertNotEquals(null, merchantOnboardingWebsiteDetailsCtrl.getDocumentMetadata());
        test.stopTest();
    }
}