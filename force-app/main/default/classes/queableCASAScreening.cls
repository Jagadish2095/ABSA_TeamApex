global class queableCASAScreening implements Queueable, Database.AllowsCallouts{
    
     private String  opportunityId;
     private String  accountRecordType; 
     private String  cifCheck;  
     private String  accountId;
    
     global queableCASAScreening (String opportunityId, String accountRecordType, String cifCheck, String accountId) { 

        this.opportunityId = opportunityId; 
        this.accountRecordType = accountRecordType;
        this.cifCheck = cifCheck;
        this.accountId = accountId; 

    } 
    
  global void execute(QueueableContext context) {     
     
  OnboardingCASAScreeningController.callToCASAScreening(opportunityId);  
      
      
   if( !Test.isRunningTest()){   
        
    System.enqueueJob(new queableRikScreening(opportunityId, accountRecordType, cifCheck, accountId ));
       
    }
  }
    
    
    
    
    
    
    
    
}