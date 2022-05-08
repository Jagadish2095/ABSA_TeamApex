/**
 * @description       : To create test data for the Contact object, the class caters for each Contact record type
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-21
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-21   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class ContactTDF {
	private static Map<String, Schema.RecordTypeInfo> contactRecordTypeMap = Contact.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	public ContactTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @return Contact
	 **/
	public static Contact addBusiness(String name) {
		Contact businessCon = new Contact();
		businessCon.RecordTypeId = contactRecordTypeMap.get('IndustriesBusiness').getRecordTypeId();
		businessCon.LastName = name;
		insert businessCon;
		return businessCon;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @return Contact
	 **/
	public static Contact addContact(String name) {
		Contact contactCon = new Contact();
		contactCon.RecordTypeId = contactRecordTypeMap.get('Contact').getRecordTypeId();
		contactCon.LastName = name;
		insert contactCon;
		return contactCon;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @return Contact
	 **/
	public static Contact addIndividual(String name) {
		Contact individualCon = new Contact();
		individualCon.RecordTypeId = contactRecordTypeMap.get('IndustriesIndividual').getRecordTypeId();
		individualCon.LastName = name;
		insert individualCon;
		return individualCon;
	}
}