/**
* Test Class for InsurancePolicyCoverAuditsSelector
* @author  Koketso Mpshane
* @date    01/02/2021
*/
@isTest
public class InsurancePolicyCoverAuditsSelectorTest {
    
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
        
        Insurance_Policy_Cover_Metadata__c policyCoverMetadata = new Insurance_Policy_Cover_Metadata__c(); 
        policyCoverMetadata.Description__c = 'Test';
        policyCoverMetadata.Code__c = 'Test';
        insert policyCoverMetadata;
        
        Insurance_Policy_Section_Metadata__c policySectionMetadata = new Insurance_Policy_Section_Metadata__c(); 
        policySectionMetadata.Description__c = 'Test';
        policySectionMetadata.Code__c = 'Test';
        insert policySectionMetadata;
        
        Insurance_Policy_Cover_Audit__c policyCoverAudit = new Insurance_Policy_Cover_Audit__c();
        policyCoverAudit.Insurance_Policy__c = policy.Id;
        policyCoverAudit.Effective_From_Date__c = system.today();
        policyCoverAudit.Effective_To_Date__c = system.today().addYears(1);
        insert policyCoverAudit;
        
        
    }

    @isTest
    private static void testSelectById() {
        
        Insurance_Policy_Cover_Audit__c tst = [SELECT Id FROM Insurance_Policy_Cover_Audit__c LIMIT 1];

        InsurancePolicyCoverAuditsSelector ipcaSelector = new InsurancePolicyCoverAuditsSelector();
        
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tst.Id);
        
        Test.startTest();
        List<Insurance_Policy_Cover_Audit__c> ipcaList = ipcaSelector.selectById(tstSet);
        Test.stopTest();
        
        System.assertEquals(ipcaList.size(), 1);
    }
    
    @isTest
    private static void testSelectByInsurancePolicyId() {
        
        InsurancePolicy iPolicy = [SELECT Id FROM InsurancePolicy LIMIT 1];

        InsurancePolicyCoverAuditsSelector ipcaSelector = new InsurancePolicyCoverAuditsSelector();
        
        Test.startTest();
        List<Insurance_Policy_Cover_Audit__c> ipcaList = ipcaSelector.selectByInsurancePolicyId(String.valueOf(iPolicy.Id));
        Test.stopTest();
        
        System.assertEquals(ipcaList.size(), 1);
    }

}