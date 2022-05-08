/**
 * @description Retrieves will details from the wills system.
 */
public class GetWillDetails_IH_v1 {
    
    public static GetWillDetails_Resp_IB_v1 getWillDetails( String willNumber ) {
		return getWillDetails( willNumber, false);
    }
    
    public static GetWillDetails_Resp_IB_v1 getWillDetails( String willNumber , Boolean log) {                
        
        Integration_API__c api = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_WILL_DETAILS);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = new Map<String, String>();
		headers.put(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        headers.put(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
        GetWillDetails_Resp_IB_v1 response = (GetWillDetails_Resp_IB_v1) RestClientUtils.invoke(service.Method__c.toUpperCase(), api.Base_URL__c + service.URL_Extension__c + willNumber, 
            														null, null, null, null, headers, null, null, GetWillDetails_Resp_IB_v1.class, null, log);     
        return response;
    }
}