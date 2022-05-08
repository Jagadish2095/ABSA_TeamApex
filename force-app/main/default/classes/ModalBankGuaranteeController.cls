/**
 * @description       : Controller class for Modal Bank Guarantee aura component
 * @author            : Himani Joshi
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-21   Himani Joshi   Initial Version
**/
public class ModalBankGuaranteeController {
    /**
    * @description : Method to get linked contracts
    * @author Himani Joshi | 2021-06-21 
    * @param recordId 
    * @return List<Contract__c> 
    **/
    @AuraEnabled
    public static List<Contract__c> getLinkedContracts(Id recordId){
     List<Contract__c>contractList=[select Id,Application_Financial_Account__c,Contract_number__c,Contract_sub_product_code__c,Contract_type__c,Contract_balance__c,Expiry_Date__c,Contract_amount__c from Contract__c where Application_Financial_Account__c=:recordId ];
     
        return contractList;
     
    }


}