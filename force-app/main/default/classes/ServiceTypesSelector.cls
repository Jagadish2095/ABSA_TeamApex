/**
* Apex Enterprise Design Patterns
* Selector Layer for Service_Type__c objects
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-07-23
*/
public class ServiceTypesSelector extends fflib_SObjectSelector {
	 //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return Service_Type__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField> {
      			Service_Type__c.Id,
                Service_Type__c.Name,
                Service_Type__c.Type__c,
                Service_Type__c.Subtype__c,
                Service_Type__c.Product__c,    
                Service_Type__c.FAIS_NCA__c,
                Service_Type__c.Case_Record_Type__c
      };
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Service_Type__c by id's 
   public List<Service_Type__c> selectById(Set<Id> idSet) {
        return (List<Service_Type__c>) selectSObjectsById(idSet);
   }
   //INHERIT FROM BASE CLASS - END
}