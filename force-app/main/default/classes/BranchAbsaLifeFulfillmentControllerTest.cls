/**
 * @description Test Class for Absa Life Products
 * @author  Haritha
 * @created 2021-09-14
 */
@isTest
public class BranchAbsaLifeFulfillmentControllerTest{

	@testSetup
	static void makeData(){
		Account account1 = new Account();
		account1.Name = 'Test Account1';
		insert account1;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account1.Id, Email = 'agents@support.co.za');
		insert contact;
		
        Opportunity testOpp = new Opportunity();
		testOpp.Name = account1.Name + '-' + 'ABSA LIFE';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
		testOpp.AccountId = account1.Id;
		insert testOpp;
        
		Product2 prod1 = new Product2(Name = 'Instant Life', Family = 'WIMI',  IsActive = TRUE);
		insert prod1;
		Product2 prod2 = new Product2(Name = 'Ulitimate Protector', Family = 'WIMI',  IsActive = TRUE);
		insert prod2;

		Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
		PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, prod1.Id);
		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = testOpp.Id;
		testApplication.ROAQuestionnaire__c = '[{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Both"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Graduate"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"None"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Student"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"How much is your monthly income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"R0 - R3000+"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":true,"AnswerType":"radio","AnswerId":"Fit and Proper"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":false,"AnswerType":"radio","AnswerId":"Working under supervision"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":true,"AnswerType":"checkbox","AnswerId":"Long-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Long-term Insurance subcategory B1-A"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Participatory interest in a collective investment scheme"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Insurance Personal Lines"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Structured Deposits"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"}]';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Application_Status__c = 'Pending';
		insert testApplication;
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.OpportunityId = testOpp.Id;
		oli.Product2Id = prod1.Id;
		oli.PriceBookEntryid = pricebookEntry.Id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		insert oli;

		Opportunity testOpp2 = new Opportunity();
		testOpp2.Name = 'Test Opp Onboarding 2';
		testOpp2.CloseDate = Date.today();
		testOpp2.StageName = StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT;
		testOpp2.AccountId = account1.Id;
		insert testOpp2;

		Application__c testApplication2 = new Application__c();
		testApplication2.Opportunity__c = testOpp2.Id;
		testApplication2.ROAQuestionnaire__c = '[{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"Do you have a regular income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"No"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"Do you already have any other financial products at other institutions?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Yes"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Both"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Graduate"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"None"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"Are you a student or graduate?","IsSelected":false,"AnswerType":"dropdown","AnswerId":"Student"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"How much is your monthly income?","IsSelected":true,"AnswerType":"dropdown","AnswerId":"R0 - R3000+"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"Can you afford the financial product?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":false,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":8,"RecommendedProducts":null,"QuestionId":"Do you understand the financial product you want to buy?","IsSelected":true,"AnswerType":"radio","AnswerId":"Yes"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":true,"AnswerType":"radio","AnswerId":"Fit and Proper"},{"sequenceNumber":9,"RecommendedProducts":null,"QuestionId":"I understand that the Sales Representative is:","IsSelected":false,"AnswerType":"radio","AnswerId":"Working under supervision"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":true,"AnswerType":"checkbox","AnswerId":"Long-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Long-term Insurance subcategory B1-A"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Participatory interest in a collective investment scheme"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Deposits"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Short-term Insurance Personal Lines"},{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"The Absa Representative is registered to provide advice for the following financial product categories:","IsSelected":false,"AnswerType":"checkbox","AnswerId":"Structured Deposits"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":true,"AnswerType":"radio","AnswerId":"No"},{"sequenceNumber":11,"RecommendedProducts":null,"QuestionId":"Are you interested in an Absa Life product?","IsSelected":false,"AnswerType":"radio","AnswerId":"Yes"}]';
		testApplication2.Preferred_Communication_Method__c = 'Email';
		testApplication2.Fees_Waived__c = true;
		testApplication2.Application_Status__c = 'Pending';
		insert testApplication2;
	}

	@IsTest
	static void TestIfCanApplyForProductOnOpportunity(){

		Boolean hasSelected = false;
		Account account1 = [select id, Name
		                    from Account
		                    where Name = 'Test Account1'];
        String name = account1.Name + '-' + 'ABSA LIFE';
		Opportunity testOpp = [SELECT Id
		                       FROM Opportunity
		                       WHERE Name =: name ];
		string prodnames = 'Instant Life';

		BranchAbsaLifeFulfillmentController.updateAbsaLifeOpportunityWithProducts(testOpp.Id, prodnames);
		List<BranchAbsaLifeFulfillmentController.SelectedAbsaLifeProducts> appliedProducts = BranchAbsaLifeFulfillmentController.getSelectedAndComletedProducts(testOpp.Id);

		for (BranchAbsaLifeFulfillmentController.SelectedAbsaLifeProducts poduct : appliedProducts){
			if (poduct.isSelected && poduct.productName == prodnames){
				hasSelected = true;
				break;
			}


		}
		system.assert(hasSelected == true, 'Instant Life is selected');
	}

	@IsTest
	static void isAbsaLifeSelectedInRoaTrue(){
        
        Account account1 = [select id, Name
		                    from Account
		                    where Name = 'Test Account1'];
        String name = account1.Name + '-' + 'ABSA LIFE';
		Opportunity testOpp = [SELECT Id
		                       FROM Opportunity
		                       WHERE Name =: name ];
        
		Boolean hasAbsaLife = BranchAbsaLifeFulfillmentController.isAbsaLifeSelectedInRoa(testOpp.Id);
		system.assert(hasAbsaLife == true, 'Yes Selected For ABSA Life Question');
	}

	@IsTest
	static void isAbsaLifeSelectedInRoaFalse(){
		Opportunity testOpp = [SELECT Id
		                       FROM Opportunity
		                       WHERE Name = 'Test Opp Onboarding 2'];
		Boolean hasAbsaLife = BranchAbsaLifeFulfillmentController.isAbsaLifeSelectedInRoa(testOpp.Id);
		system.assert(hasAbsaLife == false, 'No Selected For ABSA Life Question');
	}

	@IsTest
	static void TestgetAbsaLifeProducts(){
		List<Product2> products = BranchAbsaLifeFulfillmentController.getAbsaLifeProducts();
		system.assert(products.size() > 0, 'Returns At least 1 active product');
	} 

	@IsTest
	static void TestIfCanApplyForProductOnAccount(){

		Boolean hasSelected = false;

		Account account1 = [select id, Name
		                    from Account
		                    where Name = 'Test Account1'];
        String name = account1.Name + '-' + 'ABSA LIFE';
		Opportunity testOpp = [SELECT Id
		                       FROM Opportunity
		                       WHERE Name =: name ];


		string prodnames = 'Instant Life';
		list<string> prodlist = new List<string>();
		prodlist.add(prodnames);

		String testOppId = BranchAbsaLifeFulfillmentController.createAbsaLifeOpportunityWithProducts(account1.Id, prodlist);
		List<BranchAbsaLifeFulfillmentController.SelectedAbsaLifeProducts> appliedProducts = BranchAbsaLifeFulfillmentController.getSelectedAndComletedProducts(testOppId);
		//BranchAbsaLifeFulfillmentController.closeOpportunity(testOppId);
		for (BranchAbsaLifeFulfillmentController.SelectedAbsaLifeProducts poduct : appliedProducts){
			if (poduct.isSelected && poduct.productName == prodnames){
				hasSelected = true;
				break;
			}
		}

		system.assert(hasSelected == true, 'Instant Life is selected on existing Account');
	}
}