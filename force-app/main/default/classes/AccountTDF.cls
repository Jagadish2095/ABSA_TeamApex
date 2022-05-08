/**
 * @description       : To create test data for the Account object, the class caters for each Account record type
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-05-26
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-05-26   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class AccountTDF {
	private static Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 **/
	public AccountTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addClient(String clientType, String name) {
		Account clientAcc = new Account();
		clientAcc.RecordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId();
		clientAcc.Client_Type__c = clientType;
		clientAcc.Name = name;
		insert clientAcc;
		return clientAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndustriesBusiness(String clientType, String name) {
		Account industriesBusinessAcc = new Account();
		industriesBusinessAcc.RecordTypeId = accountRecordTypeMap.get('IndustriesBusiness').getRecordTypeId();
		industriesBusinessAcc.Client_Type__c = clientType;
		industriesBusinessAcc.Name = name;
		insert industriesBusinessAcc;
		return industriesBusinessAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addProspect(String clientType, String name) {
		Account prospectAcc = new Account();
		prospectAcc.RecordTypeId = accountRecordTypeMap.get('Prospect').getRecordTypeId();
		prospectAcc.Client_Type__c = clientType;
		prospectAcc.Name = name;
		insert prospectAcc;
		return prospectAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndustriesHousehold(String clientType, String name) {
		Account industriesHouseholdAcc = new Account();
		industriesHouseholdAcc.RecordTypeId = accountRecordTypeMap.get('IndustriesHousehold').getRecordTypeId();
		industriesHouseholdAcc.Client_Type__c = clientType;
		industriesHouseholdAcc.Name = name;
		insert industriesHouseholdAcc;
		return industriesHouseholdAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndustriesIndividual(String clientType, String name) {
		Account industriesIndividualAcc = new Account();
		industriesIndividualAcc.RecordTypeId = accountRecordTypeMap.get('IndustriesIndividual').getRecordTypeId();
		industriesIndividualAcc.Client_Type__c = clientType;
		industriesIndividualAcc.Name = name;
		insert industriesIndividualAcc;
		return industriesIndividualAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndividualClient(String clientType, String name) {
		Account individualClientAcc = new Account();
		individualClientAcc.RecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
		individualClientAcc.Client_Type__c = clientType;
		individualClientAcc.LastName = name;
		insert individualClientAcc;
		return individualClientAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndividualProspect(String clientType, String name) {
		Account individualProspectAcc = new Account();
		individualProspectAcc.RecordTypeId = accountRecordTypeMap.get('Individual_Prospect').getRecordTypeId();
		individualProspectAcc.Client_Type__c = clientType;
		individualProspectAcc.LastName = name;
		insert individualProspectAcc;
		return individualProspectAcc;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-08
	 * @param clientType
	 * @param name
	 * @return Account
	 **/
	public static Account addIndustriesInstitution(String clientType, String name) {
		Account industriesInstitutionAcc = new Account();
		industriesInstitutionAcc.RecordTypeId = accountRecordTypeMap.get('IndustriesInstitution').getRecordTypeId();
		industriesInstitutionAcc.Client_Type__c = clientType;
		industriesInstitutionAcc.Name = name;
		insert industriesInstitutionAcc;
		return industriesInstitutionAcc;
	}
}