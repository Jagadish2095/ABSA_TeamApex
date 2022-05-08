/**
 * @description       :
 * @author            : Taras Kuliievych
 * @group             :
 * @last modified on  : 08-31-2021
 * @last modified by  : Taras Kuliievych
**/
public with sharing class Enquiry_BaseComponentController {
    /**
    * @description
    * @author Taras Kuliievych | 08-31-2021
    * @param caseId
    * @return String
    **/
    @AuraEnabled
    public static String closeCase(String caseId) {
        EnquiryUtility.closeCase(caseId);

        return 'Sucess';
    }
}