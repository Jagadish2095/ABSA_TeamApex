/**
 * @description RESTful API to consume a CIF key
 * IF client exists in Salesforce, Update client using CIF and return Salesforce Account ID
 * IF client does not exist in Salesforce, Create client using CIF and return Salesforce Account ID
 * @author  Jason Quevauvilliers
 * @created 2021-03-11
 */
@RestResource(urlMapping='/upsertCustomer/v01/*')
global without sharing class UpsertCustomer_ApiRest_v1 {
	@HttpGet
	/**
	 * @description GET Method
	 * @return String Id of Account in Salesforce
	 */
	global static String upsertCustomer() {
		String response;
		Integer statusCode;
		//Create Request Log
		Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(
			JSON.serialize(RestContext.request.params, true),
			'UpsertCustomer_ApiRest_v1.upsertCustomer',
			null,
			StringConstants.SALESFORCE_STRING
		);
		//Get CIF code
		String cifCode = RestContext.request.params.get('cifCode');

		if (String.isBlank(cifCode)) {
			throw new UpsertCustomerException('Required parameter missing: cifCode');
		}

		//Get existing Accounts in Salesforce with the same CIF Key (CIF__c)
		List<Account> existingAccounts = new AccountsSelector().selectByCIF(new Set<String>{ cifCode }, 1);

		if (existingAccounts != null && existingAccounts.size() > 0) {
			//Account Exists
			//Update Account in Salesforce from CIF Asynchronously
			updateAccountFromCIFFuture(cifCode);
			//Return ID of Existing Account
			response = existingAccounts[0].Id;
			statusCode = 200;
		} else {
			//Account does NOT Exist
			//Get Account info from CIF and Create Account in Salesforce
			AccountCreate_CIF_MDM.GIPResponse createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(cifCode, '0', '009970');
			if (createdAccount.response == 'Success') {
				//return ID of New Account
				response = createdAccount.accountId;
				statusCode = 201;
			} else {
				//Return Error message
				response = createdAccount.response;
				statusCode = 500;
			}
		}
		//Get state depending on StatusCode
		String state = statusCode >= 200 && statusCode < 300 ? StringConstants.INTEGRATION_STATUS_SUCCESS : StringConstants.INTEGRATION_STATUS_FAILED;
		//Map Response Log
		log = SystemLogger.mapResponseFields(log, statusCode, state, response);
		//Asynchronously Insert Log
		SystemLogger.insertLog(log);
		//Set RestContext Response
		if (!test.isRunningTest()) {
			RestContext.response.statusCode = statusCode;
		}

		return response;
	}

	/**
	 * @description Future Method to Call CIF and retrieve Customer data to Update in Salesforce Asynchronously
	 * @param cifKey
	 */
	@future(callout=true)
	private static void updateAccountFromCIFFuture(String cifKey) {
		AccountCreate_CIF_MDM.createAccountFromCIF(cifKey, '0', '009970');
	}

	/**
	 * @description Custom Exception
	 */
	public class UpsertCustomerException extends Exception {
	}
}