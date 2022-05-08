/**
* Integration Handler for Create Opportunity function
* @author Danie Booysen and Jason Quevauvilliers
* @created 2019-07-29
*/
public class CreateOpportunity_IH_v2 {

    /* Create Opportunity in SF
     * @param: CreateOpportunity_Req_IB_v1 instance / JSON String
     * @param: Transaction Id Header
     * @param: Initiator Header
     * @param: Sender Header
     * @return: CreateOpportunity_Resp_IB_v1 object*/
    public static CreateOpportunity_Resp_IB_v1 createOpportunity(CreateOpportunity_Req_IB_v1 wrpVals, String transactionIdP, String initiatorP, String senderP){
        
        CreateOpportunity_Resp_IB_v1 responseBean;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        System.debug('Method CreateOpportunity');
        
        Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(String.valueOf(wrpVals), 'CreateOpportunity_IH_v2.createOpportunity', null, StringConstants.SALESFORCE_STRING);
        log = SystemLogger.mapAuditFields(log, transactionIdP, initiatorP, senderP);
        
        try{
            //Validate that all the required parameters were sent
            //String errorMessage = wrpVals.validate();
            String errorMessage = '';
            if(String.isBlank(errorMessage)){
                
                //Try set the owner of the account to the advisor by BRID number
                List<User> advisorUsers = new UsersSelector().selectByBridNumber(wrpVals.adviserBRID);
                
                //Check if User Exists
                if(advisorUsers.size() == 1){
                    
                    String docType = wrpVals.clientIdType == 'SA Identity Document' ? '1' : '3';
                    //SUCCESS
                    Map<GetClientDetailsByIdCIF_Resp_IB_v1, Sys_Log_Integration__c> getClientDetailsByIdMap = GetClientDetailsByIdCIF_IH_v1.getClientDetailsMap(wrpVals.clientIdNumber, docType, '3456');//Awaitng the site code mapping
                    getClientDetailsByIdMap.values()[0].Method_Name__c = '1. ' + getClientDetailsByIdMap.values()[0].Method_Name__c;
                    logList.add(getClientDetailsByIdMap.values()[0]);
                    List<GetClientDetailsByIdCIF_Resp_IB_v1> getClientDetailsByIdList = new List<GetClientDetailsByIdCIF_Resp_IB_v1>(getClientDetailsByIdMap.keySet());
                    //Assign the Bean
                    GetClientDetailsByIdCIF_Resp_IB_v1 getClientDetailsByIdResponseBean = getClientDetailsByIdList[0];
                    System.debug('GetClientDetails: ' + getClientDetailsByIdResponseBean.statusCode + ' message: ' + getClientDetailsByIdResponseBean.message + 
                                 '. Nbr of Records found: ' + getClientDetailsByIdResponseBean.nbrEntsRetrieved);
                    
                    if(getClientDetailsByIdResponseBean.statusCode == 200 && getClientDetailsByIdResponseBean.nbrEntsRetrieved != '0'){
                        System.debug('Client Type: ' + wrpVals.clientType);
                        
                        if(wrpVals.clientType == 'Individual'){
                            //INDIVIDUAL
                            Integer individualCounter = 0;
                            String cifKey = '';
                            for(GetClientDetailsByIdCIF_Resp_IB_v1.cls_tblEntry entry : getClientDetailsByIdResponseBean.tblEntry){
                                
                                if(entry.cifClntGroup == 'I'){
                                    individualCounter++;
                                    cifKey = entry.cifKey;
                                } 
                            }
                            System.debug('individualCounter: ' + individualCounter);
                            if(individualCounter == 1){
                                // One Individual
                                AccountCreate_CIF_MDM.GIPResponse createAccountResponse = AccountCreate_CIF_MDM.createAccountFromCIF(cifKey, '0', '3456');//Awaitng the site code mapping
                                
                                if(createAccountResponse.response == 'Success'){
                                    System.debug('Create Account Individual CIF Method returned Success');
                                    //Account & Address was Created
                                    //Create Opportunity and Task
                                     Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> oppCreateRespToLogMap = createOpportunityAndTask(createAccountResponse.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                                    List<CreateOpportunity_Resp_IB_v1> oppRespList = new List<CreateOpportunity_Resp_IB_v1>(oppCreateRespToLogMap.keySet());
                                    responseBean = oppRespList[0];
                                    logList.add(oppCreateRespToLogMap.values()[0]);
                                    System.debug(responseBean.description);
                                    //Do CASAScreening
                                    doCasaScreeining(responseBean.opportunityId);
                                }else{
                                    //Create Account Error in AccountCreate_CIF_MDM
                                    //Should we create an Opportunity and Task?
                                    //Map bad response bean
                                    //Create Bad Log
                                    String message = 'Create Account Individual CIF Method returned Error: ' + createAccountResponse.response;
                                    logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                                    responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                                    System.debug(message);
                                }
                            }else{
                                System.debug(individualCounter + ' Individuals Found With Type I');
                                // Call MDM with ID Number - createAccountFromMDM
                                AccountCreate_CIF_MDM.GIPResponse createAccountResponse = AccountCreate_CIF_MDM.createAccountFromMDM('SAID', wrpVals.clientIdNumber);
                                
                                if(createAccountResponse.response == 'Success'){
                                    System.debug('Create Account Individual MDM Method returned Success');
                                    //Account & Address was Created
                                    //Create Opportunity and Task
                                    Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> oppCreateRespToLogMap = createOpportunityAndTask(createAccountResponse.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                                    List<CreateOpportunity_Resp_IB_v1> oppRespList = new List<CreateOpportunity_Resp_IB_v1>(oppCreateRespToLogMap.keySet());
                                    responseBean = oppRespList[0];
                                    logList.add(oppCreateRespToLogMap.values()[0]);
                                    System.debug(responseBean.description);
                                    //Do CASAScreening
                                    doCasaScreeining(responseBean.opportunityId);
                                }else{
                                    //Create Account Error in AccountCreate_CIF_MDM
                                    //Should we create an Opportunity and Task?
                                    //Map bad response bean
                                    //Create Bad Log
                                    String message = 'Create Account Individual MDM Method returned Error: ' + createAccountResponse.response;
                                    logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                                    responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                                    System.debug(message);
                                }
                            }
                        }else if(wrpVals.clientType == 'Joint & Several'){
                            //JOINT
                            Integer jointCounter = 0;
                            String cifKey = '';
                            for(GetClientDetailsByIdCIF_Resp_IB_v1.cls_tblEntry entry : getClientDetailsByIdResponseBean.tblEntry){
                                
                                if(entry.cifClntGroup == 'J'){
                                    jointCounter++;
                                    cifKey = entry.cifKey;
                                } 
                            }
                            System.debug('jointCounter: ' + jointCounter);
                            if(jointCounter == 1){
                                // One Joint
                                AccountCreate_CIF_MDM.GIPResponse createAccountResponse = AccountCreate_CIF_MDM.createAccountFromCIF(cifKey, '0', '3456');//Awaitng the site code mapping
                                
                                if(createAccountResponse.response == 'Success'){
                                    System.debug('Create Account Joint CIF Method returned Success');
                                    //Account & Address was Created
                                    //Create Opportunity and Task
                                    Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> oppCreateRespToLogMap = createOpportunityAndTask(createAccountResponse.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                                    List<CreateOpportunity_Resp_IB_v1> oppRespList = new List<CreateOpportunity_Resp_IB_v1>(oppCreateRespToLogMap.keySet());
                                    responseBean = oppRespList[0];
                                    logList.add(oppCreateRespToLogMap.values()[0]);
                                    System.debug(responseBean.description);
                                    //Do CASAScreening
                                    doCasaScreeining(responseBean.opportunityId);
                                    
                                }else{
                                    System.debug('Create Account Joint CIF Method returned Error: ' + createAccountResponse.response);
                                    AccountCreate_CIF_MDM.GIPResponse createAccountResponseMDM = AccountCreate_CIF_MDM.createAccountFromMDM('CIF', cifKey);
                                    
                                    if(createAccountResponseMDM.response == 'Success'){
                                        System.debug('Create Account Joint MDM Method returned Success');
                                        //Account & Address was Created
                                        //Create Opportunity and Task
                                        Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> oppCreateRespToLogMap = createOpportunityAndTask(createAccountResponseMDM.accountId, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                                        List<CreateOpportunity_Resp_IB_v1> oppRespList = new List<CreateOpportunity_Resp_IB_v1>(oppCreateRespToLogMap.keySet());
                                        responseBean = oppRespList[0];
                                        logList.add(oppCreateRespToLogMap.values()[0]);
                                        System.debug(responseBean.description);
                                        //Do CASAScreening
                                        doCasaScreeining(responseBean.opportunityId);
                                        
                                    }else{
                                        //Create Account Error in AccountCreate_CIF_MDM
                                        //Map bad response bean
                                        //Create Bad Log
                                        String message = 'Create Account Joint MDM Method returned Error: ' + createAccountResponseMDM.response;
                                        logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                                        responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                                        System.debug(message);
                                    }
                                }
                            }else{
                                System.debug(jointCounter + ' Joint Accounts found with type J');
                                // Create Opportunity and Task
                                Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> oppCreateRespToLogMap = createOpportunityAndTask(null, wrpVals, transactionIdP, initiatorP, senderP, advisorUsers[0]);
                                List<CreateOpportunity_Resp_IB_v1> oppRespList = new List<CreateOpportunity_Resp_IB_v1>(oppCreateRespToLogMap.keySet());
                                responseBean = oppRespList[0];
                                logList.add(oppCreateRespToLogMap.values()[0]);
                                System.debug(responseBean.description);
                            }
                        }else{
                            //Invalid Client Type
                            String message = 'Invalid Client Type: ' + wrpVals.clientType;
                            logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                            responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                            System.debug(message);
                        }
                    }else{
                        //Get Client Details By ID Error
                        System.debug('GetClientDetailsById ERROR. Logs already Inserted');
                        responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(getClientDetailsByIdResponseBean.status, getClientDetailsByIdResponseBean.statusCode, getClientDetailsByIdResponseBean.message, null);
                        System.debug(getClientDetailsByIdResponseBean.message);
                    }
                    
                }else if(advisorUsers.size() == 0){
                    //no user found - return bad response 
                    String message = StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_NONE + wrpVals.adviserBRID;
                    logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                    responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                    System.debug(message);
                }else{
                    //multiple users found - return bad response 
                    String message = StringConstants.ERROR_MSG_COULD_NOT_CREATE_ACC_FROM_BRID_MULTIPLE + wrpVals.adviserBRID;
                    logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
                    responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
                    System.debug(message);
                }
            }else{
                //Validation Error
                logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, errorMessage));
                responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_400, 400, errorMessage, null);
                System.debug(errorMessage);
            }
        }catch(Exception e){
            //return bad response
            String message = StringConstants.ERROR_MSG_COULD_NOT_CREATE_RECORD + e.getMessage() + '. ' + e.getStackTraceString();
            logList.add(SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message));
            responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
            System.debug(message);
        }
        
        log = SystemLogger.mapResponseFields(log, responseBean.statusCode, responseBean.status, String.valueOf(responseBean));
        logList.add(log);
        
        insert logList;
        
        return responseBean;
    }  
    
