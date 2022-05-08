/**
 * @description       : 
 * @author            : mohammedjunaid.usman@absa.africa
 * @last modified on  : 2021-10-18
 * @last modified by  : mohammedjunaid.usman@absa.africa
**/

public class CVDashboardRiskRating_IH_v1 {
    
    private static final string APINAME = 'Jitterbit2';
    private static final string riskRating_Path = 'Risk Rating service';
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-10-18 
    * @param accountP 
    * @return CASAPrimaryClientScreening_Resp_IB_v3 
    **/
    public static CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningBusinessAcc(Account accountP){
        CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningResponse;
        Sys_Log_Integration__c log;
        try{
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2);
            if(integrationSettings != null && accountP != null ){
                String countryOfIncorporation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
                String idTypeTranslated ;
                if(accountP.ID_Type__c != null) {
                    idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE); 
                } else {
                    idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE); 
                }
                
                String clientTypeGrpTranslated;
                if(accountP.Client_Group__c == 'Non Individual'){
                    clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);
                    //System.debug('====>'+clientTypeGrpTranslated);
                }
                else {
                    clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
                CASAPrimaryClientScreening_Req_IB_v3 casaPrimaryClientScreeningRequest;
                if(countryOfIncorporation != null){
                    casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v3.mapRequestFields(accountP,countryOfIncorporation,clientTypeGrpTranslated,idTypeTranslated);
                    String jsonString = JSON.serialize( casaPrimaryClientScreeningRequest, true );
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    //System.debug('request: ' + request.getBody());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);                    
                    //System.debug('response: ' + response.getBody());
                    if(response.getStatusCode() == 200){
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                    if(response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT){
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                    }else{
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapResponseFields(response);
                        
                    }
                }else{
                    String message = '';
                    if(countryOfIncorporation == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_INCORPORATION + accountP.Country_of_Incorporation__c + ' for Account: ' + accountP.Name +  '. ';
                    }
                    if(clientTypeGrpTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_CLIENT_GROUP + accountP.Client_Group__c + ' for Account: ' + accountP.Name +  '. ';
                    }
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    //System.debug('message: ' + message);
                    
                }
            }else{
                String message = '';
                if(integrationSettings == null){
                    message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND;
                }
                if(accountP == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT;
                }
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
        }catch(Exception e){
            //System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null){
            SystemLogger.insertLog(log);
        }
        return casaPrimaryClientScreeningResponse;
    }
    
     /**
     * @description 
     * @author mohammedjunaid.usman@absa.africa | 2021-10-18 
     * @param acc 
     * @return CVDashboardRiskRatingResponse_IB_v1 
     **/
     public static CVDashboardRiskRatingResponse_IB_v1 getRiskRatingService(Account acc){
        CVDashboardRiskRatingRequest_IB_v1 addRequest = CVDashboardRiskRating_IU_v1.mapRequestFields(acc);
        CVDashboardRiskRatingResponse_IB_v1 responseBean = (CVDashboardRiskRatingResponse_IB_v1) Sys_Utilities_Integration.integrationServiceCall(addRequest, null, riskRating_Path, CVDashboardRiskRatingResponse_IB_v1.class);
        return responseBean;
    }

    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-11-16 
    * @param accountP 
    * @param userIdP 
    * @return GetRiskProfileClient_Resp_IB_v2 
    **/
    public static GetRiskProfileClient_Resp_IB_v2 getRiskProfileClient(Account accountP,String userIdP){
        GetRiskProfileClient_Resp_IB_v2 riskProfileClientResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_RISK_PROFILE_CLIENT);
            
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            
            if(metaDataList.size() > 0 && accountP != null){
                
                String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, accountP.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String occupationCategoryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_CATEGORY_STRING, accountP.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                //if(occupationStatusTranslated != null && occupationCategoryTranslated != null && incomeSourceTranslated != null){
                if(integrationSettings != null){
                    
                    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
					//Map Fields
                    GetRiskProfileClient_Req_IB_v2 getRiskProfileClientRequest = GetRiskProfileClient_IU_v2.mapRequestFields(accountP,userIdP,oppLineItems);
                    
                    
                if(String.isBlank(getRiskProfileClientRequest.errorMessage)){
                                            
                        String jsonString = JSON.serialize( getRiskProfileClientRequest, true );
                        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                        //System.debug('request: ' + request.getBody());
                        log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_GET_RISK_PROFILE_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                        //Send Request
                        HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                        //System.debug('responseeeeeee: ' + response.getBody());
                        if(response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT){
                            
                            riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                        }else{
                            
                            ///Map Fields
                            response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                            riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapResponseFields(response);
                            //log = SystemLogger.mapResponseFields(log, riskProfileClientResponse.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, riskProfileClientResponse.getBody());
                        	//System.debug('riskProfileClientResponseeee: ' + riskProfileClientResponse);
                            //System.debug('===responseBean=====>'+riskProfileClientResponse.WQriskProfileClientV7Response.riskRating);
                            List<Account> accList = [SELECT id,Occupation_Status__pc,CIF__c,Occupation_Category__pc,Income_Source__pc,Registration_Number__c,Client_Group__c,CASA_Reference_Number__c,CASA_Screening_Date__c,CASA_Risk_Status__c,Country_of_Registration__c,Client_Type__c,ID_Type__c FROM Account WHERE Id =:accountP.Id];
                            /*if(accList.size() >0 && accList[0] != null){
                                accList[0].CASA_Risk_Status__c = riskProfileClientResponse.WQriskProfileClientV7Response.riskRating;
                                Update accList[0];
                            } */
                            log = SystemLogger.mapResponseFields(log, riskProfileClientResponse.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                            //System.debug('log: ' + log);
                             
                           
                        }
                    }else{
                        //System.debug('Request Bean Error: ' + getRiskProfileClientRequest.errorMessage);
                        log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, getRiskProfileClientRequest.errorMessage);
                        riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, getRiskProfileClientRequest.errorMessage);
                    }
                }else{
                    
                    String message = '';
                    if(occupationStatusTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_STATUS + accountP.Occupation_Status__pc + '. ';
                    }
                    if(occupationCategoryTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_CATEGORY + accountP.Occupation_Category__pc + '. ';
                    }
                    if(incomeSourceTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + accountP.Income_Source__pc + '. ';
                    }
                    
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    //System.debug('message: ' + message);
                    
                }
            }else{
                //No Integration Settings
                String message = '';
                message += integrationSettings == null ? StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_RISK_PROFILE_CLIENT + '. Environment: ' + Sys_Utilities_General.getEnvironment() + '. ' : '';
                message += metaDataList.size() == 0 ? StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND : '';
                message += accountP == null ? StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT : '';
                //System.debug(message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                
            }
        }catch(Exception e){
            
            //System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            riskProfileClientResponse = GetRiskProfileClient_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null){
            SystemLogger.insertLog(log);
        }
        return riskProfileClientResponse;
    }
    
}