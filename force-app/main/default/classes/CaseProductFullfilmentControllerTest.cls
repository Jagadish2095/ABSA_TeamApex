/**
 * @description CaseProductFullfilmentControllerTest Description
 *
 */
@isTest
public class CaseProductFullfilmentControllerTest{
	@testSetup
	static void dataCreation(){
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Account account = new Account(Name = 'Test Account');
		insert account;
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
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
        Insert oppLineItem;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        insert app;

        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        testAppProdCred.Account_Number__c = 1234;
        insert testAppProdCred;

		Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Account = account, Email__c = 'test@test.com', recordTypeId = caseRecordTypeMap.get('CAF_Application').getRecordTypeId(), Subject = 'test', Description = 'test', Expectation_of_the_Customer__c = 'test', Incident_Date__c = date.today(),Application_Product_Id__c=testAppProdCred.Id);
		insert caseRec;
	}

	@isTest
	public static void getdetailsTest(){
		Case cs = [Select Id, Opportunity__c, Application_Product_Id__c
		           from Case
		           LIMIT 1];
		test.startTest();
        list<Application_Product__c> apList = CaseProductFullfilmentController.getdetails(cs.Id);
		system.assertNotEquals(null, apList);
        CaseProductFullfilmentController.getaccountid(cs.Id);
        Application_Product__c ap = [Select Id from Application_Product__c LIMIT 1];
        CaseProductFullfilmentController.getLabelString('labelName', ap.id);
        CaseProductFullfilmentController.getaccountid(cs.Id);
        CaseProductFullfilmentController.deleteproducts(ap.id, cs.Id);
		test.stopTest();
	}
}