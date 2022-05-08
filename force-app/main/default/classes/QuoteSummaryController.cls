/**=================================================================================================================================
* Created By: Eduardo Salia
* Created Date: 14/10/2020
* Controller for Quote Summary Aura Component
===================================================================================================================================**/
public class QuoteSummaryController
{
    public static Map<String, List<QuoteLineItem>> quoteLineItemMap = new Map<String, List<QuoteLineItem>>();
    public static Map<String, List<QuoteLineItem>> quoteLineItemDependantMap = new Map<String, List<QuoteLineItem>>();
    public static Map<String, List<Opportunity_Party__c>> opportunityPartyMap = new Map<String, List<Opportunity_Party__c>>();
    public static List<DTO_QuoteSummaryResponse> response = new List<DTO_QuoteSummaryResponse>();
    
    /**=================================================================================================================================
* Returns an array of DTO (Data Transfer Object) type DTO_QuoteSummaryResponse
* Param 1: opportunityId is our Opportunity Id from the Autolaunched Flow
* Param 2: productId is our Product Id from the Autolaunched Flow
===================================================================================================================================**/
    @AuraEnabled
    public static List<DTO_QuoteSummaryResponse> getOpportunityDetails(Id opportunityId, String productName)
    {
        //Get Opportunity By Id
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(
            opportunityId,
            StringConstants.MAX_ROW_COUNT);
        
        //Proceed if Opportunity found
        if(!Sys_Utilities_General.isListBlank(opportunities))
        {
            Set<String> quoteParams = new Set<String>();
            
            //Determine which products to filter by
            //Set will be used to filter Quotes
            if(String.isNotBlank(productName))
                quoteParams.add(productName);
            else
            {
                quoteParams.add(StringConstants.PRODUCT_CROSS_SELL);
                quoteParams.add(StringConstants.PRODUCT_ROAD_COVER);
                quoteParams.add(StringConstants.PRODUCT_HEALTH_ASSISTANCE);
                quoteParams.add(StringConstants.PRODUCT_LAW_FOR_U);
                quoteParams.add(StringConstants.PRODUCT_ULTIMATE_PROTECTOR);
                quoteParams.add(StringConstants.PRODUCT_AVAF_CREDIT_LIFE);
                quoteParams.add(StringConstants.PRODUCT_EXTENDED_COVER);
                quoteParams.add(StringConstants.PRODUCT_CARD_LIFE);
                quoteParams.add(StringConstants.PRODUCT_FLEXI_FUNERAL);
            }
            
            //Get Quotes By Opportunity Id and Product Filters
            List<Quote> quotes = new QuotesSelector().selectByProductNames(
                opportunityId,
                quoteParams);
            
            //Proceed if Quotes found
            if(!Sys_Utilities_General.isListBlank(quotes))
            {
                Set<Id> quoteIds = new Set<Id>();
            	if(productName != StringConstants.PRODUCT_FLEXI_FUNERAL)
                {
                    for(Quote quote : quotes)
                        quoteIds.add(quote.Id);
                }
                
                //Get all Quote Line Items for current Quotes
                List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
                
                if(productName == StringConstants.PRODUCT_FLEXI_FUNERAL)
                    quoteLineItems = new QuoteLineItemsSelector().selectByQuoteId(quotes[0].Id);
                else
                    quoteLineItems = new QuoteLineItemsSelector().selectByQuoteIds(quoteIds);
                
                //Proceed if Quote Line Items found
                if(!Sys_Utilities_General.isListBlank(quoteLineItems))
                {
                    //Get all Opportunity Parties for current Opportunity
                    List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityId(opportunities[0].Id);
                    
                    //Proceed if Opportunity Parties found
                    if(!Sys_Utilities_General.isListBlank(opportunityParties))
                    {
                        //Build a Map for Opportunity Parties
                        for(Opportunity_Party__c opportunityParty : opportunityParties)
                            generateOpportunityPartiesMap(opportunityParty);
                    }
                    
                    //Build a Map for Quote Line Items
                    for(QuoteLineItem quoteLineItem : quoteLineItems)
                        generateQuoteLineItemMap(quoteLineItem);
                    
                    //Build our DTO Response
                    for(String partyType : quoteLineItemMap.KeySet())
                        generateResponse(opportunityParties, partyType, productName, opportunities[0]);
                    
                    if(!response.isEmpty())
                        return response;
                }
            }
        }
        return null;
    }
    
