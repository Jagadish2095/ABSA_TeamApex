/**
* Test class for CloseOverdueLeadsBatch
* @author  Koketso Mpshane
* @date    09/03/2020
*/
@isTest
public class CloseOverdueLeadsBatchTest {
    
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        
        Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = '', Business_Unit__c = 'Business Banking');
        insert testFinancialProduct;
        
        RecordType retailRecodType = [Select Id, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' and DeveloperName = 'Retail_Sales_Lead'];
   	
        Lead hotLeadRecord = new Lead();
        hotLeadRecord.FirstName = 'Hot';
        hotLeadRecord.LastName = 'Lead';
        hotLeadRecord.Status = 'Unallocated';
        hotLeadRecord.Hot_Deal__c = true;
        hotLeadRecord.RecordTypeId = retailRecodType.Id;
        hotLeadRecord.SLA_Start_Date__c = Date.today();
        hotLeadRecord.Product_Interest_1__c = testFinancialProduct.Id;
        insert hotLeadRecord;
        hotLeadRecord.SLA_Start_Date__c = Date.today() - 15; 
        update hotLeadRecord;
            
        Lead coldLeadRecord = new Lead();
        coldLeadRecord.FirstName = 'Cold';
        coldLeadRecord.LastName = 'Lead';
        coldLeadRecord.Status = 'Allocated';
        coldLeadRecord.Hot_Deal__c = false;
        coldLeadRecord.RecordTypeId = retailRecodType.Id;
        coldLeadRecord.SLA_Start_Date__c = Date.today() - 31;
        coldLeadRecord.Product_Interest_1__c = testFinancialProduct.Id;
        insert coldLeadRecord;
        coldLeadRecord.SLA_Start_Date__c = Date.today() - 15; 
        update coldLeadRecord;
        
    }
    
    //Method to test
    static testMethod void testCloseOverdueLeadsBatch(){
        Test.startTest();
        
        CloseOverdueLeadsSchedule instance = new CloseOverdueLeadsSchedule();
        
		String cronExp = '0 0 23 * * ?'; 
        system.schedule('Test CloseOverdueLeadsSchedule', cronExp, instance); 
        
        CloseOverdueLeadsBatch.sendEmailWithErrors('Test');
        
        Test.stopTest();
    }

}