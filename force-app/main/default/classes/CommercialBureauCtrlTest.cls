/**
 * @description       : Test class for CommercialBureauCtrl
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-07-16
 * @last modified by  : Gulafsha
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
 **/

@IsTest
public class CommercialBureauCtrlTest { 
	private static Application__c application;
	private static final String POSITIVE_RESPONSE_BODY = CommercialBureauEnquiry_Resp_IB_v1.getStringDummyResponse();

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CommercialBureauEnquiry_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Account account = new Account();
		account.Name = 'Test Account';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
		account.Client_Type__c = 'Company';
		insert account;

		Opportunity opportunity = new Opportunity();
		opportunity.Name = 'Test Opp Onboarding 1';
		opportunity.CloseDate = Date.today();
		opportunity.StageName = 'New';
		opportunity.AccountId = account.Id;
		insert opportunity;

		Application__c application = new Application__c();
		application.Opportunity__c = opportunity.id;
		application.Account_Access__c = 'Cellphone';
		application.Surplus_Cash__c = 'Fixed Deposits';
		application.Borrowing_Requiment_General__c = 'Credit Card';
		application.Protection_Of_Services__c = 'Retirement';
		application.Title__c = 'dd';
		application.FirstNameSignature__c = 'Litha';
		application.SurnameSignature__c = 'Nosekeleza';
		application.Signing_Date__c = System.today();
		application.Stock_Number__c = '';
		insert application;

		Application_Profile__c appProfile = new Application_Profile__c();
		appProfile.Client_CIF_Code__c = 'AABK   007';
		appProfile.Client_Name__c = 'Absa Bank';
		appProfile.Application__c = application.Id;
		appProfile.Applicant_Type__c = 'Main Applicant';
		appProfile.PCCE_Id__c = '000000409780';
		appProfile.Account__c = account.Id;
		insert appProfile;

		CommercialBureauCtrlTest.application = application;
	}

	@isTest
	public static void shouldGetApplicationProfiles() {
		Application_Profile__c appProfile = [SELECT Id, Application__r.Opportunity__c FROM Application_Profile__c WHERE PCCE_Id__c = :'000000409780'];
		appProfile.Bureau_JSON_Response__c = POSITIVE_RESPONSE_BODY;
		update appProfile;

		Test.startTest();
		List<Map<String, Object>> bureauData = CommercialBureauCtrl.getApplicationProfiles(appProfile.Application__r.Opportunity__c);
		Test.stopTest();

		System.assertNotEquals(null, bureauData);
		System.assertNotEquals(0, bureauData.size());
	}

	@isTest
	public static void shouldGetApplicationProfilesNoBureau() {
		Application_Profile__c appProfile = [SELECT Id, Application__r.Opportunity__c FROM Application_Profile__c WHERE PCCE_Id__c = :'000000409780'];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

		Test.startTest();
		List<Map<String, Object>> bureauData = CommercialBureauCtrl.getApplicationProfiles(appProfile.Application__r.Opportunity__c);
		Test.stopTest();

		System.assertNotEquals(null, bureauData);
	}
}