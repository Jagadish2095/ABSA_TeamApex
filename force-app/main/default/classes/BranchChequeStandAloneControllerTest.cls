/*
 * @author  André Pietersen : ABSA (IQ Business)
 * @version v1.0
 * @since   2021-04-08
 * 1.1   2021-09-01   André Pietersen (IQ Business)   Multiple source of funds transfer added
 */
@isTest
public class BranchChequeStandAloneControllerTest {
	@TestSetup
	static void makeData() {
		Account account = WillsTestDataFactory.createAccount();

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021', Price_Scheme_Code__c = 'TEST');
		insert prod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
			Name = 'Onboard New Product Everyday Banking Test',
			Sales_Process__c = 'Physical Channels Process',
			Opportunity_Record_Type__c = 'Physical Channels',
			Request_Name__c = 'TestRequest'
		);
		insert salesProcessType;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp Onboarding';
		opp.CloseDate = Date.today();
		opp.StageName = 'New';
		opp.Pricebook2Id = pb.id;
		opp.AccountId = account.id;
		opp.CBPIndicator__c = '123456789';
		insert opp;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		oppLineItem.Policy_Number__c = '4048272164';
		insert oppLineItem;

		Application__c app = new Application__c();
		app.Account__c = account.id;
		app.Opportunity__c = opp.Id;
		insert app;
	}

	@isTest
	public static void setupStandAloneChequeTest() {
		Id accountId = [SELECT Id FROM Account WHERE LastName = :'Test Account'].Id;
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
		String flowName = [SELECT Name FROM Sales_Process_Type__c WHERE Name = :'Onboard New Product Everyday Banking Test'].Name;

		Test.startTest();
		BranchChequeStandAloneController.setupStandAloneCheque(accountId, opp.Id, flowName);
		System.assert(opp != null, 'Test unsuccessful');
		Test.stopTest();
	}
}