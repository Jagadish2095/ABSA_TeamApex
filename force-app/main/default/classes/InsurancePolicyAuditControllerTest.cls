/**
* Test Class for InsurancePolicyAuditController 
* @author  Koketso Mpshane
* @date    29/01/2021
*/
@isTest
public class InsurancePolicyAuditControllerTest {
    
    @isTest
    static void testInsurancePolicyAudit(){
        
        Account acc = new Account(Name = 'testAccount');
	    insert acc;	
        
        InsurancePolicy policy = new InsurancePolicy();
        policy.Name = 'Test Policy';
        policy.NameInsuredId = acc.Id;
        insert policy;
        
        Insurance_Policy_Audit__c policyAudit = new Insurance_Policy_Audit__c();
        policyAudit.Insurance_Policy__c = policy.Id;
        policyAudit.Product_Code__c = 'PRO123';
        policyAudit.Status__c = 'Draft';
        policyAudit.Policy_Action__c = 'Quote';
        policyAudit.Effective_From_Date__c = system.today();
        policyAudit.Effective_To_Date__c = system.today().addYears(1);
        insert policyAudit;
        
        Test.startTest();
        InsurancePolicyAuditController.fetchPolicyAuditList(String.valueOf(policy.Id),15,1);
        Test.stopTest();

    }

}