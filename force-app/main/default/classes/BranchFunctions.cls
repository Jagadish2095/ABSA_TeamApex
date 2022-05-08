/**
 * @description       : BranchFunctions
 * @author            : Clifford Willers
 * @last modified on  : 2021-09-07
 * @last modified by  : PaulJohn.duRand@absa.africa
**/

public without sharing class BranchFunctions {
	/**
	 * @description getFieldPickListValues
	 * @return List<String>
	 * @param objObject
	 * @param objField
	 */
	@AuraEnabled
	public static List<String> getFieldPickListValues(sObject objObject, string objField) {
		List<String> allOpts = new List<String>();
		Schema.sObjectType objType = objObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		list<Schema.PicklistEntry> values = fieldMap.get(objField).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : values) {
			if (a.isActive()) {
				//String fieldValue = toProperCase(a.getValue().trim());
				allOpts.add(a.getValue().trim());
			}
		}
		allOpts.sort();
		return allOpts;
	}
	/**
	 * @description getTranslationValues
	 * @return List<String>
	 * @param systemName
	 * @param valueType
	 * @param direction
	 */
	@AuraEnabled
	public static List<String> getTranslationValues(String systemName, String valueType, String direction) {
		List<String> listValues = new List<String>();
		Integration_Translation__c[] returnValues = [
			SELECT Internal_Value__c
			FROM Integration_Translation__c
			WHERE System_Name__c = :systemName AND Value_Type__c = :valueType AND Direction__c = :direction
			WITH SECURITY_ENFORCED
		];
		for (Integration_Translation__c returnValue : returnValues) {
			//String translationValue = toProperCase(returnValue.Internal_Value__c.trim());
			listValues.add(returnValue.Internal_Value__c.trim());
		}
		return listValues;
	}
	/**
	 * @description getValidTranslations
	 * @return Map<String,String>
	 * @param systemName
	 * @param valueType
	 * @param direction
	 * @param objObject
	 * @param objField
	 */
	@AuraEnabled
	public static Map<String, String> getValidTranslations(String systemName, String valueType, String direction, sObject objObject, string objField) {
		Map<String, String> mapValues = new Map<String, String>();
		List<String> listValues = getFieldPickListValues(objObject, objField);
		List<String> translationValues = getTranslationValues(systemName, valueType, direction);
		for (String translationItem : translationValues) {
			if (listValues.indexOf(translationItem) != -1) {
				mapValues.put(translationItem, 'valid');
			} else {
				mapValues.put(translationItem, 'inValid');
			}
		}
		return mapValues;
	}
	/**
	 * @description getFieldPigetBankInfockListValues
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getBankInfo() {
		List<String> allOpts = new List<String>();
		BankInfo__c[] bankInfo = [SELECT Name FROM BankInfo__c];
		for (BankInfo__c bankObj : bankInfo) {
			allOpts.add(bankObj.Name);
		}
		return allOpts;
	}

	/**
	 * @description toProperCase
	 * @author Clifford.willers@absa.africa | 2021-08-18
	 * @param value
	 * @return String
	 **/
	public static String toProperCase(String value) {
		value = value.toLowerCase();
		List<String> parts = new List<String>();
		for (String s : value.split(' ')) {
			s = s.capitalize();
			parts.add(s);
		}

		return String.join(parts, ' ');
	}

	/**
	 * @description Get account Id (ApplicationId,OpportunityId or AccountId can be parsed )
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param objId
	 * @return string
	 **/
	public static string getAccountId(string objId) {
		List<Account> accounts = [SELECT Id FROM Account WHERE Id = :objId WITH SECURITY_ENFORCED];
		if (!accounts.isEmpty()) {
			return accounts.get(0).Id;
		}
		List<Opportunity> opportunities = getOpportunities(objId);
		if (!opportunities.isEmpty()) {
			return opportunities.get(0).AccountId;
		}
		List<Application__c> applications = getApplications(objId);
		if (!applications.isEmpty()) {
			return applications.get(0).Account__c;
		}
		return objId;
	}

	/**
	 * @description Get Opportunity Id (ApplicationId or OpportunityId can be parsed )
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param objId
	 * @return string
	 **/
	public static string getOpportunityId(string objId) {
		List<Opportunity> opportunities = getOpportunities(objId);
		if (!opportunities.isEmpty()) {
			return opportunities.get(0).Id;
		}
		List<Application__c> applications = getApplications(objId);
		if (!applications.isEmpty()) {
			return applications.get(0).Opportunity__c;
		}
		return objId;
	}

	/**
	 * @description Get Application Id (ApplicationId or OpportunityId can be parsed )
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param objId
	 * @return string
	 **/
	public static string getApplicationId(string objId) {
		List<Application__c> applications = getApplications(objId);
		if (!applications.isEmpty()) {
			return applications.get(0).Id;
		}
		List<Application__c> opportunities = [SELECT Id FROM Application__c WHERE Opportunity__c = :objId];
		if (!opportunities.isEmpty()) {
			return opportunities.get(0).Id;
		}
		return objId;
	}

	/**
	 * @description get Opportunities
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param objId
	 * @return List<Opportunity>
	 **/
	private static List<Opportunity> getOpportunities(string objId) {
		return [SELECT Id, AccountId FROM Opportunity WHERE Id = :objId WITH SECURITY_ENFORCED];
	}

	/**
	 * @description GetApplications
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param objId
	 * @return List<Application__c>
	 **/
	private static List<Application__c> getApplications(string objId) {
		return [SELECT Id, Account__c, Opportunity__c FROM Application__c WHERE Id = :objId];
	}

	/**
	 * @description isBusinessProspect
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param accountId
	 * @return Boolean
	 **/
	public static Boolean isBusinessProspect(string accountId) {
		Account account = [SELECT RecordType.Name FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED];
		if (account.RecordType.Name == 'Business Client' || account.RecordType.Name == 'Business Prospect') {
			return true;
		} else {
			return false;
		}
	}
}