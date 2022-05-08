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
public with sharing class SalesProcessBaseTest {

    @TestSetup
    static void makeData(){

        Account  account = WillsTestDataFactory.createAccount();
        Product2 product = WillsTestDataFactory.createProduct('Premium Package Test01','Merchant');
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021', Price_Scheme_Code__c = 'TEST');
        insert prod; 
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
              
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        Product2 relProduct = WillsTestDataFactory.createProduct('Premium Package Test02','Merchant');
        Product_Product_Entry__c productProductEntry = WillsTestDataFactory.createProductProductEntry(product.Id,relProduct.Id);
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        PricebookEntry priceBookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id,relProduct.Id);
        //Sales_Process_Type__c salesProcessType = WillsTestDataFactory.createSalesProcessType('Physical Channels Process','Onboard New Product Everyday Banking Test','Physical Channels');
        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Name = 'Onboard New Product Everyday Banking Test',
            Sales_Process__c = 'Physical Channels Process',
            Opportunity_Record_Type__c = 'Physical Channels',
            Request_Name__c = 'TestRequest'
        );
        insert salesProcessType;   
    }

    @isTest 
    private static void createOpportunityWithLineItemsTest(){

        String productCode= [SELECT ProductCode FROM Product2 WHERE Name =: 'Premium Package Test01'].ProductCode;
        Id accountId= [SELECT Id FROM Account WHERE LastName =: 'Test Account'].Id;
        String productType= [SELECT Product_Type__c FROM Product2 WHERE Name =:'Premium Package Test01'].Product_Type__c;
        String requestName= [SELECT Name FROM Sales_Process_Type__c WHERE Name =:'Onboard New Product Everyday Banking Test' ].Name;
      
        Test.startTest();

            Map<String, String> oppMap = SalesProcessBase.createOpportunityWithLineItems( accountId , productCode, productType, requestName );
            System.AssertEquals(oppMap.size(),2);

        Test.stopTest();

    }

    @isTest 
    private static void createOpportunityForStandAloneProductTest(){

        String productCode= [SELECT ProductCode FROM Product2 WHERE Name =: 'Cheque Product'].ProductCode;
        Id accountId= [SELECT Id FROM Account WHERE LastName =: 'Test Account'].Id;
        String requestName= [SELECT Name FROM Sales_Process_Type__c WHERE Name =:'Onboard New Product Everyday Banking Test' ].Name;
      
        Test.startTest();

            String opp = SalesProcessBase.createOpportunityForStandAloneProduct( accountId , productCode, 'Cheque Product', requestName );
            System.Assert(opp != null);

        Test.stopTest();

    }

    @isTest 
    private static void createOpportunityWithLineItemsRoa(){

        String productCode= [SELECT ProductCode FROM Product2 WHERE Name =: 'Premium Package Test01'].ProductCode;
        Id accountId= [SELECT Id FROM Account WHERE LastName =: 'Test Account'].Id;
        String productType= [SELECT Product_Type__c FROM Product2 WHERE Name =:'Premium Package Test01'].Product_Type__c;
        String requestName= [SELECT Name FROM Sales_Process_Type__c WHERE Name =:'Onboard New Product Everyday Banking Test' ].Name;
      
        Test.startTest();

            Map<String, String> oppMap = SalesProcessBase.createOpportunityWithLineItemsRoa( accountId , productCode, productType, requestName, 'questions' );
            System.AssertEquals(oppMap.size(),2);

        Test.stopTest();

    }

}