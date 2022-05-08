/**
* @description Apex/Integration Handler class for XDSGetQuestions service
* Test Class Name: XDSGetQuestions_IH_v1_Test
* @author  Madhava Palla : Absa
* @since   2019-08-21
* @updated Koketso Mpshane 2021-09-29
*/
public class XDSGetQuestions_IH_v1 {

    /**
    * @description Makes the callout to XDSGetQuestions service 
    * @param accountId
    * @return Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> (XDSGetQuestions_Resp_IB_v1 bean object');
    */
    public static Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> callToXDSGetQuetionsService(Id accountId){
        XDSGetQuetions_Resp_IB_v1 xdsGetQuestionsServiceResponseBean;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        try{
            String jsonString = '';
            Set<Id> accIdSet = new Set<Id>();
            accIdSet.add(accountId);
            List<Account> accRec =new AccountsSelector().selectById(accIdSet,1);
            If(!accRec.isEmpty()){
                //If(accRec[0].ID_Type__pc !='' && accRec[0].ID_Type__pc =='SA Identity Document'){ Koketso - the if statement will be implemented for XDS v2.3
                    Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.XDS_GetQuestions);
                    if(integrationSettings != null){
                        //Map Request Fields
                        XDSGetQuetions_Req_IB_v1 getXDSQuestionsRequest = XDSGetQuetions_IU_v1.mapRequestFields(accRec[0]);
                        jsonString = (JSON.serialize(getXDSQuestionsRequest));
                        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                        log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                        //Make API Callout
                        HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                        if(response.getStatusCode() == 200){
                            //Success Response
                            ///Map Response Fields
                            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapResponseFields(response,accRec[0]);
                            log = SystemLogger.mapResponseFields(log, xdsGetQuestionsServiceResponseBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                        } else{
                            //Response was not 0
                            log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());

                        }
                    }else{
                        //No Integration Settings Found
                        String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.XDS_GetQuestions + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                        log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.XDS_GetQuestions, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                        xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);

                    }
                /*}else{

                    // If ID type is not SA id.
                    String message = StringConstants.ERROR_MSG_XDS_NO_ID_FOUND;
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.XDS_GetQuestions, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);

                    // throw AuraEnabledException('Error ::'+message);
                }*/
            }
        }catch(Exception e){
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.XDS_GetQuestions, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        if (log != null) {
            logList.add(log);
        }

        responseMap.put(xdsGetQuestionsServiceResponseBean, logList);
        return responseMap;
    }

    /**
     * @description added by srikanth as part of Power of attornery verification
     * @param getXDSQuestionsRequest
     * @return Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>>
     */
    public static Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> getToXDSGetQuetionsService(XDSGetQuetions_Req_IB_v1 getXDSQuestionsRequest){
        XDSGetQuetions_Resp_IB_v1 xdsGetQuestionsServiceResponseBean;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        try{
            String jsonString = '';
            Set<Id> accIdSet = new Set<Id>();
            //accIdSet.add(accountId);
            //List<Account> accRec =new AccountsSelector().selectById(accIdSet,1);
          //  If(!accRec.isEmpty()){

                    Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.XDS_GetQuestions);
                    if(integrationSettings != null){
                        //Map Request Fields
                       // XDSGetQuetions_Req_IB_v1 getXDSQuestionsRequest = XDSGetQuetions_IU_v1.mapRequestFields(accRec[0]);
                        jsonString = (JSON.serialize(getXDSQuestionsRequest));
                        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                        log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                        //Make API Callout
                        HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                        if(response.getStatusCode() == 200){
                            //Success Response
                            ///Map Response Fields
                            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapResponseFields(response);
                            log = SystemLogger.mapResponseFields(log, xdsGetQuestionsServiceResponseBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());

                        } else{
                            //Response was not 0
                            log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());

                        }

                    }else{
                        //No Integration Settings Found
                        String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.XDS_GetQuestions + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                        log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.XDS_GetQuestions, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                        xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    }

        }catch(Exception e){
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            xdsGetQuestionsServiceResponseBean = XDSGetQuetions_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_XDS_GET_QUESTIONS_STATUS, StringConstants.XDS_GetQuestions, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        if (log != null) {
            logList.add(log);
        }
        responseMap.put(xdsGetQuestionsServiceResponseBean, logList);
        return responseMap;
    }

}