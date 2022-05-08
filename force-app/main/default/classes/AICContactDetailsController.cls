/**
* @description Lightning Component Controller For AIC Contact Details Component
* @author  Bhanumurty Rayala
* @version v1.0
* @date   2021-10-12
*/
public class AICContactDetailsController {
    /**
    * @description fetching AIC Contact details from custom settings
    * @return contactDetailsLists
    */
    @AuraEnabled
    public static List<AICContactDetails__c> getAICContactDetails() {
        List<AICContactDetails__c> contactDetailsLists = AICContactDetails__c.getall().values();
        contactDetailsLists.sort();
        return contactDetailsLists;
    }
}