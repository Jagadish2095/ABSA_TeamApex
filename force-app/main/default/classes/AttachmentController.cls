/**
* @description       : AttachmentController
* @author            : Vinod.Thupakula@absa.africa
* @group             :
* @last modified on  : 2021-11-24
* @last modified by  : Vinod.Thupakula@absa.africa
**/
public class AttachmentController {
    /** @description getAttachments
     * @param linkedId
     * @return List<ContentVersion>
     **/
    @AuraEnabled
    public static List<ContentVersion> getAttachments(String linkedId){
        
        List<ContentDocumentLink> CDLs = [Select ContentDocumentId 
                                          from ContentDocumentLink 
                                          where LinkedEntityId = : linkedId];
        
        if(CDLs != NULL && CDLs.size() > 0){
            Set<Id> CDIdList = new Set<Id>();
            for (ContentDocumentLink nextCDL : CDLs) {
                CDIdList.add(nextCDL.ContentDocumentId);
            }
            List<ContentVersion> CVList = [SELECT Id, ContentDocumentId, isLatest, Title, Description,PathOnClient 
                                           FROM ContentVersion 
                                           WHERE ContentDocumentId = :CDIdList AND isLatest = true AND FileType != 'SNOTE' Order By Description];
            
            return CVList;
        }
        else{
            List<ContentVersion> CV = new List<ContentVersion>();
            CV = NULL;
            return CV;
        }
    }
}