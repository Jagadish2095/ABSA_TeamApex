/**
* Apex Enterprise Design Patterns
* Selector Layer for OrgWideEmailAddress object
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-01-18
*/
public class OrgWideEmailAddressesSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return OrgWideEmailAddress.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            OrgWideEmailAddress.Id, 
            OrgWideEmailAddress.Address,
            OrgWideEmailAddress.DisplayName
        };
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<OrgWideEmailAddress> selectById(Set<Id> idSet) {
        return (List<OrgWideEmailAddress>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END
    
    //CUSTOM SELECTORS - START

    /*
    * Return OrgWideEmailAddress 
    * Custom selector USING the Base class queryFactory
    *  
    * @return List<Case>
    */
   public List<OrgWideEmailAddress> selectAll() {
        
          return (List<OrgWideEmailAddress>) Database.query(
            newQueryFactory(). 
            toSOQL()
       ); 
     }
    
    /*
    * Return OrgWideEmailAddress with address 'plokkieven@gmail.com'
    * 
    * for setting sender name as AAActivity Tracking test in taskOverdueemailbatch 
    * note:-pass the parameter as email and dnt hardcode 
    * 
    */
   public List<OrgWideEmailAddress> selectAAActivity() {
        string emailAddress ='donotreply@absa.africa';
          return  Database.query(
            newQueryFactory(). 
            selectField('Id').
            setCondition('Address =:emailAddress').
            toSOQL()
       ); 
     }
    
        /*
    * Return OrgWideEmailAddresses based on Display Name
    * 
    */
   public List<OrgWideEmailAddress> selectByAddress(Set<String> emailAddress) {
          return  Database.query(
            newQueryFactory(). 
            selectField('Address').
            setCondition('Address IN :emailAddress').
            toSOQL()
       ); 
     }
    
    
    /*
    * Return OrgWideEmailAddresses based on Name
    *
    */
    public List<OrgWideEmailAddress> selectByName(Set<String> name) {
        return  Database.query(
          newQueryFactory().
          selectField('Address').
          setCondition('DisplayName IN :name').
          toSOQL()
        );
    }
    

    //CUSTOM SELECTORS - END
}