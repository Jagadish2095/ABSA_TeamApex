/**
* Apex Enterprise Design Patterns
* Selector Layer for Unwanted_Email__c objects
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-07
*/
public class UnwantedEmailsSelector extends fflib_SObjectSelector {

   //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return Unwanted_Email__c.sObjectType;
   } 
 
   public List<Schema.SObjectField> getSObjectFieldList() {
      return new List<Schema.SObjectField> {
			Unwanted_Email__c.Id,
            Unwanted_Email__c.CreatedDate    
      };
   }
   //MANDATORY ABSTRACT METHODS - END
   
   //INHERIT FROM BASE CLASS - START
   //override the sort method to sort by created date
   public override String getOrderBy() {
   		return 'CreatedDate ASC';
   }
   //get Unwanted_Email__c by id's 
   public List<Unwanted_Email__c> selectById(Set<Id> idSet) {
        return (List<Unwanted_Email__c>) selectSObjectsById(idSet);
   }
   //INHERIT FROM BASE CLASS - END
   
   //CUSTOM SELECTORS - START
    
    /*
    * Return Unwanted_Email__c Older than 
    * a specific creation date
    * 
    * @param purgeDate DateTime
    * @return List<Unwanted_Email__c>
    */
    public List<Unwanted_Email__c> selectByPurgeDate(DateTime purgeDate) { 
        return (List<Unwanted_Email__c>) Database.query(
            newQueryFactory(). 
            setCondition('CreatedDate < :purgeDate').
            toSOQL()
        );
       
    }
    //CUSTOM SELECTORS - END
    
    
}