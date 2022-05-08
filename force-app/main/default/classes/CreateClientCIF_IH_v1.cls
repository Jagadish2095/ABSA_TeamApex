/*
* Integration Handler to Create a Client in CIF
* @author Danie Booysen
* @created 2018-12-07
* @modified 2019-06-05
*/

public class CreateClientCIF_IH_v1 {
    
    /*Individual*/
    //Simple version of the method which inserts logs
    public static CreateClientCIF_Resp_IB_v1 createIndividualClient(Account accountP, String applicationP, String userIdP, String recordTypeP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP){
        return createIndividualClient(accountP, applicationP, userIdP, recordTypeP, nonCreditMarketIndP, creditMarketIndP, true);
    }
    
    //version of the method which has the option to insert logs or not
    //This is the orchestration for Individual. It calles 'Validate' and 'CreateClient'
    public static CreateClientCIF_Resp_IB_v1 createIndividualClient(Account accountP, String applicationP, String userIdP, String recordTypeP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP, Boolean insertLogsP){
        
        CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Sys_Log_Integration__c log;
        
        try{
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            List<Address__c> addressList = [SELECT Shipping_Street__c, Shipping_City__c, Shipping_Zip_Postal_Code__c, Shipping_Suburb__c, Shipping_Country__c, Address_Type__c, Account__c, Contact__c FROM Address__c 
                                            WHERE Contact__c = : accountP.PersonContactId
                                            OR Account__c =: accountP.Id];//accountP.Id
            //Get Integration Translations
            Map<String, String> translationMap = getTranslations(accountP, addressList);
            
            List<String> mapKeys = new List<String>(translationMap.keySet());
            
            if(!mapKeys[0].Contains('ERROR')){
                //Call Validate Method (cvsValidate & ValidateAddress)
                map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> cvsValidationMap = validateIndividual(accountP, addressList, translationMap, 'I', applicationP);
                logList = cvsValidationMap.values()[0];
                List<CvsValidationService_Resp_IB_v1> cvsList = new List<CvsValidationService_Resp_IB_v1>(cvsValidationMap.keySet());
                System.debug('Individual cvsValidate Response: ' + cvsList[0]);
                
                String branch;
                if(applicationP == 'WILLS' || applicationP == 'RBB'){
                    branch = '3232';
                }else {
                    branch = '';// TBC
                } 
                
                if(cvsList[0].statusCode == 200 && cvsList[0].valStatusCode == '0' && cvsList[0].addressCollection != null){
                    //Call CreateClient Method
                    map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createClientResponseMap;
                    
                    createClientResponseMap = createClient(accountP, new List<Account>(), '', applicationP, userList[0], translationMap, cvsList[0], 'Individual Client', branch, nonCreditMarketIndP, creditMarketIndP);
                    logList.add(createClientResponseMap.values()[0]); 
                    List<CreateClientCIF_Resp_IB_v1> responseBeanList = new List<CreateClientCIF_Resp_IB_v1>(createClientResponseMap.keySet());
                    responseBean = responseBeanList[0];
                    System.debug('Individual CreateClient Response: ' + responseBeanList[0]);
                }else{
                    //Validation Error
                    responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(cvsList[0].status, cvsList[0].statusCode, cvsList[0].message);
                    
                    //TdB - Use Jitterbit new structure
                    responseBean.CIcreateClientV12Response = new CreateClientCIF_Resp_IB_v1.CIcreateClientV12Response();
                    responseBean.CIcreateClientV12Response.Nbsmsgo3 = new CreateClientCIF_Resp_IB_v1.Nbsmsgo3();
                    CreateClientCIF_Resp_IB_v1.nbsmsgo3 statusMsg = new CreateClientCIF_Resp_IB_v1.nbsmsgo3();

                    if(cvsList[0].statusMessage != null){
                        if(cvsList[0].statusMessage.error != null){
                            List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                           
                            for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsList[0].statusMessage.error){
                                 CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errors.msgTxt = error.reason;
                                errorList.add(errors);
                            }
                            
                            statusMsg.msgEntries = errorList;
                            
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                        }
                        
                        if(cvsList[0].statusMessage.errorObj != null){
                            if(cvsList[0].statusMessage.errorObj.reason != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errorObject.msgTxt = cvsList[0].statusMessage.errorObj.reason;
                                statusMsg.msgEntry = errorObject;
                            }
                            if(cvsList[0].statusMessage.errorObj.reasonList != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                                for(String eachError : cvsList[0].statusMessage.errorObj.reasonList) {
                                    CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                    errors.msgTxt = eachError;
                                    errorList.add(errors);
                                }
                                statusMsg.msgEntries = errorList;
                            }
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                        }
                        
                    } else if (cvsList[0].message != null) {
                        responseBean.message = cvsList[0].message;
                    } else {
                        responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, cvsList[0].statusCode, translationMap.get('ERROR'));
                    }
                }
            }else{
                System.debug(translationMap.values());
                //Translation error
                log = SystemLogger.createInternalIntegrationLog('createIndividualClient', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, translationMap.get('ERROR'));
                logList.add(log);
                responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, translationMap.get('ERROR'));
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        
        if(insertLogsP){
            insert logList;
        }
        
