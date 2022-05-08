public class CPFLimitedUnlimitedGuarnteessections {
    @AuraEnabled
    public static LIST<Application_Security_CPF__c> getSecurityofferedRec(Id oppId,string secSectionsfetch) {
        system.debug('oppId===='+oppId);
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        system.debug('appPrdctCpf===='+appPrdctCpf.Id);
        LIST<Application_Security_CPF__c> securityofferedList;
        
         securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Guarantee',secSectionsfetch);
           system.debug('securityofferedList'+securityofferedList);
    
       // if(securityofferedList.size() > 0){
            return securityofferedList; 
        //}else{
              //  return null;
            //}    
        
    } 
     @AuraEnabled
    public static LIST<Application_Security_CPF__c> getUnlimitedSecurityofferedRec(Id oppId,string secSectionsfetch) {
        system.debug('oppId===='+oppId);
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
         system.debug('appId=='+app[0].Id);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'UnLimited Guarantee',secSectionsfetch);
            system.debug('securityofferedList'+securityofferedList);
        return securityofferedList;     
        
    } 
 @AuraEnabled
    public static list<Application_Security_CPF__c> InsertLimitedSecurityOfferedCpfRec(Id recId,List<Application_Security_CPF__c> LimitedGauranteelist,string secSections) {
         List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
      try{
           if(appPrdctCpf!=null){
              
               List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Guarantee',secSections);
               if(!dellist.isEmpty()) {
                   delete dellist;
               }
               for(Application_Security_CPF__c securityobj : LimitedGauranteelist) {
                   securityobj.Id= null;
                   securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                   securityobj.Category__c='Limited Guarantee';
                   securityobj.Security_Class__c =secSections;
                }
               insert LimitedGauranteelist;
               
       }
          system.debug('LimitedGauranteelist'+LimitedGauranteelist);
        return LimitedGauranteelist;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    @AuraEnabled
    public static list<Application_Security_CPF__c> InsertLimitedExistingCpfRec(Id recId,List<Application_Security_CPF__c> LimitedGauranteelistforExisting,string secSectionsforExisting) {
         List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
      try{
           if(appPrdctCpf!=null){
              
               List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Guarantee',secSectionsforExisting);
               if(!dellist.isEmpty()) {
                   delete dellist;
               }
               for(Application_Security_CPF__c securityobj : LimitedGauranteelistforExisting) {
                   securityobj.Id= null;
                   securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                   securityobj.Category__c='Limited Guarantee';
                   securityobj.Security_Class__c =secSectionsforExisting;
                }
               insert LimitedGauranteelistforExisting;
               
       }
          system.debug('LimitedGauranteelistforExisting'+LimitedGauranteelistforExisting);
        return LimitedGauranteelistforExisting;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    @AuraEnabled
    public static list<Application_Security_CPF__c> InsertUnlimitedSecurityOfferedCpfRec(Id recId,List<Application_Security_CPF__c> UnLimitedGauranteelist,string secSections) {
        system.debug('secSections '+secSections); 
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
      try{
           if(appPrdctCpf!=null){
              
			List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'UnLimited Guarantee',secSections);               
               if(!dellist.isEmpty()) {
                   delete dellist;
               }
               for(Application_Security_CPF__c securityobj : UnLimitedGauranteelist) {
                   securityobj.Id= null;
                  securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                   securityobj.Category__c='UnLimited Guarantee';
                   securityobj.Security_Class__c =secSections;
                  }
               insert UnLimitedGauranteelist;
               
       }
          system.debug('UnLimitedGauranteelist'+UnLimitedGauranteelist);
        return UnLimitedGauranteelist;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
    @AuraEnabled
    public static list<Application_Security_CPF__c> InsertUnlimitedExistingCpfRec(Id recId,List<Application_Security_CPF__c> UnLimitedGauranteelistforExisting,string secSectionsforexisting) {
         List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
      try{
           if(appPrdctCpf!=null){
              
			List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'UnLimited Guarantee',secSectionsforexisting);               
               if(!dellist.isEmpty()) {
                   delete dellist;
               }
               for(Application_Security_CPF__c securityobj : UnLimitedGauranteelistforExisting) {
                   securityobj.Id= null;
                   securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                   securityobj.Category__c='UnLimited Guarantee';
                   securityobj.Security_Class__c =secSectionsforexisting;
                  }
               insert UnLimitedGauranteelistforExisting;
               
       }
          system.debug('UnLimitedGauranteelistforExisting'+UnLimitedGauranteelistforExisting);
        return UnLimitedGauranteelistforExisting;     
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        } 
    }
}