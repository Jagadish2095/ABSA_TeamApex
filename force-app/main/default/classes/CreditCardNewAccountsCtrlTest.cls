/**
 * @description       : Test class for CreditcardNewAccount
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * @last modified on  : 2021-06-11
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   ephetehe.mokgopanyane@tetrad.co.za   Initial Version
 **/
@isTest
public class CreditCardNewAccountsCtrlTest {
	/**
	 * @description date creation
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
	 **/
	@TestSetup
	public static void makeData() {
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

		List<Application_Product__c> appProds = new List<Application_Product__c>();
		Application_Product__c appProd = new Application_Product__c();
		appProd.Product_State__c = 'Existing';
		appProd.Product_Name__c = 'Credit Card';
		appProd.Account_Balance__c = 90000;
		appProd.Account_Number__c = 12345667;
		appProd.Credit_Card_Limit__c = 78000;
		appProd.Allocated_Limit__c = 54500;
		appProd.Requested_facility_limit__c = '100000';
		appProd.Opportunity_Product_Id__c = 'Test';
		appProd.Opportunity__c = opportunity.Id;
		appProds.add(appProd);

		appProd = new Application_Product__c();
		appProd.Product_State__c = 'New';
		appProd.Product_Name__c = 'Credit Card';
		appProd.Account_Balance__c = 90000;
		appProd.Account_Number__c = 12345667;
		appProd.Credit_Card_Limit__c = 78000;
		appProd.Allocated_Limit__c = 54500;
		appProd.Requested_facility_limit__c = '100000';
		appProd.Opportunity_Product_Id__c = 'Test';
		appProd.Opportunity__c = opportunity.Id;
		appProds.add(appProd);

		insert appProds;

		Product2 prod = new Product2(Name = 'Credit Card', Family = 'Credit Card');
		insert prod;

		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;
		system.assertNotEquals(null, application);
	}

	@isTest
	public static void testDeleteAccount() {
		Application_Product__c appProd = [SELECT Id FROM Application_Product__c LIMIT 1];

		Test.startTest();
		Boolean deleteResult = CreditCardNewAccountsCtrl.deleteAccount(appProd.Id);
		system.assertEquals(true, deleteResult);
		Test.stopTest();
	}
}