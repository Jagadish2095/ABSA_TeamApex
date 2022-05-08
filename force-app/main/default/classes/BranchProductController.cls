/**
 * @description Branch Product Controller
 * @author  Paul du Randt
 * @created 2020-10-29
 */
public without sharing class BranchProductController
{

    /**
    * @description cCApplicationPreScreen
    * @return string
    * @param accountID
    */
    @AuraEnabled
    public static string cCApplicationPreScreen(String accountID)
    {
        return json.serialize(CCApplicationServiceHelper.applyPreScreen(accountID));
    }
    /**
    * @description getApplicationProductRecordId
    * @return string
    * @param applicationId
    */
    @AuraEnabled
    public static String getApplicationProductRecordId(string applicationId)
    {
        string productRecordId = '';
        Application_Product__c[] applicationProduct = [Select Id From Application_Product__c Where Application__c = :applicationId WITH SECURITY_ENFORCED];
        if (applicationProduct.size() > 0) {
            productRecordId = applicationProduct[0].id;
        }else{
            productRecordId = addApplicationProduct(applicationId);
        }
        return productRecordId;
    }
    /**
    * @description updateKnockoutQuestionAttestation
    * @param accountID
    * @param knockoutSelected
    */
    @AuraEnabled
    public static void updateKnockoutQuestionAttestation(String accountID, String knockoutSelected) {
        Account account = [SELECT DocumentAttestationOptions__c FROM Account where ID = :accountID WITH SECURITY_ENFORCED LIMIT 1];
        account.DocumentAttestationOptions__c =  (knockoutSelected  == 'accept') ?  true  : false;
        if(Schema.sObjectType.Account.isUpdateable()) {
            update account;
       }
    }
    /**
    * @description addApplicationProduct
    * @return string
    * @param applicationId
    */
    public static string addApplicationProduct(string applicationId)
    {
        Application_Product__c newProduct = new Application_Product__c(
            Application__c=applicationId,
            Opportunity_Product_Id__c='001252'
        );
        if (Application_Product__c.sObjectType.getDescribe().isCreateable()) {
            insert newProduct;
        }
        return newProduct.Id;
    }
}