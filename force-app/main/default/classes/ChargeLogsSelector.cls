/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Charge_Log__c objects
 * @author  Jason Quevauvilliers
 * @since   2021-05-11
 */
public class ChargeLogsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description Get SObject Type
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Charge_Log__c.sObjectType;
	}

	/**
	 * @description Get SObject Field List
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Charge_Log__c.Id,
			Charge_Log__c.Name,
			Charge_Log__c.Account__c,
			Charge_Log__c.Source__c,
			Charge_Log__c.Transaction_Code__c,
			Charge_Log__c.Transaction_Date__c,
			Charge_Log__c.UCID__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	/**
	 * @description Select By Id Set
	 * @param idSet
	 * @return List<Charge_Log__c>
	 */
	public List<Charge_Log__c> selectById(Set<Id> idSet) {
		return (List<Charge_Log__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	/**
	 * @description Returns Charge_Log__c for that Id
	 * @param chargeLogId
	 * @return Charge_Log__c
	 */
	public Charge_Log__c selectById(Id chargeLogId) {
		return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Account__c')
			.selectField('Account_CIF_Code__c')
            .setCondition('Id =: chargeLogId')
            .setLimit(1)
            .toSOQL());
	}


	/**
	 * @description Returns Charge_Log__c for that account Id
	 * @param accountId
	 * @return List<Charge_Log__c>
	 */
	public List<Charge_Log__c> selectChargesByAccountId(Id accountId) {

		List<Charge_Log__c> result =	[SELECT Id
												, name
												, source__c
												, account__c
												, Transaction_Date__c
												, Charge_Control__c
												, Account_CIF_Code__c
												,Transaction_Code__c
												, Charge_Control__r.Charge_Account_Number__c
												, (select id, name, charge_amount__c from charge_amounts__r)
										FROM 	Charge_Log__c
										WHERE	Account__c=:accountId];

		return result;
	}
}