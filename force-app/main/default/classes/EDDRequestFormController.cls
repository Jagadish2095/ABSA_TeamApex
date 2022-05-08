/**
 * @description : A controller class to submit EDD Request and upload Documents.
 * @created : 2021-04-28
 **/

public class EDDRequestFormController {
    /**
     * @description A Method to update EDD form.
     * @param caseId is the Case Id passed in from the component.
     * @param mediaReportReason is the Reason for media report selected from the component.
     * @param adverseMediaReport is the Adverse media report selected from the component.
     * @param fileName is the filename of attached document.
     * @param base64Data is the base64 version of document.
     * @param contentType is the filetype of the document.
     * @param isFileUploaded is the boolean variable determine whether document uploaded.
     * @return a string result of the request.
     **/

    @AuraEnabled
    public static string updateEddDetails(String caseId, String mediaReportReason, String adverseMediaReport,String fileName, 
                                        String base64Data, String contentType,Boolean isFileUploaded) {
        try {
            Case caseRec = new Case();
            caseRec = new CasesSelector().selectCaseByMaintenance(caseId);
            List<Group> grp = new GroupsSelector().selectByNameType(System.Label.EDD_Queue, 'Queue');

            if(grp.size()>0 && grp[0].Id != null) {

                caseRec.OwnerId = grp[0].Id;
                caseRec.Adverse_Media_Report__c = adverseMediaReport;
                caseRec.Reason_for_Adverse_Media_Report__c = mediaReportReason;
                update caseRec;
                if(isFileUploaded) {
                    base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
                    Attachment oAttachment = new Attachment();
                    oAttachment.parentId = caseId;
                    oAttachment.Body = EncodingUtil.base64Decode(base64Data);
                    oAttachment.Name = fileName;
                    oAttachment.ContentType = contentType;
                    insert oAttachment;
                }
                return 'SUCCESS';
            }
            else{
                return 'EDD Queue is not found';
            }
        } catch(Exception e) {
            System.debug('Exception Occured' + e.getMessage()+'At Line number' + e.getLineNumber());
            throw new AuraHandledException('Something went wrong: ' + e.getMessage());
        }
    }
}