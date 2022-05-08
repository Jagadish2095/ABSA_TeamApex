/**
 * @description Controller class for Branch Application Components
 * @author  Clifford Willers (IQ Business)
 * @created 2020-11-12
 */
public without sharing class BranchApplicationController {
    /**
    * @description getPaymentPlanRecordId
    * @return string
    * @param applicationId
    */
    @AuraEnabled
    public static string getPaymentPlanRecordId(string applicationId)
    {
        return BranchPaymentPlanHelper.getPaymentPlanRecordId(applicationId);
    }
    /**
    * @description getApplicationFinancialAccountRecordId
    * @return String
    * @param applicationId
    * @param accountPurpose
    */
    @AuraEnabled
    public static string getApplicationFinancialAccountRecordId(string applicationId, String accountPurpose)
    {
        return BranchAccountController.getAccountRecordId(applicationId, accountPurpose);
    }
    /**
    * @description getApplicationProductRecordId
    * @return string
    * @param applicationId
    */
    @AuraEnabled
    public static string getApplicationProductRecordId(string applicationId)
    {
        return BranchProductController.getApplicationProductRecordId(applicationId);
    }
    /**
    * @description getSalaryAccoutDetails
    * @return Map<String, String>
    * @param applicationId
    */
    @AuraEnabled
    public static Map<String, String> getSalaryAccoutDetails(string applicationId)
    {
        return BranchAccountController.getAccountDetail(applicationId, 'Salary');
    }
    /**
    * @description getPickListValues
    * @return List<String>
    * @param objObject
    * @param objField
    */
    @AuraEnabled
    public static List<String> getPickListValues(sObject objObject, string objField)
    {
        return BranchFunctions.getFieldPickListValues(objObject, objField);
    }
    /**
    * @description getBankInfo
    * @return List<String>
    */
    @AuraEnabled
    public static List<String> getBankInfo()
    {
        return BranchFunctions.getBankInfo();
    }
    /**
    * @description callCompleteTwo
    * @return String
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param cardProdSubProdGroupId
    */
    @AuraEnabled
    public static String callCompleteTwo(string applicationId, string applicationNumber, string lockVersionId, string cardProdSubProdGroupId)
    {
        String returnStr =  JSON.serialize(CCApplicationServiceHelper.applyComplete2(applicationId, applicationNumber, lockVersionId, cardProdSubProdGroupId));
        System.debug('returnStr**'+returnStr);
        return JSON.serialize(CCApplicationServiceHelper.applyComplete2(applicationId, applicationNumber, lockVersionId, cardProdSubProdGroupId));
    }
    /**
    * @description applyInstantAccountOpening
    * @return String
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    */
    @AuraEnabled
    public static String applyInstantAccountOpening(Id applicationId, string applicationNumber, string lockVersionId)
    {
        return JSON.serialize(CCApplicationServiceHelper.applyInstantAccountOpening(applicationId, applicationNumber, lockVersionId));
    }
    /**
    * @description applyInitiateDebiCheck
    * @return String
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    */
    @AuraEnabled
    public static String applyInitiateDebiCheck(Id applicationId, string applicationNumber, string lockVersionId)
    {
        return JSON.serialize(CCApplicationServiceHelper.applyInitiateDebiCheck(applicationId, applicationNumber, lockVersionId));
    }
}