public class FPCustomerSmsCntrl {
    

   @AuraEnabled
   public static GBlistCommentsV1_Resp_IB_V1 getSmsDetails(String personname, String dateFrom){
       system.debug(personname);
       system.debug(dateFrom);
       
        string clientCode;                    
       for(Account acc: [Select CIF__c,FinServ__BranchCode__c from Account where Name =:personname]){
            clientCode = acc.CIF__c;
       }
       system.debug(clientCode);
      GBlistCommentsV1_Resp_IB_V1 responseBean = GBlistCommentsV1_IH_v1.getComments(dateFrom,clientCode,'8913');
      system.debug(responseBean);

      return responseBean;
      
   } 
}