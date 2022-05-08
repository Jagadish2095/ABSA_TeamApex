/**
 * @description       : SalesProcessBase test class
 * @author            : Ignecious Mushanguri
 * @group             : Cloudsmiths
 * @last modified on  : 09-12-2020
 * @last modified by  : Ignecious Mushanguri
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   09-12-2020   Ignecious Mushanguri   Initial Version
**/
@isTest
public with sharing class CAF_SalesProcessBaseTest {

    @TestSetup
    static void makeData(){

        Account  account = WillsTestDataFactory.createAccount();
        Product2 product = WillsTestDataFactory.createProduct('Premium Package Test01','Merchant');
        Product2 relProduct = WillsTestDataFactory.createProduct('Premium Package Test02','Merchant');
        Product_Product_Entry__c productProductEntry = WillsTestDataFactory.createProductProductEntry(product.Id,relProduct.Id);
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry priceBookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id,relProduct.Id);
        Sales_Process_Type__c salesProcessType = WillsTestDataFactory.createSalesProcessType('Physical Channels Process','Onboard New Product Everyday Banking Test','Physical Channels');   
    }

    @isTest 
    private static void createOpportunityWithLineItemsTest(){

        String productCode= [SELECT ProductCode FROM Product2 WHERE Name =: 'Premium Package Test01'].ProductCode;
        Id accountId= [SELECT Id FROM Account WHERE LastName =: 'Test Account'].Id;
        String productType= [SELECT Product_Type__c FROM Product2 WHERE Name =:'Premium Package Test01'].Product_Type__c;
        //String requestName= [SELECT Request_Name__c FROM Sales_Process_Type__c WHERE Request_Name__c =:'Onboard New Product Everyday Banking Test' ].Request_Name__c;
        Test.startTest();

            Map<String, String> oppMap = CAF_SalesProcessBase.createOpportunityWithLineItems( accountId , productCode, 'CAF', 'CAF Application' );
            System.AssertEquals(oppMap.size(),2);

        Test.stopTest();

    }


}