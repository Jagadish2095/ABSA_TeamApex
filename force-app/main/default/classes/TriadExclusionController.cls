/**
 * @description Controller for loading Triad Exlusion Data
 * @author  Almas Aleem: Absa
 * @version v1.0
 * @since   2020-09-14
 *
 */
public class TriadExclusionController {
    /**
    * @description
    * @author Almas.Aleem@absa.africa | 2020-09-14
    * @param appID
    * @return List<Application_Triad__c>
    **/
    @auraEnabled
    public static List<Application_Triad__c> getTriadDataList(Id appID){
        List<Application_Triad__c> TriadList ;
        //Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID); //select by opp
        TriadList = new ApplicationTriadsSelector().getTriadsByApplicationID(appID);
        if(!TriadList.isEmpty() && TriadList.size()>0 ){
            return TriadList;
        }

        return TriadList;
    }
}