/**
* Controller class for Insurance Policy Cover Audit object
* @author  Koketso Mpshane
* @date    29/01/2021
*/
public class InsurancePolicyCoverAuditController {
    
    @AuraEnabled
    public static List<Insurance_Policy_Cover_Audit__c> fetchCoverAuditList(String policyId, Integer pageSize, Integer pageNumber){

        Integer psize                                = pageSize;
        Integer pnumber                              = pageNumber-1;
        Integer offsetSize                           = pageSize*pnumber; 
        //List<Insurance_Policy_Cover_Audit__c> coverAuditList = new InsurancePolicyCoverAuditsSelector().selectByInsurancePolicyId(policy);
        List<Insurance_Policy_Cover_Audit__c> coverAuditList = [SELECT Id,Name,Section_Code__c,Cover_Code__c,Effective_From_Date__c,Effective_To_Date__c,Insurance_Policy__c,Premium_Excl_VAT__c,Sum_Insured__c,Log_Date__c,CreatedDate FROM Insurance_Policy_Cover_Audit__c WHERE Insurance_Policy__c =:policyId LIMIT :pageSize OFFSET :offsetSize  ];

        return coverAuditList;      
        
    }

}