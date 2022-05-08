/**
* Apex Enterprise Design Patterns
* Selector Layer for CaseTeamTemplateMembers object
*
* @author  Tracy de Bruin
* @since   2020-02-11
*/
public class CaseTeamTemplateMembersSelector extends fflib_SObjectSelector {

     //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return CaseTeamTemplateMember.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                CaseTeamTemplateMember.id, 
                CaseTeamTemplateMember.MemberId,
                CaseTeamTemplateMember.TeamTemplateId,
				CaseTeamTemplateMember.TeamRoleId 
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get CaseTeamTemplateMember by id's
    public List<CaseTeamTemplateMember> selectById(Set<Id> idSet) {
        return (List<CaseTeamTemplateMember>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START

    /**
     * Returns a List of CaseTeamTemplateMember based on a specific User Id
     *
     * @return  User    The User object record
     */
    public List<CaseTeamTemplateMember> selectByTemplateNameAndUserId(String templateName, Id userId) {
        
        String templateNameValue = '%' + templateName + '%';
        return Database.query(
            newQueryFactory().
            setCondition('TeamTemplateId IN (SELECT Id FROM CaseTeamTemplate WHERE Name LIKE :templateNameValue) and MemberId IN (SELECT Id FROM User where Id = :userId)'). 
            toSOQL()
        );
    }
    
     /**
     * Returns a List of CaseTeamTemplateMember based on a specific User Id
     *
     * @param userId    The SF Id of the User
     *
     * @return  User    The User object record
     */
    public List<CaseTeamTemplateMember> selectByTemplateId(Set<Id> templateId) {

        return Database.query(
            newQueryFactory().
            setCondition('TeamTemplateId IN : templateId'). 
            toSOQL()
        );
    }

    
    //CUSTOM SELECTORS - END
}