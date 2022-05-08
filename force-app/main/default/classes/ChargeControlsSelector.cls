/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Charge_Control__c objects
 *
 * @author  Jason Quevauvilliers
 * @since   2021-05-11
 * @updated Koketso Mpshane 2021-08-25
 */
public class ChargeControlsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description Get SObject Type
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Charge_Control__c.sObjectType;
	}

	/**
	 * @description Get SObject Field List
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Charge_Control__c.Id,
			Charge_Control__c.Name,
			Charge_Control__c.Charge_ID__c,
			Charge_Control__c.Charge_Account_Number__c,
			Charge_Control__c.Charge_Amount__c,
			Charge_Control__c.Charge_Amount_Rollup__c,
			Charge_Control__c.Charge_Month__c,
			Charge_Control__c.Charge_Process_Code__c,
			Charge_Control__c.Charge_Process_Date__c,
			Charge_Control__c.Composite_Key__c,
			Charge_Control__c.Account__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	/**
	 * @description Select By Id Set
	 * @param idSet
	 * @return List<Charge_Control__c>
	 */
	public List<Charge_Control__c> selectById(Set<Id> idSet) {
		return (List<Charge_Control__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	/**
	 * @description Returns Charge_Control__c List for Account Ids specified in Set
	 * @param accountIdSet
	 * @return List<Charge_Control__c>
	 */
	public List<Charge_Control__c> selectByAccountIdSet(Set<Id> accountIdSet) {
		return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Account__c')
			.selectField('Charge_Account_Number__c')
            .setCondition('Account__c IN : accountIdSet')
            .toSOQL());
	}

	/**
	 * @description Returns Charge_Control__c List whos Composite Kay is specified in Set
	 * @param compositeKeySet
	 * @return List<Charge_Control__c>
	 */
	public List<Charge_Control__c> selectByCompositeKeySet(Set<String> compositeKeySet) {
		return Database.query(
			newQueryFactory()
            .selectField('Id')
            .selectField('Composite_Key__c')
			.selectField('Account__c')
			.selectField('Charge_Account_Number__c')
            .setCondition('Composite_Key__c IN : compositeKeySet')
            .toSOQL()
		);
	}
    
    /**
	 * @description Returns Charge_Control__c List Filtered By Charge Process Code 
	 * @param processCodeFilter
	 * @return List<Charge_Control__c>
	 */
	public List<Charge_Control__c> filterByChargeProcessCode(String processCodeFilter) {
		return Database.query(
            newQueryFactory()
            .setCondition('Charge_Process_Code__c !=: processCodeFilter')
            .toSOQL());
	}
}