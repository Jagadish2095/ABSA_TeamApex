/**
* Helper class to support the Lead_Allocation_Staging__c trigger process
* 
* @author Rudolf Niehaus
* @since  2020-05-06
* 
*/


public class LeadAllocationStagingTriggerFunctions {
    
    public static void beforeInsert(List<sObject> newRecords){

        for(Lead_Allocation_Staging__c stagingRec :( List<Lead_Allocation_Staging__c>)newRecords ){
        
            if( String.isBlank(stagingRec.Role__c) ){

                stagingRec.Assign_To__c = 'Regional Group';

            }else{

                stagingRec.Assign_To__c = 'Priority Banker';

            }

        }    

    }

    public static void afterInsert(Map<Id, sObject> newRecords){

        //Id batchJobId = Database.executeBatch(new LeadAllocationBatch(), 200);

    }

}