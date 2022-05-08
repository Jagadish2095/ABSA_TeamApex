/**
* Apex Enterprise Design Patterns
* Selector Layer for Service_Group__c objects
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-07-23
*/
public class ServiceGroupsSelector extends fflib_SObjectSelector {
	
   //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType() {
      return Service_Group__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
       
      return new List<Schema.SObjectField> {
                Service_Group__c.Id,
                Service_Group__c.Email_Template_Case_Creation__c,
                Service_Group__c.Email_Template_Lead_Creation__c,
                Service_Group__c.Name,
                Service_Group__c.Internal_SLA__c,
                Service_Group__c.Internal_SLA_Time_Measure__c,
                Service_Group__c.Internal_SLA_Notification_User__c,
                Service_Group__c.Internal_SLA_Units__c,
                Service_Group__c.Queue__c,
                Service_Group__c.Pause_Statuses__c,
                Service_Group__c.Response_Email_Address__c,
                Service_Group__c.Assign_Record_Type__c,  
                Service_Group__c.Business_Hours__c,
                Service_Group__c.Manager__c,
                Service_Group__c.X2IC_Manager__c,
                Service_Group__c.ITA_Manager__c,
                Service_Group__c.Skip_Split_Auto_Response__c,
                Service_Group__c.IB_Service_Group_Name__c
      };
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Service_Group__c by id's 
   public List<Service_Group__c> selectById(Set<Id> idSet) {
        return (List<Service_Group__c>) selectSObjectsById(idSet);
   }
   
   /*
    * Return Service_Group__c by Service Group
    * 
    * @param AssignedRecordType String
    * @return List<Service_Group__c> 
    */
   public List<Service_Group__c> selectByAssignedRecordType(Set<String> recordTypeName) {

        return Database.query(
      		newQueryFactory(true).
            setCondition('Assign_Record_Type__c IN :recordTypeName').
            toSOQL()
   		);
   }
    
   /*
    * @param Set<String> serviceGroupNames
    * @return List<Service_Group__c> 
    */
   public List<Service_Group__c> selectByName(Set<String> serviceGroupNames) {

        return Database.query(
      		newQueryFactory(true).
            setCondition('Name IN :serviceGroupNames').
            toSOQL()
   		);
   }
    
    /*
    * @param Set<String> serviceGroupNames, Set<String> recordTypeNames
    * @return List<Service_Group__c> 
    */
   public List<Service_Group__c> selectByNameAndAssignedRecordType(Set<String> serviceGroupNames, Set<String> recordTypeNames) {

        return Database.query(
      		newQueryFactory(true).
            setCondition('Name IN :serviceGroupNames And Assign_Record_Type__c IN :recordTypeNames').
            toSOQL()
   		);
   }
   //INHERIT FROM BASE CLASS - END
   
	   
}