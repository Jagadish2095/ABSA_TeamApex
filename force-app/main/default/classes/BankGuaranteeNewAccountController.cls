/**
 * @description       : Controller class for Bank Guarantee aura component
 * @author            : Himani Joshi
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-21   Himani Joshi   Initial Version
**/

public class BankGuaranteeNewAccountController {
	
    /**
    * @description : Method to delete account
    * @author Himani Joshi | 2021-06-21 
    * @param appProductId 
    * @return Boolean 
    **/
    @AuraEnabled(Cacheable=false)
    public static Boolean deleteAccount(Id appProductId){
        Boolean deletion = false;
        Application_Product__c appProduct = new Application_Product__c();
        appProduct.Id = appProductId;
        
        try{
            delete appProduct;
            deletion = true;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }
        
        return deletion;
    }
}