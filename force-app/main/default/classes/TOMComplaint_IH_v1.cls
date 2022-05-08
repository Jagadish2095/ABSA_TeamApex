/**
* Descripton: Apex/Integration Handler class for TOM Complaint service
* Test Class Name: TOMComplaint_IH_v1
* @author  Anka Ganta : Absa
* @since   2019-08-13
*
**/
public class TOMComplaint_IH_v1{
    
    /* Makes the callout to Tom Complaint service 
    * @param: List of Cases
    * @return: TOMComplaint_Resp_IB_v1 bean object
    * */
    @future(callout = true)
    public static void callToTOMComplaint(Id caseId){
        TOMComplaint_Resp_IB_v1 tomServiceRespBean;
        Sys_Log_Integration__c log;
        
        try{
            String queryString = '';
            
            List<Case> caseList = new CasesSelector().selectByIdWithComplaintInfoTOM(caseId,1);
            
            if(!caseList.isEmpty() && caseList.size()>0){
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.Jitterbit2, Sys_Utilities_General.getEnvironment(), StringConstants.TOM_STRING);
                System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
               
                //Check if integration settings were found
                   
                    
                    TOMComplaint_Req_IB_v1 requestBean = TOMComplaint_IU_v1.mapRequestFields(caseList[0]);
                    queryString = (JSON.serialize(requestBean));
                    
                     System.debug('requestBean+++'+requestBean);//To be removed
                  
                   HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],queryString);
                    System.debug('REQUEST BODY'+request.getBody());    //To be removed
    
                    log = SystemLogger.createRequestIntegrationLog(queryString, StringConstants.METHOD_TOM_GET_TOM_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    System.debug('log'+queryString + '' +request.getEndpoint());
    
                    //Make API Callout
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    System.debug('RESPONSE BODY: ' + response.getBody());//To be removed
        
                    if(response.getStatusCode() == 200){
                        //Success Response
                        System.debug('Status Code 200 - SUCCESS');//To be removed
                       
                        tomServiceRespBean = TOMComplaint_IU_v1.mapResponseFields(response,caseList[0]);
                        System.debug('tomServiceRespBean+++'+tomServiceRespBean);//To be removed
                        
                            log = SystemLogger.mapResponseFields(log, tomServiceRespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                            
                        
                    } else{
                        System.debug('Status Code NOT 200 - FAILURE');   //To be removed 
                        //Response was not 0
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        tomServiceRespBean = TOMComplaint_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                        caseList[0].TOM_Response__c = 'FAILURE - '+tomServiceRespBean.StatusMessage;
                    }
                    
                    update caseList;
                
            } else{
                    //No case record Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' +  StringConstants.TOM_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    tomServiceRespBean = TOMComplaint_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_TOM_GET_TOM_STATUS, StringConstants.TOM_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug(message);
                    //caseList[0].TOM_Response__c = 'FAILURE - '+tomServiceRespBean.StatusMessage;
                }
             
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            system.debug('**message****'+message+'*******line number***'+e.getLineNumber());
            tomServiceRespBean = TOMComplaint_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_TOM_GET_TOM_STATUS, StringConstants.TOM_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null){
            insert log;
        }
    }       
}