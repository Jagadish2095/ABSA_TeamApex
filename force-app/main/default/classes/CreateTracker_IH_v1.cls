/**
 * Integration Handler for Create Tracker Entry Compliance
 * @author Tshego Lesejane
 * @author Masimba Chingwende
 * @created 2019-01-05
 */
public class CreateTracker_IH_v1 {

    /** Action method which synchronously calls the create tracker operation with specified parameters
     ** @param channel
     *  @param application
     *  @param trace, 
     *	@param willNo
     *  @param tstatus
     *  @param date
     *  @param time
     *  @param userId
     *  @param sstatus
     *  @param statCd
     *	@param filLoc
     *  @param prevId
     *  @param action
     *  @param comments
     *  @param branchCd
	 */    
    public static CreateTracker_Resp_IB_v1 createTracker(String channel, String application, String trace, 
    			String willNo, String tstatus, String dateCreated, String timeCreated, String userId, String sstatus, String statCd, 
    			String filLoc, String prevId, String action, String comments, String branchCd) {         
    	CreateTracker_Req_IB_v1 request = CreateTracker_IU_v1.mapRequestFields(channel, application, trace, 
			willNo, tstatus, dateCreated, timeCreated, userId, sstatus, statCd, 
			filLoc, prevId, action, comments, branchCd);  
        Integration_API__c api = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_TRACKER_RECORD);        
		Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = new Map<String, String>();
		headers.put(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        headers.put(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
        CreateTracker_Resp_IB_v1 response = (CreateTracker_Resp_IB_v1) RestClientUtils.invoke(service.Method__c.toUpperCase(), api.Base_URL__c + service.URL_Extension__c, 
            														request, null, null, null, headers, null, null, CreateTracker_Resp_IB_v1.class, null, false);     
        return response;
    }
}