    /**=================================================================================================================================
* Build a Map with
* String Key based on Quote Line Item Party Type
* Values List<QuoteLineItem> for each Party Type
* 
* Param 1: quoteLineItem is our Quote Line Item Record
===================================================================================================================================**/
    private static void generateQuoteLineItemMap(QuoteLineItem quoteLineItem)
    {
        if(!quoteLineItemMap.containsKey(quoteLineItem.Relationship_Type__c))
            quoteLineItemMap.put(quoteLineItem.Relationship_Type__c, new List<QuoteLineItem>{quoteLineItem});
        else
        {
            List<QuoteLineItem> opportunityQuoteLineItems = quoteLineItemMap.get(quoteLineItem.Relationship_Type__c);
            opportunityQuoteLineItems.add(quoteLineItem);
            quoteLineItemMap.put(quoteLineItem.Relationship_Type__c, opportunityQuoteLineItems);
        }
    }
    
    /**=================================================================================================================================
* Builds Map of String Key and Quote Line Items values
===================================================================================================================================**/
    private static void mapQuotelineItems(List<QuoteLineItem> quoteLineItems, Opportunity_Party__c oppParty)
    {
        for(QuoteLineItem quoteLineItem : quoteLineItems)
        {
            if(quoteLineItem.OpportunityPartyId__c == oppParty.Id)
            {
                
                String partyName;
                
                if(String.isBlank(oppParty.First_Name__c)
                   && String.isNotBlank(oppParty.Last_Name__c))
                    partyName = oppParty.Last_Name__c;
                else if(String.isBlank(oppParty.Last_Name__c)
                        && String.isNotBlank(oppParty.First_Name__c))
                    partyName = oppParty.First_Name__c;
                else if(String.isNotBlank(oppParty.First_Name__c)
                        && String.isNotBlank(oppParty.Last_Name__c))
                {
                    partyName = oppParty.First_Name__c
                        + StringConstants.BLANK_SPACE
                        + oppParty.Last_Name__c;
                }
                
                if(!quoteLineItemDependantMap.containsKey(partyName))
                    quoteLineItemDependantMap.put(partyName, new List<QuoteLineItem>{quoteLineItem});
                else
                {
                    List<QuoteLineItem> oppQuoteLineItems = quoteLineItemDependantMap.get(partyName);
                    oppQuoteLineItems.add(quoteLineItem);
                    quoteLineItemDependantMap.put(partyName, oppQuoteLineItems);
                }
            }
        }
    }
    
    /**=================================================================================================================================
* Build a Map with
* String Key based on Opportunity Party - Relationship__c field
* Values List<Opportunity_Party__c> for each Party Type
* 
* Param 1: Opportunity_Party__c is our Opportunity Party Record
===================================================================================================================================**/
    private static void generateOpportunityPartiesMap(Opportunity_Party__c opportunityParty)
    {
        if(!opportunityPartyMap.containsKey(opportunityParty.Relationship__c))
            opportunityPartyMap.put(opportunityParty.Relationship__c, new List<Opportunity_Party__c>{opportunityParty});
        else
        {
            List<Opportunity_Party__c> opportunityParties = opportunityPartyMap.get(opportunityParty.Relationship__c);
            opportunityParties.add(opportunityParty);
            opportunityPartyMap.put(opportunityParty.Relationship__c, opportunityParties);
        }
    }
    
