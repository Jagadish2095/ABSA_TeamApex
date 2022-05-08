/**=================================================================================================================================
* Created By: Eduardo Salia
* Created Date: 14/10/2020
* Test Controller for Quote Summary Lightning Component
===================================================================================================================================**/
@isTest
public class QuoteSummaryControllerTest
{
    public static testMethod void testQuoteSummaryFlexiFuneral()
    {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        List<Opportunity_Party__c> opportunityParties = QuoteSummaryController.getDependantData(testDataFactory.testOpportunity.id);
        System.assertNotEquals(null, opportunityParties);
        
        testDataFactory.testQuote.Product_Name__c = StringConstants.PRODUCT_FLEXI_FUNERAL;
        UPDATE testDataFactory.testQuote;
        
        testDataFactory.testQuoteLineItem.Relationship_Type__c = StringConstants.RELATIONSHIP_TYPE_CHILD;
        testDataFactory.testQuoteLineItem.OpportunityPartyId__c = opportunityParties[0].Id;
        UPDATE testDataFactory.testQuoteLineItem;
        
        List<QuoteSummaryController.DTO_QuoteSummaryResponse> response =
            QuoteSummaryController.getOpportunityDetails(testDataFactory.testOpportunity.Id, StringConstants.PRODUCT_FLEXI_FUNERAL);
        
        Test.stopTest();
    }
    
    public static testMethod void testQuoteSummaryCrossSellProducts()
    {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        List<Opportunity_Party__c> opportunityParties = QuoteSummaryController.getDependantData(testDataFactory.testOpportunity.id);
        System.assertNotEquals(null, opportunityParties);
        
        testDataFactory.testQuote.Product_Name__c = StringConstants.PRODUCT_CROSS_SELL;
        UPDATE testDataFactory.testQuote;
        
        testDataFactory.testQuoteLineItem.Relationship_Type__c = StringConstants.RELATIONSHIP_TYPE_MAIN_MEMBER;
        testDataFactory.testQuoteLineItem.OpportunityPartyId__c = opportunityParties[0].Id;
        UPDATE testDataFactory.testQuoteLineItem;
        
        List<QuoteSummaryController.DTO_QuoteSummaryResponse> response =
            QuoteSummaryController.getOpportunityDetails(testDataFactory.testOpportunity.Id, StringConstants.PRODUCT_CROSS_SELL);
        
        Test.stopTest();
    }
    
    public static testMethod void testProductSummary()
    {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        List<Opportunity_Party__c> opportunityParties = QuoteSummaryController.getDependantData(testDataFactory.testOpportunity.id);
        System.assertNotEquals(null, opportunityParties);
        
        testDataFactory.testQuote.Product_Name__c = StringConstants.PRODUCT_CROSS_SELL;
        UPDATE testDataFactory.testQuote;
        
        testDataFactory.testQuoteLineItem.Relationship_Type__c = StringConstants.RELATIONSHIP_TYPE_MAIN_MEMBER;
        testDataFactory.testQuoteLineItem.OpportunityPartyId__c = opportunityParties[0].Id;
        UPDATE testDataFactory.testQuoteLineItem;
        
        List<QuoteSummaryController.DTO_QuoteSummaryResponse> response =
            QuoteSummaryController.getOpportunityDetails(testDataFactory.testOpportunity.Id, null);
        
        Test.stopTest();
    }
    
    public static testMethod void testProductSummaryForDependants()
    {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        List<Opportunity_Party__c> opportunityParties = QuoteSummaryController.getDependantData(testDataFactory.testOpportunity.id);
        System.assertNotEquals(null, opportunityParties);
        
        opportunityParties = QuoteSummaryController.getOpportunityParties(testDataFactory.testOpportunity.id);
        System.assertNotEquals(null, opportunityParties);
        
        testDataFactory.testQuote.Product_Name__c = StringConstants.PRODUCT_CROSS_SELL;
        UPDATE testDataFactory.testQuote;
        
        testDataFactory.testQuoteLineItem.Relationship_Type__c = StringConstants.RELATIONSHIP_TYPE_CHILD;
        testDataFactory.testQuoteLineItem.OpportunityPartyId__c = opportunityParties[0].Id;
        UPDATE testDataFactory.testQuoteLineItem;
        
        List<QuoteSummaryController.DTO_QuoteSummaryResponse> response =
            QuoteSummaryController.getOpportunityDetails(testDataFactory.testOpportunity.Id, null);
        
        Test.stopTest();
    }
}