/**
  @description        create opportunity line items
  @author             Monde Masiza
  @last modified on   2021-06-14
  @last modified by   Monde Masiza
  Modifications Log 
  Ver   Date         Author         Modification
  1.0   2021-06-14   Monde Masiza   Initial Version
  **/

@RestResource(urlMapping='/Opportunity/v1/*')
global class CreateOpportunityLineItem {
    global String opportunityId;
    global String leadId;
    global String productName;
    global String quoteNumber;
    global String policyNumber;

/**
  @description inner class
  @author             Monde Masiza
  @last modified on   2021-06-14
  **/

    global class COppsResponse {
        
        public String message;


/**
  @description Opportunity Response message
  @author             Monde Masiza
  @last modified on   2021-06-14
  @param message
  **/
        
        public COppsResponse(String message) {
            this.message = message;
            
        }
    }
    
    /**
     * @description create opportunity line items
     * @author Monde Masiza  2021-06-14 
     * @param opportunityId 
     * @param  productName 
     * @param quoteNumber 
     * @param policyNumber 
     * @param message 
     * @return COppsResponse
      
     **/
    
    @HttpPost
    global static COppsResponse getOpportunityInputs(String opportunityId,String productName,String quoteNumber,String policyNumber,String message) { 
        
        string PricebookEntryId;
        List<Opportunity> OpportunityRecord = [SELECT Id FROM Opportunity WHERE Id =:opportunityId];
        List<PricebookEntry> Pricebook = [SELECT Id, ProductCode, Product2Id, Name, UseStandardPrice FROM PricebookEntry WHERE Name =:productName];
        
        for(PricebookEntry PricebookE : Pricebook){
            PricebookEntryId =   PricebookE.Id;
            
        } 
        
        if(!OpportunityRecord.isEmpty() && !Pricebook.isEmpty()){
            List<OpportunityLineItem> oppsLineItems = new List<OpportunityLineItem>();
            for (Opportunity record  :OpportunityRecord){
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = record.Id;
                oppLineItem.PricebookEntryId = PricebookEntryId;
                oppLineItem.UnitPrice = 0;
                oppLineItem.Quantity = 1;
                oppLineItem.Quote_Number__c=quoteNumber;
                oppLineItem.ServiceDate = System.today();
                oppLineItem.Policy_Number__c = policyNumber;
                oppsLineItems.add(oppLineItem);
            }
            insert oppsLineItems;  
        }
        
        else{
            COppsResponse obj = new COppsResponse('Exception has occurred Please provide both Opportunity Id and product Name');
            return obj;
        }
        
        COppsResponse obj2 = new COppsResponse('Created successfully' + PricebookEntryId);
        return obj2;
    }
}