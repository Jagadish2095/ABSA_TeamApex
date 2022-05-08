/**
* Test Class for ActivityTrackingSelector
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-07-23
*
**/
@isTest 
public class ActivityTrackingSelectorTest {
    
    static testMethod void runActivityTrackingSelectorTest(){
        
        Financial_Product__c testFinancialProduct = new Financial_Product__c();
        testFinancialProduct.Name = 'Estate Provider Plan';
        testFinancialProduct.Type__c = 'Borrow';
        testFinancialProduct.Description__c = 'Test Product';
        testFinancialProduct.Business_Unit__c = 'Business Banking';
        testFinancialProduct.Product_Type__c = 'Bank';
        insert testFinancialProduct;
        
        Lead leadTest = new Lead();
        leadTest.FirstName = 'Activity';
        leadTest.LastName = 'TestLead';
        leadTest.Company = 'Activity Test Lead';
        leadTest.Financial_Product__c = testFinancialProduct.Id;
        leadTest.Business_Unit__c = 'Business Banking';
       	leadTest.MobilePhone = '0987654321';
        leadTest.Phone = '0987654321';
        insert leadTest;
        
        Activity_Tracking__c tracking = new Activity_Tracking__c();
        tracking.Start_Initiator__c = UserInfo.getUserName();
        tracking.Start_Time__c = System.now();
        tracking.Status_Tracked__c = leadTest.Status;
        tracking.Lead__c = leadTest.Id;
        insert tracking;
            
        Test.startTest();
        
        	Set<Id> ids = new Set<Id>();
        	ids.add(tracking.Id);
        	List<Activity_Tracking__c> act = new ActivityTrackingSelector().selectById(ids);
        	
        	System.assertEquals(1, act.size());
        
        Test.stopTest();
            
   }
    
}