/*
* Test class for InsurancePolicySelector
* @Author : Danie Booysen/Paula Kreutzfeldt
* @Date : 2020-11-03
*/

@isTest
public class InsurancePolicySelectorTest {

    //Setup test data
    @testSetup
    static void dataCreation(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        InsurancePolicy testPolicy = new InsurancePolicy(Name = 'TestPolicy1',
        NameInsuredId = testAccount.Id);
        insert testPolicy;
    }

    @isTest
    private static void InsurancePolicyByAccTest() {
        InsurancePolicy policy = [SELECT NameInsuredId FROM InsurancePolicy LIMIT 1];
        Test.startTest();
        List<InsurancePolicy> insurancePolicyList = new InsurancePolicySelector().getPoliciesByAccountId(policy.NameInsuredId);
        Test.stopTest();
        System.assertEquals(true, insurancePolicyList.size() > 0);
    }

    @isTest
    private static void InsurancePolicyByPolicyNumberTest() {
        InsurancePolicy policy = [SELECT Name FROM InsurancePolicy LIMIT 1];
        Test.startTest();
        List<InsurancePolicy> insurancePolicyList = new InsurancePolicySelector().getPoliciesByPolicyNumber(policy.Name);
        Test.stopTest();
        System.assertEquals(true, insurancePolicyList.size() > 0);
    }
    
    @isTest
    private static void selectByInsurancePolicyIdsTest() {
        InsurancePolicy policy = [SELECT Name,Id FROM InsurancePolicy LIMIT 1];
        Test.startTest();
        List<InsurancePolicy> insurancePolicyList = new InsurancePolicySelector().selectByInsurancePolicyIds(new Set<String>{policy.Id});
        Test.stopTest();
        System.assertEquals(true, insurancePolicyList.size() > 0);
    }
}