/**
* Apex Enterprise Design Patterns
* Selector Layer for Shared_Email__c object
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-07-18
*/
public class SharedEmailsSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Shared_Email__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            	Shared_Email__c.Id,
            	Shared_Email__c.Name,
                Shared_Email__c.Active__c,
                Shared_Email__c.Inbox_Address__c,    
                Shared_Email__c.Salesforce_Email_Address__c,
                Shared_Email__c.Verified__c,
                Shared_Email__c.Prioritise__c           
        };
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Shared_Email__c> selectById(Set<Id> idSet) {
        return (List<Shared_Email__c>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END
    
    //CUSTOM SELECTORS - START
    
    /*
    * Return Shared_Email__c by SF Email service address
    * Custom selector USING the Base class queryFactory
    * 
    * @param toAddress String
    * @return List<Shared_Email__c>
    */
    public List<Shared_Email__c> selectBySFEmail(String toAddress) { 
        return (List<Shared_Email__c>) Database.query(
            newQueryFactory(). 
            setCondition('Salesforce_Email_Address__c = :toAddress and Active__c = true').
            toSOQL()
        );
       
    }
    /*
    * Return Shared_Email__c by Inbox email address
    * WITH related Shared_Email_Rules
    * Custom selector USING the Base class queryFactory
    *  
    * @param toAddress String
    * @return List<Shared_Email__c>
    */
    public List<Shared_Email__c> selectByInboxWithEmailRules(String toAddress) {
        
       	fflib_QueryFactory query = newQueryFactory(false).
        					selectField('Id').
        					setCondition('Inbox_Address__c = :toAddress and Active__c = true');
        
        new SharedEmailRulesSelector().addQueryFactorySubselect(query,'Shared_Email_Rules__r');
        
        return (List<Shared_Email__c>) Database.query( query.toSOQL() );
        
     }
    /*
    * Return Shared_Email__c by SF Email service address
    * WITH related Shared_Email_Rules
    * Custom selector USING the Base class queryFactory
    *  
    * @param toAddress String
    * @return List<Shared_Email__c>
    */
    public List<Shared_Email__c> selectByToAddressesWithEmailRules(Set<String> toAddresses) {

       	fflib_QueryFactory query = newQueryFactory(false).
        					selectField('Id').
            				selectField('Inbox_Address__c').
        					setCondition('(Salesforce_Email_Address__c IN :toAddresses OR Inbox_Address__c IN :toAddresses) AND Active__c = true');
        
        new SharedEmailRulesSelector().addQueryFactorySubselect(query,'Shared_Email_Rules__r');

        return (List<Shared_Email__c>) Database.query( query.toSOQL() );
        
     }
    
    /*
    * Return Shared_Email__c by SF Email service address
    * WITH related Shared_Email_Rules
    * Custom selector USING the Base class queryFactory
    *  
    * @param toAddress String
    * @return List<Shared_Email__c>
    */
    public List<Shared_Email__c> selectByToAddressesAndPriorityWithEmailRules(Set<String> toAddresses) {

       	fflib_QueryFactory query = newQueryFactory(false).
        					selectField('Id').
            				selectField('Name').
            				selectField('Inbox_Address__c').
            				selectField('Salesforce_Email_Address__c').
            				selectField('Prioritise__c').
            				selectField('Active__c').
        					setCondition('(Salesforce_Email_Address__c IN :toAddresses OR Inbox_Address__c IN :toAddresses) AND Active__c = true And Prioritise__c = true');
        
        new SharedEmailRulesSelector().addQueryFactorySubselect(query, 'Shared_Email_Rules__r');

        return (List<Shared_Email__c>) Database.query( query.toSOQL() );
        
     }
    
    //CUSTOM SELECTORS - END
}