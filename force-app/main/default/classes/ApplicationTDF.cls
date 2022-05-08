/**
 * @description       : To create test data for the Application__c object, the class caters for each Application__c record type
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-07-01
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-07-01   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class ApplicationTDF {
	private static Map<String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 **/
	public ApplicationTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param opportunity
	 * @return Application__c
	 **/
	public static Application__c addMerchantOnboardingApp(Id opportunity) {
		Application__c merchOnboardApp = new Application__c();
		merchOnboardApp.Opportunity__c = opportunity;
		merchOnboardApp.RecordTypeId = applicationRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
		insert merchOnboardApp;
		return merchOnboardApp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param opportunity
	 * @return Application__c
	 **/
	public static Application__c addOnboardingApp(Id opportunity) {
		Application__c onboardApp = new Application__c();
		onboardApp.Opportunity__c = opportunity;
		onboardApp.RecordTypeId = applicationRecordTypeMap.get('Onboarding').getRecordTypeId();
		insert onboardApp;
		return onboardApp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param opportunity
	 * @return Application__c
	 **/
	public static Application__c addWillsApp(Id opportunity) {
		Application__c willsApp = new Application__c();
		willsApp.Opportunity__c = opportunity;
		willsApp.RecordTypeId = applicationRecordTypeMap.get('Wills').getRecordTypeId();
		insert willsApp;
		return willsApp;
	}
}