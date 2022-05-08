/* Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020 
 */
public class ViewAccountHoldsController {
    
    /**
* Retrieves client account number list  based on AccountId
*
* @param   clientAccountId
*return list of account
* 
*/ 
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        
        String errorMessage = '';
        String result;
        system.debug(LoggingLevel.FINE,'clientAccountId'+clientAccountId);
        
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        
        
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
        
        if(response !=null && response.statusCode == 200){
            
            CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
        
            List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
            System.debug(LoggingLevel.FINE,'---accTypes------'+accTypes);
            
            accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
    
            for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                accountWrapperList.add(accWrObj);
            }
             result = JSON.serialize(accountWrapperList);
        
        }
        else{
                 errorMessage = 'CIF not found for the Account'; 
                 result = errorMessage;
                 //throw new AuraHandledException('Error: '+errorMessage);   
         
             }
     return result;
    }
  
 /**
* Retrieves client saving account on hold based on AccountId
* @param   accountNumberP
*return list of savings account on hold details
* 
*/  
    
    @AuraEnabled
    public static String svgetaccountholdsdetail(String accountNo){
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
        String teller = currentUser.Teller_Operator_Code__c;
        String siteCode = currentUser.SiteCode__c;
        String supervisor = currentUser.Supervisor__c ;

       // if(teller != null && siteCode != null && supervisor != null){
            
            Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVgetAccountHoldsDetailV4_IH_v1.callTosvgetaccountholdsdetailv4(accountNo,teller,siteCode,supervisor);                                                                                 
            SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = (new List<SVgetAccountHoldsDetailV4_Resp_IB_v1>(responseMap.keySet()))[0];
            SVgetAccountHoldsDetailV4_Resp_IB_v1.SVgetAccountHoldsDetailV4Response respBean = responseBean.SVgetAccountHoldsDetailV4Response;
            
            if(responseBean != null ){
                if(responseBean.statusCode == 200){
                    if(respBean.svsp40o != null){ 
                        if(respBean.nbsmsgo3.nbrUserErrs == '0' && respBean.nbsmsgo3.nbrUserMsgs == '0'){
                            System.debug('responseBean' + respBean.nbsmsgo3.nbrUserErrs  + '-' + respBean.nbsmsgo3.nbrUserMsgs);
                            return JSON.serialize(responseBean.SVgetAccountHoldsDetailV4Response.svsp40o);
                        }else{
                             System.debug('responseBean' + responseBean.SVgetAccountHoldsDetailV4Response.nbsmsgo3.msgEntry.msgTxt); 
                            return JSON.serialize(responseBean.SVgetAccountHoldsDetailV4Response.nbsmsgo3.msgEntry); 
                            
                        } 
                    }
                    
                }
           // }
        
  }
        
        return null;
 
    }
    
