//Version 6 of Casa Screening

public class CASAPrimaryClientScreening_IH_v1 {
    
    public static CASAPrimaryClientScreening_Resp_IB_v1 casaPrimaryClientScreening(Account accountP, Id userIdP){
        
        return casaPrimaryClientScreening(accountP, userIdP, true);
    }
    
    public static cls_jointScreening casaPrimaryClientScreeningJointClient(Account accountP, List<Account> relatedPartyListP, Id userIdP){
        
        return casaPrimaryClientScreeningJointClient(accountP, relatedPartyListP, userIdP, true);
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v1 casaPrimaryClientScreening(Account accountP, Id userIdP, Boolean insertLogsP){
        
        CASAPrimaryClientScreening_Resp_IB_v1 casaPrimaryClientScreeningResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_PRIMARY_CLIENT_SCREENING);
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            
            if(integrationSettings != null && metaDataList.size() > 0 && accountP != null && userList.size() == 1){
                
                String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_Of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String countryOfPassportTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String iDTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                
                if(countryOfResTranslated != null && countryOfBirthTranslated != null && iDTypeTranslated != null && nationalityTranslated != null){
                    
                    //Map Fields
                    CASAPrimaryClientScreening_Req_IB_v1 casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v1.mapRequestFields(accountP, userList[0], countryOfResTranslated, countryOfBirthTranslated, iDTypeTranslated, nationalityTranslated, countryOfPassportTranslated, metaDataList);
                    
                    String jsonString = JSON.serialize( casaPrimaryClientScreeningRequest, true );
                    
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    System.debug('request: ' + request.getBody());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING, StringConstants.SALESFORCE_STRING, StringConstants.ECASA_STRING);
                    
                    
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    
                    if(response.getStatusCode() == 200){
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                    
                    if(response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT){
                        
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                    }else{
                        ///Map Fields
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v1.mapResponseFields(response);
                    }
                }else{
                    String message = '';
                    if(countryOfResTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_Of_Residence__pc + '. ';
                    }
                    if(countryOfBirthTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH + accountP.Country_of_Birth__pc + '. ';
                    }
                    if(iDTypeTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_IDENTITY_TYPE + accountP.ID_Type__pc + '. ';
                    }
                    if(nationalityTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Nationality__pc + '. ';
                    }
                    
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug('message: ' + message);
                    
                }//Translation end
            }else{
                //Map Bad Response and log
                String message = '';
                if(integrationSettings == null){
                    message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND;
                }
                if(metaDataList.size() == 0){
                    message += StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND;
                }
                if(accountP == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT;
                }
                if(userList.size() == 0){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_USER + userIdP;
                }
                
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
        }catch(Exception e){
            
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null && insertLogsP){
            insert log;
        }
        return casaPrimaryClientScreeningResponse;
    }
    
    public static cls_jointScreening casaPrimaryClientScreeningJointClient(Account accountP, List<Account> relatedPartyListP, Id userIdP, Boolean insertLogsP){
        
        cls_jointScreening jointClientSreening = new cls_jointScreening();
        CASAPrimaryClientScreening_Resp_IB_v1 casaPrimaryClientScreeningJointResponse;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        List<CASAScreenRelatedParty_Resp_IB_v2> relatedPartyScreeningList;
        String primaryClientRef;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_PRIMARY_CLIENT_SCREENING);
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            
            if(integrationSettings != null && metaDataList.size() > 0 && accountP != null && userList.size() == 1){
                
                String countryOfRegAccTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                String nationalityAccTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
                if(countryOfRegAccTranslated != null && nationalityAccTranslated != null){
                    
                    //Map Fields
                    CASAPrimaryClientScreening_Req_IB_v1 casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v1.mapJointAccRequestFields(accountP, userList[0], countryOfRegAccTranslated, nationalityAccTranslated, relatedPartyListP[0],  metaDataList);
                    
                    String jsonString = JSON.serialize( casaPrimaryClientScreeningRequest, true );
                    
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    System.debug('request: ' + request.getBody());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), 'CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreeningJointClient', StringConstants.SALESFORCE_STRING, StringConstants.ECASA_STRING);
                    
                    
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    
                    if(response.getStatusCode() == 200){
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                    logList.add(log);
                    
                    if(response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT){
                        
                        casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                    }else{
                        ///Map Fields
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                        casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v1.mapResponseFields(response);
                    }
                    if(casaPrimaryClientScreeningJointResponse.refNo != null){
                        primaryClientRef = casaPrimaryClientScreeningJointResponse.refNo;
                    }
                    
                    if(relatedPartyListP.size() > 0){
                        Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> relatedPartyMap = new Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c>();
                        relatedPartyScreeningList = new List<CASAScreenRelatedParty_Resp_IB_v2>();
                        for(Account account : relatedPartyListP){
                            
                            String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_Of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String countryOfPassportTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, account.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String iDTypeAccountTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, account.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            
                            relatedPartyMap = CASAScreenRelatedParty_IH_v2.screenRelatedPartyMap(account, countryOfResTranslated, countryOfBirthTranslated, nationalityTranslated, iDTypeAccountTranslated, userList[0], primaryClientRef, countryOfPassportTranslated);
                            
                            List<CASAScreenRelatedParty_Resp_IB_v2> beanList = new List<CASAScreenRelatedParty_Resp_IB_v2>(relatedPartyMap.keySet());
                            beanList[0].relatedPartyName = account.FirstName + ' ' + account.LastName;
                            beanList[0].relatedPartySfId = account.Id;
                            relatedPartyScreeningList.add(beanList[0]);
                            
                            if(relatedPartyMap.values().size() > 0){
                                logList.add(relatedPartyMap.values()[0]);
                            }
                        }//end of relatedPartyListP for loop
                    }//end of relatedPartyListP size if
                    
                }else{
                    String message = '';
                    if(countryOfRegAccTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_of_Registration__c + '. ';
                    }
                    if(nationalityAccTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Country_of_Registration__c + '. ';
                    }
                    
                    log = SystemLogger.createInternalIntegrationLog('CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreeningJointClient', StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    logList.add(log);
                    casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug('message: ' + message);
                    
                }//Translation end
            }else{
                //Map Bad Response and log
                String message = '';
                if(integrationSettings == null){
                    message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + ' for Integration Service Record: ' + StringConstants.CASA_PRIMARY_CLIENT_SCREENING;
                }
                if(metaDataList.size() == 0){
                    message += StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND;
                }
                if(accountP == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT;
                }
                if(userList.size() == 0){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_USER + userIdP;
                }
                
                log = SystemLogger.createInternalIntegrationLog('CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreeningJointClient', StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                logList.add(log);
                casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
        }catch(Exception e){
            
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog('CASAPrimaryClientScreening_IH_v1.casaPrimaryClientScreeningJointClient', StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            logList.add(log);
            casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(logList.size() > 0 && insertLogsP){
            insert logList;
        }
        jointClientSreening.primaryScreening = casaPrimaryClientScreeningJointResponse;
        jointClientSreening.relatedPartyScreening = relatedPartyScreeningList;
        return jointClientSreening;
    }
    
    public class cls_jointScreening{
        public CASAPrimaryClientScreening_Resp_IB_v1 primaryScreening;
        public CASAScreenRelatedParty_Resp_IB_v2[] relatedPartyScreening;
    }    
}