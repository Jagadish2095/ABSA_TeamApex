/**
 * @description       : Casa Controller for Aura Lightning components
 * @author            : Thomas Dry : ABSA (IQ Business)
 * @created   2021-03-02
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.1   2021-07-22   PaulJohn.duRand@absa.africa   IntegrationTranslation for customer type
 *                                                  Analyst comments for Non-Individual Entities
 * 												    Return error on invalid CASA status
 * 2.0   2021-08-05   PaulJohn.duRand@absa.africa   Refactor class
 **/

public without sharing class BranchCasaController {

	/**
	 * @description callScreening
	 * @param objId
	 * @return String
	 */
	 @AuraEnabled
	 public static String callScreening(id objId) {
		CasaScreenPrimaryClient casaScreenPrimaryClient = new CasaScreenPrimaryClient(objId);
		return casaScreenPrimaryClient.callService();
	}

	/**
	 * @description getPrimaryCasaDetails
	 * @param objId
	 * @return object
	 */
	@AuraEnabled
	public static object getPrimaryCasaDetails(id objId) {
		CasaScreenPrimaryClient casaScreenPrimaryClient = new CasaScreenPrimaryClient(objId);
			return casaScreenPrimaryClient.getPrimaryCasaDetails();
	}

	/**
	 * @description getAnalystComments
	 * @param objId
	 * @return String
	 */
	@AuraEnabled
	public static string getAnalystComments(id objId) {
		CasaScreenPrimaryClient casaScreenPrimaryClient = new CasaScreenPrimaryClient(objId);
		return casaScreenPrimaryClient.getAnnalystComments();
	}

	/**
	 * @description callRiskProfiling
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String callRiskProfiling(id oppId) {
        CasaRiskProfileClient casaRiskProfileClient = new CasaRiskProfileClient();
		return casaRiskProfileClient.callService(oppId);
	}

		/**
	 * @description callGenerateDocs
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String callGenerateDocs(id oppId) {
	 	String accountId =  BranchFunctions.getAccountId(oppId);
		CasaScreenPrimaryClient casaScreenPrimaryClient = new CasaScreenPrimaryClient(accountId);
		String versionNumber = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsByRefNumber(casaScreenPrimaryClient.getCasaReference());
		if(!versionNumber.contains('Error')){
			Account account = [SELECT Id,Casa_Sequence_Number__c FROM Account Where Id =: accountId];
			account.Casa_Sequence_Number__c = versionNumber;
			update account;
		}
		return versionNumber;
	}
}