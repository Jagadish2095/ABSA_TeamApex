/**
 * @description       : Test class Controller used by lightning components for Terms Of Business under Sanctioning
 * @author            : Almas Aleem
 * @last modified on  : 2021-10-18
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Almas Aleem   Initial Version
 **/

@isTest
public class ProductTermsOfBusinessControllerTest {
	@isTest
	static void testGetProductTermsOfBusiness() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Application_Product__c childApprod = [
			SELECT Id, Name
			FROM Application_Product__c
			WHERE Application_Product_Parent__c = NULL AND opportunity__c = :opp.Id
			LIMIT 1
		];

		Application__c testApplication = [SELECT id FROM Application__c LIMIT 1];

		Application_scoring__c appScore = new Application_scoring__c();
		appScore.name = 'a1';
		appScore.Stage__c = '7';
		appScore.SYST_Decision__c = 'A';
		appScore.Application_Number__c = testApplication.Id;
		appScore.Reason__c = 'Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
		appScore.Reason_Description__c = 'aaaa,bbbb,cccc,dddd,eeee';
		appScore.Exception__c = 'Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
		appScore.Exception_Description__c = 'uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
		appScore.ReqTotAddPotentialOc__c = 0;
		appScore.ReqPotentialTotGroup__c = 0;
		appScore.ReqPotentialTgae__c = 0;
		appScore.ReqPotentialTgbe__c = 0;
		appScore.ReqPotentialTfl__c = 0;
		appScore.Potential_OC_Offered__c = 0;
		appScore.Potential_TGE_Offered__c = 0;
		appScore.Potential_TGAE_Offered__c = 0;
		appScore.Potential_TGBE_Offered__c = 0;
		appScore.Potential_TGBOE_Offered__c = 0;
		appScore.Potential_OC_Final__c = 0;
		appScore.Potential_TGE_Final__c = 0;
		appScore.Potential_TGAE_Final__c = 0;
		appScore.Potential_TGBE_Final__c = 0;
		appScore.Potential_TGBOE_Final__c = 0;
		insert appScore;

		Application_Scoring_Product__c scoProduct1 = new Application_Scoring_Product__c();
		scoProduct1.Unique_Product_ID__c = String.valueof(childApprod.Name);
		scoProduct1.Application_Scoring__c = appScore.Id;
		scoProduct1.Final_Decision__c = 'A';
		scoProduct1.Final_Init_Fee_Amount__c = 2000;
		scoProduct1.Offer_Init_Fee_Amount__c = 1200;
		scoProduct1.Offer_Int_Rate__c = 6;
		scoProduct1.Final_Int_Rate__c = 6;
		scoProduct1.Final_Int_Rate_Prime_Plus__c = 6;
		scoProduct1.Offer_Int_Rate_Prime_Plus__c = 6;
		scoProduct1.Offer_OD_Limit_Type__c = 3;
		scoProduct1.Final_OD_Limit_Type__c = 3;
		scoProduct1.Offer_Total_Amount__c = 100000;
		scoProduct1.Final_Total_Amount__c = 100000;
		scoProduct1.Offer_Reduction_Amount__c = 4000;
		scoProduct1.Final_Reduction_Amount__c = 4000;
		scoProduct1.NCA_Max_Rate__c = 25;
		scoProduct1.Offer_Service_Fee__c = 69;
		scoProduct1.Final_Service_Fee__c = 69;
		insert scoProduct1;

		List<Application_Product__c> appProdList = new List<Application_Product__c>();
		appProdList.add(childApprod);

		SetProductTOBController.mapFromPCOResponse(appProdList, '7');
		test.startTest();
		List<ProductTermsOfBusinessController.ProductTOB> tobList = new List<ProductTermsOfBusinessController.ProductTOB>();
		tobList = ProductTermsOfBusinessController.getproductTOB(opp.Id);
		// ProductTermsOfBusinessController.ProductTOB = tobList[0];
		// Id tempId = tob.appProdId;

		ProductTermsOfBusinessController.getfWrapperList();
		ProductTermsOfBusinessController.getLimitTypeFields();

