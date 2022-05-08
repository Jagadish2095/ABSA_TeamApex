/**
 * @description
 * @author Taras Kuliievych
 * @since 2021-08-21
**/
public with sharing class Enquiry_PDFReportController {

    /**
    * @description
    * @author Taras Kuliievych | 08-31-2021
    * @param enquiryDataJSON
    * @return String
    **/
    @AuraEnabled
    public static String getEnquiryReport(String enquiryDataJSON) {
        EnquiryReportProcessor enquiryReportProcessor = new EnquiryReportProcessor();
        String report = EnquiryReportProcessor.generateEnquiryReport(enquiryDataJSON);

        return report;
    }

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