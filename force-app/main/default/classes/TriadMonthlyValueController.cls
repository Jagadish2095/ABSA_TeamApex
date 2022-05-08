/**
 * @description Controller for loading Triad Monthly Value
 * @author  Almas Aleem: Absa
 * @version v1.0
 * @since   2020-09-14
 *
 */

public class TriadMonthlyValueController {
    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-14
     * @param appId
     * @return List<Application_Triad_Detail__c>
    **/
    @AuraEnabled
    public static List<Application_Triad_Detail__c> getMonthlyValues(Id appId){

        //Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Application_Triad__c appTriad = new ApplicationTriadsSelector().getTriadsForMainApplicant(appId);
        List<Application_Triad_Detail__c> monthlyTriads ;

        if(appTriad != null){
            monthlyTriads = new ApplicationTriadDetailsSelector().getDetailByApplicationTriadID(appTriad.Id);
        }

        return monthlyTriads;
    }
}