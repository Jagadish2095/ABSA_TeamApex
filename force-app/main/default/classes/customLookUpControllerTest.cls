@isTest
public class customLookUpControllerTest {
    
    public static testMethod void testcustomLookUp(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        customLookUpController.fetchLookUpValues(testDataFactory.testBank.Name);
        Test.stopTest();
    }
    
}