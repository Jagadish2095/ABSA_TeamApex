/**
* Apex Enterprise Design Patterns
* Selector Layer for User objects
*
* @author  Venkatesh Kanukuntla
* @since   2021-01-26
*/
public class UserSitesSelector extends fflib_SObjectSelector{

     public Schema.SObjectType getSObjectType() {
        return User_Site__c.sObjectType;
    }
    
     public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User_Site__c.id
                
        };
     }
     public List<User_Site__c> selectByUserId(string userId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('BSiteName__c'). 
            selectField('userEmail__c').
            selectField('User__c').
            selectField('User__r.Name').
            
            setCondition('User__c = :userId').
            toSOQL()
        );
    }  
    public List<User_Site__c> selectBySiteCity(string searchKey) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Site__r.Cities_PickList__c').
            selectField('Site__c'). 
            selectField('User__c').
            selectField('SiteCity__c').
            selectField('BSiteName__c').
            
            setCondition('Site__r.Cities_PickList__c LIKE :searchKey  ').
            toSOQL()
        );
    } 
}