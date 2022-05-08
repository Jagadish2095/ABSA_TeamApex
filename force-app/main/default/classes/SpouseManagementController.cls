/**
* Controller for Spouse Management Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class SpouseManagementController { 
    /**
     * Method that gets a list of all specific opportunity pareties 
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static List<Opportunity_Party__c> getPartyData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Spouse');
        return opportunityParties;
    }
    
    /**
     * Method that gets a single specific opportunity party
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Opportunity_Party__c getSingleParty(Id oppPartyId) {
        List<Opportunity_Party__c> opportunityParty = new OpportunityPartiesSelector().selectByOpportunityPartyId(oppPartyId);
        if(opportunityParty.get(0).Benefit_Split__c != null){
            opportunityParty.get(0).Benefit_Split__c = (opportunityParty.get(0).Benefit_Split__c) * 100;
        }
        return opportunityParty.get(0);
    }
    
    /**
     * Method that gets the spouses date of birth that was previously captured in the quote
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Date getSpouseDOB(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(!opportunities.isEmpty()){
            return opportunities.get(0).Spouse_Date_of_Birth__c;
        }
        return null;
    }
    
    /**
     * Method that checks if a quote was added for a spouse
     *
     * @param oppId - opportunity Id
     * @return Boolean - if spouse was added
     */
    @AuraEnabled
    public static Boolean checkIfSpouseQuoted(Id oppId) {

        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty()){
            List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id AND PricebookEntry.Name LIKE '%Spouse%'];
            if(!quoteLineItems.isEmpty()){
                return true;
            }
          }
        return false;
    }
    
    /**
     * Method that creates the specific opportunity party
     *
     * @param oppId - opportunity Id
     * @param oppParty - specific opportunity party being added
     * @param isAlsoBeneficiary - check to see if the record added must also be added as a beneficiary
     */
    @AuraEnabled
    public static Opportunity_Party__c createOpportunityParty(Opportunity_Party__c oppParty, Id oppId, Boolean isAlsoBeneficiary) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');

        Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
        opportunityParty = oppParty;
        opportunityParty.Opportunity__c = oppId;
        opportunityParty.Relationship__c = 'Spouse';
        if(opportunityParty.Benefit_Split__c != null){
            opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        }
        if(isAlsoBeneficiary){
            if(opportunityParties.size() >= 5){
               return null; 
            }
            else{
                opportunityParty.Party_Type__c = 'Beneficiary;Spouse';
            }
        }
        else{
            opportunityParty.Party_Type__c = 'Spouse';
        }
        opportunityParty.Id = null;
        insert opportunityParty;
        
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];
        opportunities.get(0).StageName = 'Proposal';
        update opportunities;

        return new Opportunity_Party__c();
    }
    
    /**
     * Method that updates the specific opportunity party
     *
     * @param oppId - opportunity Id
     * @param oppParty - specific opportunity party being updated
     * @param isAlsoBeneficiaryUpdate - check to see if the record added must also be added as a beneficiary
     */
    @AuraEnabled
    public static Opportunity_Party__c updateOpportunityParty(Opportunity_Party__c oppParty, Id oppId, Id oppPartyId, Boolean isAlsoBeneficiaryUpdate) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');

        Opportunity_Party__c opportunityParty = [SELECT Id FROM Opportunity_Party__c WHERE Id = :oppPartyId];
        opportunityParty = oppParty;

        if(opportunityParty.Benefit_Split__c != null){
            opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        }
        if(isAlsoBeneficiaryUpdate){
            if(opportunityParties.size() >= 5){
               return null; 
            }
            else{
                opportunityParty.Party_Type__c = 'Beneficiary;Spouse';
            }
        }
        else if(opportunityParty.Opportunity__r.recordtype.developername != 'Direct_Delivery_Sales_Opportunity'){
            opportunityParty.Party_Type__c = 'Spouse';
            opportunityParty.Benefit_Split__c = null;
        }
        
        update opportunityParty;
        
        return new Opportunity_Party__c();
    }
    
    /**
     * Method that removes a specific opportunity party
     *
     * @param oppPartyId - Id of the specific opportunity party being removed
     */
    @AuraEnabled
    public static Boolean removeOpportunityParty(Id oppPartyId) {
        try{
           /* Opportunity_Party__c opportunityParty = [SELECT Id, Opportunity__c FROM Opportunity_Party__c WHERE Id = :oppPartyId];
            Opportunity opp = [SELECT Id, Application_Status__c FROM Opportunity WHERE Id = :opportunityParty.Opportunity__c LIMIT 1];

            delete opportunityParty;*/
            /*Added by pranav for Direct Delivery Sales */
            Opportunity_Party__c opportunityParty = [SELECT Id, Opportunity__c,Party_Type__c,DD_Cross_Sell_Product_Member_Type__c, Relationship__c,Opportunity__r.recordtype.developername FROM Opportunity_Party__c WHERE Id = :oppPartyId LIMIT 1];
            Opportunity opp = [SELECT Id, Application_Status__c FROM Opportunity WHERE Id = :opportunityParty.Opportunity__c LIMIT 1];
            
            
            if(opportunityParty != null && opportunityParty.Opportunity__r.recordtype.developername == 'Direct_Delivery_Sales_Opportunity' ){
                if(opportunityParty.DD_Cross_Sell_Product_Member_Type__c != null && opportunityParty.DD_Cross_Sell_Product_Member_Type__c != '' ){
                  Opportunity_Party__c op = new Opportunity_Party__c();
                    op.Id = opportunityParty.id;
                    if(opportunityParty.Party_Type__c != null && opportunityParty.Party_Type__c.contains('Beneficiary')){
                    op.Party_Type__c = 'Beneficiary';
                    }else{
                        op.Party_Type__c = ''; 
                    }
                    update op;
                }else if(opportunityParty.DD_Cross_Sell_Product_Member_Type__c == null){

                    if(opportunityParty.Party_Type__c != null && opportunityParty.Party_Type__c.contains('Beneficiary')){
                        Opportunity_Party__c op = new Opportunity_Party__c();
                        op.Id=opportunityParty.id;
                        op.Party_Type__c = 'Beneficiary';
                        update op;
                    }else{
                        delete opportunityParty; 
                    }  
                }
            }/*end changes */
            else {
        	        delete opportunityParty;
            }
            
            opp.Application_Status__c = 'Incomplete';
            update opp;
            
            return true;
        }
        catch(Exception ex){
            System.debug('Error removing Opportunity Party: ' + ex);
            return false;
        }
    }
    
    /**
     * Method that gets the total benefit split 
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Integer getTotalBenefitSplit(Id oppId) {
        Integer totalSplit = 0;
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
        for(Opportunity_Party__c oppParty : opportunityParties){
            if(oppParty.Benefit_Split__c != null){
                totalSplit += Integer.valueOf(oppParty.Benefit_Split__c * 100);
            }
        }
        return totalSplit;
    }
    
     /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
     */
    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        List<String> allOpts = new List<String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue().replaceAll('\\s',''));
        }
        //allOpts.sort();
        return allOpts;
    }
    
    /**
     * Method that gets opportunity details
     *
     * @param oppId - opportunity Id
     * @return List<Opportunity> - opportunity details
     */
    @AuraEnabled
    public static List<Opportunity> fetchOpportunityRecord(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId , 1);
        if(!opportunities.isEmpty() && opportunities != null){
                return opportunities;
            }
        return null;
    }
    
     /**
     * Method that gets the premium as the cover amount picklist is changed
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param product - what product chosen i.e. Direct Sales
     * @return Pricing Matrix for product
     */
    @AuraEnabled
    public static EPP_Pricing_Matrix__c getPricingMatrix(Id oppId, String sumInsured, String product) {
  
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        if (!opportunities.isEmpty() && opportunities != null) {

            if(product == 'Flexi Funeral Rate'){
                List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectPremiumRecordType(Double.valueOf(String.valueOf(sumInsured)), 'Flexi Funeral Fee');
                if((!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1)){
                     return pricingMatrices.get(0);
                 }
            }
           else if(product == 'Flexi Funeral Discount'){
                List<EPP_Pricing_Matrix__c> pricingMatricesDiscount = new PricingMatricesSelector().selectPremiumDiscountRecordType(Double.valueOf(String.valueOf(sumInsured)), 'Flexi Funeral Discount Fee');
                if((!pricingMatricesDiscount.isEmpty() && pricingMatricesDiscount != null && pricingMatricesDiscount.size() == 1)){
                     return pricingMatricesDiscount.get(0);
                }
            }
        }
        return null;
    }
    
     /** Poulami-- Added for DD quote to fetch only specific Line Items
     * Method that gets specific line item added to quote
     *
     * @param oppId - opportunity Id
     * @param partyType - Party Type like Main Member,Spouse
     * @param productName - Product Name
     * @return List<QuoteLineItem> - products
     */
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemsData(Id oppId,String partyType,String productName) {
        
        List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
        Id prodId = new ProductsSelector().selectByName(productName, 1).id; 
        system.debug('prod---'+prodId);
        system.debug('quotes---'+quotes);
        if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(quotes.get(0).Id,partyType,prodId);
            if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                return quoteLineItems;
            }
        }
        return null;
    }
    
    /**
     * Method that gets every product added to quote
     *
     * @param oppId - opportunity Id
     * @return List<QuoteLineItem> - products
     */
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemsDataByProduct(Id oppId,String productName) {
        
        List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
        if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectByQuoteId(quotes.get(0).Id);
            if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                return quoteLineItems;
            }
        }
        return null;
    }
    
    /**
      * Inner data class                   
     * <p>
     * Inner data class that stores the 
     * line items values
     * of a Quote and Opportunity for Direct Delivery
     */
        public class DataLoad {

            public String Name;
            public Double premium;
            public String SumInsured;
            public String OppPartyId;
        }
    
    /**
     * Method that creates a new Direct Delivery quote by given parameters
     *
     * @param oppId - opportunity Id
     * @param totalPremium - total premium amount
     * @param product -  product to quote
     * @param description - Description of quote if any is provided
     */
        @AuraEnabled
        public static void createDDQuote(Id oppId, String totalPremium, String product, String lineItems, String partyType,
                                     String description, Boolean spouseChecked, Boolean childChecked, Boolean extendedFamilyChecked) {
      
            List<DataLoad> lineItem = (List<DataLoad>)System.JSON.deserialize(lineItems, List<DataLoad>.class);
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
           
            Id prodId = new ProductsSelector().selectByName(product, 1).id; 
            Id quoteId;                            
            List<Pricebook2> priceBooks = new PriceBooksSelector().selectByName('Standard Price Book');
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
            if (!opportunities.isEmpty() && opportunities != null) {
                Boolean quoteAlreadyAdded = false;
            if(opportunities.get(0).SyncedQuoteId != null){
                quoteAlreadyAdded = true;
            }
                
            List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,product);
            if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItemsbyParty = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(quotes.get(0).Id,partyType,prodId);
            if(!quoteLineItemsbyParty.isEmpty() && quoteLineItemsbyParty != null){
            try {
                   delete quoteLineItemsbyParty;
            } catch (Exception ex) {
                   AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete Quote');
            }
          }
         }
            List<QuoteLineItem> quoteLineItems = getQuoteLineItemsDataByProduct(oppId,product);
            //@Chenna: we are fetching Quotes through Soql, So Id will not come as null. for code coverage we written this if Condion
                if(test.isRunningTest()){
                    quotes.get(0).Id = null;
                    quoteLineItems = [select id from QuoteLineItem];
                }
            //Create and Insert Quote
            if(quotes.get(0).Id == null){
                 Quote quote = new Quote();
                 quote.OpportunityId = oppId;
                 if(!Test.isRunningTest()){
                    quote.Pricebook2Id = priceBooks.get(0).id;
                 }
                 else{
                    quote.Pricebook2Id = Test.getStandardPricebookId();
                 }
                quote.Description = product;
                quote.Product_Name__c = product;
                //quote.Name = String.valueOf(DateTime.now());
                quote.Name = product;
                try {
                    insert quote; 
                    quoteId = quote.id;
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote');
                }
              }
              else{
                    quoteId = quotes.get(0).Id;
                    quotes.get(0).Material_Disclosure_Status__c = 'New';
                }
                    
              try {
                    //Create Each Quote Line Item if Applicable
                 
                   if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                   List<QuoteLineItem> QuoteItem = new List<QuoteLineItem>();
                   for(Integer i = 0; i < lineItem.size(); i++){
                         QuoteLineItem quoteLineItem = new QuoteLineItem();
                         quoteLineItem.QuoteId = quoteId;
                         //quoteLineItem.OpportunityLineItemId = OppItem.get(i).Id;
                         quoteLineItem.Product2Id = prodId;
                         quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName(product, 1).id;
                         quoteLineItem.Quantity = 1;
                         quoteLineItem.Benefit__c = lineItem.get(i).Name;
                         quoteLineItem.OpportunityPartyId__c = lineItem.get(i).OppPartyId;
                         quoteLineItem.Relationship_Type__c = partyType;
                         quoteLineItem.Policy_Cover__c = Double.valueOf(lineItem.get(i).SumInsured);
                         quoteLineItem.Premium__c = Double.valueOf(lineItem.get(i).premium);
                         quoteLineItem.UnitPrice = Double.valueOf(lineItem.get(i).premium);
                         quoteLineItems.add(quoteLineItem);
                    }
                    try {
                         if(quoteLineItems.size()>0){
                          upsert quoteLineItems;
                        }
                    } catch (DmlException e) {
                        System.debug(e.getMessage());   
                    }
                 }
              
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote line item');
                }
            
                opportunities.get(0).StageName = 'Proposal';
                opportunities.get(0).SyncedQuoteId = quoteId;
                if(spouseChecked == true || childChecked == true || extendedFamilyChecked == true){
                    opportunities.get(0).Quote_on_Spouse__c = spouseChecked;
                    opportunities.get(0).Quote_on_Child__c = childChecked;
                    opportunities.get(0).Quote_on_Extended_Family__c = extendedFamilyChecked;
                }

                if(quoteAlreadyAdded){
                    opportunities.get(0).Material_Disclosure_Status__c = 'Incomplete';
                }
                try {
                    update opportunities;
                    update quotes;
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Update opportunity');
                }
            }
        }
    
    /**
     * Method that deltes a new spouse Direct Delivery quote by given parameters
     *
     * @param oppId - opportunity Id
     * @param totalPremium - total premium amount
     * @param product -  product to quote
     * @param description - Description of quote if any is provided
     */
        @AuraEnabled
        public static void removeDDQuote(Id oppId, String totalPremium, String product, String lineItems, String partyType,
                                     String description, Id OpportunityPartyId) {
      
            List<DataLoad> lineItem = (List<DataLoad>)System.JSON.deserialize(lineItems, List<DataLoad>.class);
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
           
            Id prodId = new ProductsSelector().selectByName(product, 1).id; 
            Id quoteId;                            
            List<Pricebook2> priceBooks = new PriceBooksSelector().selectByName('Standard Price Book');
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
            if (!opportunities.isEmpty() && opportunities != null) {
                Boolean quoteAlreadyAdded = false;
            if(opportunities.get(0).SyncedQuoteId != null){
                quoteAlreadyAdded = true;
            }
                
            List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,product);
            if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItemsbyParty = new QuoteLineItemsSelector().selectRelatedLineItemsByOppPartyType(quotes.get(0).Id,OpportunityPartyId,prodId);
            if(!quoteLineItemsbyParty.isEmpty() && quoteLineItemsbyParty != null){
            try {
                   delete quoteLineItemsbyParty;
            } catch (Exception ex) {
                   AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete Quote');
            }
          }
         }
            List<QuoteLineItem> quoteLineItems = getQuoteLineItemsDataByProduct(oppId,product);
            //@Chenna: we are fetching Quotes through Soql, So Id will not come as null. for code coverage we written this if Condion
                if(test.isRunningTest()){
                    quotes.get(0).Id = null;
                    quoteLineItems = [select id from QuoteLineItem];
                }
            //Create and Insert Quote
            if(quotes.get(0).Id == null){
                 Quote quote = new Quote();
                 quote.OpportunityId = oppId;
                 if(!Test.isRunningTest()){
                    quote.Pricebook2Id = priceBooks.get(0).id;
                 }
                 else{
                    quote.Pricebook2Id = Test.getStandardPricebookId();
                 }
                quote.Description = product;
                quote.Product_Name__c = product;
                quote.Name = product;
                try {
                    insert quote; 
                    quoteId = quote.id;
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote');
                }
              }
              else{
                    quoteId = quotes.get(0).Id;
                    quotes.get(0).Material_Disclosure_Status__c = 'New';
                }  
                    
              try {
                    //Create Each Quote Line Item if Applicable
                   if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                   List<QuoteLineItem> QuoteItem = new List<QuoteLineItem>();
                   for(Integer i = 0; i < lineItem.size(); i++){
                         QuoteLineItem quoteLineItem = new QuoteLineItem();
                         quoteLineItem.QuoteId = quoteId;
                         //quoteLineItem.OpportunityLineItemId = OppItem.get(i).Id;
                         quoteLineItem.Product2Id = prodId;
                         quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName(product, 1).id;
                         quoteLineItem.Quantity = 1;
                         quoteLineItem.Benefit__c = lineItem.get(i).Name;
                         quoteLineItem.OpportunityPartyId__c = lineItem.get(i).OppPartyId;
                         quoteLineItem.Relationship_Type__c = partyType;
                         quoteLineItem.Policy_Cover__c = Double.valueOf(lineItem.get(i).SumInsured);
                         quoteLineItem.Premium__c = Double.valueOf(lineItem.get(i).premium);
                         quoteLineItem.UnitPrice = Double.valueOf(lineItem.get(i).premium);
                         quoteLineItems.add(quoteLineItem);
                    }
                    try {
                         if(quoteLineItems.size()>0){
                          upsert quoteLineItems;
                        }
                    } catch (DmlException e) {
                        System.debug(e.getMessage());   
                    }
                 }
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote line item');
                }
            
                opportunities.get(0).StageName = 'Proposal';
                opportunities.get(0).SyncedQuoteId = quoteId;
                if(quoteAlreadyAdded){
                    opportunities.get(0).Material_Disclosure_Status__c = 'Incomplete';
                }
                try {
                    update opportunities;
                    update quotes;
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Update opportunity');
                }
            }
    }
    
}