/**
* @description Apex Enterprise Design Patterns
* Selector Layer for the Lead_Allocation_Staging__c object
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2020-05-08
*/

public class LeadAllocationStagingSelector extends fflib_SObjectSelector{
    
    
    /**
    * @description MANDATORY ABSTRACT METHODS - START
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType(){
        return Lead_Allocation_Staging__c.sObjectType;
    } 

    /**
    * @description 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Lead_Allocation_Staging__c.Id,
            Lead_Allocation_Staging__c.Process_Status__c,
            Lead_Allocation_Staging__c.Process_Date__c,
            Lead_Allocation_Staging__c.Process_Information__c,
            Lead_Allocation_Staging__c.Distribution_Method__c,
            Lead_Allocation_Staging__c.Assign_To__c,
            Lead_Allocation_Staging__c.CIF__c, 
            Lead_Allocation_Staging__c.Lead_Source__c,
            Lead_Allocation_Staging__c.Product_Interest__c,
            Lead_Allocation_Staging__c.Product_Interest_2__c,
            Lead_Allocation_Staging__c.Product_Interest_3__c,
            Lead_Allocation_Staging__c.Lead_Status__c,
            Lead_Allocation_Staging__c.Service_Group__c,
            Lead_Allocation_Staging__c.Campaign_Name__c,
            Lead_Allocation_Staging__c.First_Name__c,
            Lead_Allocation_Staging__c.Last_Name__c,
            Lead_Allocation_Staging__c.ID_Number__c,
            Lead_Allocation_Staging__c.Cell_Phone_Number__c,
            Lead_Allocation_Staging__c.Email_Address__c,
            Lead_Allocation_Staging__c.Phone_Number__c,
            Lead_Allocation_Staging__c.Role__c,
            Lead_Allocation_Staging__c.OwnerId,
            Lead_Allocation_Staging__c.Business_Unit__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //override the sort method to sort by created date and accountId
    public override String getOrderBy() {
            return 'CreatedDate DESC';
    }
    
    /**
    * @description get cases by id's 
    * @param idSet 
    * @return List<Lead_Allocation_Staging__c> 
    **/
    public List<Lead_Allocation_Staging__c> selectById(Set<Id> idSet) {
        return (List<Lead_Allocation_Staging__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END
    
    //CUSTOM SELECTORS - START
    
    

    /**
    * @description Get records by teh process status of teh record
    * @param status 
    * @return List<Lead_Allocation_Staging__c> 
    **/
    public List<Lead_Allocation_Staging__c> selectByProcessStatus(String status) {
        return Database.query(
                newQueryFactory().          
                        setCondition('Process_Status__c = :status').
                        toSOQL()
        );
    }

}