    /**=================================================================================================================================
* Builds our response object DTO_QuoteSummaryResponse
* 
* Param 1: partyType is our Quote Line Item Party Type e.g Child, Spouse, Parent
* Param 2: productName is our Financial Product e.g Flexi Funeral
* Param 3: opportunity is our Opportunity record
===================================================================================================================================**/
    private static void generateResponse(List<Opportunity_Party__c> allOpportunityParties, String partyType, String productName, Opportunity opportunity)
    {
        //Get all Quote Line Items for current Party Type
        List<QuoteLineItem> partyQuoteLineItems = quoteLineItemMap.get(partyType);
        
        //Proceed if Quote Line Items found
        if(!Sys_Utilities_General.isListBlank(partyQuoteLineItems))
        {
            if(partyType == StringConstants.RELATIONSHIP_TYPE_MAIN_MEMBER
               || partyType == StringConstants.RELATIONSHIP_TYPE_SPOUSE)
                setResponseByPartyType(partyQuoteLineItems, partyType, productName, opportunity);
            else if(String.isNotBlank(partyType))
            {
                //Reset the Map
                quoteLineItemDependantMap = new Map<String, List<QuoteLineItem>>();
                
                //Get Opportunity Parties By Relationship Type = Dependant
                //if Party Type is Child it maps to Dependant Relationship on Opportunity Party
                List<Opportunity_Party__c> opportunityParties = new List<Opportunity_Party__c>();
                
                if(partyType == StringConstants.RELATIONSHIP_TYPE_CHILD)
                    opportunityParties = opportunityPartyMap.get(partyType);
                else
                    opportunityParties.addAll(allOpportunityParties);
                
                //Proceed if Opportunity Parties found
                if(!Sys_Utilities_General.isListBlank(opportunityParties))
                {
                    for(Opportunity_Party__c oppParty : opportunityParties)
                        mapQuotelineItems(partyQuoteLineItems, oppParty);
                    
                    if(!quoteLineItemDependantMap.isEmpty())
                    {
                        for(String oppPartyName : quoteLineItemDependantMap.KeySet())
                            setResponseByDependantPartyType(partyQuoteLineItems, partyType, productName, oppPartyName, opportunity);
                    }
                }
            }
        }
    }
    
    /**=================================================================================================================================
* Builds our response object DTO_QuoteSummaryResponse
* 
* Param 1: partyType is our Quote Line Item Party Type e.g Child, Main Member, Spouse
* Param 2: productName is our Financial Product e.g Flexi Funeral
* Param 3: opportunity is our Opportunity record
===================================================================================================================================**/
    private static void setResponseByDependantPartyType(List<QuoteLineItem> quoteLineItems, String partyType, String productName, String oppPartyName, Opportunity opportunity)
    {
        Map<String, List<QuoteLineItem>> quoteLineItemMapForProductSummary = new Map<String, List<QuoteLineItem>>();
        DTO_QuoteSummaryResponse quoteResponse = new DTO_QuoteSummaryResponse();
        Decimal quoteSumAssured = 0.0;
        Decimal quotePremium = 0.0;
        
        List<QuoteLineItem> oppQuoteLineItems = quoteLineItemDependantMap.get(oppPartyName);
        
        for(QuoteLineItem quoteLineItem : oppQuoteLineItems)
        {
            if(String.isBlank(productName))
            {
                if(!quoteLineItemMapForProductSummary.containsKey(quoteLineItem.Product_Name__c))
                    quoteLineItemMapForProductSummary.put(quoteLineItem.Product_Name__c, new List<QuoteLineItem>{quoteLineItem});
                else
                {
                    List<QuoteLineItem> opportunityQuoteLineItems = quoteLineItemMapForProductSummary.get(quoteLineItem.Product_Name__c);
                    opportunityQuoteLineItems.add(quoteLineItem);
                    quoteLineItemMapForProductSummary.put(quoteLineItem.Product_Name__c, opportunityQuoteLineItems);
                }
            }
            else
            {
                quoteSumAssured += quoteLineItem.Policy_Cover__c != null ? quoteLineItem.Policy_Cover__c : 0;
                quotePremium += quoteLineItem.Premium__c != null ? quoteLineItem.Premium__c : 0;
            }
        }
        
        if(quoteLineItemMapForProductSummary != null
          && !quoteLineItemMapForProductSummary.isEmpty())
        {
            for(String product : quoteLineItemMapForProductSummary.KeySet())
            {
                List<QuoteLineItem> productQuoteLineItems = quoteLineItemMapForProductSummary.get(product);
                
                DTO_QuoteSummaryResponse productQuoteResponse = new DTO_QuoteSummaryResponse();
                Decimal productQuoteSumAssured = 0.0;
                Decimal productQuotePremium = 0.0;
                
                for(QuoteLineItem quoteLineItem : productQuoteLineItems)
                {
                    productQuoteSumAssured += quoteLineItem.Policy_Cover__c != null ? quoteLineItem.Policy_Cover__c : 0;
                    productQuotePremium += quoteLineItem.Premium__c != null ? quoteLineItem.Premium__c : 0; 
                }
                
                productQuoteResponse.productName = product;
                productQuoteResponse.isMainMember = partyType == StringConstants.PARTY_TYPE_MAIN_MEMBER ? True : False;
                productQuoteResponse.quoteLineItems = productQuoteLineItems;
                productQuoteResponse.opportunity = opportunity;
                productQuoteResponse.partyType = partyType;
            	productQuoteResponse.partyName = oppPartyName;
                productQuoteResponse.totalPremium = productQuotePremium;
                productQuoteResponse.sumAssured = productQuoteSumAssured;
                response.add(productQuoteResponse); 
            }
        }
        else
        {
            quoteResponse.isMainMember = partyType == StringConstants.PARTY_TYPE_MAIN_MEMBER ? True : False;
            quoteResponse.productName = productName == StringConstants.PRODUCT_FLEXI_FUNERAL ? StringConstants.PRODUCT_FLEXI_FUNERAL : StringConstants.PRODUCT_CROSS_SELL;
            quoteResponse.quoteLineItems = oppQuoteLineItems;
            quoteResponse.opportunity = opportunity;
            quoteResponse.partyName = oppPartyName;
            quoteResponse.partyType = partyType;
            quoteResponse.totalPremium = quotePremium;
            quoteResponse.sumAssured = quoteSumAssured;
            response.add(quoteResponse);
        }
    }
    
