@isTest
public class OnboardingTradingAsNameControllerTest {
    
     @isTest 
    public static void getTradingAsNameRecordsTest(){
        
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Create Trading as Name test records
        Trading_as_Name__c testTradingAsName = new Trading_as_Name__c();
        testTradingAsName.Name = 'T/A Test';
        testTradingAsName.Account__c = testDataFactory.testAccount.id;
        insert testTradingAsName;
        
        
        System.assertNotEquals(testTradingAsName.id, null);
        System.assertNotEquals(testDataFactory.testAccount.id, null);
        OnboardingTradingAsNameController.getTradingAsNameRecords(testDataFactory.testAccount.id);
        OnboardingTradingAsNameController.getSelectedTradingAsNameRecord(testTradingAsName.id);
        
        try {
            OnboardingTradingAsNameController.createNewTradingAsName(testDataFactory.testAccount.id, testTradingAsName, null);
            
        } catch (Exception ex) {
            System.debug(ex);
        }
        try {
            OnboardingTradingAsNameController.createNewTradingAsName(testDataFactory.testAccount.id, null, testTradingAsName);
            
        } catch (Exception ex) {
            System.debug(ex); 
        }
        
        OnboardingTradingAsNameController.deleteTradingAsName(testTradingAsName.id);
        
        try {
            OnboardingTradingAsNameController.deleteTradingAsName(testTradingAsName.id);
            
        } catch (Exception ex) {
            System.debug(ex); 
        }
        
        
    }

}