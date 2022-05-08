@isTest  
public class AbsaListedBankLookUpControllerTest {
    
    public static testMethod void testFetchLookUpValues(){        
        Test.startTest();
        List < sObject > testObj = AbsaListedBankLookUpController.fetchLookUpValues('Telkom');
        system.assertNotEquals(null, testObj); 
        Test.stopTest();
    }
    


}