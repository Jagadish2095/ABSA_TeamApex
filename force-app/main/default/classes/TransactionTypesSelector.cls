/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Transaction_Type__c objects
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2020-04-20
 */
public class TransactionTypesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description Get SObject Type
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Transaction_Type__c.sObjectType;
	}

	/**
	 * @description Get SObject Field List
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Transaction_Type__c.Id,
			Transaction_Type__c.Name,
			Transaction_Type__c.Pricing_Formula__c,
			Transaction_Type__c.Transaction_Group__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	/**
	 * @description Select By Id Set
	 * @param idSet
	 * @return List<Transaction_Type__c>
	 */
	public List<Transaction_Type__c> selectById(Set<Id> idSet) {
		return (List<Transaction_Type__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	/**
	 * @description Returns List of Transaction Types for the specified Transaction Codes in the Set
	 * @param transactionCodeSet
	 * @return List<Transaction_Type__c>
	 */
	public List<Transaction_Type__c> selectByTransactionCode(Set<String> transactionCodeSet) {
		return Database.query(
			newQueryFactory()
         .selectField('Id')
         .selectField('Transaction_Code__c')
         .setCondition('Transaction_Code__c IN : transactionCodeSet')
         .toSOQL()
		);
	}
}