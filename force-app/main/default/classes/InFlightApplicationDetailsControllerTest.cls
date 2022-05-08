/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 05-21-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-20-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
/**
 * @description InFlightApplicationDetailsController
 * @author: Jabulani Mashia
 */
@isTest
public class InFlightApplicationDetailsControllerTest {
	public static Account acc;
	/**
	 * @description makeData
	 */
	@testSetup
	public static void makeData() {
		acc = new account();
		acc.Name = 'Testingacc';
		insert acc;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
		insert prod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;
		Opportunity opportunity = new Opportunity();
		opportunity.Name = 'Test Opp Onboarding';
		opportunity.CloseDate = Date.today();
		opportunity.StageName = 'Open';
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
		opportunity.AccountId = acc.Id;
		insert opportunity;

		OpportunityLineItem opplineItem = new OpportunityLineItem();
		opplineItem.OpportunityId = opportunity.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		oppLineItem.Policy_Number__c = '4048371403';
		insert oppLineItem;

		List<InFlightApplicationDetailsController.InFlightApplication> applications = new List<InFlightApplicationDetailsController.InFlightApplication>();
		List<Opportunity> opportunities = [
			SELECT Id, StageName, Name
			FROM Opportunity
			WHERE AccountId = :acc.Id AND StageName IN ('Apply Product', 'Open')
			WITH SECURITY_ENFORCED
		];
		InFlightApplicationDetailsController.InFlightApplication inflightApplication = new InFlightApplicationDetailsController.InFlightApplication();

		for (Opportunity opportunity2 : opportunities) {
			inflightApplication.opportunityId = opportunity2.Id;
			inflightApplication.stage = 'New';
			inflightApplication.name = 'Test Opp Onboarding 1';
			inflightApplication.products = '';
		}
		List<OpportunityLineItem> lineItems = [SELECT Name FROM OpportunityLineItem WHERE OpportunityId = :opportunity.Id WITH SECURITY_ENFORCED];
		for (OpportunityLineItem application : lineItems) {
			inflightApplication.products += inflightApplication.products == '' ? '' : ' - ';
			inflightApplication.products += application.Name + ' ';
		}
		applications.Add(inflightApplication);
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
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
	}
	@isTest
	public static void getInFlightApplicationsPositiveTest() {
		Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Name = 'Test Opp Onboarding' LIMIT 1];
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			test.startTest();
			List<InFlightApplicationDetailsController.InFlightApplication> listInflighticatAppl = InFlightApplicationDetailsController.getInFlightApplications(
				opp.AccountId
			);

			system.assert(listInflighticatAppl.size() > 0, 'assert failed');

			test.stopTest();
		}

	}
	@isTest
	public static void getInFlightApplicationsTestNegative() {
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding' LIMIT 1];
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			test.startTest();
			List<InFlightApplicationDetailsController.InFlightApplication> listInflighticatAppl = InFlightApplicationDetailsController.getInFlightApplications(
				opp.Id
			);
			system.assert(listInflighticatAppl.size() == 0, 'assert failed');
			test.stopTest();
		}

	}
}