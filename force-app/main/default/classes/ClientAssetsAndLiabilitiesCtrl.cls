/**
 * Controller class for ClientAssetsAndLiabilities aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date February 2021
 */
public class ClientAssetsAndLiabilitiesCtrl {
	/**
	 * get list of related parties for an account
	 *
	 * @param oppId opportunity Id
	 *
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled(Cacheable = false)
	public static List<FinServ__AssetsAndLiabilities__c> getAssetsLiabilities(Id accountId) {
		List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities = new FinServAssetsAndLiabilitiesSelector().selectAssetsAndLiabilitiesByAccountId(new Set<Id>{accountId});

		if (accAssetsLiabilities != null && accAssetsLiabilities.size() > 0) {
			return accAssetsLiabilities;
		} else {
            accAssetsLiabilities = new List<FinServ__AssetsAndLiabilities__c>();
			Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            list<Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
            String validPicklistVals = validAssetLiabTypes();

            for (Schema.PicklistEntry value : values) {
                for (String picklistVal : validPicklistVals.split(';')) {
                    if (value.getValue() == picklistVal) {
                        FinServ__AssetsAndLiabilities__c accAssetLiability = new FinServ__AssetsAndLiabilities__c();
                        accAssetLiability.RecordTypeId = getRecordTypeId(picklistVal);
                        accAssetLiability.Name = picklistVal;
                        accAssetLiability.FinServ__AssetsAndLiabilitiesType__c = picklistVal;
                        accAssetLiability.FinServ__PrimaryOwner__c = accountId;
                        accAssetsLiabilities.add(accAssetLiability);
                    }
                }
            }
            
			try {
				insert accAssetsLiabilities;
			} catch (Exception exc) {
                throw new AuraHandledException('' + exc);
            }

			accAssetsLiabilities = new FinServAssetsAndLiabilitiesSelector().selectAssetsAndLiabilitiesByAccountId(new Set<Id>{accountId});

			return accAssetsLiabilities;
		}
	}

	/**
	 * get list of related parties for an account
	 *
	 * @param oppId opportunity Id
	 *
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled(Cacheable = false)
	public static String updateAssetsLiabilities(List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities, String deedsOfficeSearch, Date dateDeedsOfficeSearch, String deedsOutcomePositive, Date asAtDate) {
		String upsertSuccess = 'Success';
		Account account = new Account(Id = accAssetsLiabilities[0].FinServ__PrimaryOwner__c);
		account.Date_deeds_office_search__c = dateDeedsOfficeSearch;
		account.Deeds_office_search_available_Y_N__c = deedsOfficeSearch;
		account.Outcome_positive_Y_N__c = deedsOutcomePositive;
        account.As_at_date__c = asAtDate;

		try {
			update accAssetsLiabilities;
			update account;
		} catch (Exception exc) {
			upsertSuccess = String.valueOf(exc);
        }

		return upsertSuccess;
	}

	/**
	 * get list of Asset and Liability records
	 *
	 * @return String
	 */
	private static String validAssetLiabTypes() {
		String validPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;';
		validPicklistVals += 'Loan Accounts to Businesses;Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
		validPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
		validPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);';
		validPicklistVals += 'Other Assets;Total Assets;Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;';
		validPicklistVals += 'Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities;Total Liabilities;Net Worth Owner\'s Estimate;Net Worth Manager\'s Estimate;Fixed Properties Bonded;';
		validPicklistVals += 'Fixed Properties Unbonded;Fixed Properties Informal;Total Properties;Total Bond Registered;Notarial Bond Amount';
		
        return validPicklistVals;
	}

	/**
	 * get record type Id of a picklist value
	 *
	 * @param picklistVal - picklist value for which to get record id
	 *
	 * @return Id - record type Id
	 */
	private static Id getRecordTypeId(String picklistVal) {
		String assetPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;Loan Accounts to Businesses;';
		assetPicklistVals += 'Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
		assetPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
		assetPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);Other Assets';
		String liabilityPicklistVals = 'Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities';
        String fixedPropPicklistVals = 'Fixed Properties Bonded;Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';

		for (String assetPicklistVal : assetPicklistVals.split(';')) {
			if (picklistVal == assetPicklistVal) {
				return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
			}
		}

		for (String liabilityPicklistVal : liabilityPicklistVals.split(';')) {
			if (picklistVal == liabilityPicklistVal) {
				return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
			}
		}

		for (String fixedPropPicklistVal : fixedPropPicklistVals.split(';')) {
			if (picklistVal == fixedPropPicklistVal) {
				return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
			}
		}

		return null;
	}
}