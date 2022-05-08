/**
* Apex Enterprise Design Patterns
* Selector Layer for AccountTeamMember objects
*
* @author       Tracy de Bruin (CloudSmiths)
* @since        14-08-2019
* @modified     
*/

public class AccountTeamMembersSelector extends fflib_SObjectSelector {
  //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return AccountTeamMember.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                AccountTeamMember.Id,
                AccountTeamMember.AccountId,
                AccountTeamMember.UserId,
                AccountTeamMember.TeamMemberRole
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    public List<AccountTeamMember> selectById(Set<Id> idSet) {
        return (List<AccountTeamMember>) selectSObjectsById(idSet);
    }

    //INHERIT FROM BASE CLASS - STOP

    //CUSTOM SELECTORS - START

    /**
     * Method that gets a List of AccountTeamMembers based on Account Ids and Member Role
     *
     * @return List<AccountTeamMember> 
     */
    public List<AccountTeamMember> selectByAccountIdsAndRole(Set<Id> accountIds, Set<String> memberRoleNames) {
        return Database.query(
                newQueryFactory().
                        selectField('AccountAccessLevel').
            			selectField('Account.CIF__c').
                        setCondition('AccountId IN :accountIds AND ' +
                                    'TeamMemberRole IN :memberRoleNames').
                        toSOQL()
        );

    }

    //CUSTOM SELECTORS - END
}