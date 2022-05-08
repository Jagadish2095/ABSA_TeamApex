/**
* Apex Enterprise Design Patterns
* Selector Layer for Profiles
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-03-18
*/
public class ProfilesSelector extends fflib_SObjectSelector {
    
     //MANDATORY ABSTRACT METHODS - START
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            	Profile.Id,
                Profile.Name
        };
    }
    public Schema.SObjectType getSObjectType() {
        return Profile.sObjectType;
    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    public List<Profile > selectById( Set<Id> idSet ) {
        return (List<Profile >) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP
    //CUSTOM SELECTORS - START
    //
   /*
    * Return Contacts by Account Id's
    * 
    * @param idSet Set<String> Contact Id's
    * @param 
    * @return List<Contact>
    */
   public Profile selectByLoggedInUser() { 
       String loggedInUserId = UserInfo.getProfileId();
		 return Database.query(
      		newQueryFactory(true).
            setCondition('Id = :loggedInUserId').
            toSOQL()
   		);
   }            
   //CUSTOM SELECTORS - END
}