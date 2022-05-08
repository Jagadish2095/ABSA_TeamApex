/*
 * InsurancePolicyPolicyAccountController for getting Insurance Policy Account records
 *
 * @author  Simangaliso Mathenjwa : ABSA
 * @version v1.0
 * @since   01 Feb 2021
 */

public class InsurancePolicyAccountCtrl {

	@AuraEnabled
    public static List<InsurancePolicy> getPolicyRecord(String insurancePolicyId){

		List<InsurancePolicy> insurancePolicyRecord = new InsurancePolicySelector().selectByInsurancePolicyIds(new Set<String>{insurancePolicyId});

    return insurancePolicyRecord;
	}
}