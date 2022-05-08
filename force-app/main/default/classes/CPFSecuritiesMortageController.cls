/**
 * @description       : Class for SecurityMortage controller
 * @author            :Rajesh
 * @last modified on  : 2021-07-02
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author   Modification
 * 1.0   2020-07-02      Initial Version
**/
public class CPFSecuritiesMortageController {
    /**
    * @description Method to get Securities Rec
    * @author  | 2021-07-02 
    * @param oppId 
    * @param secSectionsfetch 
    * @return LIST<Application_Security_CPF__c> 
    **/
    @AuraEnabled
    public static LIST<Application_Security_CPF__c> getSecurityofferedRec(Id oppId,string secSectionsfetch) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Limited Guarantee',secSectionsfetch);
         return securityofferedList;

    }
     /**
     * @description Method to get Security Rec of Unlimited type
     * @author  | 2021-07-02 
     * @param oppId 
     * @param secSectionsfetch 
     * @return Map<Object, Object> 
     **/
     @AuraEnabled
    public static Map<Object,Object> getUnlimitedSecurityofferedRec(Id oppId,string secSectionsfetch) {
        String typeD = secSectionsfetch == 'New' ? 'New Mortgage Bond' : 'Existing Mortgage Bond';
        Map<Object,Object> dataMap = new Map<Object,Object>();
        system.debug('oppId===='+oppId);
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
        system.debug('appId=='+app[0].Id);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        LIST<Application_Security_CPF__c> securityofferedList = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,typeD,secSectionsfetch);
        system.debug('securityofferedList'+securityofferedList);
        dataMap.put('APPPRODUCTCPF',appPrdctCpf);
        dataMap.put('APPSECURITYCPF',securityofferedList);
        return dataMap;

    }
 /**
 * @description Method to insert Security Rec of Limited type
 * @author  | 2021-07-02 
 * @param recId 
 * @param LimitedGauranteelist 
 * @param secSections 
 * @return list<Application_Security_CPF__c> 
 **/
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
                  // securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
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
    /**
    * @description Metod to insert existing Rec of limited type
    * @author  | 2021-07-02 
    * @param recId 
    * @param LimitedGauranteelistforExisting 
    * @param secSectionsforExisting 
    * @return list<Application_Security_CPF__c> 
    **/
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
                  // securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
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
    /**
    * @description Method to insert Unlimited Rec
    * @author  | 2021-07-02 
    * @param recId 
    * @param UnLimitedGauranteelist 
    * @param secSections 
    * @param bankConvrContactDetail 
    * @param bankConvrContactPerson 
    * @param bankConvrFirmDetails 
    * @return list<Application_Security_CPF__c> 
    **/
    @AuraEnabled
    public static list<Application_Security_CPF__c> InsertUnlimitedSecurityOfferedCpfRec(Id recId,List<Application_Security_CPF__c> UnLimitedGauranteelist,string secSections,String bankConvrContactDetail,String bankConvrContactPerson,String bankConvrFirmDetails) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
      try{
          if(appPrdctCpf!=null){
              appPrdctCpf.Bank_conveyancer_contact_details__c = bankConvrContactDetail;
              appPrdctCpf.Bank_conveyancer_contact_person__c = bankConvrContactPerson;
              appPrdctCpf.Bank_conveyancer_firm_details__c = bankConvrFirmDetails;
              List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'New Mortgage Bond',secSections);
              if(!dellist.isEmpty()) {
                  delete dellist;
              }
              for(Application_Security_CPF__c securityobj : UnLimitedGauranteelist) {
                  securityobj.Id= null;
                  securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                  securityobj.Category__c='New Mortgage Bond';
                  securityobj.Security_Class__c =secSections;
              }
              update appPrdctCpf;
              insert UnLimitedGauranteelist;

          }
          system.debug('UnLimitedGauranteelist'+UnLimitedGauranteelist);
          return UnLimitedGauranteelist;
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }
    }
    /**
    * @description Method to insert unlimited existing rec
    * @author  | 2021-07-02 
    * @param recId 
    * @param UnLimitedGauranteelistforExisting 
    * @param secSectionsforexisting 
    * @return list<Application_Security_CPF__c> 
    **/
    @AuraEnabled
    public static list<Application_Security_CPF__c> InsertUnlimitedExistingCpfRec(Id recId,List<Application_Security_CPF__c> UnLimitedGauranteelistforExisting,string secSectionsforexisting) {
        List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        try{
            if(appPrdctCpf!=null){

                List<Application_Security_CPF__c> dellist = new ApplicationSecurityCPFSelector().selectByAppPrdctIdandClass(appPrdctCpf.Id,'Existing Mortgage Bond',secSectionsforexisting);
                if(!dellist.isEmpty()) {
                    delete dellist;
                }
              for(Application_Security_CPF__c securityobj : UnLimitedGauranteelistforExisting) {
                  securityobj.Id= null;
                  securityobj.Application_Product_CPF__c=appPrdctCpf.Id;
                  securityobj.Category__c='Existing Mortgage Bond	';
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
    /**
    * @description Method to get products Name 
    * @author  | 2021-07-02 
    * @param oppId 
    * @return List<OpportunityLineItem> 
    **/
    @AuraEnabled
    public static List<OpportunityLineItem> getprodName(Id oppId) {
        List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        return opplineitemlst;
    }


}