/**
 * @description Controller class for the BAPIAccountFinancialInformation component.
 * @author Bhanumurty Rayala
 * @created 2021-06-09
 */
public class BAPIAccountFinancialInformation {
	/**
	 * @description call the BAPI_SF_AccountFinInfo_IH_v1 from the component to retrieve the information.
	 * @param accountNumber Selected account number from the component
	 * @return BAPI_SF_AccountFinInfo_Resp_IB_v1
	 */
	@AuraEnabled
	public static BAPI_SF_AccountFinInfo_Resp_IB_v1 getAccFinInformation(String accountNumber) {
		UsersSelector user = new UsersSelector();
		String abNumber = user.selectById(UserInfo.getUserId()).AB_Number__c;
		BAPI_SF_AccountFinInfo_Resp_IB_v1 responseBean = BAPI_SF_AccountFinInfo_IH_v1.accountFinancialInformation(accountNumber, abNumber);
		return responseBean;
	}

	/**
	 * @description fetching the banker/consultant/agent details based on the user record Id
	 * @return agentDetails
	 */
	@AuraEnabled
	public static User getAgentDetails() {
		//fetching the agent details
		UsersSelector user = new UsersSelector();
		Id agentId = UserInfo.getUserId();
		User agentDetails = user.selectById(agentId);
		return agentDetails;
	}

	/**
	 * @description sending email based on the contact status and product type to the client
	 * @param clientAVAFInformation information in the string format
	 * @param clientContactStatus contact status of the client
	 * @param clientEmail client email from CIF
	 * @param caseId Case record Id
	 */
	@AuraEnabled
	public static void clientSendEmail(
		Map<String, String> clientAVAFInformation,
		String clientContactStatus,
		String clientEmail,
		String caseId
	) {
		//setting the targetObjectId by contact object.
		//fetching the email template details to send the email based on the account category
		List<String> accountCategory = AVAFAccountTypeClassification.getContractDetailsCorpCode(
			new List<String>{ clientAVAFInformation.get('[Account number]') }
		);

		String templateName;
		if (accountCategory.get(0) == 'FORD' || accountCategory.get(0) == 'FSA') {
			if (clientContactStatus == 'notContacted') {
				templateName = 'FORD_Client_No_Contact';
			} else {
				templateName = 'FORD_Client_Contact';
			}
		} else {
			if (clientContactStatus == 'notContacted') {
				templateName = 'AVAF_Client_No_Contact';
			} else {
				templateName = 'AVAF_Client_Contact';
			}
		}
        Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id;
		NotifyBankerController.sendEmailWithMappedValues(caseId, targetObjectId, clientEmail, templateName, clientAVAFInformation);
	}
}