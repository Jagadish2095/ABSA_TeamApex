@isTest
public class QuotePDFPageControllerTest {
    
    public static testMethod void testQuoteProcess(){
                
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
                
        Test.setCurrentPageReference(new PageReference('Page.QuotePDFPage'));
        System.currentPageReference().getParameters().put('id', testDataFactory.testOpportunity.id);
        QuotePDFPageController quotePdfController = new QuotePDFPageController();

        Test.stopTest();
    }
    
}