/**
 * @description       : InvestmentOppUtility
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-10
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class InvestmentOppUtility {
    /**
	 * @description getRelatedDocuments
	 * @param  linkedId
	 * @return Map<Id,ContentDocument>
	 */
    public static Map<Id,ContentDocument> getRelatedDocuments(String linkedId){
        Map<Id,ContentDocument> contentDocumentsData = new Map<Id,ContentDocument>();
        if(String.isNotBlank(linkedId)){
            Set<Id> conDocIds = new Set<Id>();
            Set<String> fileTypes = new Set<String>();
            for(ContentDocumentLink conDocLink : [SELECT ContentDocumentId FROM ContentDocumentLink where  LinkedEntityId=:linkedId]){
                conDocIds.add(conDocLink.ContentDocumentId);
            }
            contentDocumentsData = new Map<Id,ContentDocument>([SELECT Id,Description,Title,FileExtension,FileType FROM ContentDocument WHERE ID IN:conDocIds Order By Description]);
        }
        return contentDocumentsData;
    }

    /**
	 * @description checkAllvalidDocuments
	 * @param  contentDocuments
     * @param  fileTypes
	 * @return String
	 */
    public static String checkAllvalidDocuments(List<ContentDocument> contentDocuments,List<String> fileTypes){
        String error = '';
        for(String fileType : fileTypes){
            boolean flag = true;
            for(ContentDocument contDoc : contentDocuments){
                if(contDoc.FileType != 'SNOTE' && fileType.equalsIgnorecase(contDoc.Description)){
                    flag = false;
                }
            }
            if(flag) {error += '\"'+fileType +'\", ';}
        }
        if(String.isNotBlank(error)) {
            error += 'File types are missing. Please upload the docs before you sending the email to client/customer.';
        }
        return error;
    }
    /**
	 * @description getRecordAccess
	 * @param  recordId
	 * @return boolean
	 */
    public static boolean getRecordAccess(Id recordId){
        return [SELECT RecordId,HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =:recordId LIMIT 1].HasEditAccess;
    }

    /**
	 * @description documentProcess
	 * @param  documentLinks
     * @param  attachments
	 */
    public static void documentProcess(List<ContentDocumentLink> documentLinks,List<Attachment> attachments){
        Set<Id> oppIds = new Set<Id>();
        Set<Id> emailMessageIds = new Set<Id>();
        if(documentLinks != null && documentLinks.size()>0){
            for(ContentDocumentLink docLinkId : documentLinks){
                if(docLinkId.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Opportunity'){
                    oppIds.add(docLinkId.LinkedEntityId);
                }
                if(docLinkId.LinkedEntityId.getSObjectType().getDescribe().getName() == 'EmailMessage'){
                    emailMessageIds.add(docLinkId.LinkedEntityId);
                }
            }
        }
        if(attachments != null && attachments.size()>0){
            for(Attachment attachment : attachments){
                if(attachment.ParentId.getSObjectType().getDescribe().getName() == 'Opportunity'){
                    oppIds.add(attachment.ParentId);
                }
                if(attachment.ParentId.getSObjectType().getDescribe().getName() == 'EmailMessage'){
                    emailMessageIds.add(attachment.ParentId);
                }
            }
        }
        if(emailMessageIds.size()>0){
            throw new SupportException('You cannot remove/delete this file because it has been shared to customer.');
        }
        if(oppIds.size()>0){
            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id IN:oppIds AND RecordType.Name='Investment Opportunity' AND Email_Status__c='Submitted' AND sub_status__C != 'Recommendation Stage'];
            if(!opps.isEmpty()){
                throw new SupportException('You cannot remove/delete this file because it has been shared to customer.');
            }
        }
    }

    /**
	 * @description getRequiredDocs
	 * @param  parentId
     * @return  List<String>
	 */
    public static List<String> getRequiredDocs(Id parentId){
        List<String> reqDoctypes = new List<String>();
        Note note = getNotes(parentId);
        if(note != null && note.Body != null){
            reqDoctypes.addAll(note.Body.split(';'));
        }
        return  reqDoctypes;
    }

    /**
	 * @description getRequiredDocs
	 * @param  parentId
     * @return  Note
	 */
    public static Note getNotes(Id parentId){
        try{
            return [SELECT Id,Body FROM Note WHERE ParentId =:parentId];
        }
        catch(Exception ex){
            return null;
        }
    }
    /**
	 * @description checkAllvalidDocuments
	 */
    public class SupportException extends Exception{}
}