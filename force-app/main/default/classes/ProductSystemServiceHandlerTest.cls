/**
 * @description       : ProductSystemServiceHandlerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
**/
@isTest
public class ProductSystemServiceHandlerTest {
    @TestSetup
	static void makeData() {
		Product2 prod = new Product2(Name = 'Test Product', Product_System__c = 'Absa Rewards System');
		insert prod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;
	}

    @isTest
	public static void testsaveResponseToProductSystem() {
		Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'Test Product'];
		Test.startTest();
        ProductSystemServiceHandler.getPricebookEntry(prod.Id, 15.00);
		System.assert(prod != null, 'Test unsuccessful');
		Test.stopTest();
	}
}