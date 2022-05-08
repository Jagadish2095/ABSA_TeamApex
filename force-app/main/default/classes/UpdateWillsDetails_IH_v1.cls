/**
* @description Integration Handler for Update Wills Details
*
* @author Himanshu Nimje
* @author Masimba Chingwende
* @created 2018-12-10
*/

public class UpdateWillsDetails_IH_v1 {
    
    public static UpdateWillsDetails_Resp_IB_v1 updateWillsDetails(UpdateWillsDetails_Req_IB_v1 request) {            
		
		Integration_API__c api = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.UPDATE_WILL_DETAIL);
        Integration_Service__c service = api.Integration_Services__r.get(0);
        Map<String, String> headers = new Map<String, String>();
		headers.put(StringConstants.X_IBM_CLIENT_ID_STRING, api.Client_ID__c);
        headers.put(StringConstants.X_IBM_CLIENT_SECRET_STRING, api.Client_Secret__c);
        UpdateWillsDetails_Resp_IB_v1 response = (UpdateWillsDetails_Resp_IB_v1) RestClientUtils.invoke(service.Method__c.toUpperCase(), api.Base_URL__c + service.URL_Extension__c, 
            														request, null, null, null, headers, null, null, UpdateWillsDetails_Resp_IB_v1.class, null, false);     
        return response;
    }  
    
}