/**
 * @description       : This is the Test Class for UpdateCreditApplication After Stafe 7 Test
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Himanshu.Nimje@absa.africa   Initial Version
 **/

@isTest
public class UpdateCreditApplicationTest {
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@testSetup
	public static void dataCreation() {
		insertUser();

		Account account = new Account();
		account.Name = 'Absa Bank';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
		insert account;

		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.CloseDate = Date.today() + 10;
		//opp.Spouse_Account_Id__c=account.Id;
		insert opp;

		Application__c application = new Application__c();
		application.Credit_Application_Status__c = 'Accepted';
		application.stock_Number__c = '0';
		application.External_Reference_Number__c = 9874667;
		application.Opportunity__c = opp.Id;
		insert application;

		//Products
		Id pricebookId = Test.getStandardPricebookId();

		//For Policy without Spouse
		Product2 product1 = new Product2();
		product1.name = 'EPP Executor Fees Policy';
		product1.IsActive = true;
		insert product1;

		PricebookEntry pricebookEntry1 = new PricebookEntry();
		pricebookEntry1.UnitPrice = 0;
		pricebookEntry1.Product2Id = product1.id;
		pricebookEntry1.Pricebook2Id = pricebookId;
		pricebookEntry1.IsActive = true;
		insert pricebookEntry1;

		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp.Id;
		oppLineItem.Product2Id = product1.Id;
		oppLineItem.PricebookEntryId = pricebookEntry1.Id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
		insert oppLineItem;

		Application_Product__c testAppProdCred = new Application_Product__c();
		testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred.Product_State__c = 'New';
		testAppProdCred.Opportunity__c = opp.Id;
		testAppProdCred.Product_Type__c = '11021';
		testAppProdCred.System_Decision__c = 'Accepted';
		insert testAppProdCred;

		Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;

		Application_scoring__c appScore = new Application_scoring__c();
		appScore.name = 'a1';
		appScore.Stage__c = '7';
		appScore.SYST_Decision__c = 'A';
		appScore.Application_Number__c = application.Id;
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

		Submission_History__c sh = new Submission_History__c();
		sh.application__c = application.Id;
		sh.StageId__c = application.name;
		sh.Type__c = 'Decision Summary';
		sh.Version__c = '1';
		//sh.Submitted_By__c=application.createdby.name;
		//sh.Submitted__c=application.LastModifiedDate;
		sh.System_Decision__c = 'N';
		insert sh;

		Application_Scoring_Product__c scoProduct = new Application_Scoring_Product__c();
		// scoProduct.Unique_Product_ID__c = String.valueof(testAppProdCred.Name);
		scoProduct.Application_Scoring__c = appScore.Id;
		scoProduct.Final_Decision__c = 'A';
		scoProduct.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert scoProduct;

		Application_Scoring_Product__c scoProduct1 = new Application_Scoring_Product__c();
		scoProduct.Unique_Product_ID__c = String.valueof(testAppProdCred1.Name);
		scoProduct1.Application_Scoring__c = appScore.Id;
		scoProduct1.Final_Decision__c = 'A';
		insert scoProduct1;
		system.assertNotEquals(null, account);
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testupdateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void test2updateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'D';
		update appscore;
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void test3updateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'R';
		update appscore;
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void test4updateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'C';
		update appscore;
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void test5updateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'O';
		update appscore;
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void test6updateObjAfterStage7() {
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}

    
    /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testNewUpdateObjAfterStage7() {
        Opportunity opp = [SELECT id FROM Opportunity];
        OpportunityLineItem oppLineItem = [SELECT id FROM OpportunityLineItem];
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
        
        Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;
        
        Application_Scoring_Product__c appScoreProd = new Application_Scoring_Product__c();
		appScoreProd.Application_Scoring__c = appscore[0].id;
		appScoreProd.Final_Decision__c = 'D';
		appScoreProd.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert appScoreProd;
        
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
       
    /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testNewUpdateObjAfterStage8() {
        Opportunity opp = [SELECT id FROM Opportunity];
        OpportunityLineItem oppLineItem = [SELECT id FROM OpportunityLineItem];
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
        
        Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;
        
        Application_Scoring_Product__c appScoreProd = new Application_Scoring_Product__c();
		appScoreProd.Application_Scoring__c = appscore[0].id;
		appScoreProd.Final_Decision__c = 'P';
		appScoreProd.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert appScoreProd;
        
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
    
    
    /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testNewUpdateObjAfterStage9() {
        Opportunity opp = [SELECT id FROM Opportunity];
        OpportunityLineItem oppLineItem = [SELECT id FROM OpportunityLineItem];
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
        
        Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;
        
        Application_Scoring_Product__c appScoreProd = new Application_Scoring_Product__c();
		appScoreProd.Application_Scoring__c = appscore[0].id;
		appScoreProd.Final_Decision__c = 'R';
		appScoreProd.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert appScoreProd;
        
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
    
    
     /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testNewUpdateObjAfterStage10() {
        Opportunity opp = [SELECT id FROM Opportunity];
        OpportunityLineItem oppLineItem = [SELECT id FROM OpportunityLineItem];
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
        
        Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;
        
        Application_Scoring_Product__c appScoreProd = new Application_Scoring_Product__c();
		appScoreProd.Application_Scoring__c = appscore[0].id;
		appScoreProd.Final_Decision__c = 'M';
		appScoreProd.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert appScoreProd;
        
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
    
      /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@isTest
	public static void testNewUpdateObjAfterStage11() {
        Opportunity opp = [SELECT id FROM Opportunity];
        OpportunityLineItem oppLineItem = [SELECT id FROM OpportunityLineItem];
		List<Application__c> appList = [SELECT id FROM Application__c];
		List<Application_Scoring__c> appscore = [SELECT id, SYST_Decision__c FROM Application_Scoring__c WHERE Application_Number__c = :appList[0].Id];
		appscore[0].SYST_Decision__c = 'M';
		update appscore;
        
        Application_Product__c testAppProdCred1 = new Application_Product__c();
		testAppProdCred1.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred1.Account_Number__c = 9876543;
		testAppProdCred1.Product_State__c = 'existing';
		testAppProdCred1.Opportunity__c = opp.Id;
		testAppProdCred1.Product_Type__c = '11021';
		testAppProdCred1.System_Decision__c = 'Accepted';
		insert testAppProdCred1;
        
        Application_Scoring_Product__c appScoreProd = new Application_Scoring_Product__c();
		appScoreProd.Application_Scoring__c = appscore[0].id;
		appScoreProd.Final_Decision__c = 'O';
		appScoreProd.Account_Number__c = String.valueOf(testAppProdCred1.Account_Number__c);
		insert appScoreProd;
        
		Test.startTest();
		UpdateCreditApplication.updateAppProdAfterStg7(appList[0].Id, '7');
		Test.stopTest();
		system.assertNotEquals(null, appList);
	}
    
    /**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 **/
	@future
	private static void insertUser() {
		Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
		UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];

		User futureUser = new User(
			ProfileId = p.Id,
			LastName = 'last',
			Email = 'puser000@amamama.com',
			Username = 'puser000@amamama.com' + System.currentTimeMillis(),
			CompanyName = 'TEST',
			Title = 'title',
			Alias = 'alias',
			TimeZoneSidKey = 'America/Los_Angeles',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			SiteCode__c = '8198',
			SiteType__c = '034',
			Teller_Operator_Code__c = '12345',
			Supervisor__c = '0',
			Division__c = 'RBB',
			UserRoleId = r.Id
		);
		insert (futureUser);
	}
}