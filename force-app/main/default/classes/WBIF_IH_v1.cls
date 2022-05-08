public class WBIF_IH_v1 {
    
    /* Calls the WBIF Orchestration method for get Quote Summary : getWBIFQuoteSummaryOrchestration
    * @Param: User
    * @Param: Account
    * @Param: Opportunity
    * @Return: WBIF_IB_String_v1 Bean Object
    */
    public static WBIF_IB_String_v1 getWBIFQuoteSummary(User userP, Account accountP, Opportunity opportunityP){
        
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        WBIF_IB_String_v1 responseBean;
        
        try{
            //Prepare Data
            List<Opportunity_Party__c> opportunityPartyList = [SELECT Id, Age__c, Benefit_Split__c, Date_of_Birth__c, First_Name__c, Last_Name__c, Opportunity__c, Party_Type__c, Relationship__c, RSA_ID_Number__c FROM Opportunity_Party__c WHERE Opportunity__c =: opportunityP.Id];
            
            List<QuoteLineItem> quoteLineItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Policy_Cover__c, Premium__c, TotalPrice FROM QuoteLineItem WHERE QuoteId =: opportunityP.SyncedQuoteId];
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WBIF_STRING);
            Map<String, List<Integration_Service__c>> wbifIntegrationServicesMap = Sys_Utilities_General.convertListToMapWithStringKey(integrationSettings.Integration_Services__r, StringConstants.FIELD_NAME_STRING);
            
            List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRulesMdtList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(generalVirtualAdvisorRulesMdtList, StringConstants.FIELD_DEVELOPERNAME_STRING);
            
            //Get Quote Summary
            Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> responseMap = getWBIFQuoteSummaryOrchestration(userP, accountP, opportunityP, opportunityPartyList, quoteLineItemList, integrationSettings, wbifIntegrationServicesMap, generalVirtualAdvisorRulesMap);
            List<WBIF_IB_String_v1> responseBeanList = new List<WBIF_IB_String_v1>(responseMap.keySet());
            responseBean = responseBeanList[0];
            logList = responseMap.values()[0];
            
            /*if(responseBean.statusCode == 200){
            log = SystemLogger.createInternalIntegrationLog('WBIF Quote Summary', StringConstants.WBIF_STRING, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize( responseBean, true ));
        }*/
        }catch(Exception e){
            //Map bad response with an unhandled exception and Log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog('WBIF Quote Summary', StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            logList.add(log);
        }
        if(logList.size() > 0){
            insert logList;
        }
        return responseBean;
    } // end of getWBIFQuoteSummary
    
    /* Calls the WBIF Orchestration method for get Quote Summary : getWBIFQuoteSummaryOrchestration
    * Calls the WBIF Orchestration method for Validate : getWBIFValidationOrchestration
    * @Param: User
    * @Param: Account
    * @Param: Opportunity
    * @Return: WBIF_IB_String_v1 Bean Object
    */
    public static WBIF_IB_String_v1 getWBIFValidate(User userP, Account accountP, Opportunity opportunityP){
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        WBIF_IB_String_v1 responseBean;
        List<Opportunity_Party__c> opportunityPartyList = new List<Opportunity_Party__c>();
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        try{
            //prepare Data
            //Added by Poulami to pass Ultimate Protector Module
            if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity'){
                opportunityPartyList = [SELECT Id, Age__c, Benefit_Split__c, Date_of_Birth__c, First_Name__c, Last_Name__c, Opportunity__c, Party_Type__c, Relationship__c, RSA_ID_Number__c FROM Opportunity_Party__c
                                        WHERE Opportunity__c =: opportunityP.Id AND Party_Type__c INCLUDES ('Beneficiary') AND Beneficiary_Product__c INCLUDES (:StringConstants.PRODUCT_ULTIMATE_PROTECTOR)];
                List<Quote> quotes = new QuotesSelector().selectByProductName(opportunityP.Id,StringConstants.PRODUCT_ULTIMATE_PROTECTOR);
                quoteLineItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Policy_Cover__c, Premium__c, TotalPrice,Benefit__c FROM QuoteLineItem WHERE QuoteId =: quotes[0].Id];
            }
            else{
                opportunityPartyList = [SELECT Id, Age__c, Benefit_Split__c, Date_of_Birth__c, First_Name__c, Last_Name__c, Opportunity__c, Party_Type__c, Relationship__c, RSA_ID_Number__c FROM Opportunity_Party__c WHERE Opportunity__c =: opportunityP.Id];
            
                quoteLineItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Policy_Cover__c, Premium__c, TotalPrice,Benefit__c FROM QuoteLineItem WHERE QuoteId =: opportunityP.SyncedQuoteId];
            }
                        
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WBIF_STRING);
            Map<String, List<Integration_Service__c>> wbifIntegrationServicesMap = Sys_Utilities_General.convertListToMapWithStringKey(integrationSettings.Integration_Services__r, StringConstants.FIELD_NAME_STRING);
            
            List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRulesMdtList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(generalVirtualAdvisorRulesMdtList, StringConstants.FIELD_DEVELOPERNAME_STRING);
            
            //Get Quote Summary
            Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> responseMap = getWBIFQuoteSummaryOrchestration(userP, accountP, opportunityP, opportunityPartyList, quoteLineItemList, integrationSettings, wbifIntegrationServicesMap, generalVirtualAdvisorRulesMap);
            List<WBIF_IB_String_v1> responseBeanList = new List<WBIF_IB_String_v1>(responseMap.keySet());
            WBIF_IB_String_v1 quoteResponseBean = responseBeanList[0];
            logList = responseMap.values()[0];
            
            if(quoteResponseBean.statusCode == 200){
                //Get Validation
                //logList.add(SystemLogger.createInternalIntegrationLog('WBIF Validate', StringConstants.WBIF_STRING, quoteResponseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize( quoteResponseBean, true )));
                Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> validationResponseMap = getWBIFValidationOrchestration(quoteResponseBean, userP, accountP, opportunityP,opportunityPartyList, quoteLineItemList, integrationSettings, wbifIntegrationServicesMap, generalVirtualAdvisorRulesMap);
                
                List<WBIF_IB_String_v1> validateResponseBeanList = new List<WBIF_IB_String_v1>(validationResponseMap.keySet());
                responseBean = validateResponseBeanList[0];
                
                for(Sys_Log_Integration__c currentLog : validationResponseMap.values()[0]){
                    logList.add(currentLog);
                }
                /*if(responseBean.statusCode == 200){
                    logList.add(SystemLogger.createInternalIntegrationLog('WBIF Validate', StringConstants.WBIF_STRING, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize( responseBean, true )));
                }*/
            }else{
                responseBean = WBIF_IU_v1.mapFailedResponseFields(quoteResponseBean.statusCode, quoteResponseBean.status, JSON.serialize( quoteResponseBean, true ));
            }
        }catch(Exception e){
            //Map bad response with an unhandled exception and Log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            logList.add(SystemLogger.createInternalIntegrationLog('WBIF Validate', StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
        }
        if(logList.size() > 0){
            insert logList;
        }
        return responseBean;
    } // end of getWBIFValidate
    
    /* Calls the WBIF Orchestration method for get Quote Summary : getWBIFQuoteSummaryOrchestration, then the WBIF Orchestration method for Validate getWBIFValidationOrchestration
    * After Calling the Orchestration methods the Submit Policy method is called
    * @Param: User
    * @Param: Account
    * @Param: Opportunity
    * @Return: WBIF_IB_String_v1 Bean Object
    */
    public static WBIF_IB_String_v1 getWBIFSubmitPolicy(User userP, Account accountP, Opportunity opportunityP){
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        WBIF_IB_String_v1 responseBean;
        List<Opportunity_Party__c> opportunityPartyList = new List<Opportunity_Party__c>();
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        try{
            //Prepare Data
            //Added by Poulami to pass Ultimate Protector Module
            if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity'){
                
                opportunityPartyList =  [SELECT Id, Age__c, Benefit_Split__c, Date_of_Birth__c, First_Name__c, Last_Name__c, Opportunity__c, Party_Type__c, Relationship__c, RSA_ID_Number__c FROM Opportunity_Party__c
                                        WHERE Opportunity__c =: opportunityP.Id AND Party_Type__c INCLUDES ('Beneficiary') AND Beneficiary_Product__c INCLUDES (:StringConstants.PRODUCT_ULTIMATE_PROTECTOR)];
                List<Quote> quotes = new QuotesSelector().selectByProductName(opportunityP.Id,StringConstants.PRODUCT_ULTIMATE_PROTECTOR);
                quoteLineItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Policy_Cover__c, Premium__c, TotalPrice,Benefit__c FROM QuoteLineItem WHERE QuoteId =: quotes[0].Id];
            }
            else{
                opportunityPartyList = [SELECT Id, Age__c, Benefit_Split__c, Date_of_Birth__c, First_Name__c, Last_Name__c, Opportunity__c, Party_Type__c, Relationship__c, RSA_ID_Number__c FROM Opportunity_Party__c WHERE Opportunity__c =: opportunityP.Id];
            
                quoteLineItemList = [SELECT Id, Product2.Name, Product2.ProductCode, Policy_Cover__c, Premium__c, TotalPrice, Benefit__c  FROM QuoteLineItem WHERE QuoteId =: opportunityP.SyncedQuoteId];
            }
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getMultipleIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WBIF_STRING);
            Map<String, List<Integration_Service__c>> wbifIntegrationServicesMap = Sys_Utilities_General.convertListToMapWithStringKey(integrationSettings.Integration_Services__r, StringConstants.FIELD_NAME_STRING);
            
            List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRulesMdtList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey( generalVirtualAdvisorRulesMdtList, StringConstants.FIELD_DEVELOPERNAME_STRING);
            
            //Get Quote Summary
            Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> responseMap = getWBIFQuoteSummaryOrchestration(userP, accountP, opportunityP, opportunityPartyList, quoteLineItemList, integrationSettings, wbifIntegrationServicesMap, generalVirtualAdvisorRulesMap);
            List<WBIF_IB_String_v1> responseBeanList = new List<WBIF_IB_String_v1>(responseMap.keySet());
            responseBean = responseBeanList[0];
            logList = responseMap.values()[0];
            
            if(responseBean.statusCode == 200){
                //Validate
                //logList.add(SystemLogger.createInternalIntegrationLog('WBIF Quote Summary', StringConstants.WBIF_STRING, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize( responseBean, true )));
                Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> validationResponseMap = getWBIFValidationOrchestration(responseBean, userP, accountP, opportunityP,opportunityPartyList, quoteLineItemList, integrationSettings, wbifIntegrationServicesMap, generalVirtualAdvisorRulesMap);
                
                List<WBIF_IB_String_v1> validateResponseBeanList = new List<WBIF_IB_String_v1>(validationResponseMap.keySet());
                responseBean = validateResponseBeanList[0];
                
                for(Sys_Log_Integration__c currentLog : validationResponseMap.values()[0]){
                    logList.add(currentLog);
                }
                
                if(responseBean.statusCode == 200){
                    //Submit Policy
                    //logList.add(SystemLogger.createInternalIntegrationLog('WBIF Validate', StringConstants.WBIF_STRING, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize( responseBean, true )));
                    
                    WBIF_IB_String_v1 submitPolicyRequestBean = WBIF_IU_v1.mapPolicySubmitFields(responseBean);
                    String submitPolicyJsonString = submitPolicyRequestBean.serialize(submitPolicyRequestBean);
                    submitPolicyJsonString = WBIF_IU_v1.jsonStringReplace(submitPolicyJsonString);
                    
                    Sys_Log_Integration__c submitLog = SystemLogger.createRequestIntegrationLog(submitPolicyJsonString, '8.' + StringConstants.METHOD_WBIF_SUBMIT_POLICY, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                    
                    responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettings, wbifIntegrationServicesMap.get(StringConstants.WBIF_SUBMIT_POLICY)[0], submitPolicyJsonString);
                    
                    submitLog = SystemLogger.mapResponseFields(submitLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                    logList.add(submitLog);
                    
                }
            }
        }catch(Exception e){
            //Map bad response with an unhandled exception and Log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            logList.add(SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_WBIF_SUBMIT_POLICY, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
        }
        if(logList.size() > 0){
            insert logList;
        }
        return responseBean;
    } // end of getWBIFSubmitPolicy
    
    /* Executes the logic for for the get Quote Summary method
    * - ADAPT360
    * - Policy Create
    * - Add Dependent SPOUSE
    * - Add Benefit
    * - Calculate
    * @Param: User
    * @Param: Account
    * @Param: Opportunity
    * @Param: List<Opportunity_Party__c>
    * @Param: List<QuoteLineItem>
    * @Param: Integration_API__c
    * @Param: Map<String, List<Integration_Service__c>>
    * @Param: Map<String, List<General_Virtual_Advisor_Rules__mdt>>
    * @Return: WBIF_IB_String_v1 Bean Object
    */
    public static Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> getWBIFQuoteSummaryOrchestration(User userP, Account accountP, Opportunity opportunityP, List<Opportunity_Party__c> opportunityPartyListP, List<QuoteLineItem> quoteLineItemListP, Integration_API__c integrationSettingsP, Map<String, List<Integration_Service__c>> wbifIntegrationServicesMapP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMapP){
        
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> responseMap = new Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>>();
        //Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        
        if(opportunityPartyListP.size() > 0 && quoteLineItemListP.size() > 0 && integrationSettingsP != null && generalVirtualAdvisorRulesMapP.values().size() > 0){
            
            //Value Translations
            String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfResidenceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            //***NOTE: maritalStatusTranslated will be sent to the mapping method as an Empty String ('') or with a Marital Status translated value
            String maritalStatusTranslated;
            
            if(accountP.Marital_Status__pc != null){
                
                maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_MARITAL_STATUS_STRING, accountP.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            }else{
                maritalStatusTranslated = '';
            }
            String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            //***NOTE: titleTranslated will be sent to the mapping method as null or with a Title translated value
            String titleTranslated;
            if(accountP.PersonTitle != null){
                titleTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_TITLE_STRING, accountP.PersonTitle.replace('.',''), StringConstants.OUTBOUND_RECORD_TYPE);
            }
            
            if(countryOfBirthTranslated != null && countryOfResidenceTranslated != null && maritalStatusTranslated != null && nationalityTranslated != null && incomeSourceTranslated != null){
                
                /**** ADAPT 360 CALL AND MAP RESPONSE ****/
                Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> adapt360Map = ADAPT360_IH_v1.retrieveClientDetailsMap('cif', accountP.CIF__c, 'CIB_VIEW', true);
                
                List<ADAPT360_Resp_IB_v1> beanList = new List<ADAPT360_Resp_IB_v1>(adapt360Map.keySet());
                ADAPT360_Resp_IB_v1 adapt360ResponseBean = beanList[0];
                
                if(adapt360ResponseBean.statusCode != 200 || adapt360ResponseBean.ClientDetails.size() == 0 || adapt360ResponseBean.ClientDetails == null){
                    
                    responseMap.put(WBIF_IU_v1.mapFailedResponseFields(adapt360ResponseBean.statusCode, adapt360ResponseBean.status, adapt360ResponseBean.message), logList);
                    return responseMap;
                    
                }
                //POLICY CREATE
                //Map Request Fields
                WBIF_IB_String_v1 policyCreateRequestBean = WBIF_IU_v1.mapPolicyCreateRequestFields(userP, accountP, opportunityP, countryOfBirthTranslated, countryOfResidenceTranslated, maritalStatusTranslated, nationalityTranslated, incomeSourceTranslated, titleTranslated, generalVirtualAdvisorRulesMapP, adapt360ResponseBean);
                //Serialize Bean into JSON String
                String policyCreateJsonString = policyCreateRequestBean.serialize(policyCreateRequestBean);
                policyCreateJsonString = WBIF_IU_v1.jsonStringReplace(policyCreateJsonString);
                //Create Log
                Sys_Log_Integration__c policyLog = SystemLogger.createRequestIntegrationLog(policyCreateJsonString, '1.' + StringConstants.METHOD_WBIF_POLICY_CREATE, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                //Create and send Request
                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_CREATE)[0], policyCreateJsonString); //StringConstants.WBIF_POLICY_CREATE);
                System.debug('Policy Create: ' + responseBean);
                //Populate Log
                policyLog = SystemLogger.mapResponseFields(policyLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                logList.add(policyLog);
                if(responseBean.statusCode != 200){
                    responseMap.put(responseBean, logList);
                    return responseMap;
                }
                //ADD DEPENDENT SPOUSE
                for(Opportunity_Party__c opportunityParty : opportunityPartyListP){
                    //IF THEY ARE A SPOUSE AND DEPENDENT
                    if((opportunityParty.Party_Type__c.contains(StringConstants.SPOUSE_PARTY_TYPE) 
                       || (opportunityParty.Relationship__c == StringConstants.SPOUSE_PARTY_TYPE && opportunityParty.Party_Type__c.contains(StringConstants.DEPENDANT_PARTY_TYPE))) && opportunityP.RecordType.Name != 'Direct Delivery Sales Opportunity'){
                           
                           String relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, opportunityParty.Relationship__c, StringConstants.OUTBOUND_RECORD_TYPE);
                           if(relationshipTranslated == null){
                               relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, StringConstants.UNKNOWN_STRING, StringConstants.OUTBOUND_RECORD_TYPE);
                           }
                           WBIF_IB_String_v1 addDependentRequestBean = WBIF_IU_v1.mapAddDependentRequestFields(responseBean, opportunityParty, relationshipTranslated, generalVirtualAdvisorRulesMapP);
                           String addDependentJsonString = addDependentRequestBean.serialize(addDependentRequestBean);
                           addDependentJsonString = WBIF_IU_v1.jsonStringReplace(addDependentJsonString);
                           
                           Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(addDependentJsonString, '2.' + StringConstants.METHOD_WBIF_ADD_DEPENDENT_SPOUSE, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                           
                           responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_ADD_DEPENDENT)[0], addDependentJsonString); //StringConstants.WBIF_POLICY_ADD_DEPENDENT);
                           
                           //Populate Log
                           log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                           logList.add(log);
                           if(responseBean.statusCode != 200){
                               responseMap.put(responseBean, logList);
                               return responseMap;
                           }
                       }
                }
                //ADD BENEFIT
                for(QuoteLineItem quoteLineItem : quoteLineItemListP){
                    System.debug('ADD BENEFIT Product: ' + quoteLineItem.Product2.Name + ' - ' + quoteLineItem.Product2.ProductCode);
                    if(!quoteLineItem.Product2.Name.contains(StringConstants.POLICY_FEE_STRING)){
                        
                        if(quoteLineItem.Product2.Name.contains(StringConstants.SPOUSE_PARTY_TYPE)){
                            //Spouse
                            List<WBIF_IB_String_v1.cls_Dependent> dependendList = new List<WBIF_IB_String_v1.cls_Dependent>();
                            if(responseBean.Policy_AddDependentResponse != null){
                                dependendList.addAll(responseBean.Policy_AddDependentResponse.Policy_AddDependentResult.Dependents.Dependent);
                            }else if(responseBean.Policy_AddBenefitResponse.Policy_AddBenefitResult.Dependents != null){
                                dependendList.addAll(responseBean.Policy_AddBenefitResponse.Policy_AddBenefitResult.Dependents.Dependent);
                            }
                            
                            for(WBIF_IB_String_v1.cls_Dependent dependent : dependendList){
                                
                                WBIF_IB_String_v1 addBenefitRequestBean = WBIF_IU_v1.mapAddBenefitRequestFields(responseBean, dependent.GUID, quoteLineItem.Product2.ProductCode, generalVirtualAdvisorRulesMapP, true);
                                
                                String addBenefitJsonString = addBenefitRequestBean.serialize(addBenefitRequestBean);
                                
                                Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(addBenefitJsonString, '3.' + StringConstants.METHOD_WBIF_ADD_BENEFIT, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                                
                                //Replace back to standard values
                                addBenefitJsonString = WBIF_IU_v1.jsonStringReplace(addBenefitJsonString);
                                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_ADD_BENEFIT_V2)[0], addBenefitJsonString); //StringConstants.WBIF_POLICY_ADD_BENEFIT_V2);
                                
                                //Populate Log
                                log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                                logList.add(log);
                                if(responseBean.statusCode != 200){
                                    responseMap.put(responseBean, logList);
                                    return responseMap;
                                }
                            }
                        }else{
                            //Main Member
                            String guid = '';
                            if(responseBean.Policy_AddDependentResponse != null){
                                
                                guid = responseBean.Policy_AddDependentResponse.Policy_AddDependentResult.MainMember.GUID;
                            }else if(responseBean.Policy_AddBenefitResponse != null){
                                
                                guid = responseBean.Policy_AddBenefitResponse.Policy_AddBenefitResult.MainMember.GUID;
                            }else{
                                
                                guid = responseBean.Policy_CreateResponse.Policy_CreateResult.MainMember.GUID;
                            }
                           
                                WBIF_IB_String_v1 addBenefitRequestBean = WBIF_IU_v1.mapAddBenefitRequestFields(responseBean, guid, quoteLineItem.Product2.ProductCode, generalVirtualAdvisorRulesMapP, false);
                                if(opportunityP.RecordType.Name != 'Direct Delivery Sales Opportunity'){
                                    String addBenefitJsonString = addBenefitRequestBean.serialize(addBenefitRequestBean);
                            
                                    Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(addBenefitJsonString, StringConstants.METHOD_WBIF_ADD_BENEFIT, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                                    addBenefitJsonString = WBIF_IU_v1.jsonStringReplace(addBenefitJsonString);
                            
                                    responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_ADD_BENEFIT_V2)[0], addBenefitJsonString); //StringConstants.WBIF_POLICY_ADD_BENEFIT_V2);
                            
                                    //Populate Log
                                    log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                                    logList.add(log);
                                    if(responseBean.statusCode != 200){
                                        responseMap.put(responseBean, logList);
                                        return responseMap;
                                    }
                                }
                            }
                        }
                    }
                //CALCULATE
                WBIF_IB_String_v1 calculateRequestBean = WBIF_IU_v1.mapCalculateRequestFields(responseBean, quoteLineItemListP);
                
                String calculateJsonString = calculateRequestBean.serialize(calculateRequestBean);
                
                Sys_Log_Integration__c calcLog = SystemLogger.createRequestIntegrationLog(calculateJsonString, '4.' + StringConstants.METHOD_WBIF_CALCULATE, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                
                //Replace back to standard values
                calculateJsonString = WBIF_IU_v1.jsonStringReplace(calculateJsonString);
                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_CALCULATE_V2)[0], calculateJsonString); //StringConstants.WBIF_CALCULATE_V2);
                
                //Populate Log
                calcLog = SystemLogger.mapResponseFields(calcLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                logList.add(calcLog);
                if(responseBean.statusCode != 200){
                    responseMap.put(responseBean, logList);
                    return responseMap;
                }
            }else{ //Integration Translations Value IF
                
                String message = '';
                if(countryOfBirthTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH + accountP.Country_of_Birth__pc + '. ';
                }
                if(countryOfResidenceTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_of_Residence__pc + '. ';
                }
                if(maritalStatusTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_MARITAL_STATUS + accountP.Marital_Status__pc + '. ';
                }
                if(nationalityTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Nationality__pc + '. ';
                }
                if(incomeSourceTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + accountP.Income_Source__pc + '. ';
                }
                System.debug(message);
                responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog('WBIF Quote Summary', StringConstants.WBIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize( responseBean, true ));
                logList.add(log);
            }
        }else{ //Integration Settings, G.V Advisor Rules Metadata, opportunityPartyListP and quoteLineItemListP IF
            //Map Bad Response and log
            String message = '';
            if(integrationSettingsP == null){
                message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.WBIF_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
            }
            if(generalVirtualAdvisorRulesMapP.values().size() == 0){
                message += StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND;
            }
            if(opportunityPartyListP.size() == 0){
                message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_OPPORTUNITY_PARTIES + opportunityP.Id;
            }
            if(quoteLineItemListP.size() == 0){
                message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_QUOTE_LINE_ITEMS + opportunityP.Id;
            }
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog('WBIF Quote Summary', StringConstants.WBIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize( responseBean, true ));
            logList.add(log);
        }
        responseMap.put(responseBean, logList);
        return responseMap;
    } // end of getWBIFQuoteSummaryOrchestration
    
    /* Executes the logic for for the Validate method
* - Add Dependent CHILD
* - Add Beneficiary
* - Validate
* @Param: beanP - WBIF_IB_String_v1 Bean Object
* @Param: User
* @Param: Account
* @Param: Opportunity
* @Param: List<Opportunity_Party__c>
* @Param: List<QuoteLineItem>
* @Param: Integration_API__c
* @Param: Map<String, List<Integration_Service__c>>
* @Param: Map<String, List<General_Virtual_Advisor_Rules__mdt>>
* @Return: WBIF_IB_String_v1 Bean Object
*/
    public static Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> getWBIFValidationOrchestration(WBIF_IB_String_v1 beanP, User userP, Account accountP, Opportunity opportunityP, List<Opportunity_Party__c> opportunityPartyListP, List<QuoteLineItem> quoteLineItemListP, Integration_API__c integrationSettingsP, Map<String, List<Integration_Service__c>> wbifIntegrationServicesMapP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMapP){
        
        WBIF_IB_String_v1 responseBean = beanP;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>> responseMap = new Map<WBIF_IB_String_v1, List<Sys_Log_Integration__c>>();
        
        //ADD DEPENDENT CHILD
        for(Opportunity_Party__c opportunityParty : opportunityPartyListP){
            //IF THEY ARE A DEPENDENT AND NOT A SPOUSE
            //Poulami Modified the condition for Ultimate Protector
            if(opportunityParty.Party_Type__c.contains(StringConstants.DEPENDANT_PARTY_TYPE) && opportunityParty.Relationship__c == StringConstants.CHILD_RELATIONSHIP && opportunityP.RecordType.Name != 'Direct Delivery Sales Opportunity'){
                
                String relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, opportunityParty.Relationship__c, StringConstants.OUTBOUND_RECORD_TYPE);
                if(relationshipTranslated == null){
                    relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, StringConstants.UNKNOWN_STRING, StringConstants.OUTBOUND_RECORD_TYPE);
                }
                WBIF_IB_String_v1 addDependentRequestBean = WBIF_IU_v1.mapAddDependentRequestFields(responseBean, opportunityParty, relationshipTranslated, generalVirtualAdvisorRulesMapP);
                String addDependentJsonString = addDependentRequestBean.serialize(addDependentRequestBean);
                addDependentJsonString = WBIF_IU_v1.jsonStringReplace(addDependentJsonString);
                
                //Add Dependant Child Log
                Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(addDependentJsonString, '5.' + StringConstants.METHOD_WBIF_ADD_DEPENDENT_CHILD, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                
                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_ADD_DEPENDENT)[0], addDependentJsonString); //StringConstants.WBIF_POLICY_ADD_DEPENDENT);
                
                //Populate Log
                log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                logList.add(log);
                if(responseBean.statusCode != 200){
                    responseMap.put(responseBean, logList);
                    return responseMap;
                }
                
            }
        }
        //ADD BENEFICIARY
        for(Opportunity_Party__c opportunityParty : opportunityPartyListP){
            if(opportunityParty.Party_Type__c.contains(StringConstants.BENEFICIARY_PARTY_TYPE)){
                
                String relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, opportunityParty.Relationship__c, StringConstants.OUTBOUND_RECORD_TYPE);
                if(relationshipTranslated == null){
                    relationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_RELATIONSHIP_STRING, StringConstants.UNKNOWN_STRING, StringConstants.OUTBOUND_RECORD_TYPE);
                }
                
                WBIF_IB_String_v1 addBeneficiaryRequestBean = WBIF_IU_v1.mapAddBeneficiaryRequestFields(responseBean, opportunityParty, relationshipTranslated, generalVirtualAdvisorRulesMapP);
                String addBeneficiaryJsonString = addBeneficiaryRequestBean.serialize(addBeneficiaryRequestBean);
                addBeneficiaryJsonString = WBIF_IU_v1.jsonStringReplace(addBeneficiaryJsonString);
                
                //Add Beneficiary Log
                Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(addBeneficiaryJsonString, '6.' + StringConstants.METHOD_WBIF_ADD_BENEFICIARY, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                
                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_POLICY_ADD_BENEFICIARY)[0], addBeneficiaryJsonString); //StringConstants.WBIF_POLICY_ADD_BENEFICIARY);
                
                //Populate Log
                log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                logList.add(log);
                if(responseBean.statusCode != 200){
                    responseMap.put(responseBean, logList);
                    return responseMap;
                }
            }
        }
        //VALIDATE POLICY
        WBIF_IB_String_v1 validatePolicyRequestBean = WBIF_IU_v1.mapPolicyValidateRequestFields(responseBean, accountP, opportunityP, generalVirtualAdvisorRulesMapP, quoteLineItemListP);
        String validatePolicyJsonString = validatePolicyRequestBean.serialize(validatePolicyRequestBean);
        validatePolicyJsonString = WBIF_IU_v1.jsonStringReplace(validatePolicyJsonString);
        
        //Validate Log
        Sys_Log_Integration__c validateLog = SystemLogger.createRequestIntegrationLog(validatePolicyJsonString, '7.' + StringConstants.METHOD_WBIF_VALIDATE_POLICY, StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
        
        responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettingsP, wbifIntegrationServicesMapP.get(StringConstants.WBIF_VALIDATE_POLICY)[0], validatePolicyJsonString); //StringConstants.WBIF_VALIDATE_POLICY);
        
        if(responseBean.ValidatePolicyResponse != null){
            if(responseBean.ValidatePolicyResponse.ValidatePolicyResult != null){
                if(responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo != null){
                    if(responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo.ErrorReasons != null){
                        responseBean.message = responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo.ErrorReasons;
                    }   
                    if(responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo.ErrorReason != null){
                        if(responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo.ErrorReason.errorString != null){
                            for(String errorReason : responseBean.ValidatePolicyResponse.ValidatePolicyResult.PolicyInfo.ErrorReason.errorString){
                                responseBean.message += errorReason;
                            }
                        }
                    }
                }   
            }
        }
        if(responseBean.message != null || String.isNotBlank(responseBean.message)){
            responseBean.statusCode = 400;
            responseBean.status = StringConstants.STATUS_CODE_400;
        }
        //Populate Log
        validateLog = SystemLogger.mapResponseFields(validateLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
        logList.add(validateLog);
        responseMap.put(responseBean, logList);
        return responseMap;
    } // end of getWBIFValidationOrchestration
    
    //New Method - Only Implemeting WBIF Policy Create
    public static WBIF_IB_String_v1 wbifPolicyCreate(User userP, Account accountP, Opportunity opportunityP){
        
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        
        Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WBIF_POLICY_CREATE);
        
        List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRulesMdtList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(generalVirtualAdvisorRulesMdtList, StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        if(integrationSettings != null && generalVirtualAdvisorRulesMap.values().size() > 0){
            
            //Value Translations
            String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfResidenceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
            //***NOTE: maritalStatusTranslated will be sent to the mapping method as an Empty String ('') or with a Marital Status translated value
            String maritalStatusTranslated;
            if(accountP.Marital_Status__pc != null){
                
                maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_MARITAL_STATUS_STRING, accountP.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            }else{
                maritalStatusTranslated = '';
            }
            
            String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
            //***NOTE: titleTranslated will be sent to the mapping method as null or with a Title translated value
            String titleTranslated;
            if(accountP.PersonTitle != null){
                titleTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_TITLE_STRING, accountP.PersonTitle.replace('.',''), StringConstants.OUTBOUND_RECORD_TYPE);
            }
            
            if(countryOfBirthTranslated != null && countryOfResidenceTranslated != null && maritalStatusTranslated != null && nationalityTranslated != null && incomeSourceTranslated != null){
                
                //ADAPT 360 CALL AND MAP RESPONSE
                Map<ADAPT360_Resp_IB_v1, Sys_Log_Integration__c> adapt360Map = ADAPT360_IH_v1.retrieveClientDetailsMap('cif', accountP.CIF__c, 'CIB_VIEW', true);
                
                List<ADAPT360_Resp_IB_v1> beanList = new List<ADAPT360_Resp_IB_v1>(adapt360Map.keySet());
                ADAPT360_Resp_IB_v1 adapt360ResponseBean = beanList[0];
                
                if(adapt360ResponseBean.statusCode != 200 || adapt360ResponseBean.ClientDetails.size() == 0 || adapt360ResponseBean.ClientDetails == null){
                    
                    responseBean = WBIF_IU_v1.mapFailedResponseFields(adapt360ResponseBean.statusCode, adapt360ResponseBean.status, adapt360ResponseBean.message);
                    return responseBean;
                    
                }
                //POLICY CREATE ONLY
                //Map Request Fields
                WBIF_IB_String_v1 policyCreateRequestBean = WBIF_IU_v1.mapPolicyCreateRequestFields(userP, accountP, opportunityP, countryOfBirthTranslated, countryOfResidenceTranslated, maritalStatusTranslated, nationalityTranslated, incomeSourceTranslated, titleTranslated, generalVirtualAdvisorRulesMap, adapt360ResponseBean);
                //Serialize Bean into JSON String
                String policyCreateJsonString = policyCreateRequestBean.serialize(policyCreateRequestBean);
                policyCreateJsonString = WBIF_IU_v1.jsonStringReplace(policyCreateJsonString);
                                
                //Populate Request Log
                Sys_Log_Integration__c policyLog = SystemLogger.createRequestIntegrationLog(policyCreateJsonString, '*.' + 'wbifPolicyCreate', StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
                
                responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettings, integrationSettings.Integration_Services__r[0], policyCreateJsonString);
                
                //Populate Response Log
                policyLog = SystemLogger.mapResponseFields(policyLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
                logList.add(policyLog);

            }else{
                String message = '';
                if(countryOfBirthTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH + accountP.Country_of_Birth__pc + ' for ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                }
                if(countryOfResidenceTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + accountP.Country_of_Residence__pc + ' for ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                }
                if(maritalStatusTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_MARITAL_STATUS + accountP.Marital_Status__pc + ' for ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                }
                if(nationalityTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + accountP.Nationality__pc + ' for ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                }
                if(incomeSourceTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + accountP.Income_Source__pc + ' for ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
                }
                System.debug(message);
                responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog('wbifPolicyCreate', StringConstants.WBIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize( responseBean, true ));
                logList.add(log);
            }
        }else{
            //Map Bad Response and log
            String message = '';
            if(integrationSettings == null){
                message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.WBIF_POLICY_CREATE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
            }
            if(generalVirtualAdvisorRulesMap.values().size() == 0){
                message += StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND;
            }
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog('wbifPolicyCreate', StringConstants.WBIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize( responseBean, true ));
            logList.add(log);
        }

        insert logList;
        return responseBean;
    }
    
    //New Method - Only Implemeting WBIF Policy Calcualte
    public static WBIF_IB_String_v1 wbifPolicyCalculate(WBIF_IB_String_v1 policyCreateSessionP, Map<String, String> productCodePriceMapP, String dateOfBirthP, String ageP){
        system.debug('policyCreateSessionP '+policyCreateSessionP);
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        
        Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.WBIF_CALCULATE_V2);
        
        List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRulesMdtList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(generalVirtualAdvisorRulesMdtList, StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        if(integrationSettings != null && generalVirtualAdvisorRulesMap.values().size() > 0){
            
            //If dateofBirthP & ageP is passed as null it's the Main Member, else if they have values it's the Spouse
            Boolean isSpouse = false;
            if(ageP != null && dateOfBirthP != null){
                isSpouse = true;
            }
            
            //Map Request Fields
            WBIF_IB_String_v1 policyCalculateRequestBean = WBIF_IU_v1.mapQuoteSummaryFields(policyCreateSessionP, productCodePriceMapP, dateOfBirthP, ageP, isSpouse);
            //Serialize bean into JSON string
            String policyCaclulateJsonString = policyCalculateRequestBean.serialize(policyCalculateRequestBean);
            policyCaclulateJsonString = WBIF_IU_v1.jsonStringReplace(policyCaclulateJsonString);
            //Populate Request Log
            Sys_Log_Integration__c policyLog = SystemLogger.createRequestIntegrationLog(policyCaclulateJsonString, '*.' + 'wbifPolicyCalculate', StringConstants.SALESFORCE_STRING, StringConstants.WBIF_STRING);
            
            responseBean = WBIF_IU_v1.executeWBIFCallout(integrationSettings, integrationSettings.Integration_Services__r[0], policyCaclulateJsonString);

            //Populate Response Log
            policyLog = SystemLogger.mapResponseFields(policyLog, responseBean.statusCode, responseBean.status, JSON.serialize( responseBean, true ));
            logList.add(policyLog);
            
        }else{
            //Map Bad Response and log
            String message = '';
            if(integrationSettings == null){
                message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.WBIF_POLICY_CREATE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
            }
            if(generalVirtualAdvisorRulesMap.values().size() == 0){
                message += StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND;
            }
            responseBean = WBIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            Sys_Log_Integration__c log = SystemLogger.createInternalIntegrationLog('wbifPolicyCalculate', StringConstants.WBIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize( responseBean, true ));
            logList.add(log);
        }
        
        insert logList;
        return responseBean;
    }
     
} //end of handler : WBIF_IH_v1