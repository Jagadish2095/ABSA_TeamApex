/**@description ContentVersionTriggerHandler-will be invoked from Trigger-contentVersionTrigger to call Document classification and CIS services
* @description TestClass-ContentVersionTriggerTest
* @author  Prasanth Boggula
* @since 2021-06-12
* **/

public without sharing class ContentVersionTriggerHandler extends TriggerHandler {
    
    /***
* @comment : afterInsert 
* @description ContentVersion trigger afterInsert operations workflow handler method 
* @param newRecords           
* **/   
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {        
        
        map<id,ContentVersion> docIdContentVersionMap=new map<id,ContentVersion>();
        for(ContentVersion cVersion: (list<ContentVersion>)newRecords.values()){
            if(cVersion.ContentDocumentId != null){
                docIdContentVersionMap.put(cVersion.ContentDocumentId,cVersion);
                system.debug('ContentVersion.versiondata>>'+cVersion.versiondata);
            }
        }
        
        system.debug('-$$$$-docIdContentVersionMap...'+docIdContentVersionMap);
        if(docIdContentVersionMap.size()>0){
            //call the quable class here            
            ID jobID = System.enqueueJob(new ContentVersionQueueableHandler(docIdContentVersionMap));
            System.debug('jobID'+jobID);
        }                
    }
    
    /***
* @comment : getContentDocumentLink 
* @description this method queries the content document link records and send it to classify method.
* @param docIdContentVersionMap           
* **/
    public static void getContentDocumentLink(map<id,ContentVersion> docIdContentVersionMap){
        map<id,id> docIdAttachmentMap=new map<id,id>();
        Id ficCaseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('FIC Case').getRecordTypeId();
        string customLabelCaseRecordType=System.Label.CaseRecordTypes;
        if(!docIdContentVersionMap.isEmpty() && ContentDocumentLink.sObjectType.getDescribe().isAccessible()){
            for(ContentDocumentLink cdLink:[SELECT ContentDocumentId,LinkedEntityId,LinkedEntity.recordtype.name,LinkedEntity.recordtypeID,LinkedEntity.type   
                                            FROM ContentDocumentLink 
                                            WHERE ContentDocumentId IN:docIdContentVersionMap.keyset() ]){
                                                system.debug('$$$....before If Condition cdLink>>>>>'+cdLink);
                                                if(string.valueOf(cdLink.LinkedEntityId).startsWith('500') && customLabelCaseRecordType.contains(cdLink.LinkedEntity.Recordtype.name)){
                                                    docIdAttachmentMap.put(cdLink.ContentDocumentId,cdLink.LinkedEntityId);
                                                    system.debug('$$$...Inside if condition cdLink>>>>>'+cdLink);
                                                }               
                                            }
        }
        if(!docIdAttachmentMap.IsEmpty()){
            callingClassifyandCISService(docIdAttachmentMap);
        } 
    }
    
    /***
* @comment : callingClassifyandCISService 
* @description callingClassifyandCISService method to call CIS services 
* @param docIdAttachmentMap 
* **/   
    public static void callingClassifyandCISService( map<id,id> docIdAttachmentMap){
        system.debug('Tesr calling>>>>>>DocumentClassification'+docIdAttachmentMap);
        for(id Ids:docIdAttachmentMap.keyset()){
            map<id,id>docIdcaseIdsMap=new map<id,id>();
            docIdcaseIdsMap.put(Ids,docIdAttachmentMap.get(Ids));
            system.debug('docIdcaseIdsMap>>>'+docIdcaseIdsMap);
            DocumentClassification.classifyAndUploadToCISService(docIdcaseIdsMap,'');
        }
    }
}