    /**=================================================================================================================================
* Builds our response object DTO_QuoteSummaryResponse if Party Type is not Child e.g Main Member, Spouse
* 
* Param 1: List<QuoteLineItem> quoteLineItems for this Party Type
* Param 2: partyType is our Quote Line Item Party Type e.g Child, Main Member, Spouse
* Param 3: productName is our Financial Product e.g Flexi Funeral
* Param 4: opportunity is our Opportunity record 
===================================================================================================================================**/
    private static void setResponseByPartyType(List<QuoteLineItem> quoteLineItems, String partyType, String productName, Opportunity opportunity)
    {
        Map<String, List<QuoteLineItem>> quoteLineItemMapForProductSummary = new Map<String, List<QuoteLineItem>>();
        DTO_QuoteSummaryResponse quoteResponse = new DTO_QuoteSummaryResponse();
        Decimal quoteSumAssured = 0.0;
        Decimal quotePremium = 0.0;
        
        List<Opportunity_Party__c> opportunityParties = opportunityPartyMap.get(partyType);
        
        for(QuoteLineItem quoteLineItem : quoteLineItems)
        {
            if(String.isBlank(productName))
            {
                if(!quoteLineItemMapForProductSummary.containsKey(quoteLineItem.Product_Name__c))
                    quoteLineItemMapForProductSummary.put(quoteLineItem.Product_Name__c, new List<QuoteLineItem>{quoteLineItem});
                else
                {
                    List<QuoteLineItem> opportunityQuoteLineItems = quoteLineItemMapForProductSummary.get(quoteLineItem.Product_Name__c);
                    opportunityQuoteLineItems.add(quoteLineItem);
                    quoteLineItemMapForProductSummary.put(quoteLineItem.Product_Name__c, opportunityQuoteLineItems);
                }
            }
            else
            {
                quoteSumAssured += quoteLineItem.Policy_Cover__c != null ? quoteLineItem.Policy_Cover__c : 0;
                quotePremium += quoteLineItem.Premium__c != null ? quoteLineItem.Premium__c : 0; 
            }
        }
        
        if(quoteLineItemMapForProductSummary != null
          && !quoteLineItemMapForProductSummary.isEmpty())
        {
            for(String product : quoteLineItemMapForProductSummary.KeySet())
            {
                List<QuoteLineItem> productQuoteLineItems = quoteLineItemMapForProductSummary.get(product);
                
                DTO_QuoteSummaryResponse productQuoteResponse = new DTO_QuoteSummaryResponse();
                Decimal productQuoteSumAssured = 0.0;
                Decimal productQuotePremium = 0.0;
                
                for(QuoteLineItem quoteLineItem : productQuoteLineItems)
                {
                    productQuoteSumAssured += quoteLineItem.Policy_Cover__c != null ? quoteLineItem.Policy_Cover__c : 0;
                    productQuotePremium += quoteLineItem.Premium__c != null ? quoteLineItem.Premium__c : 0; 
                }
                
                if(!Sys_Utilities_General.isListBlank(opportunityParties))
                    productQuoteResponse.opportunityParty = opportunityParties[0];
                
                productQuoteResponse.productName = product;
                productQuoteResponse.isMainMember = partyType == StringConstants.PARTY_TYPE_MAIN_MEMBER ? True : False;
                productQuoteResponse.quoteLineItems = productQuoteLineItems;
                productQuoteResponse.opportunity = opportunity;
                productQuoteResponse.partyType = partyType;
                productQuoteResponse.totalPremium = productQuotePremium;
                productQuoteResponse.sumAssured = productQuoteSumAssured;
                response.add(productQuoteResponse); 
            }
        }
        else
        {
            if(!Sys_Utilities_General.isListBlank(opportunityParties))
                quoteResponse.opportunityParty = opportunityParties[0];
            
            quoteResponse.productName = productName == StringConstants.PRODUCT_FLEXI_FUNERAL ? StringConstants.PRODUCT_FLEXI_FUNERAL : StringConstants.PRODUCT_CROSS_SELL;
            quoteResponse.isMainMember = partyType == StringConstants.PARTY_TYPE_MAIN_MEMBER ? True : False;
            quoteResponse.quoteLineItems = quoteLineItems;
            quoteResponse.opportunity = opportunity;
            quoteResponse.partyType = partyType;
            quoteResponse.totalPremium = quotePremium;
            quoteResponse.sumAssured = quoteSumAssured;
            response.add(quoteResponse); 
        }
    }
    
