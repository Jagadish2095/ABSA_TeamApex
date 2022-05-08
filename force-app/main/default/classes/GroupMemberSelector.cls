/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Group Member object
 *
 * @author  Poulami Banerjee
 * @since   2021-05-13
 */
public class GroupMemberSelector extends fflib_SObjectSelector{
    
    //MANDATORY ABSTRACT METHODS -
    /**
     * @description getSObjectType description
     *
     * @return Return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return GroupMember.sObjectType;
    }
    
    /**
     * @description getSObjectFieldList description
     *
     * @return Return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
         return new List<Schema.SObjectField> {
                GroupMember.Id,
                GroupMember.UserOrGroupId
        };
    }
    /**
     * @description selectByGroupName description
     *
     * @param roleId (Id): roleId
     * @param userId (Id): userId
     * @param groupName (String): groupName
     * @param groupType (String): groupType
     * @return Return List<GroupMember>: Return description
     */
    public List<GroupMember> selectByGroupName(Id roleId, Id userId,String groupName,String groupType) {
        return [SELECT Id FROM GroupMember WHERE (UserOrGroupId = :roleId OR UserOrGroupId = :userId) AND group.name = :groupName AND group.type = :groupType];
    }

    /**
     * @description selectByGroupType description
     *
     * @param userId (Id): userId
     * @return Return List<GroupMember>: Return description
     */
    public List<GroupMember> selectByGroupType(Id userId) {
        return [SELECT Id,Group.DeveloperName,Group.Id FROM GroupMember where UserOrGroupId = :userId and (group.type = 'Queue' or group.type = 'Regular')];
    }

/**
 * @description selectByGroupTypeInbound description
 *
 * @param roleId (Id): roleId
 * @param userId (Id): userId
 * @return Return List<GroupMember>: Return description
 */
    public List<GroupMember> selectByGroupTypeInbound(Id roleId, Id userId) {
        return [SELECT Id FROM GroupMember where (UserOrGroupId = :roleId or UserOrGroupId = :userId) and group.type = 'Queue' and Group.DeveloperName ='DD_Non_Advice_Inbound'];
    }

    /**
     * @description selectByGroupType description
     *
     * @param roleId (Id): roleId
     * @param userId (Id): userId
     * @return Return List<GroupMember>: Return description
     */
    public List<GroupMember> selectByGroupTypeExtendedCover(Id roleId, Id userId) {
        return [SELECT Id FROM GroupMember where (UserOrGroupId = :roleId or UserOrGroupId = :userId) and group.type = 'Queue' and Group.DeveloperName ='DD_Extended_Cover'];
    }

    /**
     * @description selectByGroupType description
     *
     * @param roleId (Id): roleId
     * @param userId (Id): userId
     * @return Return List<GroupMember>: Return description
     */
    public List<GroupMember> selectByGroupTypeCreditLife(Id roleId, Id userId) {
        return [SELECT Id FROM GroupMember where (UserOrGroupId = :roleId or UserOrGroupId = :userId) and group.type = 'Queue' and Group.DeveloperName ='DD_AVAF_Credit_Life'];
    }

    /**
    * @description select By Role
    * @author Monde Masiza | 05-31-2021 
    * @param userOrGroupId 
    * @param groupName 
    * @param groupType 
    * @return List<GroupMember> 
    **/
    public List<GroupMember> selectByRole(String userOrGroupId, String groupName, string groupType){
        return [SELECT Id FROM GroupMember where UserOrGroupId =:userOrGroupId and group.name=:groupName and group.type =: groupType];
        
    } 

}