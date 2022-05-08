/**
 * @description Apex controller class for the Aura bundle EBStopAndReplaceCreditCard.
 * @author Simangaliso Mathenjwa
 * @since 23 June 2021
 */
public class EBStopAndReplaceCreditCardController {
	/**
	 * @description method to get card(s) details
	 * @param CIF
	 * @return String
	 */
	@auraEnabled
	public static String getCardDetails(String CIF) {
		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING, CIF);

		if (response == null) {
			return 'Error: Blank response received from service.';
		}
		if (String.isNotBlank(response.nbsmsgo3?.msgEntry?.msgTxt)) {
			return 'Error: ' + response.nbsmsgo3.msgEntry.msgTxt;
		}
		if (response.statusCode != 200) {
			return 'Error: ' + response.message;
		}
		if (response.cip047o?.outputTable == null) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(response);
		}

		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = response.cip047o.outputTable;
		return JSON.serialize(accTypes);
	}

	/**
	 * @description method to get transactions.
	 * @param accountNumbersList
	 * @return String
	 */
	@auraEnabled
	public static String getTransactions(List<string> accountNumbersList) {
		List<CAgetAccountDetails_Resp_IB_v1.Cas095o> returnList = new List<CAgetAccountDetails_Resp_IB_v1.Cas095o>();
		List<Sys_Log_Integration__c> logsListToInsert = new List<Sys_Log_Integration__c>();
		for (String accountNumber : accountNumbersList) {
			Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> getAllCardDetailsResponseMap = CAgetAccountDetails_IH_v1.CAgetAccountDetails(
				accountNumber
			);
			CAgetAccountDetails_Resp_IB_v1 responseBean = (new List<CAgetAccountDetails_Resp_IB_v1>((getAllCardDetailsResponseMap.keySet())))[0];
			if (responseBean != null) {
				if (responseBean.statusCode == 200) {
					CAgetAccountDetails_Resp_IB_v1.Cas095o Cas095oWrapper = responseBean.CAgetAccountDetailsV2Response.Cas095o;
					returnList.add(Cas095oWrapper);
				}
			}

			logsListToInsert.addAll(getAllCardDetailsResponseMap.get(responseBean));
		}

		if (!logsListToInsert.isEmpty()) {
			insert logsListToInsert;
		}
		return JSON.serialize(returnList);
	}

	/**
	 * @description method to get transactions.
	 * @return List<Integration_Translation__c>
	 */
	@AuraEnabled
	public static List<Integration_Translation__c> getPickListValuesListTranslations() {
		List<Integration_Translation__c> pickListValuesList = new List<Integration_Translation__c>(
			[
				SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c
				FROM Integration_Translation__c
				WHERE system_Name__c = 'StopReplaceCard' AND (Value_Type__c = 'Reason' OR Value_Type__c = 'Circumstances' OR Value_Type__c = 'Delivery Method')
			]
		);
		return pickListValuesList;
	}

	/**
	 * @description method to get transactions.
	 * @param cardDetailsMap
	 * @return String
	 */
	@AuraEnabled
	public static String stopReplaceCreditCard(Map<String, String> cardDetailsMap) {
		CAstpLostStolenCardV2_Resp_IB_v5 responseBean = CAstpLostStolenCardV2_IH_v5.callCAstpLostStolenCard(cardDetailsMap);

		return json.serialize(responseBean);
	}
}