@isTest
public class SmartSearchControllerTest {
	/**
	 * @description Test class for SmartSearchController
	 *
	 * @author  Simangaliso Mathenjwa : Absa
	 * @version v1.0
	 * @since   01 March 2021
	 */

	@TestSetup
	static void makeData() {
		List<Absa_Listed_Beneficiaries__c> recordsList = new List<Absa_Listed_Beneficiaries__c>();
		//Absa Listed BeneficiaryData
		for (Integer i = 1; i <= 15; i++) {
			Absa_Listed_Beneficiaries__c absaListed = new Absa_Listed_Beneficiaries__c();
			absaListed.Name = 'Listed ' + i;
			absaListed.Beneficiary_Account_Number__c = 'Account number ' + i;
			absaListed.BranchCode__c = 'branch ' + i;
			recordsList.add(absaListed);
		}

		insert recordsList;
	}

	@isTest
	static void fetchMatchingLookupRecord() {
		List<Absa_Listed_Beneficiaries__c> recordsList = [SELECT id, Name FROM Absa_Listed_Beneficiaries__c];

		String searchKeyword = 'Listed';
		String query = SmartSearchController.getQueryString('AbsaListedBeneficiaries');
		List<Absa_Listed_Beneficiaries__c> searchResults = SmartSearchController.fetchMatchingLookupRecord(searchKeyword, query);

		System.assertEquals(recordsList.size(), searchResults.size(), 'list sizes equal');
	}
}