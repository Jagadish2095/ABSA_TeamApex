/**
* Apex Enterprise Design Patterns
* Selector Layer for Service_Level__c object
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-09-14
*/
public class ServiceLevelsSelector extends fflib_SObjectSelector{
    
     //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Service_Level__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        
        return new List<Schema.SObjectField> {
            	Service_Level__c.Id,
                Service_Level__c.External_SLA__c,
                Service_Level__c.External_SLA_Time_Measure__c,
                Service_Level__c.External_SLA_Units__c,
                Service_Level__c.Max_SLA_Extension__c,
                Service_Level__c.Max_SLA_Time_Measure__c,
                Service_Level__c.Max_SLA_Units__c,
                Service_Level__c.Email_Template_Case_Classification__c,
                Service_Level__c.Email_Template_Case_Closure__c,
                Service_Level__c.External_SLA_Warning__c,
                Service_Level__c.External_SLA_Notification_User__c,
                Service_Level__c.Default_Service_Level__c
          };
   }
   //MANDATORY ABSTRACT METHODS - END
	//INHERIT FROM BASE CLASS - START
   //get Service_Level__c by id's 
   public List<Service_Level__c> selectById(Set<Id> idSet) {
        return (List<Service_Level__c>) selectSObjectsById(idSet);
   }
    
   //CUSTOM SELECTORS - START 
   /* RN - CloudSmiths
     * 
    * Return the default service group type for unclassfied cases
    * 
    * @return List<Service_Level__c>
    */
    public List<Service_Level__c> selectDefaultServiceType() { 
        
        return (List<Service_Level__c>) Database.query(
            newQueryFactory(true).
            setCondition('Default_Service_Level__c = true').
            setLimit(1).
            toSOQL()
        );
    }  
    
   //CUSTOM SELECTORS - END 
}