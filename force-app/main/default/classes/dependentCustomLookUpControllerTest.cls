@isTest
public class dependentCustomLookUpControllerTest {
    
    public static testMethod void testDependentCustomLookUp(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        dependentCustomLookUpController.fetchDependentLookUpValues('Sandton',testDataFactory.testBank.Name);
        Test.stopTest();
    }
    
}