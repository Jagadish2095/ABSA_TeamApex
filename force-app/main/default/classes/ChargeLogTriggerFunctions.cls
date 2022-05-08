/**
 * @description Trigger functions class for Charge Log Trigger
 * @author  Jason Quevauvilliers
 * @created 2021-05-05
 */
public class ChargeLogTriggerFunctions {
	/**
	 * @description Links the Charge_Log__c to a Charge_Control__c record. If Charge_Control__c does not exist it will create a new one
	 * @param chargeLogList - List of new Charge_Log__c records
	 */
	public static void linkChargeLogToChargeControl(List<Charge_Log__c> chargeLogList) {
		//Some Charge Lof records may only have Account__c and some may only have CIF__c
		//Therefor we add both to sets and query the Account's using an OR condition
		//Then create 2 seperate Maps to store the accounts to the keys(Id & CIF__c)
		Set<String> accountCIFSet = new Set<String>();
		Set<String> accountIdSet = new Set<String>();
		String currentMonth = String.valueOf(Date.Today().Month());

		for (Charge_Log__c newChargeLog : chargeLogList) {
			// If Account_CIF_Code__c is not blank add it to the Set
			if (!String.isBlank(newChargeLog.Account_CIF_Code__c)) {
				accountCIFSet.add(newChargeLog.Account_CIF_Code__c);
			}
			// If Account__c is not blank add it to the Set
			if (!String.isBlank(newChargeLog.Account__c)) {
				accountIdSet.add(newChargeLog.Account__c);
			}
		}
		// Query Existing Accounts
		List<Account> existingAccounts = new AccountsSelector().selectByIdOrCIF(accountIdSet, accountCIFSet);
		// Map of Account to CIF__c
		Map<String, List<Account>> accountToCIFKeyMap = (Map<String, List<Account>>) Sys_Utilities_General.convertListToMapWithStringKey(
			existingAccounts,
			'CIF__c'
		);
		// Map of Account to Id
		Map<String, List<Account>> accountToIdMap = (Map<String, List<Account>>) Sys_Utilities_General.convertListToMapWithStringKey(existingAccounts, 'Id');
		Set<String> compositeKeySet = new Set<String>();

		for (Charge_Log__c newChargeLog : chargeLogList) {
			if (!String.isBlank(newChargeLog.Account__c)) {
				//Account is NOT Blank
				//Create Composite Key to query for existing Charge Controls
				compositeKeySet.add(currentMonth + accountToIdMap.get(newChargeLog.Account__c)[0].Id);
			} else {
				//Account IS Blank
				//Check if Account is in Map. If it isn't then it didnt exist in SF. In After Insert it will call CIF to create the Account
				if(accountToCIFKeyMap.get(newChargeLog.Account_CIF_Code__c) != null){
					//Set Account__c field from Account to CIF Map
					newChargeLog.Account__c = accountToCIFKeyMap.get(newChargeLog.Account_CIF_Code__c)[0].Id;
					//Create Composite Key to query for existing Charge Controls
					compositeKeySet.add(currentMonth + accountToCIFKeyMap.get(newChargeLog.Account_CIF_Code__c)[0].Id);
				}
			}
		}
		//Query Charge_Control__c based on CompositeKey
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().selectByCompositeKeySet(compositeKeySet);
		//Map of Charge_Control__c to Composite_Key__c
		Map<String, List<Charge_Control__c>> chargeControlToCompositeKeyMap = (Map<String, List<Charge_Control__c>>) Sys_Utilities_General.convertListToMapWithStringKey(
			chargeControlList,
			'Composite_Key__c'
		);
		//Map of Charge_Log__c to Account__c.Id
		Map<String, List<Charge_Log__c>> chargeLogToAccountIdMap = (Map<String, List<Charge_Log__c>>) Sys_Utilities_General.convertListToMapWithStringKey(
			chargeLogList,
			'Account__c'
		);
		List<Charge_Control__c> chargeControlsToInsert = new List<Charge_Control__c>();
		for (String compositeKey : compositeKeySet) {
			if (chargeControlToCompositeKeyMap.get(compositeKey) != null) {
				//Charge_Control__c Exists. Update Charge_Log__c.Charge_Control__c
				Charge_Log__c chargeLog = chargeLogToAccountIdMap.get(compositeKey.right(18))[0];
				chargeLog.Charge_Control__c = chargeControlToCompositeKeyMap.get(compositeKey)[0].Id;
			} else {
				//Only create the Charge Control if the Account has a Telebanking_Charge_Account_Number__c
				if(accountToIdMap.get(compositeKey.right(18))[0].Telebanking_Charge_Account_Number__c != null){
					//No Charge_Control__c Exists. Create one.
					Charge_Control__c chargeControl = new Charge_Control__c();
					chargeControl.Composite_Key__c = compositeKey;
					chargeControl.Charge_Month__c = currentMonth.leftPad(6, '0');
					chargeControl.Account__c = accountToIdMap.get(compositeKey.right(18))[0].Id;
					chargeControl.Charge_Account_Number__c = accountToIdMap.get(compositeKey.right(18))[0].Telebanking_Charge_Account_Number__c;
					chargeControlsToInsert.add(chargeControl);
				}
			}
		}
		insert chargeControlsToInsert;
		//Link the Charge_Log__c(s) to the newly inserted Charge_Control__c(s)
		for(Charge_Control__c chargeControl : chargeControlsToInsert){
			if(chargeLogToAccountIdMap.get(chargeControl.Composite_Key__c.right(18)) != null){
				Charge_Log__c chargeLog = chargeLogToAccountIdMap.get(chargeControl.Composite_Key__c.right(18))[0];
				chargeLog.Charge_Control__c = chargeControl.Id;
			}
		}
	}

