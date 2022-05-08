/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Sales_Group_Process_Type__c objects
 *
 * @author  Chandra
 * @since   2021-06-15
 */
public with sharing class SalesGroupProcessTypesSelector extends fflib_SObjectSelector {
	/**
	 * @description mandatory method getSObjectType()
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Sales_Group_Process_Type__c.sObjectType;
	}

	/**
	 * @description mandatory method getSObjectFieldList()
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{ Sales_Group_Process_Type__c.Id, Sales_Group_Process_Type__c.Name };
	}

	/**
	 * @description inherit from base class, get Sales_Group_Process_Type__c by id's
	 * @param idSet
	 * @return List<Sales_Group_Process_Type__c>
	 */
	public List<Sales_Group_Process_Type__c> selectById(Set<Id> idSet) {
		return (List<Sales_Group_Process_Type__c>) selectSObjectsById(idSet);
	}

	/**
	 * @description selectByRequestName select by request name i.e. What do you want to do today
	 * @param searchKey
	 * @param salesGroups
	 * @return List<Sales_Group_Process_Type__c>
	 */
	public List<Sales_Group_Process_Type__c> getSalesProcessTypeWithSalesGroup(String searchKey, List<String> salesGroups) {
		return Database.query(
			newQueryFactory(true)
				.selectField('Id')
				.selectField('Name')
				.selectField('Sales_Process_Type__c')
				.selectField('Sales_Process_Type__r.Name')
				.selectField('Sales_Process_Type__r.Product_Family__c')
				.selectField('Sales_Process_Type__r.Product_Selector_Mode__c')
				.selectField('Sales_Process_Type__r.Opportunity_Record_Type__c')
				.selectField('Sales_Process_Type__r.Request_Name__c')
				.selectField('Sales_Group__c')
				.selectField('Sales_Group__r.Name')
            	.selectField('Show_XDS__c') //Added by DBOOYSEN. W-012962
            	.selectField('Show_Sales_Prospect_Pop_Up__c') //Added by DBOOYSEN. W-012962
				.setCondition('Sales_Process_Type__r.Name LIKE \'' + searchKey + '\' AND Sales_Group__r.Name IN :salesGroups')
				.toSOQL()
		);
	}
	
}