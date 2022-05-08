/**
* Descripton: Apex Handler class for ESP Onboarding service
* Test Class Name: ESPOnboarding_IH_v1_Test
* @author  Manoj Danthala : Absa
* @since   2019-02-27
*
**/
public class ESPOnboarding_IH_v1{
    
    /* Makes the callout to ESP service 
    * @param: List of Leads
    * @return: ESPOnboarding_Resp_IB_v1 bean object
    * */
    public static void callToESPOnboarding(Id opportunityId){
        ESPOnboarding_Resp_IB_v1 espServiceRespBean;
        Sys_Log_Integration__c log;
        Set<Id> financialProductIdSet = new Set<Id>();
        List<Financial_Product__c> financialProductList = new List<Financial_Product__c>();
        try{
            String queryString = '';
            
            List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
            List<Lead> LeadList = new LeadsSelector().selectByLeadId(opportunityList[0].Lead_Number__c);
            if(!LeadList.isEmpty()){
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.ESP_STRING);
                System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
                //Check if integration settings were found
                
                if(integrationSettings!=null){
                    //Query Objects
                    financialProductIdSet.add(LeadList[0].Financial_Product__c);
                    financialProductList = new FinancialProductsSelector().selectById(financialProductIdSet);
                    
                    ESPOnboarding_Req_IB_v1 requestBean = ESPOnboarding_IU_v1.mapRequestdFields(LeadList[0],financialProductList[0]);
                    queryString = (JSON.serialize(requestBean)).replace('Group_x','Group');
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],queryString);
                    System.debug('REQUEST'+request);    //To be removed
                    System.debug('REQUEST BODY: ' + request.getBody()); //To be removed
    
                    log = SystemLogger.createRequestIntegrationLog(queryString, StringConstants.METHOD_ESP_GET_ESP_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
    
                    //Make API Callout
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    System.debug('RESPONSE BODY: ' + response.getBody());
                    System.debug('RESPONSE getStatusCode(): ' + response.getStatusCode());
                    if(response.getStatusCode() == 200){
                        //Success Response
                        System.debug('Status Code 200 - SUCCESS');    
                        espServiceRespBean = ESPOnboarding_IU_v1.mapResponseFields(response);
                        if(espServiceRespBean.StatusCode == 0){
                            log = SystemLogger.mapResponseFields(log, espServiceRespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                            opportunityList[0].ESP_Response__c = 'SUCCESS';
                            opportunityList[0].Is_Sent_To_ESP__c = true;
                            opportunityList[0].ESP_Sent_Time__c = System.Now();
                        }else{
                            log = SystemLogger.mapResponseFields(log, espServiceRespBean.StatusCode, StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                            opportunityList[0].ESP_Response__c = 'FAILURE - '+espServiceRespBean.StatusMessage;
                        }
                        
                    } else{
                        System.debug('Status Code NOT 200 - FAILURE');    
                        //Response was not 0
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        espServiceRespBean = ESPOnboarding_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                        opportunityList[0].ESP_Response__c = 'FAILURE - '+espServiceRespBean.StatusMessage;
                    }
                    
                } else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    espServiceRespBean = ESPOnboarding_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ESP_GET_ESP_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug(message);
                    opportunityList[0].ESP_Response__c = 'FAILURE - '+espServiceRespBean.StatusMessage;
                }
                
                if(!opportunityList.isEmpty()){
                    update opportunityList;
                }
                
            }
            
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            espServiceRespBean = ESPOnboarding_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ESP_GET_ESP_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null){
            insert log;
        }
    }       
}