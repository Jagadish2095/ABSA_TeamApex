/**
 * @description       : @description Controller class for the PowerCurveValidationScoring component
 * @author            : Jason Quevauvilliers
 * @last modified on  : 2021-07-14
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2021-01-18      Initial Version
**/
public class PowerCurveOutputController {
    /**
     * @description ScoringObject public class
     */
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
        @auraEnabled public String formalApplication;
        @auraEnabled public String incomeExpense;
        /**
         * @description constructor
        */
        public ScoringObject(){}
    }

    /**
     * @description getData description
     *
     * @param oppID (String): oppID
     * @param stageId (String): stageId
     * @return ScoringObject: Return description
     */
    @AuraEnabled
    public static ScoringObject getData(String oppID, String stageId) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(oppID);
        List<Application_Scoring__c> appScore = new ApplicationScoringSelector().selectByOpportunityId(oppID, stageId);
        List<Application_Scoring_Entity__c> appScoreEntity = new ApplicationScoringEntitiesSelector().selectByAppScoringIdStageIdEntityNum(new Set<Id>{oppID}, new Set<String>{'2'}, new Set<String>{'1'});

        if(appScore?.size() > 0) {
            ScoringObject scoringObj = new ScoringObject();
            scoringObj.preApproved = appScore[0].PaprPreapprInd__c;//'No';
            scoringObj.preApprovedAmount = '' ;//'R 250 000.00'; //applicable for reprocess only
            scoringObj.reprocessLowerLimit = appScore[0].PreapprReprocessLowerLmtInd__c ;//'Yes';
            scoringObj.overdraftLimitNewAmount = '' ;//'R 250 000.00'; //keeping blank
            scoringObj.spouseDetailsRequired = appScore[0].SpouseDetailsRequiredInd__c ;//'Yes';
            scoringObj.financialIncluded = 'NA' ;//'No';//as per comments from SA we will do it later
            scoringObj.financialAvailable = 'NA' ;//'No';
            scoringObj.version = appScore[0].Stage__c ;//'2';
            scoringObj.lastSubmitted = String.valueOf(appScore[0].LastModifiedDate);//'20 Feb 2020 10:00:00 am';
            scoringObj.formalApplication=string.valueof(opp.Illustrative_Decision__c);
            scoringObj.incomeExpense=appScore[0].MIAERequired__c;
            system.debug('appScoreEntity'+json.serializePretty(appScoreEntity));
            if(appScoreEntity?.size() > 0){
                scoringObj.financialStatementRequired = appScoreEntity[0].Financials_Required__c;//'Yes';
            } else {
                scoringObj.financialStatementRequired = '' ;//'Yes';
            }
            system.debug('scoringObj'+json.serializePretty(scoringObj));
            return scoringObj;
        }

        return null;
    }

    /**
     * @Author Tinashe M Shoko
     * @Date 14-Apr-2021
     * @WorkItem - W-008704 Reprocess Lower Limit
     * @description getApplicationTriadPreAdviced
     *
     * @param oppID (String): oppID
     * @return List<Application_Triad__c>: Return description
     */
    @AuraEnabled
    public static List<Application_Triad__c> getApplicationTriadPreAdviced(String oppID){
        List<Application_Triad__c> returnList = new List<Application_Triad__c>();
        try {
            Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        	List<Application_Triad__c> appTriads = new ApplicationTriadsSelector().getTriadsByApplicationID(app.Id);
            if (!appTriads.isEmpty() && appTriads.size() > 0 && appTriads != null) {
                for (Application_Triad__c triad : appTriads) {
                    if (triad.Is_Main_Applicant__c == true) {
                        returnList.add(triad);
                    }
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return returnList;
    }

    /**
     * @author Saurabh : 20210203
     * @description getPCO6Data - adding this method to return output fields for PCO6
     *
     * @param oppID (String): oppID
     * @param stageId (String): stageId
     * @return ScoringObject: Return description
     */
    @AuraEnabled
    public static ScoringObject getPCO6Data(String oppID, String stageId){
        List<Application_Scoring__c> appScore = new ApplicationScoringSelector().selectByOpportunityId(oppID, stageId);
        //mock screen doesnt have any fields for PCO 6 as of now, will change the fields after confirmation from SA/BA
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

    /**
     * @author Himanshu : 20210219
     * @description getPCO7Data adding this method to return output fields for PCO7
     *
     * @param oppID (String): oppID
     * @param stageId (String): stageId
     * @return List<Application_Scoring__c>: Return description
     */
    @AuraEnabled
    public static  List<Application_Scoring__c> getPCO7Data(String oppID, String stageId){
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        Opportunity opp = [select Id from Opportunity where Id = :oppID];
        List<Application_Scoring__c> appScore = [SELECT Id, stage__c, SYST_Decision__c,SYST_Decision_Date__c
                                                 from Application_Scoring__c 
                                                 where Application_Number__c=:application.Id  and stage__c= :stageId];

        if(appScore?.size() > 0) {
            return appScore;
        }
        return null;
    }

    /**
     * @Author Tinashe M Shoko
     * @Date 14-Apr-2021
     * @WorkItem - W-008704 Reprocess Lower Limit
     * @description getChequeAndOverdraft
     *
     * @param oppId (String): oppId
     * @return Application_Product__c: Return description
     */
    @AuraEnabled
    public static Application_Product__c getChequeAndOverdraft(String oppId) {
        Application_Product__c rtnRec = new Application_Product__c();
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        if(appPrdList!=null){ 
        for(Application_Product__c output : appPrdList) {
            if(output.Application_Product_Parent__c != null) {
                rtnRec = output;
            }
        }
    }
        return rtnRec;
    }
     
    /**
    * @description @WorkItem - W-008704 Reprocess Lower Limit
    * We want to be able to resubmit to PCO so we need set the Reprocessing__c
     * We also need to delete the Application_Scoring__c related records
    * @author  Tinashe M Shoko | 2021-06-12 
    * @param oppId 
    * @param lowerLimit 
    **/
    @AuraEnabled
    public static void updateOpportunity(String oppId, Double lowerLimit){
        try {
            Opportunity opp = [select Id, Reprocessing__c from Opportunity where Id = :oppId];
            opp.Reprocessing__c = true;
            update opp;
            List<Application_Scoring__c> listToDel = [Select id, Stage__c from Application_Scoring__c where Application_Number__r.Opportunity__c =:oppId];
            if (!listToDel.isEmpty() && listToDel.size() > 0 && listToDel != null) {
                delete listToDel;
            }
            /*List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
            if (!appPrdList.isEmpty() && appPrdList.size() > 0 && appPrdList != null) {
                appPrdList[0].Current_Overdraft_Limit__c = lowerLimit;
            	update appPrdList[0];
            }*/
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description makePCOCall description
     *
     * @param oppId (String): oppId
     * @return String: Return description
     */
    @AuraEnabled
    public static String makePCOCall(String oppId){
        try{
            // submit to PowerCurve Stage 01
            if (!Test.isRunningTest()){
                return PowerCurveController.pcoStageHandler(oppId, '01', false);
            } else {
                return 'Success';
            }
        }
        catch (Exception e) {
            system.debug('caught an exception somewhere ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}