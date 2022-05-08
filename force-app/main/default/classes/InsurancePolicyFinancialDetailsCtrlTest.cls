@isTest
public  class InsurancePolicyFinancialDetailsCtrlTest {

    @testSetup
    static void dataCreation(){
        Account acc = new Account(Name = 'testAccount');
	    insert acc;	

        InsurancePolicy policy = new InsurancePolicy(Name = 'Test Policy', NameInsuredId=acc.Id);
        insert policy;

        List<Insurance_Policy_Financial__c> policyFinancialsList = new List<Insurance_Policy_Financial__c>();
        for(Integer i=1; i<=100; i++){
            Insurance_Policy_Financial__c policyFinancial = new Insurance_Policy_Financial__c(Footprint_Id__c = 'Test ' +i, Transaction_Date__c=date.today(), Insurance_Policy__c=policy.Id);
            policyFinancialsList.add(policyFinancial);
        }
        insert policyFinancialsList;
    }

    @isTest
    private static void testgetFinancialDetails() {
        
        InsurancePolicy policyRecord = [SELECT Id, Name FROM InsurancePolicy WHERE Name ='Test Policy' LIMIT 1];
        List<Insurance_Policy_Financial__c> policyFinancialList = [SELECT Id, Name, Insurance_Policy__c,Transaction_Date__c, Footprint_Id__c FROM Insurance_Policy_Financial__c WHERE Insurance_Policy__c =:policyRecord.Id];
        String searchFields = 'Id, Name, Insurance_Policy__c,Transaction_Date__c, Footprint_Id__c ';
        String filter = 'AND Transaction_Date__c >=TODAY';
        List<Insurance_Policy_Financial__c> queriedPolicyFinancials =  InsurancePolicyFinancialDetailsCtrl.getFinancialDetails(policyRecord.Id, searchFields, filter, 15, 1);
		
        System.debug('size==> '+queriedPolicyFinancials.size());
        System.assert(queriedPolicyFinancials.size()==15);
        System.assertNotEquals(queriedPolicyFinancials.size(), 0);
        System.assertEquals(queriedPolicyFinancials[0].Footprint_Id__c, 'Test 1', 'Footprint Id is not Test  1');

    }

}