		ProductTermsOfBusinessController.getfWrapperListOrigination();
		tobList = ProductTermsOfBusinessController.getproductTOBOrigination(opp.Id);

		ProductTermsOfBusinessController.saveTOB(childApprod.Id);
		childApprod.Product_Status__c = 'Accepted';

		update childApprod;

		ProductTermsOfBusinessController.submitDecisionHistory(childApprod.Id);
		ProductTermsOfBusinessController.getProductDecisionHistory(childApprod.Id);

		productTermsOfBusinessController.updateDeclineTOB(childApprod.Id);
		//ProductTermsOfBusinessController.
		//ProductTermsOfBusinessController.submitDecisionHistory(prodId)
		test.stopTest();
		system.assertNotEquals(tobList, null);
	}

	@isTest
	static void testGetProductTermsOfBusinessSelector() {
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

		Application_Product__c childApprod = [
			SELECT Id, Name
			FROM Application_Product__c
			WHERE Application_Product_Parent__c = NULL AND opportunity__c = :opp.Id
			LIMIT 1
		];

		Application__c testApplication = [SELECT id FROM Application__c LIMIT 1];

		Application_Product__c childApprod2 = [
			SELECT Id, Name
			FROM Application_Product__c
			WHERE Application_Product_Parent__c = NULL AND opportunity__c = :opp.Id AND Product_State__c = 'Existing'
			LIMIT 1
		];

		Application_scoring__c appScore = new Application_scoring__c();
		appScore.name = 'a1';
		appScore.Stage__c = '7';
		appScore.SYST_Decision__c = 'A';
		appScore.Application_Number__c = testApplication.Id;
		appScore.Reason__c = 'Reason 1,Reason 2,Reason 3,Reason 4,Reason 5';
		appScore.Reason_Description__c = 'aaaa,bbbb,cccc,dddd,eeee';
		appScore.Exception__c = 'Exception 1,Exception 2,Exception 3,Exception 4,Exception 5';
		appScore.Exception_Description__c = 'uuuu,vvvv,wwww,xxxx,yyyy,zzzz';
		appScore.ReqTotAddPotentialOc__c = 0;
		appScore.ReqPotentialTotGroup__c = 0;
		appScore.ReqPotentialTgae__c = 0;
		appScore.ReqPotentialTgbe__c = 0;
		appScore.ReqPotentialTfl__c = 0;
		appScore.Potential_OC_Offered__c = 0;
		appScore.Potential_TGE_Offered__c = 0;
		appScore.Potential_TGAE_Offered__c = 0;
		appScore.Potential_TGBE_Offered__c = 0;
		appScore.Potential_TGBOE_Offered__c = 0;
		appScore.Potential_OC_Final__c = 0;
		appScore.Potential_TGE_Final__c = 0;
		appScore.Potential_TGAE_Final__c = 0;
		appScore.Potential_TGBE_Final__c = 0;
		appScore.Potential_TGBOE_Final__c = 0;
		insert appScore;

		Application_Scoring_Product__c scoProduct1 = new Application_Scoring_Product__c();
		scoProduct1.Unique_Product_ID__c = String.valueof(childApprod.Name);
		scoProduct1.Application_Scoring__c = appScore.Id;
		scoProduct1.Final_Decision__c = 'A';
		scoProduct1.Final_Init_Fee_Amount__c = 2000;
		scoProduct1.Offer_Init_Fee_Amount__c = 1200;
		scoProduct1.Offer_Int_Rate__c = 6;
		scoProduct1.Final_Int_Rate__c = 6;
		scoProduct1.Final_Int_Rate_Prime_Plus__c = 6;
		scoProduct1.Offer_Int_Rate_Prime_Plus__c = 6;
		scoProduct1.Offer_OD_Limit_Type__c = 3;
		scoProduct1.Final_OD_Limit_Type__c = 3;
		scoProduct1.Offer_Total_Amount__c = 100000;
		scoProduct1.Final_Total_Amount__c = 100000;
		scoProduct1.Offer_Reduction_Amount__c = 4000;
		scoProduct1.Final_Reduction_Amount__c = 4000;
		scoProduct1.NCA_Max_Rate__c = 25;
		scoProduct1.Offer_Service_Fee__c = 69;
		scoProduct1.Final_Service_Fee__c = 69;
		insert scoProduct1;

		List<Application_Product__c> appProdList = new List<Application_Product__c>();
		appProdList.add(childApprod);

		SetProductTOBController.mapFromPCOResponse(appProdList, '7');

		new TermsOfBusinessSelector().selectByAppProducts(appProdList);
		new TermsOfBusinessSelector().selectByAppProductsByPricing(appProdList);

		SetProductTOBController.updateTOB(childApprod.Id);
		SetProductTOBController.updateTOB(childApprod2.Id);
		test.startTest();
		List<ProductTermsOfBusinessController.ProductTOB> tobList = new List<ProductTermsOfBusinessController.ProductTOB>();
		tobList = ProductTermsOfBusinessController.getproductTOB(opp.Id);

		ProductTermsOfBusinessController.getfWrapperList();
		ProductTermsOfBusinessController.getLimitTypeFields();

		ProductTermsOfBusinessController.getfWrapperListOrigination();
		tobList = ProductTermsOfBusinessController.getproductTOBOrigination(opp.Id);

		ProductTermsOfBusinessController.saveTOB(childApprod.Id);
		childApprod.Product_Status__c = 'Accepted';

		update childApprod;

		ProductTermsOfBusinessController.saveTOB(childApprod2.Id);

		ProductTermsOfBusinessController.submitDecisionHistory(childApprod.Id);
		ProductTermsOfBusinessController.getProductDecisionHistory(childApprod.Id);

		productTermsOfBusinessController.updateDeclineTOB(childApprod.Id);

		test.stopTest();
		system.assertNotEquals(tobList, null);
	}

	@testSetup
	static void createData() {
		Account mainAccount = new Account(Name = 'Test Main Account');
		insert mainAccount;

		Opportunity opp = new Opportunity(Name = 'testopp', AccountId = mainAccount.Id, StageName = 'New', CloseDate = system.today());
		insert opp;

		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		AccountContactRelation accConnRel = new AccountContactRelation();
		accConnRel.AccountId = mainAccount.Id;
		accConnRel.ContactId = contact.Id;
		insert accConnRel;

		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
		insert prod;

		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
		insert standardPrice;

		Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
		insert customPB;

		PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
		insert customPrice;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		insert oppLineItem;

		Application_Product__c parentApplicationRecord = new Application_Product__c();
		parentApplicationRecord.Opportunity__c = opp.Id;
		parentApplicationRecord.Product_Name__c = 'Cheque';
		parentApplicationRecord.Product_Type__c = '11021'; //API picklist value for CLASSIC BUSINESS ACCOUNT
		//parentApplicationRecord.Account_Number__c = 123456789;
		parentApplicationRecord.Product_State__c = 'New';
		parentApplicationRecord.Opportunity_Product_Id__c = '001';
		parentApplicationRecord.Product_Status__c = 'Accepted';
		parentApplicationRecord.Accept_TOB__c = true;

		insert parentApplicationRecord;

		Application_Product__c childApplicationRecord = new Application_Product__c();
		childApplicationRecord.Opportunity__c = opp.Id;
		childApplicationRecord.Product_Name__c = 'Overdraft';
		childApplicationRecord.Product_Amount__c = 1000000.00;
		childApplicationRecord.Product_State__c = 'New';
		childApplicationRecord.Product_Status__c = 'Accepted';
		childApplicationRecord.Opportunity_Product_Id__c = '002';
		childApplicationRecord.Limit_Type__c = 'Reducing - Once Off Only';
		childApplicationRecord.Once_Off_Amount__c = 20000;
		childApplicationRecord.Application_Product_Parent__c = parentApplicationRecord.Id;
		insert childApplicationRecord;

		Application_Product__c parentApplicationRecord1 = new Application_Product__c();
		parentApplicationRecord1.Opportunity__c = opp.Id;
		parentApplicationRecord1.Product_Name__c = 'Cheque';
		parentApplicationRecord1.Product_Type__c = '11021'; //API picklist value for CLASSIC BUSINESS ACCOUNT
		parentApplicationRecord1.Account_Number__c = 123456789;
		parentApplicationRecord1.Product_State__c = 'Existing';
		parentApplicationRecord1.Opportunity_Product_Id__c = '001';
		parentApplicationRecord1.Product_Status__c = 'Accepted';
		parentApplicationRecord1.Accept_TOB__c = true;
		insert parentApplicationRecord1;
        
        Application_Product__c childApplicationRecord1 = new Application_Product__c();
		childApplicationRecord1.Opportunity__c = opp.Id;
		childApplicationRecord1.Product_Name__c = 'Overdraft';
		childApplicationRecord1.Product_Amount__c = 1000000.00;
		childApplicationRecord1.Product_State__c = 'Existing';
		childApplicationRecord1.Product_Status__c = 'Accepted';
		childApplicationRecord1.Opportunity_Product_Id__c = '002';
		childApplicationRecord1.Limit_Type__c = 'Reducing - Once Off Only';
		childApplicationRecord1.Once_Off_Amount__c = 20000;
        childApplicationRecord1.Secured_By_Mortgage_Bond__c = true;
		childApplicationRecord1.Application_Product_Parent__c = parentApplicationRecord1.Id;
		insert childApplicationRecord1;
        
        Application_Product__c parentApplicationRecord2 = new Application_Product__c();
		parentApplicationRecord2.Opportunity__c = opp.Id;
		parentApplicationRecord2.Product_Name__c = 'Cheque';
		parentApplicationRecord2.Product_Type__c = '11021'; //API picklist value for CLASSIC BUSINESS ACCOUNT
		parentApplicationRecord2.Account_Number__c = 123456789;
		parentApplicationRecord2.Product_State__c = 'Existing';
		parentApplicationRecord2.Opportunity_Product_Id__c = '001';
		parentApplicationRecord2.Product_Status__c = 'Accepted';
		parentApplicationRecord2.Accept_TOB__c = true;
		insert parentApplicationRecord2;
        
        Application_Product__c childApplicationRecord2 = new Application_Product__c();
		childApplicationRecord2.Opportunity__c = opp.Id;
		childApplicationRecord2.Product_Name__c = 'Overdraft';
		childApplicationRecord2.Product_Amount__c = 6000.00;
		childApplicationRecord2.Product_State__c = 'Existing';
		childApplicationRecord2.Product_Status__c = 'Accepted';
		childApplicationRecord2.Opportunity_Product_Id__c = '002';
		childApplicationRecord2.Limit_Type__c = 'Fixed';
		childApplicationRecord2.Once_Off_Amount__c = 260000;
		childApplicationRecord2.Application_Product_Parent__c = parentApplicationRecord2.Id;
		insert childApplicationRecord2;
        
        Application_Product__c parentApplicationRecord3 = new Application_Product__c();
		parentApplicationRecord3.Opportunity__c = opp.Id;
		parentApplicationRecord3.Product_Name__c = 'Cheque';
		parentApplicationRecord3.Product_Type__c = '11021'; //API picklist value for CLASSIC BUSINESS ACCOUNT
		parentApplicationRecord3.Account_Number__c = 123456789;
		parentApplicationRecord3.Product_State__c = 'New';
		parentApplicationRecord3.Opportunity_Product_Id__c = '001';
		parentApplicationRecord3.Product_Status__c = 'Accepted';
		parentApplicationRecord3.Accept_TOB__c = true;
		insert parentApplicationRecord3;
        
         Application_Product__c childApplicationRecord3 = new Application_Product__c();
		childApplicationRecord3.Opportunity__c = opp.Id;
		childApplicationRecord3.Product_Name__c = 'Overdraft';
		childApplicationRecord3.Product_Amount__c = 16000;
		childApplicationRecord3.Product_State__c = 'New';
		childApplicationRecord3.Product_Status__c = 'Accepted';
		childApplicationRecord3.Opportunity_Product_Id__c = '002';
		childApplicationRecord3.Limit_Type__c = 'Reducing - Recurring Only';
		childApplicationRecord3.Once_Off_Amount__c = 16000;
		childApplicationRecord3.Application_Product_Parent__c = parentApplicationRecord3.Id;
		insert childApplicationRecord3;

        Application_Product__c parentApplicationRecord4 = new Application_Product__c();
		parentApplicationRecord4.Opportunity__c = opp.Id;
		parentApplicationRecord4.Product_Name__c = 'Cheque';
		parentApplicationRecord4.Product_Type__c = '11021'; //API picklist value for CLASSIC BUSINESS ACCOUNT
		parentApplicationRecord4.Account_Number__c = 123456789;
		parentApplicationRecord4.Product_State__c = 'New';
		parentApplicationRecord4.Opportunity_Product_Id__c = '001';
		parentApplicationRecord4.Product_Status__c = 'Accepted';
		parentApplicationRecord4.Accept_TOB__c = true;
		insert parentApplicationRecord4;
        
         Application_Product__c childApplicationRecord4 = new Application_Product__c();
		childApplicationRecord4.Opportunity__c = opp.Id;
		childApplicationRecord4.Product_Name__c = 'Overdraft';
		childApplicationRecord4.Product_Amount__c = 16000;
		childApplicationRecord4.Product_State__c = 'New';
		childApplicationRecord4.Product_Status__c = 'Accepted';
		childApplicationRecord4.Opportunity_Product_Id__c = '002';
		childApplicationRecord4.Limit_Type__c = 'Variable';
		childApplicationRecord4.Once_Off_Amount__c = 16000;
		childApplicationRecord4.Application_Product_Parent__c = parentApplicationRecord4.Id;
		insert childApplicationRecord4;
		

		String responseString = '{"IPlistNCARatesV1Response":{"ipb100o":{"ncaMaxfeeCfErr":"0000 - SUCCESS","ncaMaxfeeCfMaxsf":69,"ncaMaxfeeMaErr":"0000 - SUCCESS","ncaMaxfeeMaMaxsf":69,';
		responseString += '"ncaMaxfeeOcaErr":"0000 - SUCCESS","ncaMaxfeeOcaMaxsf":69,"ncaMaxfeeStctErr":"0000 - SUCCESS","ncaMaxfeeStctMaxsf":69,"ncaMaxfeeUctErr":"0000 - SUCCESS",';
		responseString += '"ncaMaxfeeUctMaxsf":69,"ncaMaxifeeCfErr":"0000 - SUCCESS","ncaMaxifeeCfFirst":189.75,"ncaMaxifeeCfMax":6050.5,"ncaMaxifeeCfNext":11.5,"ncaMaxifeeCfPerc":1000,';
		responseString += '"ncaMaxifeeMaErr":"0000 - SUCCESS","ncaMaxifeeMaFirst":1265,"ncaMaxifeeMaMax":6037.5,"ncaMaxifeeMaNext":11.5,"ncaMaxifeeMaPerc":10000,';
		responseString += '"ncaMaxifeeOcaErr":"0000 - SUCCESS","ncaMaxifeeOcaFirst":189.75,"ncaMaxifeeOcaMax":1207.5,"ncaMaxifeeOcaNext":11.5,"ncaMaxifeeOcaPerc":1000,';
		responseString += '"ncaMaxifeeStctErr":"0000 - SUCCESS","ncaMaxifeeStctFirst":189.75,"ncaMaxifeeStctMax":1207.5,"ncaMaxifeeStctNext":11.5,"ncaMaxifeeStctPerc":1000,';
		responseString += '"ncaMaxifeeUctErr":"0000 - SUCCESS","ncaMaxifeeUctFirst":189.75,"ncaMaxifeeUctMax":6040.5,"ncaMaxifeeUctNext":11.5,"ncaMaxifeeUctPerc":1000,';
		responseString += '"ncaMaxrateCfErr":"0000 - SUCCESS","ncaMaxrateCfMaxdr":20.75,"ncaMaxrateMaErr":"0000 - SUCCESS","ncaMaxrateMaMaxdr":19,"ncaMaxrateOcaErr":"0000 - SUCCESS",';
		responseString += '"ncaMaxrateOcaMaxdr":21,"ncaMaxrateStctErr":"0000 - SUCCESS","ncaMaxrateStctMaxdr":60,"ncaMaxrateUctErr":"0000 - SUCCESS","ncaMaxrateUctMaxdr":27.75,';
		responseString += '"primeRate":6.25,"primeRateErr":"0000 - SUCCESS","repurchaseRate":7,"repurchaseRateErr":"0000 - SUCCESS"},"nbsapdpo":{"reasonCode":0,"returnCode":0,';
		responseString += '"serviceVersion":"BUSO001"},"nbsmsgo3":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';

		Application__c testApplication = new Application__c();
		testApplication.Opportunity__c = opp.Id;
		testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
		testApplication.Preferred_SMS__c = '065892600';
		testApplication.Preferred_Communication_Method__c = 'Email';
		testApplication.Fees_Waived__c = true;
		testApplication.Products_And_Services__c = 'NotifyMe';
		testApplication.AIPS__c = responseString;
		insert testApplication;

		Security_Offered__c security = new Security_Offered__c();
		security.Application__c = testApplication.Id;
		security.Security_Type__c = 'Bonds';
		insert security;

		SetProductTOBController.insertTob(parentApplicationRecord.Id);

		SetProductTOBController.updateTOB(parentApplicationRecord.Id);

		SetProductTOBController.insertTob(parentApplicationRecord1.Id);
        
        SetProductTOBController.insertTob(parentApplicationRecord2.Id);
        
        SetProductTOBController.updateTOB(parentApplicationRecord2.Id);
        
        SetProductTOBController.insertTob(parentApplicationRecord3.Id);
        
        SetProductTOBController.updateTOB(parentApplicationRecord3.Id);
        
        SetProductTOBController.insertTob(parentApplicationRecord4.Id);
        
        SetProductTOBController.updateTOB(parentApplicationRecord4.Id);

		ProductTermsOfBusinessController.ProductTOB tob = new ProductTermsOfBusinessController.ProductTOB();
		tob.appProdId = parentApplicationRecord.Id;
		tob.appProduct = parentApplicationRecord;
		tob.termstobList = new List<Terms_Of_Business__c>();

		//tob.appProductHistory = new List<ProductTermsOfBusinessController.appProdHistory> ();

		// ProductTermsOfBusinessController.appProdHistory appHis = new ProductTermsOfBusinessController.appProdHistory();
	}
    
    @isTest
    static void testgetSelectedProduct() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        test.startTest();
		system.assertNotEquals(ProductTermsOfBusinessController.getSelectedProduct(opp.Id), null);
        test.stopTest();
        
    }
    
    @isTest
    static void testCCGetProductTermsOfBusiness() {
        Application__c testApplication = [SELECT id FROM Application__c LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_scoring__c appScore = new Application_scoring__c();
        appScore.name = 'a1';
        appScore.Stage__c = '6';
        appScore.SYST_Decision__c = 'A';
        appScore.Application_Number__c = testApplication.Id;
        insert appScore;
        
        Application_Product__c appProd = new Application_Product__c();
		appProd.Opportunity__c = opp.Id;
		appProd.Product_Name__c = 'Credit Card';
		appProd.Product_Type__c = '11021'; 
		appProd.Product_State__c = 'New';
        appProd.Secured_By_Mortgage_Bond__c = true;
		appProd.Opportunity_Product_Id__c = '001';
		appProd.Product_Status__c = 'Accepted';
		appProd.Accept_TOB__c = true;
        appProd.Product_Amount__c =14000;
		insert appProd;
        
        Application_Product__c appProd1 = new Application_Product__c();
		appProd1.Opportunity__c = opp.Id;
		appProd1.Product_Name__c = 'Credit Card';
		appProd1.Product_Type__c = '11021'; 
		appProd1.Product_State__c = 'New';
		appProd1.Opportunity_Product_Id__c = '001';
		appProd1.Product_Status__c = 'Accepted';
		appProd1.Accept_TOB__c = true;
        appProd1.Product_Amount__c=16000;
		insert appProd1;
        
        Application_Product__c appPro2 = new Application_Product__c();
		appPro2.Opportunity__c = opp.Id;
		appPro2.Product_Name__c = 'Credit Card';
		appPro2.Product_Type__c = '11021'; 
		appPro2.Product_State__c = 'New';
		appPro2.Opportunity_Product_Id__c = '001';
		appPro2.Product_Status__c = 'Accepted';
		appPro2.Accept_TOB__c = true;
        appPro2.Product_Amount__c=250000;
        appPro2.Maximum_NCA_Rate_Type__c='';
		insert appPro2;
        
         Application_Product__c appPro3 = new Application_Product__c();
		appPro3.Opportunity__c = opp.Id;
		appPro3.Product_Name__c = 'Credit Card';
		appPro3.Product_Type__c = '11021'; 
		appPro3.Product_State__c = 'New';
		appPro3.Opportunity_Product_Id__c = '001';
		appPro3.Product_Status__c = 'Accepted';
		appPro3.Accept_TOB__c = true;
        appPro3.Product_Amount__c=14000;
        appPro3.Maximum_NCA_Rate_Type__c='54';
		insert appPro3;
        
        Application_Product__c appProdExist = new Application_Product__c();
		appProdExist.Opportunity__c = opp.Id;
		appProdExist.Product_Name__c = 'Credit Card';
        appProdExist.Product_Amount__c=16000;
		appProdExist.Product_Type__c = '11021'; 
		appProdExist.Product_State__c = 'Existing';
        appProdExist.Account_Number__c = 1234567891;
        appProd.Secured_By_Mortgage_Bond__c = true;
		appProdExist.Opportunity_Product_Id__c = '001';
		appProdExist.Product_Status__c = 'Accepted';
		appProdExist.Accept_TOB__c = true;
		insert appProdExist;
        SetProductTOBController.insertCCTob(appProd.Id);
        SetProductTOBController.updateCCTOB(appProd.Id);
        
        
        test.startTest();
        ProductTermsOfBusinessController.CCProductTOB cctob = new ProductTermsOfBusinessController.CCProductTOB();
        system.assertNotEquals(ProductTermsOfBusinessController.getCCProductTOB(opp.Id), null);
        test.stopTest();
    }

	@isTest
    static void testLDPGetProductTermsOfBusiness() {
        Application__c testApplication = [SELECT id FROM Application__c LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        

        Application_Product__c appProd = new Application_Product__c();
		appProd.Opportunity__c = opp.Id;
		appProd.Product_Name__c = 'Bank Guarantee';
		appProd.Product_Type__c = '11021';
		appProd.Product_State__c = 'New';
        appProd.Secured_By_Mortgage_Bond__c = true;
		appProd.Opportunity_Product_Id__c = '001';
		appProd.Product_Status__c = 'Accepted';
		appProd.Accept_TOB__c = true;
        appProd.Requested_facility_limit__c ='14000';
        appProd.Facility_review_date__c = date.today();
		insert appProd;

        
        Application_Product__c appProdExist = new Application_Product__c();
		appProdExist.Opportunity__c = opp.Id;
		appProdExist.Product_Name__c = 'Bank Guarantee';
        appProdExist.Product_Amount__c=16000;
		appProdExist.Product_Type__c = '11021';
		appProdExist.Product_State__c = 'Existing';
        appProdExist.Account_Number__c = 1234567891;
        appProd.Secured_By_Mortgage_Bond__c = true;
		appProdExist.Opportunity_Product_Id__c = '001';
		appProdExist.Product_Status__c = 'Accepted';
		appProdExist.Accept_TOB__c = true;
        appProdExist.Facility_limit__c='10000';
        appProdExist.Requested_facility_limit__c='14000';
        appProdExist.Facility_review_date__c = date.today();
		insert appProdExist;
        SetProductTOBController.insertTOBForLDP(appProd.Id);
        SetProductTOBController.updateLDPTOB(appProd.Id);


        test.startTest();
       // ProductTermsOfBusinessController.LDPproductTOB cctob = new ProductTermsOfBusinessController.CCProductTOB();
        system.assertNotEquals(ProductTermsOfBusinessController.getTOBProductsForLDP(opp.Id), null);
        test.stopTest();
    }
}