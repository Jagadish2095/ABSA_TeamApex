/**
* Test Class for InsurancePolicyAuditsSelector
* @author  Koketso Mpshane
* @date    01/02/2021
*/
@isTest
public class InsurancePolicyAuditsSelectorTest {
    
     /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        
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
        
    }

    @isTest
    private static void testSelectById() {
        
        Insurance_Policy_Audit__c tst = [SELECT Id FROM Insurance_Policy_Audit__c LIMIT 1];

        InsurancePolicyAuditsSelector ipaSelector = new InsurancePolicyAuditsSelector();
        
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tst.Id);
        
        Test.startTest();
        List<Insurance_Policy_Audit__c> ipaList = ipaSelector.selectById(tstSet);
        Test.stopTest();
        
        System.assertEquals(ipaList.size(), 1);
    }
    
    @isTest
    private static void testSelectByInsurancePolicyId() {
        
        InsurancePolicy iPolicy = [SELECT Id FROM InsurancePolicy LIMIT 1];

        InsurancePolicyAuditsSelector ipaSelector = new InsurancePolicyAuditsSelector();
        
        Test.startTest();
        List<Insurance_Policy_Audit__c> ipaList = ipaSelector.selectByInsurancePolicyId(String.valueOf(iPolicy.Id));
        Test.stopTest();
        
        System.assertEquals(ipaList.size(), 1);
    }

}