//Version 7 of Casa Screening

public class CASAPrimaryClientScreening_IH_v2 {
    
    public static final String CLIENT_TYPE_GROUP = 'Client Type Group';
    
    public static CASAPrimaryClientScreening_Resp_IB_v2 casaPrimaryClientScreening(Account accountP, Id userIdP, String channelP, String sbuP, String branchP){
        
        return casaPrimaryClientScreening(accountP, userIdP, channelP, sbuP, branchP, true);
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v2 casaPrimaryClientScreening(Account accountP, Id userIdP, String channelP, String sbuP, String branchP,  Boolean insertLogsP){
        
        CASAPrimaryClientScreening_Resp_IB_v2 casaPrimaryClientScreeningResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2);
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            
            if(integrationSettings != null && metaDataList.size() > 0 && accountP != null && userList.size() == 1){
                
                String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_Of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String countryOfPassportTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String iDTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, CLIENT_TYPE_GROUP, accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
                
                if(countryOfResTranslated != null && countryOfBirthTranslated != null && iDTypeTranslated != null && nationalityTranslated != null && clientTypeGrpTranslated != null){
                    
                    //Map Fields
                    CASAPrimaryClientScreening_Req_IB_v2 casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v2.mapRequestFields(accountP, userList[0], countryOfResTranslated, countryOfBirthTranslated, iDTypeTranslated, nationalityTranslated, countryOfPassportTranslated, metaDataList, channelP, sbuP, branchP, clientTypeGrpTranslated);
                    
                    String jsonString = JSON.serialize( casaPrimaryClientScreeningRequest, true );
                    
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    System.debug('request: ' + request.getBody());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    
                    
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
                        
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                    }else{
                        ///Map Fields
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));                        
                        casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v2.mapResponseFields(response);
                        //Translate response values and return the translated bean
                        casaPrimaryClientScreeningResponse = translateToInternalValues(casaPrimaryClientScreeningResponse);
                    }
                }else{
                    String message = '';
                    if(countryOfResTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_Of_Residence__pc + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(countryOfBirthTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH + accountP.Country_of_Birth__pc + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(iDTypeTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_IDENTITY_TYPE + accountP.ID_Type__pc + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(nationalityTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Nationality__pc + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(clientTypeGrpTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_CLIENT_TYPE + accountP.Client_Type__c + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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
                
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
        }catch(Exception e){
            
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null && insertLogsP){
            insert log;
        }
        return casaPrimaryClientScreeningResponse;
    }
    
    public static cls_jointScreening casaPrimaryClientScreeningJointClient(Account accountP, List<Account> relatedPartyListP, Id userIdP, String channelP, String sbuP, String branchP){
        
        return casaPrimaryClientScreeningJointClient(accountP, relatedPartyListP, userIdP, channelP, sbuP, branchP, true);
    }
    
    public static cls_jointScreening casaPrimaryClientScreeningJointClient(Account accountP, List<Account> relatedPartyListP, Id userIdP, String channelP, String sbuP, String branchP, Boolean insertLogsP){
        
        cls_jointScreening jointClientSreening = new cls_jointScreening();
        CASAPrimaryClientScreening_Resp_IB_v2 casaPrimaryClientScreeningJointResponse;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        List<CASAScreenRelatedParty_Resp_IB_v1> relatedPartyScreeningList;
        String primaryClientRef;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2);
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            
            if(integrationSettings != null && metaDataList.size() > 0 && accountP != null && userList.size() == 1){
                
                String countryOfRegAccTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                String nationalityAccTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
                String clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, CLIENT_TYPE_GROUP, accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);

                if(countryOfRegAccTranslated != null && nationalityAccTranslated != null && clientTypeGrpTranslated != null){
                    
                    //Map Fields
                    CASAPrimaryClientScreening_Req_IB_v2 casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v2.mapJointAccRequestFields(accountP, userList[0], countryOfRegAccTranslated, nationalityAccTranslated, relatedPartyListP[0],  metaDataList, channelP, sbuP, branchP, clientTypeGrpTranslated);
                    
                    String jsonString = JSON.serialize( casaPrimaryClientScreeningRequest, true );
                    
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    System.debug('request: ' + request.getBody());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_JOINT, StringConstants.SALESFORCE_STRING, StringConstants.ECASA_STRING);
                    
                    
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
                        
                        casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                    }else{
                        ///Map Fields
                        response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                        casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v2.mapResponseFields(response);
                        //Translate response values and return the translated bean
                        casaPrimaryClientScreeningJointResponse = translateToInternalValues(casaPrimaryClientScreeningJointResponse);
                    }
                    if(casaPrimaryClientScreeningJointResponse.refNo != null){
                        primaryClientRef = casaPrimaryClientScreeningJointResponse.refNo;
                    }
                    
                    if(relatedPartyListP.size() > 0){
                        Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c> relatedPartyMap = new Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c>();
                        relatedPartyScreeningList = new List<CASAScreenRelatedParty_Resp_IB_v1>();
                        for(Account account : relatedPartyListP){
                            
                            String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_Of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, account.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String iDTypeAccountTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, account.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String countryOfPassportTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, account.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                            String clientTypePATranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, CLIENT_TYPE_GROUP, account.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                            String relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Relationship', account.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                            
                            relatedPartyMap = CASAScreenRelatedParty_IH_v1.screenRelatedPartyMap(account, countryOfResTranslated, countryOfBirthTranslated, nationalityTranslated, iDTypeAccountTranslated, userList[0], primaryClientRef, countryOfPassportTranslated, channelP, sbuP, branchP, relationshipTranslated, clientTypePATranslated);
                            
                            List<CASAScreenRelatedParty_Resp_IB_v1> beanList = new List<CASAScreenRelatedParty_Resp_IB_v1>(relatedPartyMap.keySet());
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
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_of_Registration__c + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(nationalityAccTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Country_of_Registration__c + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    if(clientTypeGrpTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_CLIENT_TYPE + accountP.Client_Type__c + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                    }
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_JOINT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    logList.add(log);
                    casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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
                
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_JOINT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                logList.add(log);
                casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
        }catch(Exception e){
            
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_JOINT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            logList.add(log);
            casaPrimaryClientScreeningJointResponse = CASAPrimaryClientScreening_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(logList.size() > 0 && insertLogsP){
            insert logList;
        }
        jointClientSreening.primaryScreening = casaPrimaryClientScreeningJointResponse;
        jointClientSreening.relatedPartyScreening = relatedPartyScreeningList;
        return jointClientSreening;
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v2 translateToInternalValues(CASAPrimaryClientScreening_Resp_IB_v2  screeningRepBeanP){
        
        String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, 'eCasa Status', screeningRepBeanP.casaStatus, StringConstants.INBOUND_RECORD_TYPE);
        System.debug('casaStatusTranslated: ' + casaStatusTranslated);
        
        if(casaStatusTranslated != null){
            screeningRepBeanP.casaStatus = casaStatusTranslated;
        }
        
        return screeningRepBeanP;
    }
    
    public class cls_jointScreening{
        public CASAPrimaryClientScreening_Resp_IB_v2 primaryScreening;
        public CASAScreenRelatedParty_Resp_IB_v1[] relatedPartyScreening;
    }  
}