    /**=================================================================================================================================
* Returns an array of Opportunity_Party__c
* Method that gets a list of all dependants added to an opportunity
* Param 1: opportunityId is our Opportunity Id from the Process Flow
===================================================================================================================================**/
    @AuraEnabled
    public static List<Opportunity_Party__c> getDependantData(Id opportunityId)
    {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdForQuoteSummary(opportunityId);
        if(!Sys_Utilities_General.isListBlank(opportunityParties))
            return opportunityParties;
        
        return null;
    }
    
    /**=================================================================================================================================
* Returns an array of Opportunity_Party__c
* Method that gets a list of all Opportunity Parties added to an opportunity
* Param 1: opportunityId is our Opportunity Id from the Process Flow
===================================================================================================================================**/
    @AuraEnabled
    public static List<Opportunity_Party__c> getOpportunityParties(Id opportunityId)
    {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityId(opportunityId);
        if(!Sys_Utilities_General.isListBlank(opportunityParties))
            return opportunityParties;
        
        return null;
    }
    
    @TestVisible
    public class DTO_QuoteSummaryResponse
    {
        @AuraEnabled
        public Opportunity opportunity {get;set;}
        @AuraEnabled
        public Opportunity_Party__c opportunityParty {get;set;}
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItems {get;set;}
        @AuraEnabled
        public Decimal totalPremium {get;set;}
        @AuraEnabled
        public Decimal sumAssured {get;set;}
        @AuraEnabled
        public String partyType {get;set;}
        @AuraEnabled
        public String partyName {get;set;}
        @AuraEnabled
        public String productName {get;set;}
        @AuraEnabled
        public Boolean isMainMember {get;set;}
    }
}