/**
* Controller for Product Summary Lightning Component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class ProductSummaryController {
    
    /**
     * Method that gets the total amount for the quote
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static String getTotalQuoteData(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        
        if(!quotes.isEmpty()){
            return String.valueOf(quotes.get(0).GrandTotal.setScale(0));
        }
        
        return null;
    }
    
    /**
     * Method that gets a list of all quote line items
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemsData(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty()){
        	List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id];
            if(!quoteLineItems.isEmpty()){
                return quoteLineItems;
            }
        }
        
        return null;
    }
    
    /**
     * Method that gets a list of all beneficiaries added to an opportunity
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static List<Opportunity_Party__c> getBeneficiaryData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
        
        if(!opportunityParties.isEmpty()){
            return opportunityParties;
        }
        
        return null;
    }
    
    /**
     * Method that gets a list of all dependants added to an opportunity
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static List<Opportunity_Party__c> getDependantData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Dependant');
        
        if(!opportunityParties.isEmpty()){
            return opportunityParties;
        }
        
        return null;
    }
    
    /**
     * Method that gets the accounts details added to an opportunity
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Account getMainLifeData(Id oppId) {
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        Account account = new AccountsSelector().selectByOpportunityId(opportunity.AccountId, 1);       
        
        return account;
    }
    
    /**
     * Method that gets the the spouse details that was added to an opportunity
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Opportunity_Party__c getSpouseData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Spouse');
   
        if(!opportunityParties.isEmpty()){
   
            return opportunityParties.get(0);
        }
        
        return null;
    }
}