/**
* Updates client Savings account on hold   based on AccountId 
* @param   accountNumber
*return list of  Savings account on hold details
* 
*/
    @AuraEnabled
    public static String svUpdateaccountholds( String accountNumber,String frozenInd, String stoppedInd, String dormantInd,
                                             String semiDormantInd, String exclEstateInd, String exclInslvntInd, String courtOrderInd,
                                             String signingAuthInd, String monitorActivityInd, String potBadDebtInd,
                                             String legalActionInd, String nonResidentInd, String lostBookInd,String blockedInd, String offlineEnqInd, String securityMessageInd, 
                                              String restricHoldInd,String exceedMaxBalInd, String wtiCountry,String rbaEddHold) {

        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
        String teller = currentUser.Teller_Operator_Code__c;
        String siteCode = currentUser.SiteCode__c;
        String supervisor = currentUser.Supervisor__c ;
        String result;  
                                                  
  //if(teller != null && siteCode != null && supervisor != null){
        Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVupdateAccountHoldsV4_IH_v1.callTosvupdateaccountholdsV4(accountNumber,frozenInd,stoppedInd, dormantInd,semiDormantInd, exclEstateInd,exclInslvntInd, courtOrderInd,signingAuthInd, monitorActivityInd, potBadDebtInd,legalActionInd, nonResidentInd, lostBookInd, blockedInd, offlineEnqInd,securityMessageInd,restricHoldInd,exceedMaxBalInd, wtiCountry, rbaEddHold,siteCode,teller,supervisor);
                                                                                                                                                    
        SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = (new List<SVupdateAccountHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
        
        if(responseBean !=null) {
            if(responseBean.statusCode == 200){ 
                SVupdateAccountHoldsV4_Resp_IB_v1.SVupdateAccountHoldsV4Response respBean = responseBean.SVupdateAccountHoldsV4Response;
                if(respBean.svsp42o != null) {
                    
                    SVupdateAccountHoldsV4_Resp_IB_v1.nbsmsgo3 errorBean = responseBean.SVupdateAccountHoldsV4Response.nbsmsgo3;
                    SVupdateAccountHoldsV4_Resp_IB_v1.svsp42o outputBean = responseBean.SVupdateAccountHoldsV4Response.svsp42o;
                    
                    if(outputBean.holdNbr =='NaN' ){
                        SVupdateAccountHoldsV4_Resp_IB_v1.msgEntry msg = errorBean.msgEntry; 
                         System.debug('resul: ' + outputBean.holdNbr + '/ ' + msg.msgTxt);
                        result = msg.msgTxt;   
                        
                    }else{
                      List<SVupdateAccountHoldsV4_Resp_IB_v1.holdTbl> holdTblList = responseBean.SVupdateAccountHoldsV4Response.svsp42o.holdTbl;
                       for(SVupdateAccountHoldsV4_Resp_IB_v1.holdTbl holdTblBean :holdTblList){
                           String holdDesc = holdTblBean.holdDesc;
                           String holdStat = holdTblBean.holdStat;
                           System.debug('result: ' + outputBean.holdNbr + ' / '+ holdDesc + 'is ' + holdStat);
                           result = holdStat;
                       }
                    }
                    
                }
            }
       // }
      
  }

        return result ;
}  
    
    
 /**
* Retrieves client Cheque account on hold based on AccountI
* @param   accountNumber
*return list of Cheque account on hold details
* 
*/ 
    @AuraEnabled
    public static String cqgetaccountholdsdetail(String accountNumber){   

        Map<CQgetAcctHoldsMaintV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQgetAcctHoldsMaintV4_IH_v1.callTocqgetacctholdsmaintv4(accountNumber);                                                                                 
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = (new List<CQgetAcctHoldsMaintV4_Resp_IB_v1>(responseMap.keySet()))[0];
        CQgetAcctHoldsMaintV4_Resp_IB_v1.cqh503o cqh503oBean = responseBean.CQgetAcctHoldsMaintV4Response.cqh503o;
        
        if(responseBean != null ){
            if(responseBean.statusCode == 200){
                if(cqh503oBean != null){
                    return JSON.serialize(responseBean.CQgetAcctHoldsMaintV4Response.cqh503o); 
                    
                } else {
                    system.debug('re' + responseBean.CQgetAcctHoldsMaintV4Response.nbsmsgo3.msgEntry);
                    return JSON.serialize(responseBean.CQgetAcctHoldsMaintV4Response.nbsmsgo3.msgEntry); 

                }
                
            }
        }
    
    return null;
 }   
    
 /**
* Update client Cheque account on hold based on AccountId
* @param   accountNumber
* 
*/ 
    @AuraEnabled
    public static String validateChequeHolds(String accountNumber,String blocked, String courtOrder, String mandateRequired,
                                             String dormant, String semiDormant, String confiscated, String externalTransfer,
                                             String staff, String creditAccount, String excludeFromEstate, String blockAdhocDbt,
                                             String blockAdhocCrd, String specialRqpRedirect, String commercialPropFin,
                                             String misHold, String genSecMsg, String wapWildAccPickup, 
                                             String exclFromInsolvent, String digitalHold, String odSwitchInd){  
        
        String result;
                 
        Map<CQupdAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4(accountNumber,blocked,courtOrder,mandateRequired,dormant,semiDormant,confiscated,externalTransfer,
                                                                                                                                   staff,creditAccount,excludeFromEstate,blockAdhocDbt,blockAdhocCrd,specialRqpRedirect,commercialPropFin,
                                                                                                                                   misHold,genSecMsg,wapWildAccPickup, exclFromInsolvent,digitalHold,odSwitchInd);
                                                                                       
         CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (new List<CQupdAcctHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];                                         
        CQupdAcctHoldsV4_Resp_IB_v1.cqh525o cqh525oBean = responseBean.CQupdAcctHoldsV4Response.cqh525o; 
           CQupdAcctHoldsV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3Bean = responseBean.CQupdAcctHoldsV4Response.nbsmsgo3;  
                                                 
          if(responseBean != null ){
            if(responseBean.statusCode == 200){
                if(cqh525oBean != null){
                    if(nbsmsgo3Bean.nbrUserMsgs == '0' && nbsmsgo3Bean.nbrUserErrs == '0'){
                        List<CQupdAcctHoldsV4_Resp_IB_v1.confirmationDetails> confirmationDetailList = responseBean.CQupdAcctHoldsV4Response.cqh525o.confirmationDetails;
                        for(Integer i = 0; i < confirmationDetailList.size();i++){
                            if(confirmationDetailList[i].details != null)  {
                                result = confirmationDetailList[i].details;   
                                
                            }      
                            
                        }
                        
                        
                    } else {
                        result = nbsmsgo3Bean.msgEntry.msgTxt;
                        
                    }
                    
                }
            }                                        
              
          }
       
    System.debug('outBEAN: '+ result);   
	return result;
        

   
}
    
    
}