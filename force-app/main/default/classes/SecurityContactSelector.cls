/**
* Apex Enterprise Design Patterns
* Selector Layer for Security_Offered_Contact_Relationship__c objects
*
* @author  Himani Joshi:Absa 
* @since   2020-09-15
*/
public class SecurityContactSelector extends fflib_SObjectSelector {
      //MANDATORY ABSTRACT METHODS - START
   public Schema.SObjectType getSObjectType(){
      return Security_Offered_Contact_Relationship__c.sObjectType;
   }
    
  public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            
                Security_Offered_Contact_Relationship__c.Id
                
                };
      }
     //MANDATORY ABSTRACT METHODS - END 
    
     ////Custom Selectors

        /**
     * Method to retrieve Security_Offered_Contact_Relationship__c 
     *
     
     * @return List of Security_Offered_Contact_Relationship__c 
    **/
    public List<Security_Offered_Contact_Relationship__c> getSecurityContacts(String securityOfferedId,Id ContactId) {
      return Database.query(
            newQueryFactory().selectField('Id')
            .selectField('Contact__c')
            .setCondition('Security_Offered__c =: securityOfferedId AND Contact__c =:ContactId')
            .toSOQL()
        );
    }
    }