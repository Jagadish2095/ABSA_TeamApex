/**
* Integration Handler for Update Lead Status in Siebel function
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-08-22
* @Updated by Danie Booysen
* @Updated Date 2018-10-11
*/

public class UpdateLeadStatusSiebel_IH_v1 {
    
    /* POST Callout to Siebel to update Lead status
    * @param: Opportunity Id
    * @param: Opportunity closed Reason (Won/Lost)
    * @param: externalId
    * @param: Opportunity product
    * @param: Opportunity sales stage name
    * @return: Response JSON or Error Message*/
    
    public static UpdateLeadStatusSiebel_Resp_IB_v1 updateLeadStatusSiebel(Id opportunityIdP, String reasonWonLostP, String externalIdP, String opportunityProductP, String saleStageNameP){
        
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponseBean;
        Sys_Log_Integration__c log;
        
        try{
            
            List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(opportunityIdP, 1);
            //Check if Opportunity was found
            if(opportunityList.size() == 1){
                
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.UPDATE_LEAD_STATUS_SIEBEL);
                
                //Check if Integration Settings was found
                if(integrationSettings != null){
                    
                    String reasonWonLostTranslated;
                    //Check if reasonWonLost is an empty string
                    if(reasonWonLostP == ''){
                        
                        reasonWonLostTranslated = reasonWonLostP;
                    }else{
                        
                        //Map salesforce values to Siebel values for stage name
                        reasonWonLostTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.SIEBEL_STRING, StringConstants.FIELD_STAGE_NAME_STRING, reasonWonLostP, StringConstants.OUTBOUND_RECORD_TYPE);
                    }
                    //Map salesforce values to Siebel values for opportunity product
                    String salesMethod = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.SIEBEL_STRING, StringConstants.FIELD_PRODUCT_NAME_STRING, opportunityProductP, StringConstants.OUTBOUND_RECORD_TYPE);
                    
                    //Check if stageName was successfuly mapped to a Siebel value
                    if(reasonWonLostTranslated != null && salesMethod != null){
                        
                        //Create Request Bean class
                        UpdateLeadStatusSiebel_Req_IB_v1 siebelUpdateLeadStatusRequest = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelRequest(externalIdP, reasonWonLostTranslated, salesMethod, saleStageNameP);
                        //Serialize Bean to JSON String
                        String jsonString = JSON.serialize( siebelUpdateLeadStatusRequest, true );
                        
                        //Call mapFieldsSiebelHttpRequest method to build the Request
                        //Call serviceCallout method to Send the Request
                        HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                        
                        //Check Response Status Code
                        //Set Field on Opportunity and return serialized instance of a bean
                        if (response.getStatusCode() != 200){
                            
                            opportunityList[0].External_Call_Outcome__c = StringConstants.INTEGRATION_STATUS_UNSUCCESSFUL;
                            System.debug(StringConstants.ERROR_MSG_UNEXPECTED_STATUS_CODE + response.getStatusCode() + ' ' + response.getStatus());
                            
                        }else{
                            
                            opportunityList[0].External_Call_Outcome__c = StringConstants.INTEGRATION_STATUS_SUCCESSFUL;
                        }
                        
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                        siebelResponseBean = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelResponse(response.getStatusCode(), response.getStatus(), response.getBody());
                        
                    }else{
                        String message = '';
                        if(reasonWonLostTranslated == null){
                            message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_SIEBEL_STAGE_NAME_VALUE + reasonWonLostP + '. ';
                        }
                        if(salesMethod == null){
                            message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_SIEBEL_OPP_PRODUCT_VALUE + opportunityProductP + '. ';
                        }
                        
                        opportunityList[0].External_Call_Outcome__c = StringConstants.INTEGRATION_STATUS_UNSUCCESSFUL;
                        log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_LEAD_STATUS_SIEBEL, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                        siebelResponseBean = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelResponse(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                        
                    }
                    update opportunityList[0];
                }else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.UPDATE_LEAD_STATUS_SIEBEL + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_LEAD_STATUS_SIEBEL, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    siebelResponseBean = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelResponse(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                }
            }else{
                //No Opportunity Found
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_LEAD_STATUS_SIEBEL, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, StringConstants.ERROR_MSG_UNABLE_TO_FIND_OPP + opportunityIdP);
                siebelResponseBean = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelResponse(500, StringConstants.ERROR_MSG_UNABLE_TO_FIND_OPP, opportunityIdP);
            }
            
        }catch(Exception e){
            
            //return bad response with an unhandled exception
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_LEAD_STATUS_SIEBEL, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            siebelResponseBean = UpdateLeadStatusSiebel_IU_v1.mapFieldsUpdateLeadStatusSiebelResponse(500, StringConstants.UNHANDLED_EXCEPTION_STATUS, description);
            
        }
        if(log != null){
            insert log;
        }
        return siebelResponseBean;
    }
}