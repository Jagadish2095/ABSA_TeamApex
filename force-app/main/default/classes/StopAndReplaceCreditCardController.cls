/*
* Extension Controller for LostReplaceCreditCard Component
*
* @author  Madhava Palla : Absa
* @version v1.0
* @since   2019-10-16
*
*/

public class StopAndReplaceCreditCardController {
    
    
    /**
* This method takes CIF code of client 
* and returns result of wrapper class which contains all plastic card details, transcation details specifc to the each account number
* 
* */
    
    
    @auraEnabled 
    Public Static String  getCardDetails(String clientcd){
        System.debug('========>'+clientcd);
        Map<string,List<StopaAndReplaceCardsWrapper>> accProdTypeWithTransactionDetailsMap = new Map<String,List<StopaAndReplaceCardsWrapper>>();
        Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accNoMapToReponseWrapper = new  Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();//Store all account details to client
        List<StopaAndReplaceCardsWrapper> wrapperListToShow = new List<StopaAndReplaceCardsWrapper>();
        List<Sys_Log_Integration__c> logsTobeInserted = new List<Sys_Log_Integration__c>();
        Set<ID> accIdSet = new Set<ID>();
        accIdSet.add((ID)clientcd);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet);
        system.debug('==accountList===>'+accountList);
        system.debug('==accountList[0].cif__c===>'+accountList[0].cif__c);
        try{
            
            if(!accountList.isEmpty() && accountList[0].cif__c != null){
                
                // Get all accounts related to the client
                Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseBeanMap= CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(StringConstants.SALESFORCE_STRING,accountList[0].cif__c);   
                CIgetAcctLinkedToClientCode_Resp_IB_v1 accDetailsObjResp = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>((responseBeanMap.keySet())))[0]; //response from service
                
                //add logs to INSERT List
                if(responseBeanMap.get(accDetailsObjResp) != null){
                    logsTobeInserted.addAll(responseBeanMap.get(accDetailsObjResp));
                }
                
                
                if(accDetailsObjResp != null){
                    
                    if(accDetailsObjResp.statusCode == 200){
                        
                        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accDetailsList = accDetailsObjResp.cip047o.outputTable;
                        
                        for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accDetailsList){
                            
                            if(accWrObj.productType =='CA' && accWrObj.status =='ACTIVE' ){ // ADD CONDITION FOR STATUS
                                accNoMapToReponseWrapper.put(accWrObj.oaccntnbr,accWrObj);
                            }
                        }
                       
                    }else if(accDetailsObjResp.statusCode == 500){
                        accProdTypeWithTransactionDetailsMap.put(StringConstants.Sevice500InternalErrorMessage,null);
                    }
                    
                    // To get all plastic cards related to all accounts 
                    // CAgetAccountDetails_Resp_IB_v1 responseBean;
                    
                    if(accNoMapToReponseWrapper != null){
                        accProdTypeWithTransactionDetailsMap = callGetAccountDetailsService(accNoMapToReponseWrapper,logsTobeInserted);
                        
                    }
                }
            }else{
                accProdTypeWithTransactionDetailsMap.put(StringConstants.NoCIFKeyPresentForAccount,null); 
                system.debug('*******No CIF Key****'+clientcd);
            }
        }catch(Exception e){
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();  
            throw new AuraHandledException('Error:'+message);
        }
        system.debug('***accProdTypeWithTransactionDetailsMap***'+accProdTypeWithTransactionDetailsMap);
        If(accProdTypeWithTransactionDetailsMap.isEmpty()){//Show error no active cards error message
            system.debug('****inside****');
            accProdTypeWithTransactionDetailsMap.put(StringConstants.NoActiveCardsPresentForClient,null); 
            
        }
        system.debug('***jsonOutput***'+json.serialize(accProdTypeWithTransactionDetailsMap));
        return json.serialize(accProdTypeWithTransactionDetailsMap);
    }
    
    
    /**
* This method takes account numbers infromation from CIgetacctLinkedToclientCode service and system logs
* and returns result of wrapper class which contains all plastic card details, transcation details specifc to the each account number
* 
* */
    
    Public Static Map<String,List<StopaAndReplaceCardsWrapper>> callGetAccountDetailsService(Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accNoMapToReponseWrapper,List<Sys_Log_Integration__c> logsTobeInserted){
        
        Map<string,List<StopaAndReplaceCardsWrapper>> accProdTypeWithTransactionDetailsMap = new Map<String,List<StopaAndReplaceCardsWrapper>>();
        for(string accNo : accNoMapToReponseWrapper.keyset()){
            
            Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>>  getAllCardDetailsResponseMap =CAgetAccountDetails_IH_v1.CAgetAccountDetails(accNo);
            CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>((getAllCardDetailsResponseMap.keySet())))[0]; //response from service
            
            //add logs to INSERT List
            if(getAllCardDetailsResponseMap.get(responseBean) != null){
                logsTobeInserted.addAll(getAllCardDetailsResponseMap.get(responseBean));
            }
            
            if(responseBean !=null){
                
                if(responseBean.statusCode == 200){
                    
                    CAgetAccountDetails_Resp_IB_v1.CAgetAccountDetailsV2Response caGetAccountDetailsV2Response = responseBean.CAgetAccountDetailsV2Response;
                    CAgetAccountDetails_Resp_IB_v1.Cas095o Cas095oWrapper = caGetAccountDetailsV2Response.Cas095o;
                    List<CAgetAccountDetails_Resp_IB_v1.AcctPlasNumbers> plasticAccDetailsList = Cas095oWrapper.AcctPlasNumbers;
                    // List<CAgetAccountDetails_Resp_IB_v1.TxnLn> transactionsList = Cas095oWrapper.TxnLn;
                    
                    for(CAgetAccountDetails_Resp_IB_v1.AcctPlasNumbers  plasticAccDetail : plasticAccDetailsList){
                        
                        if(accNo.contains(plasticAccDetail.pdPlasNbr)){
                            StopaAndReplaceCardsWrapper wrapperRec= new StopaAndReplaceCardsWrapper();
                            List<StopaAndReplaceCardsWrapper.TransactionsDetails> transList = new List<StopaAndReplaceCardsWrapper.TransactionsDetails>();
                            List<StopaAndReplaceCardsWrapper.PlasticCardDetils> plasList = new List<StopaAndReplaceCardsWrapper.PlasticCardDetils>();
                            StopaAndReplaceCardsWrapper.PlasticCardDetils plasDet = new StopaAndReplaceCardsWrapper.PlasticCardDetils();
                            plasDet.plasticCardHolderName = plasticAccDetail.tdEmbNmLn1;
                            plasDet.plasticCardNumber = plasticAccDetail.pdPlasNbr;
                            plasList.add(plasDet);
                            
                            for(CAgetAccountDetails_Resp_IB_v1.TxnLn transObj:Cas095oWrapper.TxnLn){
                                StopaAndReplaceCardsWrapper.TransactionsDetails transDet = new StopaAndReplaceCardsWrapper.TransactionsDetails();
                                transDet.transactionAmount = transObj.dt1TxnAmt;
                                transDet.transactionDescription = transObj.dt1TxnDesc;
                                transList.add(transDet);
                            }
                            
                            wrapperRec.plasticCardsList = plasList;
                            wrapperRec.transcactionList = transList;
                            wrapperRec.productName = accNoMapToReponseWrapper.get(accNo).product;
                            wrapperRec.productType = accNoMapToReponseWrapper.get(accNo).productType;
                            wrapperRec.plasticCardNum = plasticAccDetail.pdPlasNbr;
                            
                            if(accProdTypeWithTransactionDetailsMap.containsKey(accNoMapToReponseWrapper.get(accNo).product)){
                                List<StopaAndReplaceCardsWrapper>  tempList =accProdTypeWithTransactionDetailsMap.get(accNoMapToReponseWrapper.get(accNo).product);
                                tempList.add(wrapperRec);
                                accProdTypeWithTransactionDetailsMap.put(accNoMapToReponseWrapper.get(accNo).product,tempList);
                            }else{
                                accProdTypeWithTransactionDetailsMap.put(accNoMapToReponseWrapper.get(accNo).product,new List<StopaAndReplaceCardsWrapper>{wrapperRec}); 
                            }
                            
                        }
                    }
                }else if(responseBean.statusCode == 500){
                    accProdTypeWithTransactionDetailsMap.put(StringConstants.Sevice500InternalErrorMessage,null);                    
                }
            }
        }
        
        // INSERT LOGS
        if(!logsTobeInserted.isEmpty()){
            insert logsTobeInserted;
        }
        
        return accProdTypeWithTransactionDetailsMap;
    }
    
    /**
* This method takes Wrapper as input from UI component
* and returns result * 
* */
    
    
    @auraEnabled 
    Public Static List<StopAndReplaceCardsServiceWrapper>  getStopServiceWrapper(){
        List<StopAndReplaceCardsServiceWrapper> stopServiceWrapperList = new List<StopAndReplaceCardsServiceWrapper>();
        return stopServiceWrapperList;
    }
    
    
    @AuraEnabled
    public static List<Integration_Translation__c> getCardReasons(){
        List<Integration_Translation__c> reasonsList = new List<Integration_Translation__c>();
        for(Integration_Translation__c itRec: [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c 
                                               FROM Integration_Translation__c 
                                               WHERE system_Name__c='StopReplaceCard']){
                                                   if(itRec.Value_Type__c !=null && itRec.Value_Type__c =='Reason'){
                                                       reasonsList.add(itRec);
                                                   }
                                                   
                                               }
        return reasonsList;
    }
    
    @AuraEnabled
    public static List<Integration_Translation__c> getCardCircumstances(){
        List<Integration_Translation__c> circumstancesList = new List<Integration_Translation__c>();
        for(Integration_Translation__c itRec: [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c 
                                               FROM Integration_Translation__c 
                                               WHERE system_Name__c='StopReplaceCard']){
                                                   if(itRec.Value_Type__c !=null && itRec.Value_Type__c =='Circumstances'){
                                                       circumstancesList.add(itRec);
                                                   }
                                                   
                                               }
        return circumstancesList;
    }
    
    @AuraEnabled
    public static List<Integration_Translation__c> getDeliveryMethods(){
        List<Integration_Translation__c> deliveryMethodList = new List<Integration_Translation__c>();
        for(Integration_Translation__c itRec: [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c 
                                               FROM Integration_Translation__c 
                                               WHERE system_Name__c='StopReplaceCard']){
                                                   if(itRec.Value_Type__c !=null && itRec.Value_Type__c =='Delivery Method'){
                                                       deliveryMethodList.add(itRec);
                                                   }
                                                   
                                               }
        return deliveryMethodList;
    }
    
    @AuraEnabled
    public static String makeStopCardsCallOut(String jsonStr){
        
        //CAstpLostStolenCardV2_Resp_IB_v5
        system.debug('jsonStr ---'+jsonStr);
        CAstpLostStolenCardV2_Resp_IB_v5 responseBean = new CAstpLostStolenCardV2_Resp_IB_v5();
        Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>> responseMap = new Map<CAstpLostStolenCardV2_Resp_IB_v5, List<Sys_Log_Integration__c>>(); 
        
        if(jsonStr != null){
            
            responseMap = CAstpLostStolenCardV2_IH_v5.CAstpLostStolenCardResponseDetails(jsonStr);
            responseBean = (New List<CAstpLostStolenCardV2_Resp_IB_v5>((responseMap.keySet())))[0];
            system.debug('FINALKLresponseBean jsonStr ---'+json.serialize(responseBean));
        }
        
        // INSERT Logs List
        if(responseMap.get(responseBean) != null){
            insert responseMap.get(responseBean);
        }
        system.debug('FINALKL jsonStr ---'+json.serialize(responseBean));
        return json.serialize(responseBean);
    }
    
    @AuraEnabled
    public static void sendEmailNotifications(Id caseRecordId, String emailAddress, 
                                              String mobileNumber, String commMethod,String plasticCardNums){
                                                  
                                                  
                                                  //Pick the Email template based upon job type 
                                                  //if(JobType = Balance Enquiry){   
                                                  if(plasticCardNums != '' && plasticCardNums != null){
                                                      Id targetObjectId = [Select id from Contact where Email != '' limit 1].Id; //get any dummy contact just for sake of passing it
                                                      List<Messaging.SingleEmailMessage> constructEmail =   EmailHandler.composeEmail(caseRecordId,targetObjectId,emailAddress,'StopReplaceCreditCard');
                                                      Messaging.SingleEmailMessage email = constructEmail.get(0);
                                                      String htmlBody = email.getHTMLBody();
                                                      // EmailHandler.sendMailFromFlow(caseRecordId,emailAddress,accNumber,accBalance);
                                                      sendMailFromFlow(emailAddress,htmlBody);
                                                  }    
                                                  
                                                  
                                                  if(caseRecordId!=null ){
                                                      Case caseObj = new Case(Id=caseRecordId);
                                                      if(emailAddress != ''){
                                                          caseObj.Email__c = emailAddress; 
                                                      }
                                                      if(mobileNumber != ''){
                                                          caseObj.Mobile__c = mobileNumber;
                                                      }
                                                      if(commMethod != ''){
                                                          caseObj.Communication_Method__c = commMethod;
                                                      }
                                                      caseObj.Status = 'Closed';
                                                      Update caseObj;
                                                  }
                                                  
                                              } 
    
    
    
    
    //Send email to client using dymanic body and email
    public static void sendMailFromFlow( string emailAddress, string emailBody ){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {emailAddress};
            email.setToAddresses(to);
        email.setSubject('Stop Replace Card');
        email.setHtmlBody(emailBody); 
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
}