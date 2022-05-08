/*
 * VAS Rewards Test
 * @author André Pietersen IQ Business (ABSA)
 * @created 2021-02-20
 */
@isTest
public class VASRewardHelperTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"NewMemberRegistration_Resp_IB_v1":{"NewMemberRegistrationResponse": {"NewMemberRegistrationResult":{"MembershipNumber":"1234567890"}}}';
	public static final String POSITIVE_RESPONSE_BODY_REWARDS = '{"GetLookupsResponse":{"GetLookupsResult":{"DebitOrderAmounts":{"NonStaffAnnualFee":278.4,"NonStaffMonthlyFee":23.2,"StaffAnnualFee":139.2,"StaffMonthlyFee":11.6},"Languages":{"Language":[{"Code":"CLAAFR","Description":"Afrikaans"},{"Code":"CLAENG","Description":"English"},{"Code":"CLANDE","Description":"Ndebele"},{"Code":"CLANSO","Description":"North Sotho"},{"Code":"CLAOTH","Description":"Other"},{"Code":"CLASSO","Description":"South Sotho"},{"Code":"CLASWA","Description":"Swazi"},{"Code":"CLATSO","Description":"Tsonga"},{"Code":"CLATSW","Description":"Tswana"},{"Code":"CLAVEN","Description":"Venda"},{"Code":"CLAXHO","Description":"Xhosa"},{"Code":"CLAZUL","Description":"Zulu"}]},"MethodResponse":{"ErrorCode":"E0001","ErrorReferenceNumber":"8a558baf-223b-43b4-a21b-934bc6779dda"},"NotificationMethods":{"NotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"},{"Code":"NOMSMS","Description":"Sms"},{"Code":"NOMTEL","Description":"Telephone"}]},"RedemptionTypes":null,"StatementNotificationMethods":{"StatementNotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"}]}}}}';
	public static final String POSITIVE_RESPONSE_BODY_ACCOUNTS = '{"cip047o" :{"outputTable" :[{ "productType" : "CQ", "oaccntnbr" : 9051471582},{ "productType" : "SA", "oaccntnbr" : 4048143949},	{ "productType" : "CC", "oaccntnbr" : 4567123434566757 }]}}';

	@testSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ NewMemberRegistration_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ RewardsGetlookups_IH_v1.INTEGRATION_SERVICE_NAME });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CIgetAcctLinkedToClientCodeV3_IH_v1.INTEGRATION_SERVICE_NAME });

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
		insert prod;

		Product2 prod2 = new Product2(Name = 'Absa Rewards', Product_System__c = 'Absa Rewards System');
		insert prod2;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod2.Id, UnitPrice = 23.20, IsActive = true);
		insert customPrice2;

		Account account = new Account();
		account.ID_Number__pc = '9308305015082';
		account.FirstName = 'Test';
		account.LastName = 'Tester';
		account.Gender__pc = 'Male';
		account.Next_of_Kin_Last_Name__pc = 'Testing';
		account.Next_of_Kin_First_Name_s__pc = 'Testing';

		account.CIF__c = 'LTD 933';
		account.Language__c = 'english';
		account.Number_Of_Dependents__c = 0;
		account.PersonEmail = 'test@absa.africa';
		account.PersonMobilePhone = '0819908786';
		account.ID_Type__pc = 'PASSPORT';
		account.Nationality__pc = 'ZIM';
		account.Highest_Qualification__pc = 'Matric';
		account.Residential_Status__pc = 'Owner';
		account.Marital_Status__pc = 'MARRIED';
		account.CASA_Risk_Status__c = 'High';
		insert account;

		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp Onboarding';
		opp.CloseDate = Date.today();
		opp.StageName = 'New';
		opp.Pricebook2Id = pb.id;
		opp.AccountId = account.id;
		opp.Site__c = siteRec.id;
		opp.CBPIndicator__c = '123456789';
		insert opp;

		Application__c app = new Application__c();
		app.Opportunity__c = opp.id;
		app.Source_of_Funds__c = 'ALLOWANCE';
		insert app;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		oppLineItem.Policy_Number__c = '4048272164';
		insert oppLineItem;

		Address__c addr = new Address__c();
		addr.Shipping_Zip_Postal_Code__c = '0081';
		addr.Shipping_Street__c = 'Test';
		addr.Shipping_City__c = 'City';
		addr.Address_TYpe__c = 'Residential';
		addr.Account__c = account.Id;
		insert addr;

		Application_Product__c appProd = new Application_Product__c();
		appProd.Opportunity__c = opp.Id;
		appProd.Opportunity_Product_Id__c = oppLineItem.Id;
		insert appProd;
	}

	@isTest
	public static void testApplyReward() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_REWARDS));

		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		Account account = [SELECT Id FROM Account WHERE Name = 'Test Tester'];
		Product2 product = [SELECT Id FROM Product2 WHERE Name = 'Absa Rewards'];
		VASRewardHelper.ApplyReward(
			'{"oppId":"' +
			opp.Id +
			'","accountID":"' +
			account.Id +
			'","CCApplicationNumber":"102102181301051747","rewardDebitedFromValue":"Cheque","rewardDateDebitedValue":"01"}'
		);
		VASRewardHelper.callProductSystem(product.Id);
		VASRewardHelper.getRewardsMonthlyFee();
		System.assert(opp != null, 'Test unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void getAccountsLinkedToCustomerTest()
	{
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_ACCOUNTS));
		List<VASRewardHelper.VasRewardsObject> accounts = VASRewardHelper.getAccountsLinkedToCustomer(opp.Id, '');

		System.assert(accounts.size() > 0, 'Success');

		Test.stopTest();
	}

	
	@isTest
	public static void getAccountsLinkedToCustomerWithCreditCardTest()
	{
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_ACCOUNTS));
		List<VASRewardHelper.VasRewardsObject> accounts = VASRewardHelper.getAccountsLinkedToCustomer(opp.Id, '102102181301051747');

		Boolean hasCreditCardAccount = false;

		for(VASRewardHelper.VasRewardsObject account :accounts){
			if(account.rewardDebitedFromValue == '102102181301051747'){
				hasCreditCardAccount = true;
			}
		}
		System.assert(hasCreditCardAccount, 'Success');
		Test.stopTest();
	}
}