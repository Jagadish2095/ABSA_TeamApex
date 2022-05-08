/**
 * @description       : ASPPinpadControllerTest
 * @author            : Paul du Randt
 * @last modified on  : 2021-10-07
 * @last modified by  : André Pietersen (IQ Business)
 **/

@isTest
public class ASPPinpadControllerTest {
	@testSetup
	static void dataCreation() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			Account acc = new Account();
			acc.FirstName = 'First test';
			acc.LastName = 'last test';
			acc.CIF__c = 'LTD 933';
			acc.Language__c = 'english';
			acc.Number_Of_Dependents__c = 0;
			acc.PersonEmail = 'test@absa.africa';
			acc.Phone = '0819908786';
			acc.Contact_Method__pc = 'Email';
			acc.ID_Number__pc = '9308124512515';
			insert acc;

			site__c siteRec = new site__c();
			siteRec.Site_Code__c = '1334';
			siteRec.Name = 'Test';
			insert siteRec;

			Opportunity opp = new Opportunity();
			opp.Name = 'Test Opp Onboarding';
			opp.CloseDate = Date.today();
			opp.StageName = 'New';
			opp.AccountId = acc.id;
			opp.Site__c = siteRec.id;
			insert opp;

			Application__c app = new Application__c();
			app.Opportunity__c = opp.id;
			app.Account__c = acc.id;
			app.Source_of_Funds_Savings__c = '27	ALLOWANCE';
			insert app;

			Payment_Plan__c paymentplan = new Payment_Plan__c();
			paymentplan.Account_Number__c = '';
			paymentplan.Account_Holder_Name__c = '';
			paymentplan.Bank_Name__c = '';
			paymentplan.Branch_Code__c = 8311;
			paymentplan.Account_Number__c = '';
			paymentplan.Amount__c = 1541245;
			paymentplan.Application__c = app.id;
			paymentplan.Status__c = 'New';
			paymentplan.Method__c = 'Debit Order';
			insert paymentplan;
		}
	}

	@isTest
	public static void testDummyRequest() {
		ASPPinpadRequest test = new ASPPinpadRequest();
		test.DummyONUSandNOUSRequest();
        System.assert(test != null, 'Test empty');
	}

	@isTest
	public static void GetPinPadRequestMetadataONUSandNOUS() {
		Test.startTest();
		Payment_Plan__c RecordId = [SELECT Id FROM Payment_Plan__c WHERE Amount__c = 1541245 LIMIT 1];
		String result = ASPPinpadController.GetPinPadRequestMetadata('ONUSandNOUS', RecordId.Id);
        System.assert(result != null, 'result empty');
		Test.stopTest();
	}

	@isTest
	public static void GetPinPadRequestMetadataNewEPin() {
		Test.startTest();
		Payment_Plan__c RecordId = [SELECT Id FROM Payment_Plan__c WHERE Amount__c = 1541245 LIMIT 1];
		String result = ASPPinpadController.GetPinPadRequestMetadata('NewEPin', RecordId.Id);
        System.assert(result != null, 'result empty');
		Test.stopTest();
	}
}