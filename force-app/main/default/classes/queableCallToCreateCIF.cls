public class queableCallToCreateCIF implements Queueable, Database.AllowsCallouts {
    
     private String  opportunityId;
     private String  accountRecordType;
     private String  PriceSchemeCode; 
     private String  cifCheck;
     private String  accountId;
    
     public queableCallToCreateCIF (String opportunityId, String accountRecordType, String cifCheck, String accountId) { 

      this.opportunityId = opportunityId;
      Account acccount = new AccountsSelector().selectByOpportunityId(opportunityId);
      this.accountRecordType = acccount.RecordType.DeveloperName;  
      this.cifCheck = cifCheck;
      List<OpportunityLineItem> oppLineItem = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
         for(OpportunityLineItem oppLineItemloop: oppLineItem){
             if(oppLineItemloop.Fee_Structure_code__c != null){
                 this.PriceSchemeCode = oppLineItemloop.Fee_Structure_code__c;}} 
      system.debug('PriceSchemeCode--->'+PriceSchemeCode);
      this.accountId = accountId;
    } 
    
  public void execute(QueueableContext context) {   
      
      If(cifCheck == null){
      
     OnboardingGenerateCIFController.callToCreateCIF(opportunityId, accountRecordType); }
      
      if( !Test.isRunningTest()){
      
   System.enqueueJob(new queableGetAccountNumber(opportunityId,accountRecordType,PriceSchemeCode,accountId ));   
  
  }
    
      }  
    
}