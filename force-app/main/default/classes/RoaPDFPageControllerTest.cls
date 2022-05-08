/**
* Test class for RoaPDFPageController
* @author  Kyle Alexander
* @created 2018-10-11
*/

@IsTest
public class RoaPDFPageControllerTest {
    
    public static testMethod void testRoaPDFGeneration(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.RoaPDFPage'));
        System.currentPageReference().getParameters().put('id', testDataFactory.testOpportunity.id);
        RoaPDFPageController roaController = new RoaPDFPageController();
        
        Test.stopTest();
    }    
}