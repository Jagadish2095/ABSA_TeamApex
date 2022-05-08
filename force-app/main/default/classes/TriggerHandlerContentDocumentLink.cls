/**
 * @description       : TriggerHandlerContentDocumentLink
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-24
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public with sharing class TriggerHandlerContentDocumentLink extends TriggerHandler{
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        Map<Id, ContentDocumentLink> deleteContentDocumentslinks = (Map<Id, ContentDocumentLink>)oldRecords;
        InvestmentOppUtility.documentProcess(deleteContentDocumentslinks.values(),null);
    }
}