    private static Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> createOpportunityAndTask(Id accountIdP, CreateOpportunity_Req_IB_v1 wrpValsP, String transactionIdP, String initiatorP, String senderP, User advisorUserP){
        
        Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c> responseMap = new Map<CreateOpportunity_Resp_IB_v1,Sys_Log_Integration__c>();
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        CreateOpportunity_Resp_IB_v1 responseBean = new CreateOpportunity_Resp_IB_v1();
        String message = '';
        
        try{
            Opportunity opp = CreateOpportunity_IU_v2.mapOpportunityFields(accountIdP, wrpValsP, transactionIdP, initiatorP, senderP, advisorUserP);
            insert opp;
            
            Task task = CreateOpportunity_IU_v2.mapTaskFields(wrpValsP);
            task.WhatId = opp.Id;
            task.OwnerId = advisorUserP.Id;
            insert task;
            
            message = 'Opportunity and Task were Created.';
            
            log = SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunityAndTask', StringConstants.SALESFORCE_STRING, 200, StringConstants.INTEGRATION_STATUS_SUCCESS, message);
            responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_200, 200, message, opp.Id);
            
        }catch(Exception e){
            message = e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog('CreateOpportunity_IH_v2.createOpportunity', StringConstants.SALESFORCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateOpportunity_IU_v2.mapCreateOpportunityResponseFields(StringConstants.STATUS_CODE_500, 500, message, null);
        }
        System.debug(message);
        responseMap.put(responseBean, log);
        
        return responseMap;
    }
    
    @future(callout=true)
    public static void doCasaScreeining(Id oppId) {  
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(oppId);
    }    
}