/**
 * @description       :
 * @author            : Taras Kuliievych
 * @group             :
 * @last modified on  : 08-31-2021
 * @last modified by  : Taras Kuliievych
**/
public with sharing class EnquiryUtility {
    /**
    * @description
    * @author Taras Kuliievych | 08-31-2021
    * @param caseId
    **/
    @future
    @AuraEnabled
    public static void closeCase(String caseId) {
        Case targetCase = [Select Id, Status, Out_Of_SLA_Comments__c, Out_Of_SLA_Reason__c from Case where Id = :caseId];

        targetCase.Status = 'Closed';
        targetCase.Out_Of_SLA_Comments__c = 'CBP Enquiry';
        targetCase.Out_Of_SLA_Reason__c = 'Fees and Charges';

        update targetCase;
    }
}