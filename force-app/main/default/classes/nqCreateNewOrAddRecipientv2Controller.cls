public class nqCreateNewOrAddRecipientv2Controller {
    
    @AuraEnabled
    public static String getAccountDetails(String caseId){
    
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
        
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
      
        if(currentCase.size() > 0 || currentCase != null){

           if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
               
       		   CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,currentCase[0].Account.CIF__c);
        
               if(response.statusCode == 200){
            
                 CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
            
                 List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
                 System.debug('---accTypes------'+accTypes);
                 accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
            
                 for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                    accountWrapperList.add(accWrObj);
                 }
                
                   return JSON.serialize(accountWrapperList);
               }
               
              
            }
        
       }
        return null;
    }
    
    @AuraEnabled
    public static String registerNotifyMe(String accountNumber, String caseId,boolean payment ,boolean withDrawal , 
                                                          boolean  deposit, boolean  transfer, boolean returned, boolean scheduled, 
                                                          boolean  purchase, String notifyTimes, String balanceUpdates, String minimumAmount,
                                                          String  recipName,String  cellPhone, String  lng, String contactPref, String email, String productType){
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
                                                                                                                    
        nQcreateNewOrAddRecipientV2_Resp_IB_v2.NQcreateNewOrAddRecipientV2Response nQcreateNewOrAddRecipientV2Response;
                                                              
        String site, teller;                                                      
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
        teller = currentUser.Teller_Operator_Code__c;                                                      
        system.debug('Current User' + currentUser.SiteCode__c);
                                                              
        if(currentCase.size() > 0 || currentCase != null){

            if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
            
            	 Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQcreateNewOrAddRecipientV2_IH_v2.nQcreateNewOrAddRecipientV2(currentCase[0].Account.CIF__c, accountNumber, site, teller, currentCase[0].Account.SBU_Segment__c, recipName, contactPref, lng, email, cellPhone, productType, payment, withDrawal, deposit, transfer, returned, scheduled, purchase, notifyTimes, balanceUpdates, minimumAmount);
                 
                 nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = (new List<nQcreateNewOrAddRecipientV2_Resp_IB_v2>(responseMap.keySet()))[0];
            
                 if(responseBean.statusCode == 200){
                     if(responseBean.NQcreateNewOrAddRecipientV2Response != null){
                         nQcreateNewOrAddRecipientV2Response = responseBean.NQcreateNewOrAddRecipientV2Response;
                            return JSON.serialize(nQcreateNewOrAddRecipientV2Response);
                        
                     }
                     
                 }
                }
            }                                          
                
         
                
        return null;                                    
      }
    
    @AuraEnabled
    public static String updateNotifyMe(String accountNumber, String caseId,boolean payment ,boolean withDrawal , 
                                                          boolean  deposit, boolean  transfer, boolean returned, boolean scheduled, 
                                                          boolean  purchase, String notifyTimes, String balanceUpdates, String minimumAmount,
                                                           String productType){
                                                               
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
                                                                                                                    
        nQupdateNotificationsV1_Resp_IB_v2.NQupdJVProdNotificationAcctSettingsV1Response nQupdJVProdNotificationAcctSettingsV1Response;
                                                              
        String site, teller;                                                      
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
        teller = currentUser.Teller_Operator_Code__c;                                                      
        system.debug('Current User' + currentUser.SiteCode__c);
                                                              
        if(currentCase.size() > 0 || currentCase != null){

            if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
                Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQupdateNotificationsV1_IH_v2.nQupdateNotificationsV1(currentCase[0].Account.CIF__c, accountNumber, site, teller, productType, payment, withDrawal, deposit, transfer, returned, scheduled, purchase, notifyTimes, balanceUpdates, minimumAmount);
                 
                nQupdateNotificationsV1_Resp_IB_v2 responseBean = (new List<nQupdateNotificationsV1_Resp_IB_v2>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                     if(responseBean.NQupdJVProdNotificationAcctSettingsV1Response != null){
                         nQupdJVProdNotificationAcctSettingsV1Response = responseBean.NQupdJVProdNotificationAcctSettingsV1Response;
                            return JSON.serialize(nQupdJVProdNotificationAcctSettingsV1Response);
                        
                     }
                     
                 }
            }
        }
           return null;
                                            
    }
    
    @AuraEnabled
    public static String cancelNotifyMe(String accountNumber, String caseId){
                                                               
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
                                                                                                                    
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1.NQcancelAnAcctJVProdNotificationV1Response nQcancelAnAcctJVProdNotificationV1Response;
                                                              
        String site, teller;                                                      
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
        teller = currentUser.Teller_Operator_Code__c;                                                      
        system.debug('Current User' + currentUser.SiteCode__c);
                                                              
        if(currentCase.size() > 0 || currentCase != null){

            if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
                Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQcancelAnAcctJVProdNotifV1_IH_v1.nQcancelAnAcctJVProdNotificationV1(currentCase[0].Account.CIF__c, accountNumber, site);
                 
                nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean = (new List<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1>(responseMap.keySet()))[0];
                
                if(responseBean.statusCode == 200){
                     if(responseBean.NQcancelAnAcctJVProdNotificationV1Response != null){
                         nQcancelAnAcctJVProdNotificationV1Response = responseBean.NQcancelAnAcctJVProdNotificationV1Response;
                            return JSON.serialize(nQcancelAnAcctJVProdNotificationV1Response);
                        
                     }
                     
                 }
            }
        }
           return null;
                                            
    }
    
    @AuraEnabled
    public static String getAccountName(String caseId){ 
       List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
       if(currentCase.size() > 0 || currentCase != null){

           if(String.isNotBlank(currentCase[0].Account.Name) ){
               return JSON.serialize(currentCase[0].Account.Name); 
           }
       }
       return null;
    }
    
    @AuraEnabled
    public static String getRecipientRegistered(String caseId){
        String site;
        
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
        
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
         if(currentCase.size() > 0 || currentCase != null){

            if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
                 Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQlistRecipientsRegisteredV1_IH_v1.getRecipientsRegisteredDetails(currentCase[0].Account.CIF__c,site);
                 
                nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean = (new List<nQlistRecipientsRegisteredV1_Resp_IB_v1>(responseMap.keySet()))[0];
                if(responseBean != null){
                	if(responseBean.statusCode == 200){
                        if(responseBean.NQlistRecipientsRegisteredForCustV1Response != null){
                            if(responseBean.NQlistRecipientsRegisteredForCustV1Response.nqp904o != null){
                                return JSON.serialize(responseBean.NQlistRecipientsRegisteredForCustV1Response.nqp904o);
                            }
                        }
                	}
                 }
            }
         }
        
        return null;
    }
        
    @AuraEnabled
    public static String updateRecipientRegistered(String caseId,String recipNm,String contactPref, String language, String email , String cellphone){
        String site;
        
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
        
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId()); 
        site = currentUser.SiteCode__c;
         if(currentCase.size() > 0 || currentCase != null){

            if(String.isNotBlank(currentCase[0].Account.CIF__c) ){
                
              
                Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>> responseMap = nQreplaceRecipientsV1_IH_v1.updateRecipients(currentCase[0].Account.CIF__c,recipNm, site, contactPref, language, email, cellphone); 
                nQreplaceRecipientsV1_Resp_v1 responseBean = (new List<nQreplaceRecipientsV1_Resp_v1>(responseMap.keySet()))[0];
                 if(responseBean != null){
                	if(responseBean.statusCode == 200){
                         
                        if(responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nbsmsgo != null && responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nqp096o != null){
                            if(responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nqp096o.rc == '0'){
                                return JSON.serialize(responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nqp096o.rc); 
                            }else if(responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nbsmsgo.msgEntry != null){
                                return JSON.serialize(responseBean.NQreplaceRecipientsAcrossAllAcntsV1Response.nbsmsgo.msgEntry.msgTxt);
                              }
                            }
                        } 
                    }
                 }
           	}
        
        return null;
    }
}