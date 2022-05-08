/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Group object
 *
 * @author  Rudolf Niehaus - CloudSmiths
 * @since   2018-07-24
 */
public class GroupsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS -
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Group.sObjectType;
	}

	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{ Group.Id, Group.Name, Group.DeveloperName };
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	//get Group by id's
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectById(Set<Id> idSet) {
		return (List<Group>) selectSObjectsById(idSet);
	}

	/**
	 * @description selectById description
	 *
	 * @param userId (Id): userId
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectById(Id userId) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Name').selectField('RelatedId').setCondition('Id = :userId').toSOQL());
	}

	/**
	 * @description selectByGroupRole description
	 *
	 * @param roleId (Id): userId
	 * @param type
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectByGroupRole(Id roleId, String type) {
		return Database.query(
			newQueryFactory()
			.selectField('Id')
			.selectField('Name')
			.selectField('RelatedId')
			.setCondition('RelatedId = :roleId AND Type = :type')
			.toSOQL()
		);
	}
	
	/**
	 * SELECT Id FROM GroupMember where (UserOrGroupId =:groupWithRole[0].Id or UserOrGroupId =:UserInfo.getUserId()) and 
                                                        group.name=:serviceGroupTypeMap.get(eachCase.sd_Service_Group_Type_Id__c).Service_Group__r.Queue__c and group.type = 'Queue'
	 */
	//INHERIT FROM BASE CLASS - END

	//CUSTOM SELECTORS - START
	/**
	 * @description selectByNameAndType description
	 *
	 * @param name (String): name
	 * @param groupType (String): groupType
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectByNameAndType(String name, String groupType) {
		return Database.query(newQueryFactory().setCondition('Name = :name AND Type = :groupType').toSOQL());
	}

	/**
	 * @description selectByType description
	 *
	 * @param groupType (String): groupType
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectByType(String groupType) {
		return Database.query(newQueryFactory().setCondition('Type = :groupType').toSOQL());
	}

	/**
	 * @description selectByNameSetAndType description
	 *
	 * @param names (Set<String>): names
	 * @param groupType (String): groupType
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectByNameSetAndType(Set<String> names, String groupType) {
		return Database.query(newQueryFactory().setCondition('Name IN :names AND Type = :groupType').toSOQL());
	}

	/**
	 * @description selectByDeveloperNameAndType description
	 *
	 * @param developerName (String): developerName
	 * @param groupType (String): groupType
	 * @return Return List<Group>: Return description
	 */
	public List<Group> selectByDeveloperNameAndType(String developerName, String groupType) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('DeveloperName')
				.setCondition('DeveloperName = :developerName AND Type = :groupType')
				.toSOQL()
		);
	}

	/**
	 * @description selectByName description
	 *
	 * @param name (String): name
	 * @return Return Group: Return description
	 */
	public Group selectByName(String name) {
		fflib_QueryFactory query = newQueryFactory(false).selectField('Id').setCondition('Name = :name');

		List<String> fields = new List<String>{ 'Id', 'UserOrGroupId', 'GroupId' };

		fflib_QueryFactory oliQueryFactory = query.subselectQuery('GroupMembers').selectFields(fields);

		return (Group) Database.query(query.toSOQL());
	}

	/**
	* @description
	* @param name
	* @param grpType
	* @return List<Group>
	**/
	public List<Group> selectByNameType(string name,string grpType){
        return Database.query(
      		newQueryFactory().
            selectField('Id').
            setCondition('Name = :name AND Type = :grpType').
            toSOQL()
   		);
    }
	//CUSTOM SELECTORS - END
}