        System.debug('CREATE CLIENT RESPONSE: ' + responseBean);
        return responseBean;
    }
    
    //TdB - W-004795 - Create a Mini IndividualCIF 
    public static CreateClientCIF_Resp_IB_v1 createMiniIndividualClient(Account accountP, String applicationP, String userIdP, String recordTypeP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP){
        return createMiniIndividualClient(accountP, applicationP, userIdP, recordTypeP, nonCreditMarketIndP, creditMarketIndP, true);
    }
    
    //TdB - W-004795 - Create a Mini IndividualCIF (CVS validation for Address only)
    public static CreateClientCIF_Resp_IB_v1 createMiniIndividualClient(Account accountP, String applicationP, String userIdP, String recordTypeP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP, Boolean insertLogsP){
        System.debug('In createMiniIndividualClient');  
        CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>(); 
        Sys_Log_Integration__c log;
        
        try{
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            List<Address__c> addressList = [SELECT Shipping_Street__c, Shipping_City__c, Shipping_Zip_Postal_Code__c, Shipping_Suburb__c, Shipping_Country__c, Address_Type__c, Account__c, Contact__c FROM Address__c 
                                            WHERE Contact__c = : accountP.PersonContactId
                                            OR Account__c =: accountP.Id];//accountP.Id
            //Get Integration Translations
            Map<String, String> translationMap = getTranslations(accountP, addressList);
            
            List<String> mapKeys = new List<String>(translationMap.keySet());
            
            if(!mapKeys[0].Contains('ERROR')){
                //Call Validate Method (cvsValidate & ValidateAddress)
                map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> cvsValidationMap = validateMiniIndividual(accountP, addressList, translationMap, 'I', applicationP);
                logList = cvsValidationMap.values()[0];
                List<CvsValidationService_Resp_IB_v1> cvsList = new List<CvsValidationService_Resp_IB_v1>(cvsValidationMap.keySet());
                System.debug('Individual Mini cvsValidate Response: ' + cvsList[0]);
                
                String branch;
                if(applicationP == 'WILLS' || applicationP == 'RBB' || applicationP == 'RBB Mini'){
                    branch = '3232';
                }else {
                    branch = '';// TBC
                } 
                
                if(cvsList[0].statusCode == 200 && cvsList[0].valStatusCode == '0' && cvsList[0].addressCollection != null){
                    //Call CreateClient Method
                    map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createClientResponseMap;
                    
                    createClientResponseMap = createClient(accountP, new List<Account>(), '', 'RBB Mini', userList[0], translationMap, cvsList[0], 'Individual Client', branch, nonCreditMarketIndP, creditMarketIndP);
                    
                    logList.add(createClientResponseMap.values()[0]); 
                    List<CreateClientCIF_Resp_IB_v1> responseBeanList = new List<CreateClientCIF_Resp_IB_v1>(createClientResponseMap.keySet());
                    responseBean = responseBeanList[0];
                    System.debug('Individual CreateClient Response: ' + responseBeanList[0]);
                }else{
                    //Validation Error
                    responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(cvsList[0].status, cvsList[0].statusCode, cvsList[0].message);
                    responseBean.CIcreateClientV12Response = new CreateClientCIF_Resp_IB_v1.CIcreateClientV12Response();
                    responseBean.CIcreateClientV12Response.Nbsmsgo3 = new CreateClientCIF_Resp_IB_v1.Nbsmsgo3();
                    
                    if(cvsList[0].statusMessage != null){
                        //TdB - Use Jitterbit new structure
                        CreateClientCIF_Resp_IB_v1.nbsmsgo3 statusMsg = new CreateClientCIF_Resp_IB_v1.nbsmsgo3();
                        if(cvsList[0].statusMessage.error != null){
                            List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                            for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsList[0].statusMessage.error){
                                CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errors.msgTxt = error.reason;
                                errorList.add(errors);  
                            }
                            statusMsg.msgEntries = errorList;
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg; 
                        }
                        if(cvsList[0].statusMessage.errorObj != null){
                            if(cvsList[0].statusMessage.errorObj.reason != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errorObject.msgTxt = cvsList[0].statusMessage.errorObj.reason;
                                statusMsg.msgEntry = errorObject;
                            }
                            if(cvsList[0].statusMessage.errorObj.reasonList != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                                for(String eachError : cvsList[0].statusMessage.errorObj.reasonList) {
                                    CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                    errors.msgTxt = eachError;
                                    errorList.add(errors);
                                }
                                statusMsg.msgEntries = errorList;
                            }
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                        }
                    } else if (cvsList[0].message != null) {
                        responseBean.message = cvsList[0].message;
                    } else {
                        responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, cvsList[0].statusCode, translationMap.get('ERROR'));
                    }
                }
            }else{
                System.debug(translationMap.values());
                //Translation error
                log = SystemLogger.createInternalIntegrationLog('createIndividualClient', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, translationMap.get('ERROR'));
                logList.add(log);
                responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, translationMap.get('ERROR'));
                System.debug('Translation Error responseBean : ' + responseBean);
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        
        if(insertLogsP){
            insert logList;
        }
        System.debug('CREATE CLIENT RESPONSE: ' + responseBean);
        return responseBean;
    }
    
    /*Business*/
    //Simple version of the method which inserts logs
    public static CreateClientCIF_Resp_IB_v1 createBusinessClient(Account accountP, List<Account> relatedAccountListP, String primaryAccId, String recordTypeP, String applicationP, String userIdP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP){
        return createBusinessClient(accountP, relatedAccountListP, primaryAccId, recordTypeP, applicationP, userIdP, nonCreditMarketIndP, creditMarketIndP, true);
    }
    
    //version of the method which has the option to insert logs or not
    //This is the orchestration for Business. It calles 'Validate' and 'CreateClient'. Still need to add the extra validation and updateJointPartByClientCode
    public static CreateClientCIF_Resp_IB_v1 createBusinessClient(Account accountP, List<Account> relatedAccountListP, String primaryAccId, String recordTypeP, String applicationP, String userIdP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP, Boolean insertLogsP){
        
        CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Sys_Log_Integration__c log;
        
        try{
            Set<Id> relatedAccountIdSet = new Set<Id>();
            for(Account relatedParty : relatedAccountListP){
                relatedAccountIdSet.add(relatedParty.Id);
            }
            relatedAccountIdSet.add(accountP.Id);
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            List<Address__c> addressList = [SELECT Shipping_Street__c, Shipping_City__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c, Address_Type__c, Shipping_Suburb__c, Account__c, Contact__c FROM Address__c 
                                            WHERE Account__c IN : relatedAccountIdSet];
            //Get Integration Translations
            Map<String, String> translationMap = getTranslations(accountP, relatedAccountListP, addressList);
            
            List<String> mapKeys = new List<String>(translationMap.keySet());
            
            if(!mapKeys[0].Contains('ERROR')){
                //Call Validate Method (cvsValidate & ValidateAddress)
                map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> cvsValidationMap = validateBusiness(accountP, addressList, relatedAccountListP, primaryAccId, translationMap, 'J');
                logList = cvsValidationMap.values()[0];
                List<CvsValidationService_Resp_IB_v1> cvsList = new List<CvsValidationService_Resp_IB_v1>(cvsValidationMap.keySet());
                System.debug(cvsList[0].statusCode);
                if(cvsList[0].statusCode == 200 && cvsList[0].valStatusCode == '0' && cvsList[0].addressCollection != null){
                    //Call CreateClient Method
                    System.debug('CreateClient');
                    map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createClientResponseMap;
                    String branch;
                    if(applicationP == 'WILLS'){
                        branch = '3232';
                    }else if(applicationP == 'EPP'){
                        branch = '';// TBC
                    }
                    
                    createClientResponseMap = createClient(accountP, relatedAccountListP, primaryAccId, applicationP, userList[0], translationMap, cvsList[0], 'Business Client', branch, nonCreditMarketIndP, creditMarketIndP);
                    
                    logList.add(createClientResponseMap.values()[0]); 
                    List<CreateClientCIF_Resp_IB_v1> responseBeanList = new List<CreateClientCIF_Resp_IB_v1>(createClientResponseMap.keySet());
                    responseBean = responseBeanList[0];
                    if(responseBean.statusCode == 200 && responseBean.CIcreateClientV12Response.cib003o.outputCkey != null){
                        System.debug('UpdateJnt');
                        
                        //Update Joint Part By Client Code
                        Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> updateResponseMap = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCodeMap(responseBean.CIcreateClientV12Response.cib003o.outputCkey, applicationP, branch, 'A', relatedAccountListP, userIdP, cvsList[0], false);
                        updateResponseMap.values()[0].Related_Object_Id__c = accountP.Id;
                        logList.add(updateResponseMap.values()[0]); 
                        List<UpdateJntPartByClientCode_Resp_IB_v1> updResponseBeanList = new List<UpdateJntPartByClientCode_Resp_IB_v1>(updateResponseMap.keySet());
                        
                        if(updResponseBeanList[0].fault != null){
                            responseBean.message = updResponseBeanList[0].fault.faultString;
                        }
                        responseBean.updateJntPart = updResponseBeanList[0];
                        responseBean.statusCode = updResponseBeanList[0].statusCode;
                        responseBean.message = updResponseBeanList[0].message;
                        
                    }//No Else needed - Already creates negative bean in the handler
                }else{
                    //Validation Error
                    responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(cvsList[0].status, cvsList[0].statusCode, cvsList[0].message);
                    //TdB - Use Jitterbit new structure
                    responseBean.CIcreateClientV12Response = new CreateClientCIF_Resp_IB_v1.CIcreateClientV12Response();
                    responseBean.CIcreateClientV12Response.Nbsmsgo3 = new CreateClientCIF_Resp_IB_v1.Nbsmsgo3();
                    CreateClientCIF_Resp_IB_v1.nbsmsgo3 statusMsg = new CreateClientCIF_Resp_IB_v1.nbsmsgo3();
                    
                    if(cvsList[0].statusMessage != null){
                        if(cvsList[0].statusMessage.error != null){
                            List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                            for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsList[0].statusMessage.error){
                                CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errors.msgTxt = error.reason;
                                errorList.add(errors);
                            }
                            
                            statusMsg.msgEntries = errorList;
                            
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                            
                            if(cvsList[0].statusMessage.errorObj != null){
                                if(cvsList[0].statusMessage.errorObj.reason != null){
                                    CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                    errorObject.msgTxt = cvsList[0].statusMessage.errorObj.reason;
                                    statusMsg.msgEntry = errorObject;
                                }
                                if(cvsList[0].statusMessage.errorObj.reasonList != null){
                                    CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                    
                                    for(String eachError : cvsList[0].statusMessage.errorObj.reasonList) {
                                        CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                        errors.msgTxt = eachError;
                                        errorList.add(errors);
                                    }
                                    statusMsg.msgEntries = errorList;
                                }
                            }
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                            System.debug(statusMsg);
                        }
                     } else if (cvsList[0].message != null) {
                        responseBean.message = cvsList[0].message;
                    } else {
                        responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, cvsList[0].statusCode, translationMap.get('ERROR'));
                    }  
                    
                    System.debug(responseBean);
                }
            }else{
                System.debug(translationMap.values());
                //Translation error
                log = SystemLogger.createInternalIntegrationLog('createBusinessClient', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, String.valueOf(translationMap.values()));
                logList.add(log);
                responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, String.valueOf(translationMap.values()));
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF + ' Business Account', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            logList.add(log);
        }
        
        if(insertLogsP){
            insert logList;
        }
        System.debug('Create Business Client FINAL Response Bean' + responseBean);
        return responseBean;
    }
    
    /************************************************************/
    //Added by Haritha - For Business Prospect Clients
    /*Business Prospects*/
    //Simple version of the method which inserts logs
    public static map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createBusinessProspectClient(Account accountP, List<Account> relatedAccountListP, String primaryAccId, String recordTypeP, String applicationP, String userIdP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP){
        return createBusinessProspectClient(accountP, relatedAccountListP, primaryAccId, recordTypeP, applicationP, userIdP, nonCreditMarketIndP, creditMarketIndP, true);
    }
    
    //version of the method which has the option to insert logs or not
    //This is the orchestration for Business. It calles 'Validate' and 'CreateClient'. 
    public static map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createBusinessProspectClient(Account accountP, List<Account> relatedAccountListP, String primaryAccId, String recordTypeP, String applicationP, String userIdP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP, Boolean insertLogsP){
        
        CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Sys_Log_Integration__c log;
        map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createClientResponseMap = new  map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c>() ;
        try{
            Set<Id> relatedAccountIdSet = new Set<Id>();
            if(relatedAccountListP!=null){
                for(Account relatedParty : relatedAccountListP){
                    relatedAccountIdSet.add(relatedParty.Id);
                }
            }
            relatedAccountIdSet.add(accountP.Id);
            List<User>  userList =new List<User>  ();
            if(userIdP!=null){
                userList = [Select id,Teller_Operator_Code__c,EmployeeNumber,AB_Number__c,SiteCode__c from User where id=:userIdP];
            }
            List<Address__c> addressList = [SELECT Shipping_Street__c, Shipping_City__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c, Address_Type__c, Shipping_Suburb__c, Account__c, Contact__c FROM Address__c 
                                            WHERE Account__c =: accountP.Id];
            //Get Integration Translations
            Map<String, String> translationMap = getBusinessProspectTranslations(accountP, relatedAccountListP, addressList);
            List<String> mapKeys = new List<String>(translationMap.keySet());
            if(!mapKeys[0].Contains('ERROR')){
                map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> cvsResponseBean = OnboardingGenerateCIFController.cvsValidateClientInfo(accountP.Id);
                List<CvsValidationService_Resp_IB_v1> cvsResponseBeanList = new List<CvsValidationService_Resp_IB_v1>(cvsResponseBean.keySet());  
                logList.add(cvsResponseBean.values()[0]); 
                system.debug('vsResponseBeanList-------'+cvsResponseBeanList);
                
                if(cvsResponseBeanList[0].statusCode == 200 && cvsResponseBeanList[0].valStatusCode == '0'){
                    //Call Create Client Method
                    String branch = '';
                    createClientResponseMap = createClient(accountP, relatedAccountListP, primaryAccId, applicationP, userList[0], translationMap, cvsResponseBeanList[0], 'Business Prospect', '', new List<String>{}, new List<String>{});
                    logList.add(createClientResponseMap.values()[0]); 
                    
                    List<CreateClientCIF_Resp_IB_v1> responseBeanList = new List<CreateClientCIF_Resp_IB_v1>(createClientResponseMap.keySet());
                    responseBean = responseBeanList[0];
                    
                    //TdB - Service to create Praticipants
                    if(accountP.Client_Type__c.toUpperCase() == 'PARTNERSHIP') {
                        List<Account> participantRelatedParties = new List<Account>();
                        Set<Id> relatedPartyIds = new Set<Id>();
                        
                        //Add all Related Parties with Participant Role to a set 
                        for(AccountContactRelation eachParty : new AccountContactRelationSelector().selectbyAccountIdAndRoles(accountP.id, 'Participant')) { 
                            if(eachParty.AccountId != null) {
                                relatedPartyIds.add(eachParty.AccountId); 
                            }
                            if(eachParty.Contact.AccountId != null) {
                                relatedPartyIds.add(eachParty.Contact.AccountId); 
                            }
                        }
                        
                        //Add Related Party record to a List (only Participant Role)
                        for (Account eachRelatedParty : relatedAccountListP) {
                            if(relatedPartyIds.contains(eachRelatedParty.id)) {
                                participantRelatedParties.add(eachRelatedParty);
                            }
                        }
                        
                        if(responseBean.statusCode == 200 && responseBean.CIcreateClientV12Response.cib003o.outputCkey != null){
                            System.debug('UpdateJnt');
                            
                            //Update Joint Part By Client Code
                            Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> updateResponseMap = UpdateJntPartByClientCode_IH_v1.updateJointParticipantByClientCodeMap(responseBean.CIcreateClientV12Response.cib003o.outputCkey, applicationP, branch, 'A', participantRelatedParties, userIdP, cvsResponseBeanList[0], false);
                            updateResponseMap.values()[0].Related_Object_Id__c = accountP.Id;
                            logList.add(updateResponseMap.values()[0]); 
                            List<UpdateJntPartByClientCode_Resp_IB_v1> updResponseBeanList = new List<UpdateJntPartByClientCode_Resp_IB_v1>(updateResponseMap.keySet());
                            
                            if(updResponseBeanList[0].fault != null){
                                responseBean.message = updResponseBeanList[0].fault.faultString;
                            }
                            responseBean.updateJntPart = updResponseBeanList[0];
                            responseBean.statusCode = updResponseBeanList[0].statusCode;
                            responseBean.message = updResponseBeanList[0].message;
                            
                        }
                        
                    }
                }else{
                    //Validation Error
                    responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(cvsResponseBeanList[0].status, cvsResponseBeanList[0].statusCode, cvsResponseBeanList[0].message);
                    //TdB - Use Jitterbit new structure
                    responseBean.CIcreateClientV12Response = new CreateClientCIF_Resp_IB_v1.CIcreateClientV12Response();
                    responseBean.CIcreateClientV12Response.Nbsmsgo3 = new CreateClientCIF_Resp_IB_v1.Nbsmsgo3();
                    CreateClientCIF_Resp_IB_v1.nbsmsgo3 statusMsg = new CreateClientCIF_Resp_IB_v1.nbsmsgo3();
                    
                    if(cvsResponseBeanList[0].statusMessage != null){
                        if(cvsResponseBeanList[0].statusMessage.error != null){
                            List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                            for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsResponseBeanList[0].statusMessage.error){
                                CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errors.msgTxt = error.reason;
                                errorList.add(errors);
                            }
                            
                            statusMsg.msgEntries = errorList;
                            
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                        }
                        if(cvsResponseBeanList[0].statusMessage.errorObj != null){
                            if(cvsResponseBeanList[0].statusMessage.errorObj.reason != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                errorObject.msgTxt = cvsResponseBeanList[0].statusMessage.errorObj.reason;
                                statusMsg.msgEntry = errorObject;
                            }
                            if(cvsResponseBeanList[0].statusMessage.errorObj.reasonList != null){
                                CreateClientCIF_Resp_IB_v1.msgEntry errorObject = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                List<CreateClientCIF_Resp_IB_v1.msgEntry> errorList = new List<CreateClientCIF_Resp_IB_v1.msgEntry>();
                                
                                for(String eachError : cvsResponseBeanList[0].statusMessage.errorObj.reasonList) {
                                    CreateClientCIF_Resp_IB_v1.msgEntry errors = new CreateClientCIF_Resp_IB_v1.msgEntry();
                                    errors.msgTxt = eachError;
                                    errorList.add(errors);
                                }
                                
                                statusMsg.msgEntries = errorList;
                            }
                            responseBean.CIcreateClientV12Response.Nbsmsgo3 = statusMsg;
                        }
                    } else if (cvsResponseBeanList[0].message != null) {
                        responseBean.message = cvsResponseBeanList[0].message;
                    } else {
                        responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, cvsResponseBeanList[0].statusCode, translationMap.get('ERROR'));
                    }  
                    
                    createClientResponseMap.put(responseBean, logList[0]); 
                }
            }else{
                System.debug(translationMap.values());
                //Translation error
                log = SystemLogger.createInternalIntegrationLog('createBusinessProspectClient', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, String.valueOf(translationMap.values()));
                logList.add(log);
                responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, String.valueOf(translationMap.values()));
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF + ' Business Account', StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            logList.add(log);
        }
        if(insertLogsP){
            insert logList;
        }
        return createClientResponseMap;
    }
    
    public static Map<String, String> getBusinessProspectTranslations(Account accountP, List<Account> relatedAccountListP, List<Address__c> addressListP){
        Map<String, String> tanslationValueMap = new Map<String, String>();
        String message = '';
        
        /****** BUSINESS PROSPECT ACCOUNT ******/
        //Field value translations
        
        String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
        String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountP.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountP.Preferred_Communication_Method__c, StringConstants.OUTBOUND_RECORD_TYPE);//update variable to prefcom...
        String countryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfRegistrationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.BillingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.ShippingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryIssueTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String employerCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String LanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountP.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String companyYearEnd = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING,'Financial Year End', accountP.Financial_Year_End__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING,'Source of Income', accountP.Source_of_Income__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryForeignTax = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Foreign_tax__c, StringConstants.OUTBOUND_RECORD_TYPE);
        
        system.debug('sicCodeTranslated'+sicCodeTranslated);
        //Add the value translations to a map
        tanslationValueMap.put('nationalityTranslated', nationalityTranslated);
        tanslationValueMap.put('clientTypeTranslated', clientTypeTranslated);
        tanslationValueMap.put('countryOfBirthTranslated', countryOfBirthTranslated);
        tanslationValueMap.put('sicCodeTranslated', sicCodeTranslated); 
        tanslationValueMap.put('idTypeTranslated', idTypeTranslated);
        tanslationValueMap.put('LanguageTranslated', LanguageTranslated);
        tanslationValueMap.put('companyYearEnd', companyYearEnd);
        
        tanslationValueMap.put('comMethodTranslated', comMethodTranslated);
        tanslationValueMap.put('billCountryTranslated', billCountryTranslated);
        tanslationValueMap.put('shipCountryTranslated', shipCountryTranslated);
        tanslationValueMap.put('employerCountryTranslated', employerCountryTranslated);
        tanslationValueMap.put('countryOfOriginTranslated', countryOfOriginTranslated);
        tanslationValueMap.put('countryOfRegistrationTranslated', countryOfRegistrationTranslated);
        tanslationValueMap.put('countryIssueTranslated', countryIssueTranslated);
        tanslationValueMap.put('incomeSourceTranslated', incomeSourceTranslated);
        tanslationValueMap.put('countryForeignTax', countryForeignTax);
        System.debug('tanslationValueMap: ' + tanslationValueMap);
        return tanslationValueMap;
    }
    
    /*********************************Common Methods************************************/
    
    public static map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> validateIndividual(Account accountP, List<Address__c> addressListP, Map<String, String> translationMapP, String clientTypeGroupP, String appliationP){
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> responseMap = new map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>>();
        CvsValidationService_Req_IB_v1 cvsValidateBean = new CvsValidationService_Req_IB_v1();
        
        if(appliationP == 'RBB') {
            cvsValidateBean = CvsValidationService_IU_v1.mapRBBIndividualRequestFields(accountP, addressListP, clientTypeGroupP, translationMapP);
        } else {
            cvsValidateBean = CvsValidationService_IU_v1.mapIndividualRequestFields(accountP, addressListP, clientTypeGroupP, translationMapP);
        }
        
        System.debug(cvsValidateBean);
        //CvsValidationService
        map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> validateResponseMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false);
        
        List<CvsValidationService_Resp_IB_v1> cvsValidationBeanList = new List<CvsValidationService_Resp_IB_v1>(validateResponseMap.keySet());
        logList.add(validateResponseMap.values()[0]);
        
        if(cvsValidationBeanList[0].statusCode == 200 && cvsValidationBeanList[0].valStatusCode == '0'){//Success = 0, Failure = 1
            
            //Validate Employers Address
            List<ValidateAddress_Resp_IB_v1> validateEmployerAddressList;
            
            for(Address__c add : addressListP){
                
                if(add.Shipping_Zip_Postal_Code__c != null){
                    
                    if(add.Address_Type__c == 'Employers'){
                        
                        List<String> streetList = add.Shipping_Street__c.split('\r\n');
                        String line1Employer;
                        String line2Employer;
                        if(streetList.size() > 0){
                            line1Employer = streetList[0];
                            if(streetList.size() > 1){
                                line2Employer = streetList[1];
                            }
                        }
                        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateEmployerAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 70, line1Employer, line2Employer, add.Shipping_Suburb__c, add.Shipping_City__c, String.valueOf(add.Shipping_Zip_Postal_Code__c));
                        validateEmployerAddressList = new List<ValidateAddress_Resp_IB_v1>(validateEmployerAddressMap.keySet());
                        logList.add(validateEmployerAddressMap.values()[0]);
                    }
                }
                
            }
            Boolean proceedToShippingAddress = false;
            if(validateEmployerAddressList != null){
                if(validateEmployerAddressList[0].statusCode == 200 && validateEmployerAddressList[0].nbrUserErrs == '0'){
                    proceedToShippingAddress = true;
                }
            }else{
                proceedToShippingAddress = true;
            }
            if(proceedToShippingAddress){
                //Validate Shipping Address
                List<ValidateAddress_Resp_IB_v1> validateShippingAddressBeanList;
                if(accountP.ShippingStreet != null){
                    List<String> streetListShipping = accountP.ShippingStreet.split('\r\n');
                    String line1Shipping;
                    String line2Shipping;
                    if(streetListShipping.size() > 0){
                        line1Shipping = streetListShipping[0];
                        if(streetListShipping.size() > 1){
                            line2Shipping = streetListShipping[1];
                        }
                    }
                    Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateShippingAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 10, line1Shipping, line2Shipping, null, accountP.ShippingCity, accountP.ShippingPostalCode);
                    validateShippingAddressBeanList = new List<ValidateAddress_Resp_IB_v1>(validateShippingAddressMap.keySet());
                    logList.add(validateShippingAddressMap.values()[0]); 
                }
                
                Boolean proceedToPostalAddress = false;
                if(validateShippingAddressBeanList != null){
                    if(validateShippingAddressBeanList[0].statusCode == 200 && validateShippingAddressBeanList[0].nbrUserErrs == '0'){
                        proceedToPostalAddress = true;
                    }
                }else{
                    proceedToPostalAddress = true;
                }
                if(proceedToPostalAddress){
                    //Validate Postal Address
                    List<ValidateAddress_Resp_IB_v1> validateBillingAddressBeanList;
                    if(accountP.BillingStreet != null){
                        List<String> streetListBilling = accountP.BillingStreet.split('\r\n');
                        String line1Postal;
                        String line2Postal;
                        if(streetListBilling.size() > 0){
                            line1Postal = streetListBilling[0];
                            if(streetListBilling.size() > 1){
                                line2Postal = streetListBilling[1];
                            }
                        }
                        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateBillingAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 10, line1Postal, line2Postal, null, accountP.BillingCity, accountP.BillingPostalCode);
                        validateBillingAddressBeanList = new List<ValidateAddress_Resp_IB_v1>(validateBillingAddressMap.keySet());
                        logList.add(validateBillingAddressMap.values()[0]);
                    }
                    
                    Boolean proceedToMapping = false;
                    if(validateBillingAddressBeanList != null){
                        if(validateBillingAddressBeanList[0].statusCode == 200 && validateBillingAddressBeanList[0].nbrUserErrs == '0'){
                            proceedToMapping = true;
                        }
                    }else{
                        proceedToMapping = true;
                    }
                    
                    if(proceedToMapping){
                        
                        //Get the Address returned from Validate Address and add it to the cvsValidation bean which is returned 
                        CvsValidationService_Resp_IB_v1.cls_addressCollection employersAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        CvsValidationService_Resp_IB_v1.cls_addressCollection shippingAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        CvsValidationService_Resp_IB_v1.cls_addressCollection billingAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        List<CvsValidationService_Resp_IB_v1.cls_addressCollection> addressCollectionList = new List<CvsValidationService_Resp_IB_v1.cls_addressCollection>();
                        
                        if(validateEmployerAddressList != null){
                            if(validateEmployerAddressList[0].addressCollection != null){
                                employersAddressCollection.addressType = validateEmployerAddressList[0].addressCollection[0].addressType;
                                employersAddressCollection.addressLine1 = validateEmployerAddressList[0].addressCollection[0].addressLine1;
                                employersAddressCollection.addressLine2 = validateEmployerAddressList[0].addressCollection[0].addressLine2;
                                employersAddressCollection.town = validateEmployerAddressList[0].addressCollection[0].town;
                                employersAddressCollection.suburb = validateEmployerAddressList[0].addressCollection[0].suburb;
                                employersAddressCollection.postalCode = validateEmployerAddressList[0].addressCollection[0].postalCode;
                                employersAddressCollection.addressTypeSF = 'Employers';
                                addressCollectionList.add(employersAddressCollection);
                            }
                        }
                        
                        if(validateShippingAddressBeanList != null){
                            if(validateShippingAddressBeanList[0].addressCollection != null){
                                shippingAddressCollection.addressType = validateShippingAddressBeanList[0].addressCollection[0].addressType;
                                shippingAddressCollection.addressLine1 = validateShippingAddressBeanList[0].addressCollection[0].addressLine1;
                                shippingAddressCollection.addressLine2 = validateShippingAddressBeanList[0].addressCollection[0].addressLine2;
                                shippingAddressCollection.town = validateShippingAddressBeanList[0].addressCollection[0].town;
                                shippingAddressCollection.suburb = validateShippingAddressBeanList[0].addressCollection[0].suburb;
                                shippingAddressCollection.postalCode = validateShippingAddressBeanList[0].addressCollection[0].postalCode;
                                shippingAddressCollection.addressTypeSF = 'Physical';
                                addressCollectionList.add(shippingAddressCollection);
                            }
                        }
                        
                        if(validateBillingAddressBeanList != null){
                            if(validateBillingAddressBeanList[0].addressCollection != null){
                                billingAddressCollection.addressType = validateBillingAddressBeanList[0].addressCollection[0].addressType;
                                billingAddressCollection.addressLine1 = validateBillingAddressBeanList[0].addressCollection[0].addressLine1;
                                billingAddressCollection.addressLine2 = validateBillingAddressBeanList[0].addressCollection[0].addressLine2;
                                billingAddressCollection.town = validateBillingAddressBeanList[0].addressCollection[0].town;
                                billingAddressCollection.suburb = validateBillingAddressBeanList[0].addressCollection[0].suburb;
                                billingAddressCollection.postalCode = validateBillingAddressBeanList[0].addressCollection[0].postalCode;
                                billingAddressCollection.addressTypeSF = 'Postal';
                                addressCollectionList.add(billingAddressCollection);
                            }
                        }
                        
                        cvsValidationBeanList[0].addressCollection = addressCollectionList;
                        cvsValidationBeanList[0].statusCode = 200;
                        cvsValidationBeanList[0].valStatusCode = '0';
                        
                    }else{
                        //Validate BillingAddress Error
                        String message;
                        if(validateBillingAddressBeanList[0].msgEntry.size() > 0){
                            if(validateBillingAddressBeanList[0].msgEntry[0].msgTxt != null){
                                message = validateBillingAddressBeanList[0].msgEntry[0].msgTxt;
                            }
                        }
                        if(message == null){
                            message = validateBillingAddressBeanList[0].message;
                        }
                        cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateBillingAddressBeanList[0].status, message);
                    }
                    
                    
                }else{
                    //validate Shipping Address Error
                    String message;
                    if(validateShippingAddressBeanList[0].msgEntry.size() > 0){
                        if(validateShippingAddressBeanList[0].msgEntry[0].msgTxt != null){
                            message = validateShippingAddressBeanList[0].msgEntry[0].msgTxt;
                        }
                    }
                    if(message == null){
                        message = validateShippingAddressBeanList[0].message;
                    }
                    cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateShippingAddressBeanList[0].status, message);
                }
            }else{
                //validate Employers Address Error
                String message;
                if(validateEmployerAddressList[0].msgEntry.size() > 0){
                    if(validateEmployerAddressList[0].msgEntry[0].msgTxt != null){
                        message = validateEmployerAddressList[0].msgEntry[0].msgTxt;
                    }
                }
                if(message == null){
                    message = validateEmployerAddressList[0].message;
                }
                cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateEmployerAddressList[0].status, message);
            }
            
        }else{
            //cvsValidate Error
            cvsValidationBeanList[0].statusCode = 400;
            String message = '';
            
            if(cvsValidationBeanList[0].statusMessage != null){
                
                if(cvsValidationBeanList[0].statusMessage.errorObj != null){
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reason != null){
                        message += cvsValidationBeanList[0].statusMessage.errorObj.reason + ' ';
                    }
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reasonList != null){
                        for(String reason : cvsValidationBeanList[0].statusMessage.errorObj.reasonList){
                            message += reason + ' ';
                        }
                    }
                }
                if(cvsValidationBeanList[0].statusMessage.error != null){
                    for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsValidationBeanList[0].statusMessage.error){
                        if(error.reason != null){
                            message += error.reason + ' ';
                        }
                        if(error.reasonList != null){
                            for(String reason : error.reasonList){
                                message += reason + ' ';
                            }
                        }
                    }
                }
            }
            cvsValidationBeanList[0].message = message;
        }
        System.debug('CVS VALIDATE BEAN: ' + cvsValidationBeanList[0]);
        responseMap.put(cvsValidationBeanList[0], logList);
        return responseMap;
    }
    
    //TdB - W-004795 - CVS validation for Address only
    public static map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> validateMiniIndividual(Account accountP, List<Address__c> addressListP, Map<String, String> translationMapP, String clientTypeGroupP, String appliationP){
        System.debug('In validateMiniIndividual');        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> responseMap = new map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>>();
        CvsValidationService_Req_IB_v1 cvsValidateBean = new CvsValidationService_Req_IB_v1();
        
        cvsValidateBean = CvsValidationService_IU_v1.mapRBBMiniIndividualRequestFields(accountP, addressListP, clientTypeGroupP, translationMapP);
        
        System.debug(cvsValidateBean);
        //CvsValidationService
        map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> validateResponseMap = CvsValidationService_IH_v1.validateClientMap(cvsValidateBean, false);
        
        List<CvsValidationService_Resp_IB_v1> cvsValidationBeanList = new List<CvsValidationService_Resp_IB_v1>(validateResponseMap.keySet());
        logList.add(validateResponseMap.values()[0]);
        
        if(cvsValidationBeanList[0].statusCode == 200 && cvsValidationBeanList[0].valStatusCode == '0'){//Success = 0, Failure = 1
            
            //Validate Employers Address
            List<ValidateAddress_Resp_IB_v1> validateEmployerAddressList;
            
            for(Address__c add : addressListP){
                
                if(add.Shipping_Zip_Postal_Code__c != null){
                    
                    if(add.Address_Type__c == 'Employers'){
                        
                        List<String> streetList = add.Shipping_Street__c.split('\r\n');
                        String line1Employer;
                        String line2Employer;
                        if(streetList.size() > 0){
                            line1Employer = streetList[0];
                            if(streetList.size() > 1){
                                line2Employer = streetList[1];
                            }
                        }
                        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateEmployerAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 70, line1Employer, line2Employer, add.Shipping_Suburb__c, add.Shipping_City__c, String.valueOf(add.Shipping_Zip_Postal_Code__c));
                        validateEmployerAddressList = new List<ValidateAddress_Resp_IB_v1>(validateEmployerAddressMap.keySet());
                        logList.add(validateEmployerAddressMap.values()[0]);
                    }
                }
                
            }
            Boolean proceedToShippingAddress = false;
            if(validateEmployerAddressList != null){
                if(validateEmployerAddressList[0].statusCode == 200 && validateEmployerAddressList[0].nbrUserErrs == '0'){
                    proceedToShippingAddress = true;
                }
            }else{
                proceedToShippingAddress = true;
            }
            if(proceedToShippingAddress){
                //Validate Shipping Address
                List<ValidateAddress_Resp_IB_v1> validateShippingAddressBeanList;
                if(accountP.ShippingStreet != null){
                    List<String> streetListShipping = accountP.ShippingStreet.split('\r\n');
                    String line1Shipping;
                    String line2Shipping;
                    if(streetListShipping.size() > 0){
                        line1Shipping = streetListShipping[0];
                        if(streetListShipping.size() > 1){
                            line2Shipping = streetListShipping[1];
                        }
                    }
                    Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateShippingAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 10, line1Shipping, line2Shipping, null, accountP.ShippingCity, accountP.ShippingPostalCode);
                    validateShippingAddressBeanList = new List<ValidateAddress_Resp_IB_v1>(validateShippingAddressMap.keySet());
                    logList.add(validateShippingAddressMap.values()[0]); 
                }
                
                Boolean proceedToPostalAddress = false;
                if(validateShippingAddressBeanList != null){
                    if(validateShippingAddressBeanList[0].statusCode == 200 && validateShippingAddressBeanList[0].nbrUserErrs == '0'){
                        proceedToPostalAddress = true;
                    }
                }else{
                    proceedToPostalAddress = true;
                }
                if(proceedToPostalAddress){
                    //Validate Postal Address
                    List<ValidateAddress_Resp_IB_v1> validateBillingAddressBeanList;
                    if(accountP.BillingStreet != null){
                        List<String> streetListBilling = accountP.BillingStreet.split('\r\n');
                        String line1Postal;
                        String line2Postal;
                        if(streetListBilling.size() > 0){
                            line1Postal = streetListBilling[0];
                            if(streetListBilling.size() > 1){
                                line2Postal = streetListBilling[1];
                            }
                        }
                        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateBillingAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 10, line1Postal, line2Postal, null, accountP.BillingCity, accountP.BillingPostalCode);
                        validateBillingAddressBeanList = new List<ValidateAddress_Resp_IB_v1>(validateBillingAddressMap.keySet());
                        logList.add(validateBillingAddressMap.values()[0]);
                    }
                    
                    Boolean proceedToMapping = false;
                    if(validateBillingAddressBeanList != null){
                        if(validateBillingAddressBeanList[0].statusCode == 200 && validateBillingAddressBeanList[0].nbrUserErrs == '0'){
                            proceedToMapping = true;
                        }
                    }else{
                        proceedToMapping = true;
                    }
                    
                    if(proceedToMapping){
                        
                        //Get the Address returned from Validate Address and add it to the cvsValidation bean which is returned 
                        CvsValidationService_Resp_IB_v1.cls_addressCollection employersAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        CvsValidationService_Resp_IB_v1.cls_addressCollection shippingAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        CvsValidationService_Resp_IB_v1.cls_addressCollection billingAddressCollection = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        List<CvsValidationService_Resp_IB_v1.cls_addressCollection> addressCollectionList = new List<CvsValidationService_Resp_IB_v1.cls_addressCollection>();
                        
                        if(validateEmployerAddressList != null){
                            if(validateEmployerAddressList[0].addressCollection != null){
                                employersAddressCollection.addressType = validateEmployerAddressList[0].addressCollection[0].addressType;
                                employersAddressCollection.addressLine1 = validateEmployerAddressList[0].addressCollection[0].addressLine1;
                                employersAddressCollection.addressLine2 = validateEmployerAddressList[0].addressCollection[0].addressLine2;
                                employersAddressCollection.town = validateEmployerAddressList[0].addressCollection[0].town;
                                employersAddressCollection.suburb = validateEmployerAddressList[0].addressCollection[0].suburb;
                                employersAddressCollection.postalCode = validateEmployerAddressList[0].addressCollection[0].postalCode;
                                employersAddressCollection.addressTypeSF = 'Employers';
                                addressCollectionList.add(employersAddressCollection);
                            }
                        }
                        
                        if(validateShippingAddressBeanList != null){
                            if(validateShippingAddressBeanList[0].addressCollection != null){
                                shippingAddressCollection.addressType = validateShippingAddressBeanList[0].addressCollection[0].addressType;
                                shippingAddressCollection.addressLine1 = validateShippingAddressBeanList[0].addressCollection[0].addressLine1;
                                shippingAddressCollection.addressLine2 = validateShippingAddressBeanList[0].addressCollection[0].addressLine2;
                                shippingAddressCollection.town = validateShippingAddressBeanList[0].addressCollection[0].town;
                                shippingAddressCollection.suburb = validateShippingAddressBeanList[0].addressCollection[0].suburb;
                                shippingAddressCollection.postalCode = validateShippingAddressBeanList[0].addressCollection[0].postalCode;
                                shippingAddressCollection.addressTypeSF = 'Physical';
                                addressCollectionList.add(shippingAddressCollection);
                            }
                        }
                        
                        if(validateBillingAddressBeanList != null){
                            if(validateBillingAddressBeanList[0].addressCollection != null){
                                billingAddressCollection.addressType = validateBillingAddressBeanList[0].addressCollection[0].addressType;
                                billingAddressCollection.addressLine1 = validateBillingAddressBeanList[0].addressCollection[0].addressLine1;
                                billingAddressCollection.addressLine2 = validateBillingAddressBeanList[0].addressCollection[0].addressLine2;
                                billingAddressCollection.town = validateBillingAddressBeanList[0].addressCollection[0].town;
                                billingAddressCollection.suburb = validateBillingAddressBeanList[0].addressCollection[0].suburb;
                                billingAddressCollection.postalCode = validateBillingAddressBeanList[0].addressCollection[0].postalCode;
                                billingAddressCollection.addressTypeSF = 'Postal';
                                addressCollectionList.add(billingAddressCollection);
                            }
                        }
                        
                        cvsValidationBeanList[0].addressCollection = addressCollectionList;
                        cvsValidationBeanList[0].statusCode = 200;
                        cvsValidationBeanList[0].valStatusCode = '0';
                        
                    }else{
                        //Validate BillingAddress Error
                        String message;
                        if(validateBillingAddressBeanList[0].msgEntry.size() > 0){
                            if(validateBillingAddressBeanList[0].msgEntry[0].msgTxt != null){
                                message = validateBillingAddressBeanList[0].msgEntry[0].msgTxt;
                            }
                        }
                        if(message == null){
                            message = validateBillingAddressBeanList[0].message;
                        }
                        cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateBillingAddressBeanList[0].status, message);
                    }
                    
                    
                }else{
                    //validate Shipping Address Error
                    String message;
                    if(validateShippingAddressBeanList[0].msgEntry.size() > 0){
                        if(validateShippingAddressBeanList[0].msgEntry[0].msgTxt != null){
                            message = validateShippingAddressBeanList[0].msgEntry[0].msgTxt;
                        }
                    }
                    if(message == null){
                        message = validateShippingAddressBeanList[0].message;
                    }
                    cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateShippingAddressBeanList[0].status, message);
                }
            }else{
                //validate Employers Address Error
                String message;
                if(validateEmployerAddressList[0].msgEntry.size() > 0){
                    if(validateEmployerAddressList[0].msgEntry[0].msgTxt != null){
                        message = validateEmployerAddressList[0].msgEntry[0].msgTxt;
                    }
                }
                if(message == null){
                    message = validateEmployerAddressList[0].message;
                }
                cvsValidationBeanList[0] = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateEmployerAddressList[0].status, message);
            }
            
        }else{
            //cvsValidate Error
            cvsValidationBeanList[0].statusCode = 400;
            String message = '';
            
            if(cvsValidationBeanList[0].statusMessage != null){
                
                if(cvsValidationBeanList[0].statusMessage.errorObj != null){
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reason != null){
                        message += cvsValidationBeanList[0].statusMessage.errorObj.reason + ' ';
                    }
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reasonList != null){
                        for(String reason : cvsValidationBeanList[0].statusMessage.errorObj.reasonList){
                            message += reason + ' ';
                        }
                    }
                }
                if(cvsValidationBeanList[0].statusMessage.error != null){
                    for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsValidationBeanList[0].statusMessage.error){
                        if(error.reason != null){
                            message += error.reason + ' ';
                        }
                        if(error.reasonList != null){
                            for(String reason : error.reasonList){
                                message += reason + ' ';
                            }
                        }
                    }
                }
            }
            cvsValidationBeanList[0].message = message;
        }
        System.debug('CVS VALIDATE BEAN: ' + cvsValidationBeanList[0]);
        responseMap.put(cvsValidationBeanList[0], logList);
        return responseMap;
    }
    
    public static map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> validateBusiness(Account accountP, List<Address__c> addressListP, List<Account> relatedAccountListP, String primaryAccId, Map<String, String> translationMapP, String clientTypeGroupP){
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CvsValidationService_Req_IB_v1 requestBean;
        map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>> responseMap = new map<CvsValidationService_Resp_IB_v1,List<Sys_Log_Integration__c>>();
        CvsValidationService_Resp_IB_v1 responseBean = new CvsValidationService_Resp_IB_v1();
        List<CvsValidationService_Resp_IB_v1.cls_addressCollection> addressBeanList = new List<CvsValidationService_Resp_IB_v1.cls_addressCollection>();
        
        requestBean = CvsValidationService_IU_v1.mapBusinessRequestFields(accountP, relatedAccountListP, primaryAccId, addressListP, clientTypeGroupP, translationMapP);
        
        //CvsValidationService
        map<CvsValidationService_Resp_IB_v1,Sys_Log_Integration__c> validateResponseMap = CvsValidationService_IH_v1.validateClientMap(requestBean, false);
        
        List<CvsValidationService_Resp_IB_v1> cvsValidationBeanList = new List<CvsValidationService_Resp_IB_v1>(validateResponseMap.keySet());
        logList.add(validateResponseMap.values()[0]);
        System.debug(cvsValidationBeanList[0].statusCode);
        responseBean = cvsValidationBeanList[0];
        if(cvsValidationBeanList[0].statusCode == 200 && cvsValidationBeanList[0].valStatusCode == '0'){
            
            //For each Contact
            for(Account relatedAccount : relatedAccountListP){
                //Validate Billing Address
                List<ValidateAddress_Resp_IB_v1> validateAddressBeanList;
                if(relatedAccount.BillingStreet != null){
                    List<String> streetList = relatedAccount.BillingStreet.split('\r\n');
                    String line1;
                    String line2;
                    if(streetList.size() > 0){
                        line1 = streetList[0];
                        if(streetList.size() > 1){
                            line2 = streetList[1];
                        }
                    }
                    Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateAddressMap = ValidateAddress_IH_v1.validateAddressDetailsMap('E', 1, 10, line1, line2, null, relatedAccount.BillingCity, relatedAccount.BillingPostalCode);
                    validateAddressBeanList = new List<ValidateAddress_Resp_IB_v1>(validateAddressMap.keySet());
                    logList.add(validateAddressMap.values()[0]);
                }
                
                if(validateAddressBeanList != null){
                    //If Success
                    if(validateAddressBeanList[0].statusCode == 200 && validateAddressBeanList[0].nbrUserErrs == '0'){
                        //Add address returned to an address List
                        CvsValidationService_Resp_IB_v1.cls_addressCollection addressBean = new CvsValidationService_Resp_IB_v1.cls_addressCollection();
                        addressBean.accountSFId = String.valueOf(relatedAccount.Id);
                        addressBean.addressTypeSF = 'Billing';
                        addressBean.addressType = validateAddressBeanList[0].addressCollection[0].addressType;
                        addressBean.addressLine1 = validateAddressBeanList[0].addressCollection[0].addressLine1;
                        addressBean.addressLine2 = validateAddressBeanList[0].addressCollection[0].addressLine2;
                        addressBean.postalCode = validateAddressBeanList[0].addressCollection[0].postalCode;
                        addressBean.town = validateAddressBeanList[0].addressCollection[0].town;
                        addressBean.suburb = validateAddressBeanList[0].addressCollection[0].suburb;
                        addressBeanList.add(addressBean);
                        responseBean.statusCode = 200;
                        responseBean.valStatusCode = '0';
                    }else{
                        //If Failure - return a bad bean and stop the loop
                        String message;
                        if(validateAddressBeanList[0].msgEntry.size() > 0){
                            if(validateAddressBeanList[0].msgEntry[0].msgTxt != null){
                                message = validateAddressBeanList[0].msgEntry[0].msgTxt + '. For Account: ' + relatedAccount.FirstName + ' ' + relatedAccount.LastName + '. ';
                            }
                        }
                        if(message == null){
                            message = validateAddressBeanList[0].message + '. For Account: ' + relatedAccount.FirstName + ' ' + relatedAccount.LastName + '. ';
                        }
                        responseBean.statusCode = 400;
                        responseBean = CvsValidationService_IU_v1.mapFailedResponseFields(400, validateAddressBeanList[0].status, message);
                        break;
                    }
                }
                
            }
            //Add validated addresses to the response bean 
            responseBean.addressCollection = addressBeanList;
            System.debug('VALIDATE ADDRESS: ' + responseBean.addressCollection);
            
        }else{
            //cvsValidate Error
            responseBean.statusCode = 400;
            String message = '';
            
            if(cvsValidationBeanList[0].statusMessage != null){
                
                if(cvsValidationBeanList[0].statusMessage.errorObj != null){
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reason != null){
                        message += cvsValidationBeanList[0].statusMessage.errorObj.reason + ' ';
                    }
                    if(cvsValidationBeanList[0].statusMessage.errorObj.reasonList != null){
                        for(String reason : cvsValidationBeanList[0].statusMessage.errorObj.reasonList){
                            message += reason + ' ';
                        }
                    }
                }
                if(cvsValidationBeanList[0].statusMessage.error != null){
                    for(CvsValidationService_Resp_IB_v1.cls_Error error : cvsValidationBeanList[0].statusMessage.error){
                        if(error.reason != null){
                            message += error.reason + ' ';
                        }
                        if(error.reasonList != null){
                            for(String reason : error.reasonList){
                                message += reason + ' ';
                            }
                        }
                    }
                }
            }
            responseBean.message = message;
        }
        responseMap.put(responseBean, logList);
        system.debug('responseBean----'+responseBean);
        system.debug('responseBean.message----'+responseBean.message);
        system.debug('responseMap----'+responseMap);
        return responseMap;
    }
    
    public static map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> createClient(Account accountP, List<Account> relatedAccountListP, String primaryAccId, String applicationP, User userP, Map<String, String> translationMapP, CvsValidationService_Resp_IB_v1 cvsResponseBeanP, String recordTypeP, String branchP, List<String> nonCreditMarketIndP, List<String> creditMarketIndP){
        
        map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c> responseMap = new map<CreateClientCIF_Resp_IB_v1,Sys_Log_Integration__c>();
        CreateClientCIF_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), StringConstants.CI_Create_Client_V12);
            
            if(integrationSettings != null){
                
                //Map Fields
                CreateClientCIF_Req_IB_v1 requestBean; 
                if(recordTypeP == 'Individual Client'){
                    if(applicationP == 'RBB') {
                        requestBean = CreateClientCIF_IU_v1.mapRBBIndividualClientRequestFields(accountP, applicationP, userP, translationMapP, cvsResponseBeanP, branchP, nonCreditMarketIndP, creditMarketIndP);
                    } else if(applicationP == 'RBB Mini') {
                        applicationP = 'RBB';
                        requestBean = CreateClientCIF_IU_v1.mapRBBMiniIndividualClientRequestFields(accountP, applicationP, userP, translationMapP, cvsResponseBeanP, branchP, nonCreditMarketIndP, creditMarketIndP);
                    } else {
                        requestBean = CreateClientCIF_IU_v1.mapIndividualClientRequestFields(accountP, applicationP, userP, translationMapP, cvsResponseBeanP, branchP, nonCreditMarketIndP, creditMarketIndP);
                    }
                    
                }else if(recordTypeP == 'Business Client'){
                    requestBean = CreateClientCIF_IU_v1.mapBusinessClientRequestFields(accountP, relatedAccountListP, primaryAccId, applicationP, userP, translationMapP, cvsResponseBeanP, branchP, nonCreditMarketIndP, creditMarketIndP);
                }else if(recordTypeP == 'Business Prospect'){
                    requestBean = CreateClientCIF_IU_v1.mapBusinessProspectClientRequestFields(accountP, relatedAccountListP, primaryAccId, applicationP, userP, translationMapP, cvsResponseBeanP, branchP, nonCreditMarketIndP, creditMarketIndP);
                } 
                
                CreateClientJsonGenerator cj = new CreateClientJsonGenerator();
                System.debug('requestBean '+requestBean);
                String jsonString = cj.toString(requestBean);
                
                System.debug('jsonString '+jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                //Send Request
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_CLIENT_CIF + recordTypeP, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                //Map Response
                responseBean = CreateClientCIF_IU_v1.mapResponseFields(response);
                
                if(response.getStatusCode() == 200){
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_CLIENT_CIF + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
                
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateClientCIF_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        responseMap.put(responseBean, log);
        return responseMap;
    }
    
    //Individual Account
    public static Map<String, String> getTranslations(Account accountP, List<Address__c> addressListP){
        
        Map<String, String> tanslationValueMap = new Map<String, String>();
        String message = '';
        
        //Field value translations
        String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type Group', accountP.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String genderTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Gender', accountP.Gender__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);	//Masechaba changed back to pc field 14112020
        if(accountP.ID_Type__pc == null || accountP.ID_Type__pc == '') {
            idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountP.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        }
        String comLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountP.Communication_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String maritalContractTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Contract Type', accountP.Marital_Contract_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Status', accountP.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String nonCreditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Non-Credit Marketing Consent', accountP.Non_Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String creditMarketConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Credit Marketing Consent', accountP.Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String occupaionCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', accountP.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, accountP.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String occupationLevelTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Level' , accountP.Occupation_Level__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountP.Preferred_Communication_Method__pc, StringConstants.OUTBOUND_RECORD_TYPE);//update variable to prefcom...
        String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String homeLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountP.Home_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Origin__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfRegistrationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        
        String billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.BillingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.ShippingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryIssueTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        String employerCountryTranslated;
        // String billCountryTranslated;
        //String shipCountryTranslated;
        for(Address__c add : addressListP){
            if(add.Address_Type__c == 'Employers' && add.Account__c == accountP.Id){
                employerCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            }
            if(add.Address_Type__c == 'Postal' && add.Account__c == accountP.Id){
                //billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            }
            if(add.Address_Type__c == 'Physical Address' && add.Account__c == accountP.Id){
                // shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            } 
        }
        String personTitleTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Title', accountP.PersonTitle, StringConstants.OUTBOUND_RECORD_TYPE);
        String incomeGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Monthly Income', accountP.Monthly_Income__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        //IF Status is : Housewife, Student, Unemployed, Pensioner or Pre-School/Scholar
        if(occupationStatusTranslated == '4' || occupationStatusTranslated == '5' || occupationStatusTranslated == '6' || occupationStatusTranslated == '7' || occupationStatusTranslated == '10'){
            occupaionCodeTranslated = '0';
        }
        if(comLanguageTranslated != null && personTitleTranslated != null){
            
            //Add the value translations to a map
            tanslationValueMap.put('nationalityTranslated', nationalityTranslated);
            tanslationValueMap.put('clientTypeTranslated', clientTypeTranslated);
            tanslationValueMap.put('clientTypeGroupTranslated', clientTypeGroupTranslated);
            tanslationValueMap.put('countryOfBirthTranslated', countryOfBirthTranslated);
            tanslationValueMap.put('genderTranslated', genderTranslated);
            tanslationValueMap.put('idTypeTranslated', idTypeTranslated);
            tanslationValueMap.put('comLanguageTranslated', comLanguageTranslated);
            tanslationValueMap.put('maritalContractTranslated', maritalContractTranslated);
            tanslationValueMap.put('maritalStatusTranslated', maritalStatusTranslated);
            tanslationValueMap.put('nonCreditMarketConsentTranslated', nonCreditMarketConsentTranslated);
            tanslationValueMap.put('creditMarketConsentTranslated', creditMarketConsentTranslated);
            tanslationValueMap.put('occupaionCodeTranslated', occupaionCodeTranslated);
            tanslationValueMap.put('occupationStatusTranslated', occupationStatusTranslated);
            tanslationValueMap.put('occupationLevelTranslated', occupationLevelTranslated);
            tanslationValueMap.put('comMethodTranslated', comMethodTranslated);
            tanslationValueMap.put('personTitleTranslated', personTitleTranslated);
            tanslationValueMap.put('billCountryTranslated', billCountryTranslated);
            tanslationValueMap.put('shipCountryTranslated', shipCountryTranslated);
            tanslationValueMap.put('employerCountryTranslated', employerCountryTranslated);
            tanslationValueMap.put('incomeSourceTranslated', incomeSourceTranslated);
            tanslationValueMap.put('homeLanguageTranslated', homeLanguageTranslated);
            tanslationValueMap.put('incomeGroupTranslated', incomeGroupTranslated);
            tanslationValueMap.put('countryOfOriginTranslated', countryOfOriginTranslated);
            tanslationValueMap.put('countryOfRegistrationTranslated', countryOfRegistrationTranslated);
            tanslationValueMap.put('countryIssueTranslated', countryIssueTranslated);
            
        }else{
            if(comLanguageTranslated == null){
                message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COMMUNICATION_LANGUAGE + accountP.Communication_Language__pc + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
            }
            if(personTitleTranslated == null){
                message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_TITLE + accountP.PersonTitle + ' for Account: ' + accountP.FirstName + ' ' + accountP.LastName + '. ';
            }
        }
        if(message != ''){
            tanslationValueMap.put('ERROR', message);
            
        }
        System.debug('tanslationValueMap: ' + tanslationValueMap);
        return tanslationValueMap;
    }
    
    //Joint Account & Person Accounts(Related Parties)
    public static Map<String, String> getTranslations(Account accountP, List<Account> relatedAccountListP, List<Address__c> addressListP){
        
        Map<String, String> tanslationValueMap = new Map<String, String>();
        String message = '';
        
        /****** JOINT ACCOUNT ******/
        //Field value translations
        String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String genderTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Gender', accountP.Gender__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String comLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', accountP.Communication_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String maritalContractTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Contract Type', accountP.Marital_Contract_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Status', accountP.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String marketingConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Non-Credit Marketing Consent', accountP.Non_Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String occupaionCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', accountP.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, accountP.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountP.Preferred_Communication_Method__pc, StringConstants.OUTBOUND_RECORD_TYPE);//update variable to prefcom...
        String countryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Origin__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfRegistrationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        
        String billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.BillingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.ShippingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryIssueTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        String employerCountryTranslated;
        //String billCountryTranslated;
        //String shipCountryTranslated;
        for(Address__c add : addressListP){
            if(add.Address_Type__c == 'Employers' && add.Account__c == accountP.Id){
                employerCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            }
            if(add.Address_Type__c == 'Postal' && add.Account__c == accountP.Id){
                //billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            }
            if(add.Address_Type__c == 'Physical Address' && add.Account__c == accountP.Id){
                //shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
            } 
        }
        
        //if(comLanguageTranslated != null){
        
        //Add the value translations to a map
        tanslationValueMap.put('nationalityTranslated', nationalityTranslated);
        tanslationValueMap.put('clientTypeTranslated', clientTypeTranslated);
        tanslationValueMap.put('countryOfBirthTranslated', countryOfBirthTranslated);
        tanslationValueMap.put('genderTranslated', genderTranslated);
        tanslationValueMap.put('idTypeTranslated', idTypeTranslated);
        tanslationValueMap.put('comLanguageTranslated', comLanguageTranslated);
        tanslationValueMap.put('maritalContractTranslated', maritalContractTranslated);
        tanslationValueMap.put('maritalStatusTranslated', maritalStatusTranslated);
        tanslationValueMap.put('marketingConsentTranslated', marketingConsentTranslated);
        tanslationValueMap.put('occupaionCodeTranslated', occupaionCodeTranslated);
        tanslationValueMap.put('occupationStatusTranslated', occupationStatusTranslated);
        tanslationValueMap.put('comMethodTranslated', comMethodTranslated);
        tanslationValueMap.put('billCountryTranslated', billCountryTranslated);
        tanslationValueMap.put('shipCountryTranslated', shipCountryTranslated);
        tanslationValueMap.put('employerCountryTranslated', employerCountryTranslated);
        tanslationValueMap.put('countryOfOriginTranslated', countryOfOriginTranslated);
        tanslationValueMap.put('countryOfRegistrationTranslated', countryOfRegistrationTranslated);
        tanslationValueMap.put('countryIssueTranslated', countryIssueTranslated);
        
        /*}else{
if(comLanguageTranslated == null){
message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COMMUNICATION_LANGUAGE + accountP.Communication_Language__pc + ' for Account: ' + accountP.Name + '. ';
}
}*/
        
        /****** PERSON ACCOUNTS (CONTACTS) ******/
        
        for(Account relatedAccount : relatedAccountListP){
            //Field value translations
            nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, 'Nationality', relatedAccount.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', relatedAccount.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            genderTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Gender', relatedAccount.Gender__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Identity Type', relatedAccount.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            comLanguageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Language', relatedAccount.Communication_Language__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            maritalContractTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Contract Type', relatedAccount.Marital_Contract_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Marital Status', relatedAccount.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            marketingConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Non-Credit Marketing Consent', relatedAccount.Non_Credit_Marketing_Consent__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            occupaionCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Occupation Category', relatedAccount.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, relatedAccount.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            comMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', relatedAccount.Preferred_Communication_Method__pc, StringConstants.OUTBOUND_RECORD_TYPE);//update variable to prefcom...
            String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, relatedAccount.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String personTitleTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Title', relatedAccount.PersonTitle, StringConstants.OUTBOUND_RECORD_TYPE);
            String billingCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', relatedAccount.BillingCountry, StringConstants.OUTBOUND_RECORD_TYPE);
            countryIssueTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', relatedAccount.CountryPassport__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
            
            System.debug(comLanguageTranslated + ' ' + relatedAccount.Communication_Language__pc);
            for(Address__c add : addressListP){
                if(add.Address_Type__c == 'Employers' && add.Account__c == relatedAccount.Id){
                    employerCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
                if(add.Address_Type__c == 'Postal' && add.Account__c == relatedAccount.Id){
                    //billCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
                if(add.Address_Type__c == 'Physical Address' && add.Account__c == relatedAccount.Id){
                    //shipCountryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', add.Shipping_Country__c, StringConstants.OUTBOUND_RECORD_TYPE);
                } 
            }
            
            System.debug(comLanguageTranslated + ' ' + relatedAccount.Communication_Language__pc);
            System.debug(personTitleTranslated + ' ' + relatedAccount.PersonTitle);
            System.debug(comMethodTranslated + ' ' + relatedAccount.Preferred_Communication_Method__pc);
            
            //IF Status is : Housewife, Student, Unemployed, Pensioner or Pre-School/Scholar
            if(occupationStatusTranslated == '4' || occupationStatusTranslated == '5' || occupationStatusTranslated == '6' || occupationStatusTranslated == '7' || occupationStatusTranslated == '10'){
                occupaionCodeTranslated = '0';
            }
            
            if(comLanguageTranslated != null && personTitleTranslated != null){
                System.debug('Putting them in the map');
                
                //Add the value translations to a map
                tanslationValueMap.put('nationalityTranslated' + relatedAccount.Id, nationalityTranslated);
                tanslationValueMap.put('countryOfBirthTranslated' + relatedAccount.Id, countryOfBirthTranslated);
                tanslationValueMap.put('genderTranslated' + relatedAccount.Id, genderTranslated);
                tanslationValueMap.put('idTypeTranslated' + relatedAccount.Id, idTypeTranslated);
                tanslationValueMap.put('comLanguageTranslated' + relatedAccount.Id, comLanguageTranslated);
                tanslationValueMap.put('maritalContractTranslated' + relatedAccount.Id, maritalContractTranslated);
                tanslationValueMap.put('maritalStatusTranslated' + relatedAccount.Id, maritalStatusTranslated);
                tanslationValueMap.put('marketingConsentTranslated' + relatedAccount.Id, marketingConsentTranslated);
                tanslationValueMap.put('occupaionCodeTranslated' + relatedAccount.Id, occupaionCodeTranslated);
                tanslationValueMap.put('occupationStatusTranslated' + relatedAccount.Id, occupationStatusTranslated);
                tanslationValueMap.put('comMethodTranslated' + relatedAccount.Id, comMethodTranslated);
                tanslationValueMap.put('personTitleTranslated' + relatedAccount.Id, personTitleTranslated);
                tanslationValueMap.put('incomeSourceTranslated' + relatedAccount.Id, incomeSourceTranslated);
                tanslationValueMap.put('billingCountryTranslated' + relatedAccount.Id, billingCountryTranslated);
                tanslationValueMap.put('countryIssueTranslated' + relatedAccount.Id, countryIssueTranslated);
                
            }else{
                if(comLanguageTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_COMMUNICATION_LANGUAGE + relatedAccount.Communication_Language__pc + ' for Account: ' + relatedAccount.FirstName + ' ' + relatedAccount.LastName + '. ';
                }
                if(personTitleTranslated == null){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_TITLE_CONTACT + relatedAccount.PersonTitle + ' for Account: ' + relatedAccount.FirstName + ' ' + relatedAccount.LastName + '. ';
                }
            }
        }
        System.debug(tanslationValueMap.get('comLanguageTranslated' + relatedAccountListP[0].Id));
        System.debug(tanslationValueMap.keySet());
        if(message != ''){
            tanslationValueMap.put('ERROR', message);
            
        }
        System.debug('tanslationValueMap: ' + tanslationValueMap);
        return tanslationValueMap;
    }
}