/*
* InsurancePolicyFinancialDetailsController for getting Insurance Policy Financial Details
*
* @author  Simangaliso Mathenjwa : ABSA
* @version v1.0
* @since   19 Feb 2021
*/

@isTest
public class InsurancePolicyAccountCtrlTest {

    @testSetup
    static void dataCreation(){
        Account acc = new Account(Name = 'testAccount');
	    insert acc;	

        List<InsurancePolicy> policyList = new List<InsurancePolicy>();
        for(Integer i=1; i<=25; i++){
            InsurancePolicy policy = new InsurancePolicy(Name = 'Test Policy ' +i, NameInsuredId=acc.Id);
            policyList.add(policy);
        }
        insert policyList;
    }

    @isTest
    private static void testgetPolicyRecord() {
        
        InsurancePolicy policyRecord = [SELECT Id, Name FROM InsurancePolicy WHERE Name ='Test Policy 1' LIMIT 1];
        List<InsurancePolicy> queriedPolicy =  InsurancePolicyAccountCtrl.getPolicyRecord(policyRecord.Id);
        System.assert(queriedPolicy.size()==1);
        System.assertNotEquals(queriedPolicy.size(), 0);
        System.assertEquals(queriedPolicy[0].Name, 'Test Policy 1', 'The Name is not Test Policy 1');

    }

    

}