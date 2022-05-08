/**
 * @description Handler for the Charge Log trigger
 * @author  Jason Quevauvilliers
 * @created 2021-05-05
 */
public with sharing class TriggerHandlerChargeLog extends TriggerHandler {
	/**
	 * @description Method for before insert
	 * @param triggerNew - List of new Charge_Log__c records
	 */
	public virtual override void beforeInsert(List<sObject> triggerNew) {
		List<Charge_Log__c> chargeLogTriggerNew = (List<Charge_Log__c>) triggerNew;
		ChargeLogTriggerFunctions.linkChargeLogToChargeControl(chargeLogTriggerNew);
	}

	/**
	 * @description Method for After Insert
	 * @param newRecords - List of new Charge_Log__c records
	 */
	public virtual override void afterInsert(Map<Id, sObject> newRecords) {
		Map<Id, Charge_Log__c> newChargeLogs = (Map<Id, Charge_Log__c>) newRecords;
		Set<Id> accountIdSet = new Set<Id>();
		for (Charge_Log__c chargeLog : newChargeLogs.values()) {
			if (String.isBlank(chargeLog.Account__c) && !String.isBlank(chargeLog.Account_CIF_Code__c)) {
				//Account__c is still Blank. Therefore Account did not exist in Salesforce in before insert.
				//Call CIF Asyncronously to create the account in Salesforce.
				updateAccountFromCIFFuture(chargeLog.Account_CIF_Code__c, chargeLog.Id);
			} else {
				accountIdSet.add(chargeLog.Account__c);
			}
		}
		ChargeLogTriggerFunctions.createChargeAmountRecords(newChargeLogs, accountIdSet);
	}

	/**
	 * @description Future Method to Call CIF and retrieve Customer data to Update in Salesforce Asynchronously
	 * @param cifKey
	 * @param chargeLogId
	 */
	@future(callout=true)
	public static void updateAccountFromCIFFuture(String cifKey, Id chargeLogId) {
		AccountCreate_CIF_MDM.GIPResponse createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(cifKey, '0', '009970');
		if (createdAccount.response == 'Success') {
			Charge_Log__c chargeLog = new ChargeLogsSelector().selectById(chargeLogId);
			chargeLog.Account__c = createdAccount.accountId;
			update chargeLog;

			ChargeLogTriggerFunctions.linkChargeLogToChargeControl(new List<Charge_Log__c>{ chargeLog });
		}
	}
}