	/**
	 * @description Gets the correct Price Scheme and the corresponding Charge Amount and creates a Charge_Amount__c record.
	 * @param chargeLogMap - Map of new Charge_Log__c records
	 * @param accountIdSet - Set of Account Ids from the Charge_Log__c records
	 */
	public static void createChargeAmountRecords(Map<Id, Charge_Log__c> chargeLogMap, Set<Id> accountIdSet) {
		List<Account> accountList = new AccountsSelector().selectById(accountIdSet, accountIdSet.size());
		//Map of Account__c to Account__c.Id
		Map<String, List<Account>> accountToIdMap = (Map<String, List<Account>>) Sys_Utilities_General.convertListToMapWithStringKey(accountList, 'Id');
		Map<Id, String> priceSchemeNameToChargeLogIdMap = new Map<Id, String>();
		for (Charge_Log__c chargeLog : chargeLogMap.values()) {
			//If ChargeLog.Account is not null AND Account is in accountToIdMap
			if (!String.isBlank(chargeLog.Account__c) && accountToIdMap.get(chargeLog.Account__c) != null) {
				Account currentAccount = accountToIdMap.get(chargeLog.Account__c)[0];
				String priceSchemeName;
				if (currentAccount.Recordtype.Name.contains('Individual')) {
					//Is Individual
					if (currentAccount.Client_Type__c != 'Staff' && (currentAccount.Age__pc < 60 || currentAccount.Age__pc == null)) {
						if (chargeLog.Source__c == 'IVR') {
							priceSchemeName = Label.Price_Scheme_IVR_Individual;
						} else {
							priceSchemeName = Label.Price_Scheme_Agent_Assisted_Individual;
						}
					}
					//Else its a staff or pensioner, So no charge, So no need to get Price Scheme
				} else {
					//Is Business
					if (chargeLog.Source__c == 'IVR') {
						priceSchemeName = Label.Price_Scheme_IVR_Business;
					} else {
						priceSchemeName = Label.Price_Scheme_Agent_Assisted_Business;
					}
				}
				//If they are Staff or Pensioner they will not have a PriceSchemeName. Therefore don't add to map
				if (priceSchemeName != null) {
					priceSchemeNameToChargeLogIdMap.put(chargeLog.Id, priceSchemeName);
				}
			} else {
				chargeLog.addError('The Charge Log: ' + chargeLog.Id + ' does not have an Account linked to it. ');
			}
		}
		//Get Map of Price Scheme Entries to Charge Log Ids
		Map<Id, Price_Scheme_Entry__c> priceSchemeEntryToChargeLogIdMap = QuoteBuilderController.getPriceSchemeEntriesForChargeLogs(
			priceSchemeNameToChargeLogIdMap,
			chargeLogMap.values()
		);
		//Query all Charge Controls that contain the Account Ids in the Set
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().selectByAccountIdSet(accountIdSet);
		//Convert to: Map of Charge Control to Account Id
		Map<String, List<Charge_Control__c>> chargeControlToAccountIdMap = (Map<String, List<Charge_Control__c>>) Sys_Utilities_General.convertListToMapWithStringKey(
			chargeControlList,
			'Account__c'
		);
		//Create Charge_Amount__c Records
		List<Charge_Amount__c> chargeAmountList = new List<Charge_Amount__c>();
		for (Charge_Log__c chargeLog : chargeLogMap.values()) {
			//Would only be null for Staff or Pensioners. So exclude those
			if (priceSchemeEntryToChargeLogIdMap.get(chargeLog.Id) != null) {
				Charge_Amount__c chargeAmount = new Charge_Amount__c();
				chargeAmount.Charge_Control__c = chargeControlToAccountIdMap.get(chargeLog.Account__c)[0].Id;
				chargeAmount.Charge_Log__c = chargeLog.Id;
				chargeAmount.Charge_Amount__c = priceSchemeEntryToChargeLogIdMap.get(chargeLog.Id).Fee_Amount_Fixed__c;
				chargeAmount.Price_Scheme_Entry__c = priceSchemeEntryToChargeLogIdMap.get(chargeLog.Id).Id;
				chargeAmountList.add(chargeAmount);
			}
		}
		insert chargeAmountList;
	}
}