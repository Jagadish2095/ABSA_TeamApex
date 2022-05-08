/**
 * @author  Nikolay Kibalov
 * @since   2021-07-01
 * @description : FIC_TransferEmailCaseController
**/
public with sharing class FIC_TransferEmailCaseController {
    /**
        *@description  : Case transfer and send an email if needed
        *@comment : Case transfer
            *@param caseId
            *@param selectedOption
            *@param departmentSelected
            *@param emailSubject
            *@param emailsBody
     **/
    @AuraEnabled
    public static void transferCase(Id caseId, String selectedOption, String departmentSelected, String emailSubject, String emailsBody) {
        String emailAddress;
        Case transferCase = [SELECT Id, OwnerId, Status FROM Case WHERE Id =: caseId];
        Map<String, String> departmentToEmailAddress = new Map<String, String>();
        departmentToEmailAddress.put('Non-Res', 'jhbnonreshub@absa.co.za');
        departmentToEmailAddress.put('Business Bank', 'Mybusinessbanker@absa.co.za');
        departmentToEmailAddress.put('Private Bank', 'privatebanking@absa.co.za');
        departmentToEmailAddress.put('Admin Team', 'Admins@absa.africa');

        if(selectedOption == 'Email not relevant, send case to junk queue') {
            Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'FIC_Archive'];
            transferCase.OwnerId = gQueue.Id;
            transferCase.Status = 'Junk mail';
        } else if (selectedOption == 'Email relevant to other department') {

            emailAddress = departmentToEmailAddress.get(departmentSelected);

            String[] toAddress = new String[] {emailAddress};
            String emailBody = emailsBody;
            String subject = emailSubject;

            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            emailMessage.setToAddresses(toAddress);
            emailMessage.setSubject(subject);
            emailMessage.setHtmlBody(emailBody);
            emailMessage.saveAsActivity = false;

            List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :caseId];
            List<ContentVersion> uploadedFiles = new List<ContentVersion>();
            if (contentDocumentLinks.size() > 0)
            {
                List<Id> contentDocumentLinkIds = new List<Id>();
                for (ContentDocumentLink contentDocumentLink : contentDocumentLinks ) contentDocumentLinkIds.add(contentDocumentLink.ContentDocumentId);
                uploadedFiles = [SELECT Id, ContentDocumentId, Title, FileType, FileExtension, VersionData
                FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentLinkIds];
            }
            //Build attachments list.
            for(ContentVersion uploadedFile : uploadedFiles) {
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setBody(uploadedFile.VersionData);
                attachment.setFileName(uploadedFile.Title+'.'+uploadedFile.FileExtension);
                attachments.add(attachment);
            }
            //Add all attachments to email.
            emailMessage.setFileAttachments(attachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailMessage});

            if(departmentSelected == 'Non-Res'){
                Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Awaiting_Documents'];
                transferCase.OwnerId = gQueue.Id;
            }

        } else if (selectedOption == 'Manually send an email to the relevant recipient group') {
            Group gQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'FIC_Archive'];
            transferCase.OwnerId = gQueue.Id;
            transferCase.Status = 'nonFicRelated';
        }
        update transferCase;
    }
}