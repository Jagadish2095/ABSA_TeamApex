/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Trading as Name objects
 *
 * @author  Tracy de Bruin
 * @since   2020-02-06
 */

public class TradingAsNamesSelector extends fflib_SObjectSelector {
	
	/**
	 * @description MANDATORY ABSTRACT METHODS - START
	 * @param
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Trading_as_Name__c.sObjectType;
	}

	/**
	 * @description Field list
	 * @param
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Trading_as_Name__c.Id,
			Trading_as_Name__c.Account__c,
			Trading_as_Name__c.CASA_Analyst_Comments__c,
			Trading_as_Name__c.Name,
			Trading_as_Name__c.CASA_Reference_Number__c,
			Trading_as_Name__c.CASA_Screening_Date__c,
			Trading_as_Name__c.CASA_Screening_Status__c,
			Trading_as_Name__c.Casa_Status__c,
			Trading_as_Name__c.CIF__c,
			Trading_as_Name__c.Client_Group__c,
			Trading_as_Name__c.Client_Type__c,
			Trading_as_Name__c.Country_of_Incorporation__c,
			Trading_as_Name__c.Date_Established__c,
			Trading_as_Name__c.ID_Type__c,
			Trading_as_Name__c.PEP_Status__c,
			Trading_as_Name__c.Registration_Incorporation_Number__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	/**
	 * @description get Trading_as_Name__c by id's
	 * @param idSet
	 * @return List<Trading_as_Name__c>
	 */
	public List<Trading_as_Name__c> selectById(Set<Id> idSet) {
		return (List<Trading_as_Name__c>) selectSObjectsById(idSet);
	}

	//CUSTOM SELECTORS - START

	/**
	 * @description Method that gets Trading as Names based on AccountId
	 * @param accIds
	 * @return List<Trading_as_Name__c>
	 */
	public List<Trading_as_Name__c> selectByAccountId(Set<Id> accIds) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Name').setCondition('Account__c IN :accIds').toSOQL());
	}

	/**
	 * @description Method that gets Trading as Names based on Id
	 * @param recordId
	 * @return Trading_as_Name__c
	 */
	public Trading_as_Name__c selectById(Id recordId) {
		return Database.query(newQueryFactory().setCondition('Id = :recordId').toSOQL());
	}
}