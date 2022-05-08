/*
 * MLStatementOnDemandController for Statement On Demand
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-03
 * @W-
 */

public class MLStatementOnDemandController {
    @AuraEnabled
    public static String getStatementOnDemand(
        Integer numberOfMonths,
        Integer accountType,
        String accountNumber,
        String emailAddress,
        Id caseId,
        String emailTemplate,
        String fileName
    ) {
        MLRetrieveOnDemandStatement_Resp_IB_v1 responseBean = MLRetrieveOnDemandStatement_IH_v1.onDemandStatementRequest(
            numberOfMonths,
            accountType,
            accountNumber
        );
        if (responseBean == null) {
            return 'Error: Blank response received from service';
        }

        if (String.isNotBlank(responseBean.error)) {
            return 'Error: Unexpected response received from service. Message: ' + responseBean.error;
        }

        if (responseBean.statusCode != 200) {
            return 'Error: Unexpected response received from service. Status Code: ' + responseBean.statusCode + '. Message: ' + responseBean.message;
        }

        sendEmail(caseId, emailTemplate, emailAddress, fileName, responseBean.statements);
        return 'success';
    }

    @AuraEnabled
    public static String caseStatusUpdate(String caseId) {
        Case caseObj = new Case(Id = caseId, Status = 'Closed', Bypass_Validation_Rules__c = true);
        try {
            update caseObj;
        } catch (exception e) {
            return e.getMessage();
        }
        return 'success';
    }

    public static void sendEmail(Id caseId, String emailTemplate, String emailAddress, String fileName, String pdfData) {
        Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id;
        List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress, emailTemplate);

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(constructEmail.get(0).getSubject() + ' - ' + fileName);
        mail.setSaveAsActivity(true);
        mail.setToAddresses(new List<String>{ emailAddress });
        mail.setHtmlBody(constructEmail.get(0).getHtmlBody());
        mail.setOrgWideEmailAddressId(NotifyBankerController.getOrgWideEmailAddressId(caseId));

        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(fileName + '.pdf');
        efa.setBody(EncodingUtil.base64Decode(pdfData));
        fileAttachments.add(efa);
        mail.setFileAttachments(fileAttachments);
        mails.add(mail);

        Messaging.sendEmail(mails);
        NotifyBankerController.emailActivities(mail, caseId);
    }
}