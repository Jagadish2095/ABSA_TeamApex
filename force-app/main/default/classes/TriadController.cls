/**
 * @description       : Controller for loading Triad Data
 * @author            : Almas Aleem: Absa
 * @last modified on  : 2021-07-14
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   2020-09-15      Initial Version
**/

public class TriadController {
	
	/**
	* @description return List of Application Triad for application
	* @author  | 2021-06-12 
	* @param clientCode 
	* @param ApplicationId 
	* @param isMainApplicant 
	* @param clientName 
	**/
	@future(callout = true)
	public static void getApplicationTriadFromService(String clientCode, Id ApplicationId, Boolean isMainApplicant, String clientName) {
		GetTriadsController.getTriadsFromService(clientCode, ApplicationId, isMainApplicant, clientName);
	}

	/**
	* @description get triads
	* @author  | 2021-06-12 
	* @param oppID 
	* @return Application__c 
	**/
	@AuraEnabled
	public static Application__c getApplicationTriad(Id oppID) {
		List<Application_Triad__c> TriadList;
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID); //select by opp
		TriadList = new ApplicationTriadsSelector().getTriadsByApplicationID(app.Id);

		if (!TriadList.isEmpty() && TriadList.size() > 0) {
			return app;
		}
		else {
			List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
			for (Application_Profile__c appProfile : appProfileList) {
                if(!Test.isRunningTest()){
                  getApplicationTriadFromService(appProfile?.Client_CIF_Code__c, app.Id, appProfile.Is_Main_Applicant__c, appProfile?.Client_Name__c);
                }
			}
		}
		return app;
	}
}