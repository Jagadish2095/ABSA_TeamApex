/**
* Apex Enterprise Design Patterns
* Selector Layer for Shared_Email_Rule__c *junction* object
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-07-18
*/
public class SharedEmailRulesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Shared_Email_Rule__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Shared_Email_Rule__c.Email_Rule__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //- None - 
    //INHERIT FROM BASE CLASS - END
    
}