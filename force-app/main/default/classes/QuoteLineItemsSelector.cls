/**
* Apex Enterprise Design Patterns
* Selector Layer for Quote Line Item
*
* @author  Rob McLean
* @since   2020-04-23
*/
public class QuoteLineItemsSelector extends fflib_SObjectSelector {    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return QuoteLineItem.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            QuoteLineItem.id,
            QuoteLineItem.LineNumber,
            QuoteLineItem.Product_Name__c,
            QuoteLineItem.Policy_Cover__c,
            QuoteLineItem.Premium__c,
            QuoteLineItem.PriceBookEntryID
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<QuoteLineItem> selectById(Set<Id> idSet) {
        return (List<QuoteLineItem>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START
    /*RM 
    * Return a list of quote line items
    * based on a quote Id
    * 
    * @param quoteId Id
    * @return List<QuoteLineItem>
    */
    public List<QuoteLineItem> selectByQuoteId(Id quoteId) {
        return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Policy_Cover__c').
                selectField('Premium__c').
                selectField('Benefit__c').// Added DD Quote
                selectField('Relationship_Type__c').// Added DD Quote
            	selectField('OpportunityPartyId__c').// Added DD Quote
            	selectField('Quote.Quote_Outcome__c').// Added DD Quote
            	selectField('Quote.Quote_Outcome_Reason__c').// Added DD Quote
            selectField('Quote.Status').// Added DD Quote
                selectField('Product2Id').
                selectField('PricebookEntry.Name').
                selectField('Product2.Name').
                setCondition('QuoteId = :quoteId').
                toSOQL()
        );
    }
    
    /**=================================================================================================================================
* Created By Eduardo Salia 03/11/2020
* Returns a List of QuoteLineItem
* Param 1: quoteIds is our unique collection of Quote Ids
===================================================================================================================================**/
    public List<QuoteLineItem> selectByQuoteIds(Set<Id> quoteIds)
    {
        return Database.query(
                newQueryFactory().
                selectField(QuoteLineItem.Id).
                selectField(QuoteLineItem.Policy_Cover__c).
                selectField(QuoteLineItem.Premium__c).
                selectField(QuoteLineItem.Benefit__c).
                selectField(QuoteLineItem.Relationship_Type__c).
                selectField(QuoteLineItem.Product2Id).
                selectField(QuoteLineItem.Product_Name__c).
                selectField(QuoteLineItem.OpportunityPartyId__c).
                selectField('PricebookEntry.Name').
                selectField('Product2.Name').
                setCondition('QuoteId IN :quoteIds').
                setOrdering('Product_Name__c', fflib_QueryFactory.SortOrder.ASCENDING, True).
                toSOQL()
        );
    }
    
    /**
    * Poulami: 20201010
    *
    * Returns only DD Related Opportunity Line Items associated with PartyType
    *
    * @param QuoteId    The Quote Id
    * @return QuoteLineItems
    */
    public List<QuoteLineItem> selectRelatedLineItemsByPartyType(Id quoteId,String PartyType , Id prodId) {

         return Database.query(
            newQueryFactory().
                selectField('Id').
             	selectField('QuoteId').
                selectField('Policy_Cover__c').
                selectField('Premium__c').
                selectField('Benefit__c').// Added DD Quote
                selectField('Relationship_Type__c').// Added DD Quote
             	selectField('OpportunityPartyId__c').// Added DD Quote
                selectField('Product2Id').
                selectField('PricebookEntry.Name').
                selectField('Product2.Name').
            setCondition('QuoteId =: quoteId AND Relationship_Type__c =: PartyType AND Product2Id =: prodId').
            toSOQL()
        );
    }
    
    /**
    * Poulami: 20201010
    *
    * Returns only DD Related Opportunity Line Items associated with PartyType
    *
    * @param QuoteId    The Quote Id
    * @return QuoteLineItems
    */
    public List<QuoteLineItem> selectRelatedLineItemsByOppPartyType(Id quoteId,String OppPartyType , Id prodId) {

         return Database.query(
            newQueryFactory().
                selectField('Id').
             	selectField('QuoteId').
                selectField('Policy_Cover__c').
                selectField('Premium__c').
                selectField('Benefit__c').// Added DD Quote
                selectField('Relationship_Type__c').// Added DD Quote
             	selectField('OpportunityPartyId__c').// Added DD Quote
                selectField('Product2Id').
                selectField('PricebookEntry.Name').
                selectField('Product2.Name').
            setCondition('QuoteId =: quoteId AND OpportunityPartyId__c =: OppPartyType AND Product2Id =: prodId').
            toSOQL()
        );
    }
    
    /**=================================================================================================================================
* Created By Eduardo Salia 19/10/2020
* Returns a List of QuoteLineItem
* Param 1: opportunityId is our Opportunity Id
* Param 2: productId is our Product Id
===================================================================================================================================**/
    public List<QuoteLineItem> selectByQuoteIdAndFinancialProduct(Id quoteId, Set<String> products)
    {
        return Database.query(
                newQueryFactory().
                selectField(QuoteLineItem.Id).
                selectField(QuoteLineItem.Policy_Cover__c).
                selectField(QuoteLineItem.Premium__c).
                selectField(QuoteLineItem.Benefit__c).
                selectField(QuoteLineItem.Product_Name__c).
                selectField(QuoteLineItem.Relationship_Type__c).
                selectField(QuoteLineItem.Product2Id).
                selectField('PricebookEntry.Name').
                selectField('Product2.Name').
                setCondition('QuoteId =: quoteId AND Benefit__c IN :products').
                setOrdering('Product_Name__c', fflib_QueryFactory.SortOrder.ASCENDING, True).
                toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}