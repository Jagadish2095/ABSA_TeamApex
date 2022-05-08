/**
* Apex Enterprise Design Patters
* Test Class for the Selector layer for ESP_Onboarded__c objects
*
* @author  Manoj Danthala
* @since   11/18/2020
*/
@IsTest
public class ESPOnboardedSelectorTest {
	static testMethod void testGetSObjectType() {
        test.startTest();
        System.assert(new ESPOnboardedSelector().getSObjectType() != null);
        test.stopTest();
    }

    static testMethod void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new ESPOnboardedSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    
    static testMethod void testSelectBycif() {
        ESP_Onboarded__c espOn = new ESP_Onboarded__c();
        espOn.ClientKey__c = 'LETANTA008';
        insert espOn;
        
        test.startTest();
        ESP_Onboarded__c espList = new ESPOnboardedSelector().selectBycif(espOn.ClientKey__c).get(0);
        System.assert(new ESPOnboardedSelector().selectBycif(espList.ClientKey__c) != null);
        test.stopTest();
    }
}