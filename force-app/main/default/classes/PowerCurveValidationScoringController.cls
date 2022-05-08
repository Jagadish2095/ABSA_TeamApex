/**
 * Controller class for the PowerCurveValidationScoring component
 * @author Jason Quevauvilliers
 * @created 2021-01-18
 */
public class PowerCurveValidationScoringController {
    public class ScoringObject{
        @auraEnabled public String preApproved;
        @auraEnabled public String preApprovedAmount;
        @auraEnabled public String reprocessLowerLimit;
        @auraEnabled public String overdraftLimitNewAmount;
        @auraEnabled public String financialStatementRequired;
        @auraEnabled public String spouseDetailsRequired;
        @auraEnabled public String financialIncluded;
        @auraEnabled public String financialAvailable;
        @auraEnabled public String version;
        @auraEnabled public String lastSubmitted;
        public ScoringObject(){}
    }

    @AuraEnabled
    public static ScoringObject getData(String oppID, String stageId) {
        List<Application_Scoring__c> appScore = new ApplicationScoringSelector().selectByOpportunityId(oppID, stageId);

        if(appScore?.size() > 0) {
            ScoringObject scoringObj = new ScoringObject();
            scoringObj.preApproved = appScore[0].PaprPreapprInd__c;//'No';
            scoringObj.preApprovedAmount = '' ;//'R 250 000.00'; //applicable for reprocess only
            scoringObj.reprocessLowerLimit = appScore[0].PreapprReprocessLowerLmtInd__c ;//'Yes';
            scoringObj.overdraftLimitNewAmount = '' ;//'R 250 000.00'; //keeping blank
            scoringObj.financialStatementRequired = '' ;//'Yes';
            scoringObj.spouseDetailsRequired = appScore[0].SpouseDetailsRequiredInd__c ;//'Yes';
            scoringObj.financialIncluded = 'NA' ;//'No';//as per comments from SA we will do it later
            scoringObj.financialAvailable = 'NA' ;//'No';
            scoringObj.version = appScore[0].Stage__c ;//'2';
            scoringObj.lastSubmitted = String.valueOf(appScore[0].LastModifiedDate);//'20 Feb 2020 10:00:00 am';
            return scoringObj;
        }

        return null;
    }

    @AuraEnabled
    public static List<Application_Product__c> getChequeAndOverdraft(String oppId){
        try {
            return new ApplicationProductSelector().selectLinkedUniqueIDAndRefAccByOppId(oppId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Application_Triad__c> getApplicationTriadPreAdviced(String oppID){
        try {
            return TriadPreAdvicedController.getApplicationTriadPreAdviced(oppID);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}