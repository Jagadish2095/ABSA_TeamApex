public class Link_DelinkAccountCBCardController {
    /*
* Handler for Link_DelinkAccountCombiCard component 
* @author Srikanth N
* @created 2020-05-07
*/ 
    @AuraEnabled
    public static String getAccountDetails(String caseId){
        
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
        
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        
        if(currentCase.size() > 0){
            
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
    public static String getAccountName(String caseId){ 
        List<Case> currentCase = new CasesSelector().selectByAccountIdByCaseId(new Set<Id>{caseId}, 1);
        if(currentCase.size() > 0){
            
            if(String.isNotBlank(currentCase[0].Account.Name) ){
                return JSON.serialize(currentCase[0].Account.Name); 
            }
        }
        return null;
    }
    
    
    
    @AuraEnabled
    public static Map<String,String> linkDelinkUpdateCall(String caseId, String actionItem, List<String> accountList, String cbNumber){ 
        Map<String,String> returnMap = new Map<String,String>{'isSuccess'=>'','successMessage'=>'','errorMessage'=>''};
            try{
                Case presentcase = [Select Id,Account.CIF__c FROM Case Where Id=:caseId];
                if(actionItem == 'Link'){
                    cclinkaccounttocombicardv3_Resp_IB_v1 resposeMap = cclinkaccounttocombicardv3_IH_v1.getcclinkaccounttocombicardv3(cbNumber,accountList[0],presentcase.Account.CIF__c ,true);
                    if(resposeMap.statusCode != 200){
                        returnMap.put('isSuccess','false');
                        returnMap.put('errorMessage',resposeMap.StatusMessage);
                    }else if(resposeMap.CClinkAccountToCombiCardV3Response.ccp303o.combiRetrvdInd == 'Y' && 
                             resposeMap.CClinkAccountToCombiCardV3Response.ccp303o.accntLinked == 'Y'){                
                                 returnMap.put('isSuccess','true');
                                 returnMap.put('successMessage','Account has been linked Successfully');
                             }else{			
                                 returnMap.put('isSuccess','false');
                                 returnMap.put('errorMessage',resposeMap.CClinkAccountToCombiCardV3Response.nbsmsgo.msgEntry.msgTxt);			
                             }
                }else if(actionItem == 'DeLink'){
                   // accountList.remove(null);
                    if(accountList.size() > 0){
                        ccdelinkaccountsv1_Resp_IB_v1 resposeMap = ccdelinkaccountsv1_IH_v1.getccdelinkaccountsv1(cbNumber,accountList,true);
                        if(resposeMap.statusCode != 200){
                            returnMap.put('isSuccess','false');
                            returnMap.put('errorMessage',resposeMap.StatusMessage);
                        }else if(resposeMap.CCdelinkAccountsV1Response.ccp309o.combiRetrvdInd == 'Y' ){                
                            returnMap.put('isSuccess','true');
                            returnMap.put('successMessage','Account de-linked Successfully');
                        }else if(resposeMap.CCdelinkAccountsV1Response.ccp309o.combiRetrvdInd == null){	
                            for(ccdelinkaccountsv1_Resp_IB_v1.msgEntry msgentry: resposeMap.CCdelinkAccountsV1Response.nbsmsgo.msgEntry){
                                if(msgentry.msgErrInd == 'E'){                                    
                                    returnMap.put('isSuccess','false');
                                    returnMap.put('errorMessage',msgentry.msgTxt);
                                    break;
                                }
                            }		
                        }
                    }else{
                        returnMap.put('isSuccess','false');
                        returnMap.put('errorMessage','No Account number selected for delink');  
                    }
                }
            }catch(exception exp){
                returnMap.put('isSuccess','false');
                returnMap.put('errorMessage',exp.getMessage());            
            }
        return returnMap;  
    }         
}