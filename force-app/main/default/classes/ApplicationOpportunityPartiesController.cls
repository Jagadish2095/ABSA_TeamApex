public class ApplicationOpportunityPartiesController {
     
    @AuraEnabled
    public static String checkInitValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        return opportunities.get(0).Application_Status__c;
    }
    
    @AuraEnabled
    public static String checkDependantValidity(Id oppId) {

        Boolean isFamilyFuneralAdded = false;
        List<OpportunityLineItem> oppLineItems = [SELECT Id, Name from OpportunityLineItem WHERE OpportunityId = :oppId];
        for(OpportunityLineItem oLineItem : oppLineItems){
            if(oLineItem.Name.contains('Funeral Benefit')){
              	isFamilyFuneralAdded = true;
            }
        }

        List<Opportunity_Party__c> opportunityDependantParties = [SELECT id, Party_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Party_Type__c INCLUDES ('Dependant')];
        if(opportunityDependantParties.size() == 0){
            if(isFamilyFuneralAdded){
            	return 'Invalid Dependant';
        	}
        }
        
        return 'Valid';
    }
    
	@AuraEnabled
    public static String checkValidity(Id oppId) {
        Double totalBenefitSplit = 0;
        List<Opportunity_Party__c> opportunityParties = [SELECT id, Benefit_Split__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Party_Type__c INCLUDES ('Beneficiary')];
        
        for(Opportunity_Party__c oppParty : opportunityParties){
            totalBenefitSplit += oppParty.Benefit_Split__c;
        }
        
        System.debug(totalBenefitSplit);
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        if(totalBenefitSplit != 1){
            
            return 'Invalid Beneficiaries';
        }
        
        Boolean isSpouseAdded = false;
        List<OpportunityLineItem> oppLineItems = [SELECT Id, Name from OpportunityLineItem WHERE OpportunityId = :oppId];
        for(OpportunityLineItem oLineItem : oppLineItems){
            if(oLineItem.Name.contains('Spouse') && !oLineItem.Name.contains('EPP Funeral Benefit Spouse')){
              	isSpouseAdded = true;
            }
        }
        List<Opportunity_Party__c> opportunitySpouseParties = [SELECT id, Party_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Party_Type__c INCLUDES ('Spouse')];
        if(opportunitySpouseParties.size() == 0){
            if(isSpouseAdded){
            	return 'Invalid Spouse';
        	}
        }
        
        //ToDo interim code - needs to be changed added due to incorrect analysis and rules 
        Boolean nofamilyFuneralSpouse = true;
        Boolean spouseAdded = false;
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty()){
            List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id];
            for(QuoteLineItem quoteLineItem : quoteLineItems){
                if(quoteLineItem.PricebookEntry.Name.equals('EPP Funeral Benefit Spouse')){
                    nofamilyFuneralSpouse = false;
                    break;
                }
            }
        }
        List<Opportunity_Party__c> opportunityDependantParties = [SELECT id, Party_Type__c, Relationship__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Party_Type__c INCLUDES ('Dependant')];
        for(Opportunity_Party__c opportunityDependantParty : opportunityDependantParties){
            if(opportunityDependantParty.Relationship__c.equals('Spouse')){
                spouseAdded = true;
                break;
            }
        }
        if(nofamilyFuneralSpouse == true && spouseAdded == true){
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = oppId;
            oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
            oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
            oppLineItem.Quantity = 1;
            oppLineItem.Premium__c = 0;
            oppLineItem.TotalPrice = 0;
            
            insert oppLineItem;
            
			QuoteLineItem quoteLineItem = new QuoteLineItem();
            quoteLineItem.QuoteId = quotes.get(0).Id;
            quoteLineItem.OpportunityLineItemId = oppLineItem.Id;
            quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
            quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Policy_Cover__c = 0;
            quoteLineItem.Premium__c = 0;
            quoteLineItem.UnitPrice = 0;
            
            insert quoteLineItem;  
        }
        //End ToDo
        
        //All valid
        opportunities.get(0).Application_Status__c = 'Valid';
        update opportunities;
        
        return 'Valid';
    }
}