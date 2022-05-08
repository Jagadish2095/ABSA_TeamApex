/**
* Controller class for Insurance Policy Audit object
* @author  Koketso Mpshane
* @date    29/01/2021
*/
public class InsurancePolicyAuditController {
    
    @AuraEnabled
    public static List<Insurance_Policy_Audit__c> fetchPolicyAuditList(String policyId, Integer pageSize, Integer pageNumber){ 
		
        Integer psize                                = pageSize;
        Integer pnumber                              = pageNumber-1;
        Integer offsetSize                           = pageSize*pnumber; 
        //List<Insurance_Policy_Audit__c> policyAuditList = new InsurancePolicyAuditsSelector().selectByInsurancePolicyId(policy);
        List<Insurance_Policy_Audit__c> policyAuditList =[SELECT Id,Name,Insurance_Policy_Number__c, Product_Code__c,Effective_From_Date__c,Effective_To_Date__c,Status__c,Policy_Action__c,Action__c,Log_Date__c,CreatedDate FROM Insurance_Policy_Audit__c WHERE Insurance_Policy__c=: policyId LIMIT :pageSize OFFSET :offsetSize];
        
        return policyAuditList;

    }

}