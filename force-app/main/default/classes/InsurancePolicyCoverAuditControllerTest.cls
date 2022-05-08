/**
* Test Class for InsurancePolicyCoverAuditController 
* @author  Koketso Mpshane
* @date    29/01/2021
*/
@isTest
public class InsurancePolicyCoverAuditControllerTest {
    
    @isTest
    static void testInsurancePolicyCoverAudit(){
        
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
        
        Test.startTest();
        InsurancePolicyCoverAuditController.fetchCoverAuditList(String.valueOf(policy.Id), 10, 10);
        Test.stopTest();

    }

}