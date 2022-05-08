/**
 * @description       :TriggerHandlerContentDocument
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-24
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public with sharing class TriggerHandlerContentDocument extends TriggerHandler{
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        Map<Id, ContentDocument> deleteContentDocuments = (Map<Id, ContentDocument>)oldRecords;
        List<ContentDocumentLink> contentDocumentLinks = [SELECT LinkedEntityId FROM ContentDocumentLink where  ContentDocumentId IN:deleteContentDocuments.keySet()];
        InvestmentOppUtility.documentProcess(contentDocumentLinks,null);
    }
}