/**
* Test Class for ActivityTrackingSelector
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-07-23
*
**/
@isTest 
public class ActivityTrackingAndSLAManagementTest {
    
    static testMethod void runTrackingAndSLAManagementTest(){
        
        Financial_Product__c testFinancialProduct = new Financial_Product__c();
        testFinancialProduct.Name = 'Estate Provider Plan';
        testFinancialProduct.Type__c = 'Borrow';
        testFinancialProduct.Description__c = 'Test Product';
        testFinancialProduct.Business_Unit__c = 'Business Banking';
        testFinancialProduct.Product_Type__c = 'Bank';
        insert testFinancialProduct;
        
        Lead leadTest = new Lead();
        leadTest.FirstName = 'Tracking';
        leadTest.LastName = 'TestLead';
        leadTest.Company = 'Activity Test Lead';
        leadTest.Financial_Product__c = testFinancialProduct.Id;
        leadTest.Business_Unit__c = 'Business Banking';
       	leadTest.MobilePhone = '0987654321';
        leadTest.Phone = '0987654321';
        leadTest.sd_Track_Status_Changes__c = true;
            
        Test.startTest();
        
        insert leadTest;
        
        List<Activity_Tracking__c> actTracking = [Select Id From Activity_Tracking__c Where Lead__c = :leadTest.Id];
        System.assertEquals(1, actTracking.size());
        
        leadTest.Status = 'Accepted';
        update leadTest;
        
		actTracking = [Select Id From Activity_Tracking__c Where Lead__c = :leadTest.Id];
        System.assertEquals(2, actTracking.size());        
        
        Test.stopTest();
            
   }

}