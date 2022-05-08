/**
* Apex Enterprise Design Patterns
* Selector Layer for EmailTemplate objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-10-17
*/
public class EmailTemplatesSelector extends fflib_SObjectSelector {
    
     //MANDATORY ABSTRACT METHODS - START
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            EmailTemplate.Id,
            EmailTemplate.DeveloperName,
            EmailTemplate.Name,
            EmailTemplate.HTMLValue,
            EmailTemplate.Subject
        };
    }
    public Schema.SObjectType getSObjectType() {
        return EmailTemplate.sObjectType;
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    public List<EmailTemplate> selectByName(String names ){
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('Name = :names');
        return (List<EmailTemplate>) Database.query( query.toSOQL() );
    }
    public List<EmailTemplate> selectById( Set<Id> idSet ) {
        return (List<EmailTemplate>) selectSObjectsById(idSet);
    }
    public List<EmailTemplate> selectByDeveloperName(String names ){
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition('DeveloperName = :names');
        return (List<EmailTemplate>) Database.query( query.toSOQL() );
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOM SELECTORS - START
      
   //CUSTOM SELECTORS - END
}