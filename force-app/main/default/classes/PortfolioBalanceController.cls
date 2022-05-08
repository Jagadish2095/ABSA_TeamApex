/*This is Portfolio Balance Lightning component Apex Controller Class
*
* @author Mashudu Raidimi 
* @created 2020/05/04
 */

public class PortfolioBalanceController {
/**
* Retrieves retrieves client account account number based on AccountId
* @param   clientAccountId
*return list of account 
*/ 

    @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        
        String errorMessage = '';
        String results = '';
        
        system.debug(LoggingLevel.FINE,'clientAccountId'+clientAccountId);
        
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        
        if(accountList.size() > 0){
            if(String.isNotBlank(accountList[0].CIF__c)){
                CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
        
                if(response.statusCode == 200){
                   CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
                   results = JSON.serialize(cls_Cip047oWrapper);
                    
                 }else{
                     
                   results = 'CIF not found for the Account';   
                 }
        
                 return results;
  
            }
        }
        
        return null;
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