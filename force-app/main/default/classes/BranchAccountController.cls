/**
 * @description Branch Customer Address Helper
 * @author  Clifford Willers : ABSA (IQ Business)
 * @created 2021-01-04
 */
public without sharing class BranchAccountController {
    /**
    * @description getAccountRecordId
    * @return String
    * @param applicationId
    * @param accountPurpose
    */
    @AuraEnabled
    public static String getAccountRecordId(string applicationId, String accountPurpose)
    {
        string accountRecordId = '';
        Application_Financial_Account__c[] financialAccount = [Select Id From Application_Financial_Account__c Where Application__c = :applicationId And Account_Purpose__c = :accountPurpose WITH SECURITY_ENFORCED];
        if (financialAccount.size() > 0) {
            accountRecordId = financialAccount[0].id;
        }else{
            accountRecordId = addAccount(applicationId, accountPurpose);
        }
        return accountRecordId;
    }
    /**
    * @description getAccountDetail
    * @return Map<String,String>
    * @param applicationId
    * @param accountPurpose
    */
    @AuraEnabled
    public static Map<String,String> getAccountDetail(string applicationId, String accountPurpose)
    {
        Map<String, string> accountDetails = new Map<String, string>();
        Application_Financial_Account__c[] financialAccount = [Select Account_Holder_Name__c, Account_Number__c, Account_Type__c, Institution_Name__c From Application_Financial_Account__c Where Application__c = :applicationId And Account_Purpose__c = :accountPurpose WITH SECURITY_ENFORCED];
        if (financialAccount.size() > 0) {
            accountDetails.put('Account_Holder_Name__c', financialAccount[0].Account_Holder_Name__c);
            accountDetails.put('Account_Number__c', String.valueOf(financialAccount[0].Account_Number__c));
            accountDetails.put('Account_Type__c', financialAccount[0].Account_Type__c);
            accountDetails.put('Institution_Name__c', financialAccount[0].Institution_Name__c);
        }else{
            accountDetails.put('Account_Holder_Name__c', '');
            accountDetails.put('Account_Number__c', '');
            accountDetails.put('Account_Type__c', '');
            accountDetails.put('Institution_Name__c', '');
        }
        return accountDetails;
    }
    /**
    * @description addAccount
    * @return String
    * @param applicationId
    * @param accountPurpose
    */
    public static string addAccount(string applicationId, String accountPurpose)
    {
        Application_Financial_Account__c newAccount = new Application_Financial_Account__c(
            Name=accountPurpose + ': ' + applicationId,
            Application__c=applicationId,
            Account_Purpose__c=accountPurpose
        );
        if (Application_Financial_Account__c.sObjectType.getDescribe().isCreateable()) {
            insert newAccount;
        }
        return newAccount.Id;
    }
}