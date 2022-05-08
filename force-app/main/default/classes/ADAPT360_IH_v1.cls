public class ADAPT360_IH_v1 {

    public static ADAPT360_Resp_IB_v1 retrieveClientDetails(String queryTypeP, String regIdP, String viewP, Boolean hideMetaP){
        Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> adapt360Map = retrieveClientDetailsMap(queryTypeP, regIdP, viewP, hideMetaP);
        if(adapt360Map.values().size() > 0){
            insert adapt360Map.values()[0];
        }
        List<ADAPT360_Resp_IB_v1> beanList = new List<ADAPT360_Resp_IB_v1>(adapt360Map.keySet());

        return beanList[0];
    }

    /* Action method which synchronously calls the Get Client Details operation with specified parameters
** queryTypeP: Type of query, valids ones are: cif, passport, identityDocument and suid
** regIdP: Registration number, ID number, passport number etc depending on the query type
** viewP: Predefined views of the client information. If it is null or empty "BASIC_VIEW" will be used
** hideMetaP: Boolean flag, if set to true then no extra meta data will be shown. Default is false*/

    public static Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> retrieveClientDetailsMap(String queryTypeP, String regIdP, String viewP, Boolean hideMetaP){

        Sys_Log_Integration__c log;
        ADAPT360_Resp_IB_v1 clientDetailsRespBean;
        Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> adapt360Map = new Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c>();
        try{
            String queryString='';
            // Builds the query strings based on the parameters passed to the method
            if (queryTypeP != '') queryString = queryString + '?queryType=' + queryTypeP;
            if (regIdP != '') queryString = queryString + (queryString=='' ? '?' : '&') + 'regId=' + EncodingUtil.urlEncode(regIdP, 'UTF-8');
            if (viewP != '') queryString = queryString + (queryString=='' ? '?' : '&') + 'view=' + viewP;
            queryString = queryString + (queryString=='' ? '?' : '&') + 'hideMeta=' + (hideMetaP ? 'true' : 'false');

            System.debug('ADAPT 360 Query String: ' + queryString);

            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, Sys_Utilities_General.getEnvironment(), StringConstants.ADAPT360_STRING);

            //Check if Integration Settings were found
            if(integrationSettings != null){
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], '');

                String endpoint = request.getEndpoint() + QueryString.replace(' ','%20');
                request.setEndpoint(endpoint);

                log = SystemLogger.createRequestIntegrationLog(queryString, StringConstants.METHOD_ADAPT360_RETRIEVE_CLIENT_DETAILS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                System.debug('request endpoint: ' + request.getEndpoint());
                System.debug('response body: ' + response.getBody());
                if(response.getStatusCode() == 200){

                    clientDetailsRespBean = ADAPT360_IU_v1.mapResponseFields(response);

                    if(clientDetailsRespBean.statusCode == 200){
                        log = SystemLogger.mapResponseFields(log, clientDetailsRespBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        log = SystemLogger.mapResponseFields(log, clientDetailsRespBean.statusCode, StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                }else{
                    //Response was not 200
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    clientDetailsRespBean = ADAPT360_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER_ADAPT360 + '. Service: ' +  StringConstants.ADAPT360_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                clientDetailsRespBean = ADAPT360_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ADAPT360_RETRIEVE_CLIENT_DETAILS, StringConstants.ADAPT360_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }

        }catch(Exception e){
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            clientDetailsRespBean = ADAPT360_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            // PJAIN: 20201103: Added below if condition
            if (log != null) {
                log = SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            } else {
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ADAPT360_RETRIEVE_CLIENT_DETAILS, StringConstants.ADAPT360_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            }
        }
        System.debug('ADAPT360 Bean: ' + clientDetailsRespBean);
        adapt360Map.put(clientDetailsRespBean, log);
        return adapt360Map;
    }


    public static ADAPT360GetJointParticipant_Resp_IB_v1 retrieveClientDetails(String queryTypeP, String regIdP, String viewP, String clientCodeP){

        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c> ();

        Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> adapt360BeanMap = retrieveClientDetailsMap(queryTypeP, regIdP, viewP, true);

        for(ADAPT360_Resp_IB_v1 bean360 : adapt360BeanMap.keySet()){

            logList.add(adapt360BeanMap.get(bean360));

            if(bean360.statusCode == 200){

                GetJointParticipant_Resp_IB_v1 jointParticipantBean =  GetJointParticipant_IH_v1.getJointParticipant(clientCodeP);

                if(jointParticipantBean.statusCode == 200){

                    try{

                        responseBean = ADAPT360_IU_v1.combinedBeanFields(bean360, jointParticipantBean);
                        if(responseBean == null){
                            responseBean = ADAPT360_IU_v1.mapFailedResponseFieldsCombinedBean(500, StringConstants.STATUS_CODE_500, 'Error while combining ADAPT360 and GetJointParticipant beans');
                        }
                    }catch(Exception e){
                        String message = e.getMessage() + '. ' + e.getStackTraceString();
                        System.debug(message);
                        Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ADAPT360_RETRIEVE_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.STATUS_CODE_500, message);
                        logList.add(log);
                        responseBean = ADAPT360_IU_v1.mapFailedResponseFieldsCombinedBean(500, StringConstants.STATUS_CODE_500, message);

                    }//end of try-catch

                }else{
                    //GetJointParticipant failed
                    responseBean = ADAPT360_IU_v1.mapFailedResponseFieldsCombinedBean(jointParticipantBean.statusCode, jointParticipantBean.status, jointParticipantBean.message);
                }//end of GetJointParticipant if-else

            }else{
                //ADAPT360 failed
                responseBean = ADAPT360_IU_v1.mapFailedResponseFieldsCombinedBean(bean360.statusCode, bean360.status, bean360.message);
            }//end of Adapt360 if-else

        }//end of loop
        if(logList != null && logList.size() > 0){
            insert logList;
        }
        return responseBean;
    }//end of retrieveClientDetails method for ADAPT360GetJointParticipant_Resp_IB_v1

}