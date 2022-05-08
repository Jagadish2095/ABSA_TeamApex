/*
* Integration Handler for Get Client Details CIF
* @author Jason Quevauvilliers
* @created 2019-07-19
*/
public class GetClientDetailsByIdCIF_IH_v1 {

    public static final String GET_CLIENT_DETAILS_BY_ID_SERVICE = 'Get Client Details By Id CIF';
    public static final String GET_CLIENT_DETAILS_BY_ID_METHOD = 'GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap';
    
    /* Method to get client details for CIF - Inserts Logs
	* @Param: String Id Number
	* @Param: String Document Type
	* @Param: String Site Code
	* @Return: GetClientDetailsByIdCIF_Resp_IB_v1 Response Bean
	* */
    public static GetClientDetailsByIdCIF_Resp_IB_v1 getClientDetails(String idNumberP, String idDocTypeP, String siteCodeP){
        
        return getClientDetails(idNumberP, idDocTypeP, siteCodeP, true);
    }
    
    /* Method to get client details for CIF - Ability to Insert Logs or Not
	* @Param: String Id Number
	* @Param: String Document Type
	* @Param: String Site Code
	* @Param: Boolean Insert Logs or not
	* @Return: GetClientDetailsByIdCIF_Resp_IB_v1 Response Bean
	* */
    public static GetClientDetailsByIdCIF_Resp_IB_v1 getClientDetails(String idNumberP, String idDocTypeP, String siteCodeP, Boolean insertLogsP){
        
        //Call getClientDetailsMap
        Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> responseMap = getClientDetailsMap(idNumberP, idDocTypeP, siteCodeP);
        
        //Check for logs and insert if specified 
        if(responseMap.values().size() > 0){
            
            if(responseMap.values()[0] != null && insertLogsP){
                //Insert Logs
                insert responseMap.values()[0];
            }
        }
        //Get Response Bean from Map
        List<GetClientDetailsByIdCIF_Resp_IB_v1> responseList = new List<GetClientDetailsByIdCIF_Resp_IB_v1>(responseMap.keySet());
        
        return responseList[0];
    }
    
    /* Method to get client details for CIF - Returns Map of Bean to Log for Orchestration Methods
	* @Param: String Id Number
	* @Param: String Document Type
	* @Param: String Site Code
	* @Return: Map of GetClientDetailsByIdCIF_Resp_IB_v1 Response Bean to Sys_Log_Integration__c
	* */
    public static Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> getClientDetailsMap(String idNumberP, String idDocTypeP, String siteCodeP){
        
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> responseMap = new Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c>();
        
        try{
            //Check if Parameters are NULL
            if(idNumberP != null && idDocTypeP != null && siteCodeP != null){
                
                //Get Integration Settings
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_CLIENT_DETAILS_BY_ID_SERVICE);
                
                //Check If Integration Settings were found
                if(integrationSettings != null){
                    
                    //Map Request Fields
                    GetClientDetailsByIdCIF_Req_IB_v1 requestBean = GetClientDetailsByIdCIF_IU_v1.mapRequestFields(idNumberP, idDocTypeP, siteCodeP);
                    
                    //Serialize Bean into JSON String
                    String jsonString = requestBean.serialize(requestBean);
                    
                    //Create Request
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    
                    //Create Request Log
                    log  = SystemLogger.createRequestIntegrationLog(request.getBody(), GET_CLIENT_DETAILS_BY_ID_METHOD, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    System.debug('Get Client Details By Id Response: ' + response.getStatusCode() + ' ' + response.getBody());
                    
                    //Get status of the callout for logging
                    String calloutStatus = response.getStatusCode() == 200 ? StringConstants.INTEGRATION_STATUS_SUCCESS : StringConstants.INTEGRATION_STATUS_FAILED;
                    
                    //Map Response Log
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), calloutStatus, response.getBody());
                    
                    //Map Response Bean
                    responseBean = GetClientDetailsByIdCIF_IU_v1.mapResponseFields(response);
                    
                }else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  GET_CLIENT_DETAILS_BY_ID_SERVICE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    log = SystemLogger.createInternalIntegrationLog(GET_CLIENT_DETAILS_BY_ID_METHOD, GET_CLIENT_DETAILS_BY_ID_SERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    responseBean = GetClientDetailsByIdCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message); 
                    System.debug(message);
                }
            }else{
                //Parameters are NULL
                String message = 'Error: The following Parameter(s) are Null:';
                message += idNumberP == null ? ' Id Number,' : '';
                message += idDocTypeP == null ? ' Id Doc Type,' : '';
                message += siteCodeP == null ? ' Site Code,' : '';
                message = message.removeEnd(',');
                log = SystemLogger.createInternalIntegrationLog(GET_CLIENT_DETAILS_BY_ID_METHOD, GET_CLIENT_DETAILS_BY_ID_SERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = GetClientDetailsByIdCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                System.debug(message);
            }
        }catch(Exception e){
            //Exception response bean and log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(GET_CLIENT_DETAILS_BY_ID_METHOD, GET_CLIENT_DETAILS_BY_ID_SERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = GetClientDetailsByIdCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }
        responseMap.put(responseBean, log);
        System.debug(responseBean);
        
        return responseMap;
    }

    /*
    * Integration Handler for Get Client Details CIF v cigetclientdetailsbyidnov2
    * @author Paul Jhon du Randt Added new version 
    * @created 2020-11-17
    */
     public static final String INTEGRATION_SERVICE_NAME = 'cigetclientdetailsbyidnov2';
        
        public static  GetClientDetailsByIdCIF_Resp_IB_v1 GetCIFCodebyId(String idNumber,String docType, String ClientGroup, String ClientType ,String siteCode){

            GetClientDetailsByIdCIF_Req_IB_v1 requestBean = new GetClientDetailsByIdCIF_Req_IB_v1();
            requestBean.idNbr = idNumber;
            requestBean.inpCifClntGroup = ClientGroup;
            requestBean.inpCifClntType = docType;
            requestBean.maxRecsToRtrv = '1';
            requestBean.startAfterSearchPos = '';
            requestBean.siteCode = siteCode;
            GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = (GetClientDetailsByIdCIF_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  GetClientDetailsByIdCIF_Resp_IB_v1.class);
            return responseBean;
        }
    
}