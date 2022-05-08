/**
 * @description Controller Class for TriadPreAdviced Component
 * @author  Englarmerdge Mongwe
 * @since   2020-12-06
 *
*/
public class TriadPreAdvicedController {
    /**
    * @description method to getApplicationTriadPreAdviced
    * @author englarmerdge.mongwe@absa.africa | 2020-12-06
    * @param oppID
    * @return List<Application_Triad__c>
    **/
    @AuraEnabled
    public static List<Application_Triad__c> getApplicationTriadPreAdviced(Id oppID) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Triad__c> TriadList = new ApplicationTriadsSelector().getTriadsByApplicationID(app.Id);

        if(TriadList != null && TriadList.size() > 0){
            return TriadList;
        }
        return null;
    }
}