/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for Quote objects
 *
 * @author  Kyle Alexander
 * @since   2018-09-04
 */
public without sharing class QuotesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return Quote.sObjectType;
	}
	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Quote.id,
			Quote.name,
			Quote.Commission_1st_Year__c,
			Quote.Commission_2nd_Year__c,
			Quote.Material_Disclosure_Status__c
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//override the sort method to sort by created date and accountId
	public override String getOrderBy() {
		return 'CreatedDate DESC';
	}
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<Quote>: Return description
	 */
	public List<Quote> selectById(Set<Id> idSet) {
		return (List<Quote>) selectSObjectsById(idSet);
	}

	//CUSTOM SELECTORS - START

	/**
	 * @description Method that gets a list of quotes given certain criteria
	 *@param oppId
	 * @return Quote -  list of Quote
	 */
	public List<Quote> selectByOpportunityId(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('GrandTotal')
				.selectField('Commission_1st_Year__c')
				.selectField('Commission_2nd_Year__c')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Salary_Day__c')
				.selectField('Debit_Order_Debit_Day__c')
				.setCondition('OpportunityId = :oppId AND IsSyncing = true')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets a list of quotes given certain criteria
	 *@param syncedQuoteId
	 * @return Quote -  list of Quote
	 */
	public Quote selectBySyncedQuoteId(Id syncedQuoteId) {
		return Database.query(newQueryFactory(false).selectField('Id').selectField('Description').setCondition('Id = :syncedQuoteId').toSOQL());
	}

	/**Poulami 26/10/2020
	 * @description Method that gets a list of quotes given certain criteria
	 * @param oppId
	 * @param productName
	 * @return Quote -  list of Quote
	 */
	public List<Quote> selectByProductName(Id oppId, String productName) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('GrandTotal')
				.selectField('Material_Disclosure_Status__c')
				.selectField('Description')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Salary_Day__c')
				.selectField('Debit_Order_Debit_Day__c')
				.selectField('Payment_Method__c')
				.selectField('Commencement_Date__c')
				.selectField('Email_and_SMS_sent__c')
				.selectField('Quote_Outcome__c') // Added DD Quote
				.selectField('Quote_Outcome_Reason__c') // Added DD Quote
				.selectField('Status') // Added DD Quote
				.setCondition('OpportunityId = :oppId AND Product_Name__c =: productName')
				.toSOQL()
		);
	}

	/**Poulami 22/12/2020
	 * @description Method that gets a list of quotes given certain criteria
	 * @param oppId
	 * @param disclosureStatus
	 * @return Quote -  list of Quote
	 */
	public List<Quote> selectByMaterialDisclosureStatus(Id oppId, String disclosureStatus) {
		return Database.query(
			newQueryFactory(false)
				.selectField('Id')
				.selectField('GrandTotal')
				.selectField('Material_Disclosure_Status__c')
				.selectField('Description')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Salary_Day__c')
				.selectField('Debit_Order_Debit_Day__c')
				.selectField('Payment_Method__c')
				.selectField('Commencement_Date__c')
				.selectField('Status')
				.selectField('Email_and_SMS_sent__c')
				.setCondition(
					'OpportunityId = :oppId AND ((Material_Disclosure_Status__c !=: disclosureStatus AND Status = \'Accepted\') OR (Status != \'Draft\' AND Status != \'Rejected\' AND Status != \'Denied\' AND Material_Disclosure_Status__c !=: disclosureStatus)) '
				)
				.toSOQL()
		);
	}

	/**
	 * @description selectByProductNames description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param productNames (Set<String>): productNames
	 * @return Return List<Quote>: Return description
	 */
	public List<Quote> selectByProductNames(Id opportunityId, Set<String> productNames) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('GrandTotal')
				.selectField('Description')
				.setCondition('OpportunityId = :opportunityId AND Product_Name__c IN :productNames')
				.toSOQL()
		);
	}

	/**
	 * Created By Pranav  03/11/2020
	 * @description Method that gets a list of quotes given certain criteria
	 *@param oppId
	 * @return Quote -  list of Quote sync and non sync
	 */
	public List<Quote> filterByOpportunityId(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('GrandTotal')
				.selectField('Commission_1st_Year__c')
				.selectField('Commission_2nd_Year__c')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Debit_Day__c')
				.selectField('TotalPrice')
				.selectField('OpportunityId')
				.selectField('Pricebook2Id')
				.selectField('description')
				.selectField('Product_Name__c')
				.selectField('Opportunity.Opportunity_Record_Type_Name__c')
				.setCondition('OpportunityId = :oppId ')
				.toSOQL()
		);
	}

	/**
	 * @description selectQuoteByOpportunityId description
	 *
	 * @param oppId (Id): oppId
	 * @return Return List<Quote>: Return description
	 */
	public List<Quote> selectQuoteByOpportunityId(Id oppId) {
		return Database.query(
			newQueryFactory()
				.selectField('GrandTotal')
				.selectField('Commission_1st_Year__c')
				.selectField('Commission_2nd_Year__c')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Debit_Day__c')
				.selectField('Quote_Outcome__c') // Added DD Quote
				.selectField('Quote_Outcome_Reason__c') // Added DD Quote
				.selectField('Status') // Added DD Quote
				.setCondition('OpportunityId = :oppId')
				.toSOQL()
		);
	}
	/**
	 * @description selectQuoteByOpportunityIdAndProdName description
	 *
	 * @param oppId (Id): oppId
	 * @param productName (string): productName
	 * @return Return List<Quote>: Return description
	 */
	public List<Quote> selectQuoteByOpportunityIdAndProdName(Id oppId, string productName) {
		return Database.query(
			newQueryFactory()
				.selectField('GrandTotal')
				.selectField('Commission_1st_Year__c')
				.selectField('Commission_2nd_Year__c')
				.selectField('Debit_Order_Account_Number__c')
				.selectField('Debit_Order_Account_Type__c')
				.selectField('Debit_Order_Bank_Name__c')
				.selectField('Debit_Order_Branch_Code__c')
				.selectField('Debit_Order_Branch_Name__c')
				.selectField('Debit_Order_Date__c')
				.selectField('Debit_Order_Debit_Day__c')
				.selectField('Quote_Outcome__c') // Added DD Quote
				.selectField('Quote_Outcome_Reason__c') // Added DD Quote
				.selectField('Status') // Added DD Quote
				.setCondition('OpportunityId = :oppId AND Product_Name__c =:productName')
				.toSOQL()
		);
	}

	//CUSTOM SELECTORS - END
}