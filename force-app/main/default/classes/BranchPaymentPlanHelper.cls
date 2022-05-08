/**
 * @description Branch Payment Plan Helper
 * @author  Clifford Willers
 * @created 2020-10-29
 */
public without sharing class BranchPaymentPlanHelper {
    /**
    * @description getPaymentPlanRecordId
    * @return string
    * @param applicationId
    */
    @AuraEnabled
    public static string getPaymentPlanRecordId(string applicationId)
    {
        string paymentPlanRecordId = '';

        Payment_Plan__c[] paymentPlan = [Select Id From Payment_Plan__c Where Application__c = :applicationId WITH SECURITY_ENFORCED];
        if (paymentPlan.size() > 0) {
            paymentPlanRecordId = paymentPlan[0].id;
        }else{
            paymentPlanRecordId = addPaymentPlanRecord(applicationId);
        }
        return paymentPlanRecordId;
    }
    /**
    * @description addPaymentPlanRecord
    * @return string
    * @param applicationId
    */
    public static string addPaymentPlanRecord(string applicationId)
    {
        Payment_Plan__c newPaymentPlan = new Payment_Plan__c(
            Application__c=applicationId,
            Name=applicationId,
            Status__c='New',
            Method__c='Debit Order');
        if (Payment_Plan__c.sObjectType.getDescribe().isCreateable()) {
            insert newPaymentPlan;
        }
        return newPaymentPlan.Id;
    }
}