/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Sales_Group_User_Entry__c objects
 *
 * @author  Chandra
 * @since   2021-06-15
 */
public with sharing class SalesGroupUserEntriesSelector extends fflib_SObjectSelector {
	/**
	 * @description mandatory method getSObjectType()
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Sales_Group_User_Entry__c.sObjectType;
	}

	/**
	 * @description mandatory method getSObjectFieldList()
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Sales_Group_User_Entry__c.Id,
			Sales_Group_User_Entry__c.Name,
			Sales_Group_User_Entry__c.Sales_Group__c,
			Sales_Group_User_Entry__c.User__c
		};
	}

	/**
	 * @description inherit from base class, get Sales_Group_User_Entry__c by id's
	 * @param idSet
	 * @return List<Sales_Group_User_Entry__c>
	 */
	public List<Sales_Group_User_Entry__c> selectById(Set<Id> idSet) {
		return (List<Sales_Group_User_Entry__c>) selectSObjectsById(idSet);
	}

	/**
	 * @description get Sales_Group_User_Entry__c by user id's
	 * @param userIdSet
	 * @return List<Sales_Group_User_Entry__c>
	 */
	public List<Sales_Group_User_Entry__c> selectByUserId(Set<Id> userIdSet) {
		return Database.query(newQueryFactory().selectField('Sales_Group__r.Name').setCondition('User__c IN: userIdSet').toSOQL());
	}
	
}