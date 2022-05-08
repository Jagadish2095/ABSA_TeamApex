/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-12   almas.aleem@absa.africa   Initial Version
 */
@IsTest
public class ApplicationProductSelectorTest{
	/**
	 * @description
	 * @author almas.aleem@absa.africa | 2021-06-12
	 **/
	@testSetup
	static void createData(){
		Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id accRecordTypeId = rtInfo.get('Individual_Prospect').getRecordTypeId();
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.RecordTypeId = accRecordTypeId;
        account.Registration_Number__c = '1990/011515/23';
        account.PersonEmail='testaccount@absa.africa';
        insert account;
        
		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.CloseDate = Date.today()+10;
        opp.accountId = account.Id;
		Insert opp;

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

		Application__c app = new Application__c();
		app.Opportunity__c = opp.Id;
		insert app;

		Application_Product__c testAppProdCred = new Application_Product__c();
		testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCred.Account_Number__c = 1234;
		insert testAppProdCred;

		Application_Product__c testAppProdCredC = new Application_Product__c();
		testAppProdCredC.Opportunity_Product_Id__c = oppLineItem.Id;
		testAppProdCredC.Application_Product_Parent__c = testAppProdCred.Id;
		insert testAppProdCredC;
	}

	@isTest
	static void testAllSelectMethods(){
		Application__c app = [SELECT Id
		                      FROM Application__c
		                      Limit 1];
		Opportunity opp = [SELECT Id,accountId
		                   FROM Opportunity
		                   LIMIT 1];
		OpportunityLineItem opportunityLineItem = [SELECT Id
		                                           FROM OpportunityLineItem
		                                           LIMIT 1];
		Application_Product__c apc = [SELECT Id, Opportunity_Product_Id__c, Account_Number__c
		                              FROM Application_Product__c
		                              WHERE Application_Product_Parent__c = null
		                              LIMIT 1];

		Test.startTest();
		System.assert(new ApplicationProductSelector().selectById(new Set<Id>{apc.Opportunity_Product_Id__c}) != null);
		System.assert(new ApplicationProductSelector().selectByOpportunityId(apc.Opportunity_Product_Id__c) != null);
		System.assert(new ApplicationProductSelector().selectIdsByOpportunityLineItemId(opportunityLineItem.Id) != null);
		System.assert(new ApplicationProductSelector().SelectApplicationProductById(apc.Id) != null);
		System.assert(new ApplicationProductSelector().selectApplicationAccountNumber(apc.Account_Number__c) != null);
		System.assert(new ApplicationProductSelector().selectApplicationProductByParentId(apc.Id) != null);
		System.assert(new ApplicationProductSelector().selectUniqueIentifiers(apc.Opportunity_Product_Id__c) != null);
		System.assert(new ApplicationProductSelector().selectforCase(apc.Opportunity_Product_Id__c) != null);
		System.assert(new ApplicationProductSelector().selectApplicationProductHistory(new List<Application_Product__c>{apc}) != null);
		System.assert(new ApplicationProductSelector().selectApplicationProductHistoryById(apc.Opportunity_Product_Id__c) != null);
		System.assert(new ApplicationProductSelector().selectByOpportunityIdWithTOB(apc.Opportunity_Product_Id__c, true, 'Prime Rate') != null);
		System.assert(new ApplicationProductSelector().selectApplicationProductByOppId(apc.Opportunity_Product_Id__c) != null);
		System.assert(new ApplicationProductSelector().selectApplicationProductByCreditOppId(apc.Opportunity_Product_Id__c) != null);
        new ApplicationProductSelector().selectLinkedUniqueIDAndRefAccByOppId(opp.Id);
        new ApplicationProductSelector().selectApplicationProductByOpportunityId(opp.Id);
        //new ApplicationProductSelector().applicationProdRelatedToAcc(opp.accountId);
		Test.stopTest();
	}
}