/**
* @description CaseSupportCotroller to get related policyies for case. 
**/
public class CaseSupportCotroller {
    
    /**
* @description Method is created to retun case Details. 
* @param  caseId 
* @return case
**/
    @AuraEnabled
    public static Case getCaseDetails(String caseId){
        Case caseobj=[select id,RecordType.Name,ID_V_Completed__c from case where id =:caseId];  
        return caseobj;
    }
    
    /**
* Author - vj
* @description Method is created to retun policies associated with case 
* @param  caseId 
* @return list of case releated policies.
**/    
    @AuraEnabled
    public static list<Case_Support__c> getPolicyDetails(String caseId){
        List<Case_Support__c>  listOfPolicies=new List<Case_Support__c>();
        CaseSupportSelector cSupportSelector = new CaseSupportSelector();
        if(String.isNotBlank(caseId))
        {
            listOfPolicies=cSupportSelector.selectByCaseID(caseId);
        }
        
        if(!listOfPolicies.isEmpty()) {
            return listOfPolicies;
        }
        return null;
    }
    
}