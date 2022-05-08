public class RoaPDFPageController {
    
    public Opportunity opportunity {get;set;}
    public Account account {get;set;} 
    public User advisor {get;set;}
    public Quote quote {get;set;}
    public List<QuoteLineItem> quoteLineItems {get;set;}
    public List<Opportunity_Party__c> spouses {get;set;}
    public List<Opportunity_Party__c> beneficiaries {get;set;}
    public List<Opportunity_Party__c> dependants {get;set;}
    
    public String commencementDate {get;set;}
    public String debitDate {get;set;}
    public String birthDate {get;set;}
    
    public String executorFee {get;set;} 
    public String executorFeeSpouse {get;set;}
    public String estateBridging {get;set;}
    public String estateBridgingSpouse {get;set;}
    public String funeralBenefit {get;set;}
    public String funeralBenefitSpouse {get;set;}
    
    public String isSupervision {get;set;} 
    
    public RoaPDFPageController(){
        Id oppId = apexpages.currentpage().getparameters().get('id');
		
        opportunity = [SELECT Id, Name, AccountId, Adviser_BRID_Number__c, OwnerId, Commencement_Date__c, Debit_Order_Date__c,
                       SyncedQuoteId FROM Opportunity WHERE Id = :oppId LIMIT 1];
        commencementDate = opportunity.Commencement_Date__c.format();
        debitDate = opportunity.Debit_Order_Date__c.format();
        
        account = [SELECT Id, Name, PersonTitle, FirstName, LastName, PersonBirthdate FROM Account WHERE Id = :opportunity.AccountId LIMIT 1];
        birthDate = account.PersonBirthdate.format();
        
        advisor = [SELECT Id, Name, IsSupervised__c FROM User WHERE Id = :opportunity.OwnerId LIMIT 1];
        if(advisor.IsSupervised__c){
            isSupervision = 'am';
        }
        else{
            isSupervision = 'am NOT';
        }
        
        quote = [SELECT Id, Name, TotalPrice, Commission_1st_Year__c, Commission_2nd_Year__c FROM Quote WHERE Id = :opportunity.SyncedQuoteId LIMIT 1];
        quote.Commission_1st_Year__c = quote.Commission_1st_Year__c.setScale(2);
        quote.Commission_2nd_Year__c = quote.Commission_2nd_Year__c.setScale(2);
        
        quoteLineItems = [SELECT Id, Policy_Cover__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quote.Id];
        executorFee = 'Executor Fee: N/A';
        executorFeeSpouse = 'Executor Fee: N/A';
        estateBridging = 'Bridging Finance: N/A'; 
        estateBridgingSpouse = 'Bridging Finance: N/A'; 
        funeralBenefit = 'Funeral Cover: No'; 
        funeralBenefitSpouse = 'Funeral Cover: No'; 
            
        for(QuoteLineItem item : quoteLineItems){
            if(item.PricebookEntry.Name.contains('Executor Fees Policy') && !item.PricebookEntry.Name.contains('Spouse')){
                executorFee = 'Executor Fee: R' + item.Policy_Cover__c;
            }
            else if(item.PricebookEntry.Name.contains('Executor Fees Policy Spouse')){
                executorFeeSpouse = 'Executor Fee: R' + item.Policy_Cover__c;
            }
            else if(item.PricebookEntry.Name.contains('Estate Bridging Benefit') && !item.PricebookEntry.Name.contains('Spouse')){
                estateBridging = 'Bridging Finance: R' + item.Policy_Cover__c;
            }
            else if(item.PricebookEntry.Name.contains('Estate Bridging Benefit Spouse')){
                estateBridgingSpouse = 'Bridging Finance: R' + item.Policy_Cover__c;
            }
            else if(item.PricebookEntry.Name.contains('Funeral Benefit') && !item.PricebookEntry.Name.contains('Spouse')){
                funeralBenefit = 'Funeral Cover: Yes';
            }
            else if(item.PricebookEntry.Name.contains('Funeral Benefit Spouse')){
                funeralBenefitSpouse = 'Funeral Cover: Yes';
            }
        }
        
        beneficiaries = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
        for(Opportunity_Party__c beneficiary : beneficiaries){
            beneficiary.Benefit_Split__c = (beneficiary.Benefit_Split__c * 100).setScale(0);
            beneficiary.Party_Type__c = beneficiary.Date_of_Birth__c.format();
        }
        
        dependants = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Dependant');
        spouses = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Spouse');
        if(spouses.size() != 0){
            dependants.add(spouses.get(0));
        }
        for(Opportunity_Party__c dependant : dependants){
            dependant.Party_Type__c = dependant.Date_of_Birth__c.format();
        }
    }
}