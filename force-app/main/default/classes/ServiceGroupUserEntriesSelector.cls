/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Service_Group_User_Entry__c objects
 *
 * @author  Prashant Jain (Tetrad)
 * @since   2020-09-11
 * @updated 2021-03-31 Koketso Mpshane
 */

public class ServiceGroupUserEntriesSelector extends fflib_SObjectSelector {
	/**
	 * @description mandatory method getSObjectType()
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Service_Group_User_Entry__c.sObjectType;
	}

	/**
	 * @description mandatory method getSObjectFieldList()
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Service_Group_User_Entry__c.Id,
			Service_Group_User_Entry__c.Name,
			Service_Group_User_Entry__c.Service_Group__c,
			Service_Group_User_Entry__c.User__c
		};
	}

	/**
	 * @description inherit from base class, get Service_Group_User_Entry__c by id's
	 * @param idSet
	 * @return List<Service_Group_User_Entry__c>
	 */
	public List<Service_Group_User_Entry__c> selectById(Set<Id> idSet) {
		return (List<Service_Group_User_Entry__c>) selectSObjectsById(idSet);
	}

	/**
	 * @description get Service_Group_User_Entry__c by user id's
	 * @param userIdSet
	 * @return List<Service_Group_User_Entry__c>
	 */
	public List<Service_Group_User_Entry__c> selectByUserId(Set<Id> userIdSet) {
		return Database.query(newQueryFactory().selectField('Service_Group__r.Name').setCondition('User__c IN: userIdSet').toSOQL());
	}

	/**
	 * @description get the number of Service_Group_User_Entry__c records by user id and service group names
	 * @param userId
	 * @param serviceGroupNames
	 * @return Integer
	 */
	public Integer countUserRelatedEntries(Id userId, List<String> serviceGroupNames) {
		return [SELECT COUNT() FROM Service_Group_User_Entry__c WHERE User__c = :userId AND Service_Group__r.Name IN :serviceGroupNames];
	}
}