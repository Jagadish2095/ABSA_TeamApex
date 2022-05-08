public class queableGetAccountNumber  implements Queueable, Database.AllowsCallouts {
    
     private String  opportunityId;
     private String  accountRecordType; 
     private String  PriceSchemeCode;  
     private String  accountId;
    
    
     public queableGetAccountNumber (String opportunityId, String accountRecordType, String PriceSchemeCode, String accountId) { 

        this.opportunityId = opportunityId;
        this.accountRecordType = accountRecordType;
        this.PriceSchemeCode = PriceSchemeCode; 
        this.accountId = accountId;

    } 
    
  public void execute(QueueableContext context) {
  productOnboardingController.getOppData(opportunityId,PriceSchemeCode); 
  if( !Test.isRunningTest()){    
  System.enqueueJob(new queueableSendAccountNumber(opportunityId,accountId ));}   

      
  }
    

}