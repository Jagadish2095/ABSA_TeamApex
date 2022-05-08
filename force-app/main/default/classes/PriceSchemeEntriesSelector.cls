/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Price_Scheme_Entry__c objects
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2020-04-20
 */
public class PriceSchemeEntriesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description Get SObject Type
	 * @return Schema.SObjectType
	 */
	public Schema.SObjectType getSObjectType() {
		return Price_Scheme_Entry__c.sObjectType;
	}

	/**
	 * @description Get SObject Field List
	 * @return List<Schema.SObjectField>
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Price_Scheme_Entry__c.Id,
			Price_Scheme_Entry__c.Name,
			Price_Scheme_Entry__c.Price_Scheme__c,
			Price_Scheme_Entry__c.Fee_Type__c,
			Price_Scheme_Entry__c.Fee_Amount_Percent__c,
			Price_Scheme_Entry__c.Fee_Amount_Fixed__c,
			Price_Scheme_Entry__c.Pricing_Template__c,
			Price_Scheme_Entry__c.Transaction_Group_Name__c,
			Price_Scheme_Entry__c.Transaction_Type__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//INHERIT FROM BASE CLASS - START
	/**
	 * @description Select By Id Set
	 * @param idSet
	 * @return List<Price_Scheme_Entry__c>
	 */
	public List<Price_Scheme_Entry__c> selectById(Set<Id> idSet) {
		return (List<Price_Scheme_Entry__c>) selectSObjectsById(idSet);
	}
	//INHERIT FROM BASE CLASS - END

	/**
	 * @description Select By Id.
	 * @param priceSchemeEntryId
	 * @return List<Price_Scheme_Entry__c>
	 */
	public List<Price_Scheme_Entry__c> selectById(Id priceSchemeEntryId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Fee_Type__c')
				.selectField('Fee_Amount_Fixed__c')
				.selectField('Fee_Amount_Percent__c')
				.setCondition('Id =: priceSchemeEntryId')
				.toSOQL()
		);
	}

	/**
	 * @description Select By Price Scheme Id.
	 * @param priceSchemeId
	 * @return List<Price_Scheme_Entry__c>
	 */
	public List<Price_Scheme_Entry__c> selectByPriceSchemeId(Id priceSchemeId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Pricing_Template__c')
				.selectField('Fee_Type__c')
				.selectField('Fee_Amount_Fixed__c')
				.selectField('Fee_Amount_Percent__c')
				.selectField('Is_Negotiable__c')
				.selectField('Transaction_Type__c')
				.selectField('Transaction_Type__r.Name')
				.selectField('Transaction_Type__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c')
				.selectField('Transaction_Type__r.Transaction_Group__r.Name')
				.selectField('Transaction_Type__r.Transaction_Group__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c')
				.setCondition('Price_Scheme__c =: priceSchemeId')
				.toSOQL()
		);
	}

	/**
	 * @description Returns List of Price Scheme Entries where Price Scheme Id and Transaction Type Id is in the Sets
	 * @param priceSchemeIdSet
	 * @param transactionTypeIdSet
	 * @return List<Price_Scheme_Entry__c>
	 */
	public List<Price_Scheme_Entry__c> selectByPriceSchemeIdAndTransactionTypeId(Set<Id> priceSchemeIdSet, Set<Id> transactionTypeIdSet) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('Price_Scheme__c')
				.selectField('Transaction_Type__c')
				.selectField('Fee_Amount_Fixed__c')
				.setCondition('Price_Scheme__c IN : priceSchemeIdSet' + ' AND Transaction_Type__c IN : transactionTypeIdSet')
				.toSOQL()
		);
	}
    /**
    * @description  method to return the Price Scheme Entries by AccountId
    * @author Manish.battu@absa.africa | 06-02-2021
    * @param accountId  - Account Id
    * @return List<Price_Scheme_Entry__c> priceSchemeEntries
    **/
    public List<Price_Scheme_Entry__c> selectByPriceSchemeByAccountId(Id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Price_Scheme__c').
            selectField('Fee_Amount_Percent__c').
            selectField('Fee_Amount_Fixed__c').
            selectField('Fee_Type__c').
            selectField('Pricing_Template__c').
            selectField('Transaction_Group_Name__c').
            setCondition('Price_Scheme__r.Account__c =: accountId').
            toSOQL()
            );
    }
}