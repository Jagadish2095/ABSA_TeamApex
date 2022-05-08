/**
* Apex Enterprise Design Patterns
* Selector Layer for Data_Staging__c objects
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-04-11
*/
public class DataStagingSelector extends fflib_SObjectSelector {
	
    public Schema.SObjectType getSObjectType() {
        return Data_Staging__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Data_Staging__c.Id,
                Data_Staging__c.CIF_Key__c,
                Data_Staging__c.Banker_Name__c,
                Data_Staging__c.Banker_Email__c,
                Data_Staging__c.Banker_Phone__c,
                Data_Staging__c.Client_Phone__c,
                Data_Staging__c.Data_Type__c,
                Data_Staging__c.Process_Status__c,
                Data_Staging__c.Process_Status_Description__c,
                Data_Staging__c.Client_Name__c,
                Data_Staging__c.Client_Title__c,
                Data_Staging__c.Client_First_Name__c,
                Data_Staging__c.Client_Initials__c,
                Data_Staging__c.Client_Surname__c,
                Data_Staging__c.Client_Email__c,
                Data_Staging__c.Unique_Key__c,
                Data_Staging__c.Banker_BRID__c,
                Data_Staging__c.Account_Number__c,
                Data_Staging__c.Product_Code__c,
                Data_Staging__c.Product_Sub_Code__c,
                Data_Staging__c.Contact_Person_Mobile__c,
                Data_Staging__c.Contact_Person_Work_Number__c,
                Data_Staging__c.Contact_Person_Work_Dial_Code__c,
                Data_Staging__c.Contact_Person_Name__c,
                Data_Staging__c.Language__c,
                Data_Staging__c.RecordTypeId
                    
        };
    }

    //get Data_Staging__c by id's
    public List<Data_Staging__c> selectById(Set<Id> idSet) {
        return (List<Data_Staging__c>) selectSObjectsById(idSet);
    }

    /**
    * Get all records NOT equal to a specific status value
    *
    * @param String status
    * @param Integer recordLimit
    * @return List<Data_Staging__c>
    */
    public List<Data_Staging__c> selectNotByProcessStatus(String status, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        setCondition('Process_Status__c != :status').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }

    /**
    * Get all records based on a specific status value
    *
    * @param String status
    * @param Integer recordLimit
    * @return List<Data_Staging__c>
    */
    public List<Data_Staging__c> selectByProcessStatus(String status, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        setCondition('Process_Status__c = :status').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }
}