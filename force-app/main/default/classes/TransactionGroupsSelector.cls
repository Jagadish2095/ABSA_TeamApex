/**
* Apex Enterprise Design Patterns
* Selector Layer for Transaction_Group__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2020-04-20
*/
public class TransactionGroupsSelector extends fflib_SObjectSelector {
	 //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return Transaction_Group__c.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField> {
      			Transaction_Group__c.Id,
                Transaction_Group__c.Name,
                Transaction_Group__c.Pricing_Formula__c
		};
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //get Transaction_Group__c by id's 
   public List<Transaction_Group__c> selectById(Set<Id> idSet) {
        return (List<Transaction_Group__c>) selectSObjectsById(idSet);
   }
   //INHERIT FROM BASE CLASS - END
}