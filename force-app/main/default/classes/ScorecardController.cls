public  class ScorecardController {
    @AuraEnabled
    public static Application_Scoring__c getScorecardData(String oppId) {
        //Only 1 Application Scoring record should exist for an Application and one Application for an Opportunity
        //Get the newest Application Scoring record if more than one exists for a specific Application linked to the Opportunity
        Application_Scoring__c appScoring = [SELECT Id, (SELECT Id, Excess_Indicator__c FROM Application_Scoring_Entity__r WHERE Entity_Number__c = '1')
                                                FROM Application_Scoring__c
                                                WHERE Application_Number__r.Opportunity__c =: oppId ORDER BY CreatedDate DESC LIMIT 1];
        return appScoring;
    }
}