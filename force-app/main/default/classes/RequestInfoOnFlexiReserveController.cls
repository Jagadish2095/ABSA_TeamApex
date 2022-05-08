public class RequestInfoOnFlexiReserveController {
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
   // public static abfgetgeneraldetailsv2_Resp_IB_v1 getAccountInfo(String caseId, String accountId){
      //return abfgetgeneraldetailsv2_IH_v1.getabfgetgeneraldetailsv2(accountId,true);
   public static mlviewcomprehensivedetailsv1_Resp_IB_v1 getAccountInfo(String caseId, String accountId){   
        return mlviewcomprehensivedetailsv1_IH_v1.getmlviewcomprehensivedetailsv1(accountId,true);
      
    }
    
    //added by srikanth to call NH Account details
     @AuraEnabled
   public static NHGetAccountDetailv3_Resp_IB_v1 getNHAccountInfo(String accountNumber){   
       system.debug(accountNumber); 
        return NHGetAccountDetailv3_IH_v1.nhgetaccountdetailv3(accountNumber,accountNumber);
      
    }
    
    @AuraEnabled
    public static Map<String,String> caseClose(String caseId){
        Map<String,String> returnMap = new Map<String,String>();
        try{
            Update new Case(Id=caseId, Status='Closed');
            returnMap.put('isSuccess', 'true');
        }catch(exception ex){            
            returnMap.put('isSuccess', 'false');
            returnMap.put('errorMessage', ex.getMessage());           
        }
        
        
      return returnMap;
      
    }
    
    
}