@isTest 
public class DependentFeesLookControllerTest {
    @isTest 
    public static void testcustomLookUp(){  
  
        Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');//[SELECT Id,Name From Product2];
        Test.startTest();
        List<SObject> result = DependentFeesLookController.fetchDependentLookUpValues('Administrative Fee',product.Id);
        System.assert(result != null);
        Test.stopTest();
    }
    
        @isTest 
    public static void testfetchLookUpValues(){  
  
        //Product2 product = WillsTestDataFactory.createProduct('R0.00 - WAIVED (ABSA EXECUTOR)','WILL');//[SELECT Id,Name From Product2];
        Test.startTest();
        List<SObject> result = DependentFeesLookController.fetchLookUpValues('Cheques Fees','Incorrect Fee Captured - Undercharged');
        System.assert(result != null);
        Test.stopTest();
    }
    

}