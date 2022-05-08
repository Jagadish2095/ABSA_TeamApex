/**
 * @description Transaction_Filter_List__c Selector Class
 * @Author Humbelani Denge
 */
public class TransactionsFilterSelector extends fflib_SObjectSelector {
	/**
	 * @description indicates which sObject the selector is for
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Transaction_Filter_List__c.sObjectType;
	}

	/**
	 * @description indicates which fields should be selected from current sObject
	 * @return  List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Transaction_Filter_List__c.Id,
			Transaction_Filter_List__c.Processing_Date__c,
			Transaction_Filter_List__c.Effective_Date__c,
			Transaction_Filter_List__c.Description1__c,
			Transaction_Filter_List__c.Description2__c,
			Transaction_Filter_List__c.Description3__c,
			Transaction_Filter_List__c.Transaction_Amount__c,
			Transaction_Filter_List__c.Transaction_Cost__c,
			Transaction_Filter_List__c.Balance_After_Transaction__c,
			Transaction_Filter_List__c.Transaction_Type__c,
			Transaction_Filter_List__c.Event_Number__c,
			Transaction_Filter_List__c.Line_Number__c,
			Transaction_Filter_List__c.Transaction_Category__c
		};
	}

	/**
	 * @description override the sort method to sort by Processing_Date__c
	 * @return String
	 */
	public override String getOrderBy() {
		return 'Processing_Date__c ASC ';
	}

	/**
	 * @description get Transaction records by Processing Date
	 * @param procDate
	 * @return Transaction_Filter_List__c collection
	 */
	public List<Transaction_Filter_List__c> getByDate(Date procDate) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Processing_Date__c')
				.selectField('Effective_Date__c')
				.selectField('Description1__c')
				.selectField('Description2__c')
				.selectField('Description3__c')
				.selectField('Transaction_Amount__c')
				.selectField('Transaction_Cost__c')
				.selectField('Balance_After_Transaction__c')
				.selectField('Transaction_Type__c')
				.selectField('Event_Number__c')
				.selectField('Line_Number__c')
				.selectField('Transaction_Category__c')
				.setCondition('Processing_Date__c =:procDate')
				.toSOQL()
		);
	}

	/**
	 * @description get Transaction records by Processing Date and description
	 * @param procDate
	 * @param description
	 * @return Transaction_Filter_List__c collection
	 */
	public List<Transaction_Filter_List__c> getByDateAndDesc(Date procDate, String description) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Processing_Date__c')
				.selectField('Effective_Date__c')
				.selectField('Description1__c')
				.selectField('Description2__c')
				.selectField('Description3__c')
				.selectField('Transaction_Amount__c')
				.selectField('Transaction_Cost__c')
				.selectField('Balance_After_Transaction__c')
				.selectField('Transaction_Type__c')
				.selectField('Event_Number__c')
				.selectField('Line_Number__c')
				.selectField('Transaction_Category__c')
				.setCondition('Processing_Date__c =:procDate and Description2__c Like' + description)
				.toSOQL()
		);
	}

	/**
	 * @description get Transaction records bytransactionTypes set
	 * @param transactionTypes
	 * @return Transaction_Filter_List__c collection
	 */
	public List<Transaction_Filter_List__c> getByTransactionSet(Set<String> transactionTypes) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Processing_Date__c')
				.selectField('Effective_Date__c')
				.selectField('Description1__c')
				.selectField('Description2__c')
				.selectField('Description3__c')
				.selectField('Transaction_Amount__c')
				.selectField('Transaction_Cost__c')
				.selectField('Balance_After_Transaction__c')
				.selectField('Transaction_Type__c')
				.selectField('Event_Number__c')
				.selectField('Line_Number__c')
				.selectField('Transaction_Category__c')
				.setCondition('Description1__c IN: transactionTypes')
				.toSOQL()
		);
	}

	/**
	 * @description get Transaction records by description2
	 * @param description
	 * @return Transaction_Filter_List__c collection
	 */

	public List<Transaction_Filter_List__c> getByDescription(String description) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('Processing_Date__c')
				.selectField('Effective_Date__c')
				.selectField('Description1__c')
				.selectField('Description2__c')
				.selectField('Description3__c')
				.selectField('Transaction_Amount__c')
				.selectField('Transaction_Cost__c')
				.selectField('Balance_After_Transaction__c')
				.selectField('Transaction_Type__c')
				.selectField('Event_Number__c')
				.selectField('Line_Number__c')
				.selectField('Transaction_Category__c')
				.setCondition('Description2__c Like' + description)
				.toSOQL()
		);
	}
}