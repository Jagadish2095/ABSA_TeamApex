/**
* Test class for MerchantOnboardingQualityAssuranceCntrlr class
*
* @author  Lerato Matenzhe
* @version v1.0
* @since   2020-06-04
*/

@isTest
public class MerchantOnboardingQualityAssuranceTest {
    
    @TestSetup
    static void makeData(){
        WimiTestDataFactory testDatafactory = new WimiTestDataFactory();
    }
    
    @isTest static void getData(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        Map<String, String> responseMap = MerchantOnboardingQualityAssuranceCntrlr.getData(opp.Id, null);
        responseMap = MerchantOnboardingQualityAssuranceCntrlr.getData(opp.Id, 'Merchant_Onboarding_QA_Team');
        Test.stopTest();
        
        System.assert(responseMap.containsKey('applicationId'));
        System.assert(responseMap.containsKey('applicationRecordTypeId'));
        System.assertNotEquals('applicationId', null);
    }
}