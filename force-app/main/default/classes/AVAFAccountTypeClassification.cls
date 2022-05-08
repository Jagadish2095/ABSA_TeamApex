/**
 * @description - Handler class for avaf email templates
 * @author Koketso Mpshane
 * @date   16/03/2021
 */
public class AVAFAccountTypeClassification {
	/**
	 * @description Receives client account number and then returns a corp code
	 * @param iAccount client account
	 * @return List<String>
	 */
	@InvocableMethod(label='Get Contract Corp Code' description='Receives client account number and then returns a corp code')
	public static List<String> getContractDetailsCorpCode(List<String> iAccount) {
		String corpCode;
		List<String> errorMessages = new List<String>();

		try {
			if (iAccount.isEmpty() || String.isBlank(iAccount[0])) {
				errorMessages.add('Error: Account number not provided');
				return errorMessages;
			}

			User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

			if (String.isBlank(currentUser.AB_Number__c)) {
				errorMessages.add('Error: User AB number not provided');
				return errorMessages;
			}

			String iUser = currentUser.AB_Number__c;

			BAPISFContrDetails_Resp_IB_v1 contractDetailsResp = BAPISFContrDetails_IH_v1.BAPISFContrDetails(iAccount[0], iUser);

			if (contractDetailsResp == null) {
				errorMessages.add('Error: Blank response received from service');
				return errorMessages;
			}

			if (contractDetailsResp.statusCode != 200) {
				errorMessages.add('Error: ' + contractDetailsResp.message);
				return errorMessages;
			}

			if (!contractDetailsResp.BAPI_SF_CONTR_DETAILS.isEmpty()) {
				// check if response data not empty
				if (contractDetailsResp.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE != 0) {
					// check if is not a success response
					errorMessages.add('Error: ' + contractDetailsResp.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE_DESC);
					return errorMessages;
				} else {
					// success response
					corpCode = contractDetailsResp.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.CORP_CODE;
				}
			} else {
				// empty response
				errorMessages.add('Error: Unexpected response received. Service Response: ' + json.serialize(contractDetailsResp));
				return errorMessages;
			}
		} catch (Exception ex) {
			system.debug('EmailDocumentsHandler.getContractDetailsCorpCode Error:' + ex.getMessage() + ' Stack Trace:' + ex.getStackTraceString());
			errorMessages.add('Error: ' + ex.getMessage());
			return errorMessages;
		}

		return new List<String>{ corpCode };
	}
}