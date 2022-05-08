/**
* Test class for LeadAllocationStagingPurgeBatch
* @author  Koketso Mpshane
* @date    18/08/2020
*/
@isTest
public class LeadAllocationStagingPurgeBatchTest {
    
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        
        List<Lead_Allocation_Staging__c> lsalist = new List<Lead_Allocation_Staging__c>();
        
        Lead_Allocation_Staging__c las = new Lead_Allocation_Staging__c();
        las.Process_Status__c = 'Completed';
        lsalist.add(las);
        
        Lead_Allocation_Staging__c las1 = new Lead_Allocation_Staging__c();
        las1.Process_Status__c = 'Completed';
        lsalist.add(las1);
        
        Lead_Allocation_Staging__c las2 = new Lead_Allocation_Staging__c();
        las2.Process_Status__c = 'Completed';
        lsalist.add(las2);
        
        insert lsalist;
           
    }
    
    //Method to test
    static testMethod void testLeadAllocationStagingPurgeBatch(){
        
        Test.startTest();
        
        LeadAllocationStagingPurgeSchedule instance = new LeadAllocationStagingPurgeSchedule();
        
		String cronExp = '0 0 23 * * ?'; 
        system.schedule('Test LeadAllocationStagingPurgeSchedule', cronExp, instance); 
               
        Test.stopTest();
    }

}