public class QuotePDFPageController {

    public Opportunity opportunity {get;set;}
    public Account account {get;set;} 
    public User advisor {get;set;}
    public Quote quote {get;set;}
    public List<QuoteLineItem> quoteLineItems {get;set;}
    public QuoteItemPurpose__mdt mdt {get;set;}
    public List<QuoteLineItem> enrichedQuoteLineItems {get;set;}
    public List<QuoteLineItem> enrichedSpouseQuoteLineItems {get;set;}
    public Boolean spouseIncluded  {get;set;}
    public Boolean funeralIncluded  {get;set;}
    
    public QuotePDFPageController() {
      
        funeralIncluded = false;
          
        Id oppId = apexpages.currentpage().getparameters().get('id');
    
        opportunity = [SELECT Id, Name, AccountId, Adviser_BRID_Number__c, OwnerId, Commencement_Date__c, Debit_Order_Date__c,
                       SyncedQuoteId FROM Opportunity WHERE Id = :oppId LIMIT 1];
        account = [SELECT Id, Name, PersonTitle, FirstName, LastName, PersonBirthdate FROM Account WHERE Id = :opportunity.AccountId LIMIT 1];
        advisor = [SELECT Id, Name FROM User WHERE Id = :opportunity.OwnerId LIMIT 1];
        quote = [SELECT Id,Subtotal FROM Quote where Id =: opportunity.SyncedQuoteId LIMIT 1];
        quoteLineItems = [SELECT Id, Product2.Name, Policy_Cover__c, Premium__c , Motivation__c FROM QuoteLineItem WHERE QuoteId = :quote.Id];
        mdt = [SELECT Bridging_finance__c, Executor_fee__c, Funeral_cover__c FROM QuoteItemPurpose__mdt LIMIT 1];
        
        enrichLists();
        
    }
    
    
    private void enrichLists() {
        enrichedQuoteLineItems = new List<QuoteLineItem>();
        enrichedSpouseQuoteLineItems = new List<QuoteLineItem>();
        for (QuoteLineItem qLine : quoteLineItems) {
            if (qLine.Product2.Name.equals('EPP Funeral Benefit')) {
                funeralIncluded = true;
                qLine.Product2.Name = 'EPP Family Funeral Benefit';
                qLine.Motivation__c = mdt.Funeral_cover__c;
            } else if (qLine.Product2.Name.contains('Estate')) {
                qLine.Motivation__c = mdt.Bridging_finance__c;
            } else if (qLine.Product2.Name.contains('Executor')) {
                qLine.Motivation__c = mdt.Executor_fee__c;
            }
            if (qLine.Product2.Name.contains('Spouse')) {
                if(!qLine.Product2.Name.equals('EPP Funeral Benefit Spouse')){
                    enrichedSpouseQuoteLineItems.add(qLine);
                }
            } else {
                if (!qLine.Product2.Name.contains('Policy Fee')) {
                    enrichedQuoteLineItems.add(qLIne);
                }
            }
            if (enrichedSpouseQuoteLineItems.size() > 0) {
                spouseIncluded = true;
            } else {
                spouseIncluded = false;
            }
        }
    }
}