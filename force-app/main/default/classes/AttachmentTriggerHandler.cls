/**@description AttachmentTriggerHandler-will be invoked from Trigger-AttachmentTrigger to migrate the attachments to files 
* @description TestClass-AttachmentTriggerTest
* @author  Hari
* @since 2021-06-12
* **/

public without sharing class AttachmentTriggerHandler  extends TriggerHandler{

    /***
    * @comment : beforedelete
    * @description Attachment trigger before delete attachments
    * @param oldRecords
    * **/
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        Map<Id, Attachment> attachments = (Map<Id, Attachment>)oldRecords;
        InvestmentOppUtility.documentProcess(null,attachments.values());
    }
    /***
    * @comment : afterInsert 
    * @description Attachment trigger afterInsert operations workflow handler method 
    * @param newRecords           
    * **/       
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        set<id> attachmentIdsSet=new set<id>();
        set<id> parentIdSet=new set<id>();        
        for(Attachment attRec:(list<Attachment>)newRecords.values()){
            if(attRec.ParentId!=NULL && !(string.valueOf(attRec.ParentId).startsWith('00Q'))){
                if(string.valueOf(attRec.ParentId).startsWith('500') || string.valueOf(attRec.ParentId).startsWith('02s')){
                 attachmentIdsSet.add(attRec.id);
                 parentIdSet.add(attRec.ParentId);
             } 
           }
        }
        if(!attachmentIdsSet.Isempty()){            
            migrateAttachmentsToFiles(attachmentIdsSet,parentIdSet);
        }
    }
    
    /***
    * @comment : migrateAttachmentsToFiles 
    * @description future method to migrate the attachments to files
    * @param setOfAttachmentIds
    * @param parentIdSet
    * **/
    //@future
    
    public static void migrateAttachmentsToFiles(set<id> setOfAttachmentIds,set<id> parentIdSet) {        
        map<id,Attachment> attachmentsMap=new map<id,Attachment>();
        map<id,Case> caseMap=new map<id,Case>();
        map<id,id> attachmentCaseMap=new map<id,id>();
        map<id,EmailMessage> emailMessageMap=new map<id,EmailMessage>();
        String errorMessage;

        if(parentIdSet.size()>0 && Case.sObjectType.getDescribe().isAccessible()){
            for(Case caseRecord:[Select ID From Case Where Id IN: parentIdSet AND (Recordtype.name='FIC Case' OR Recordtype.name='Home Loans' OR Recordtype.name='AOL' OR Recordtype.name='AIC' OR Recordtype.name='DSP Sales')]){
                caseMap.put(caseRecord.id,caseRecord);            
            }
        }
        if(parentIdSet.size()>0 && EmailMessage.sObjectType.getDescribe().isAccessible()){
            for(EmailMessage em:[Select ID,parentId From EmailMessage Where Id IN: parentIdSet AND (parent.Recordtype.name = 'FIC Case' OR parent.Recordtype.name='Home Loans' OR parent.Recordtype.name='AOL' OR parent.Recordtype.name='AIC' OR parent.Recordtype.name='DSP Sales')]){
                emailMessageMap.put(em.id,em);
            }
        }
        if(setOfAttachmentIds.size()>0 && Attachment.sObjectType.getDescribe().isAccessible()){            
            for(Attachment attRec: [SELECT Id,Name,Body,ContentType,ParentId,OwnerId                                                                                                                   
                                  FROM Attachment  
                                  WHERE ID IN:setOfAttachmentIds AND ParentId!=NULL                                                   
                                  ]){
                if(string.valueOf(attRec.ParentId).startsWith('500') && caseMap.containsKey(attRec.ParentId)){
                    attachmentsMap.put(attRec.id,attRec);
                    attachmentCaseMap.put(attRec.id,attRec.ParentId);
                }
                else if(string.valueOf(attRec.ParentId).startsWith('02s') && emailMessageMap.containsKey(attRec.ParentId)){                 
                    attachmentsMap.put(attRec.id,attRec);
                    attachmentCaseMap.put(attRec.id,emailMessageMap.get(attRec.ParentId).parentId);
                }
            }            
        }
        
        //Actual File
        map<id, ContentVersion > contentVersionMap = new map<id,ContentVersion > ();        
        for(Attachment attach:attachmentsMap.values()){
            //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.ContentLocation = 'S';
            cVersion.PathOnClient = attach.Name;//File name with extention
            cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = attach.OwnerId;//Owner of the file
            cVersion.Title = attach.Name;//Name of the file
            cVersion.VersionData = attach.Body;//File content
            cVersion.Comments__c=attach.id;
            contentVersionMap.put(attach.id,cVersion);                        
        }
        //Insert the ContentVersion/actual files
        if(!contentVersionMap.isEmpty() && contentVersion.sObjectType.getDescribe().isCreateable()) {
            try{
                insert contentVersionMap.values();
                insertcontentDocumentLink(contentVersionMap.values(), attachmentsMap,attachmentCaseMap);  
            } catch(exception ex){
                errorMessage = 'Error: '+ex;
            }            
        }
    }
    
     /***
    * @comment : insertcontentDocumentLink 
    * @description method to share and attach to the Parent case records.
    * @param contentVersionList         
    * @param attachmentsMap
    * @param attachmentCaseMap
    * **/     
    public static void insertcontentDocumentLink(list<ContentVersion> contentVersionList, map<id,Attachment> attachmentsMap,map<id,id> attachmentCaseMap) {
        //Its Sharing and Parent records attachability.
        list<ContentDocumentLink > contentDocumentLinkList = new list<ContentDocumentLink > ();
        String errorMessage;
        //it holds the list of attachments for delete 
        list<Attachment> deleteAttachmentList=new list<Attachment>();
        if(!ContentVersionList.isEmpty() && contentVersion.sObjectType.getDescribe().isAccessible()) {
            ContentVersionList=[select id,ContentDocumentId,Comments__c 
                               from ContentVersion 
                               WHERE Id in: ContentVersionList];
        }
        //Attach to the parent case and enable sharing
        for (ContentVersion cVersion: contentVersionList) {
            //to link the attachment to the parent case record.
            if(cVersion.Comments__c!=NULL && attachmentsMap.containsKey(cVersion.Comments__c)){
                Attachment attach= attachmentsMap.get(cVersion.Comments__c);
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cVersion.ContentDocumentId;
                //Shared with Case record
                cl.LinkedEntityId = attachmentCaseMap.get(cVersion.Comments__c);
                cl.ShareType = 'V';
                cl.Visibility = 'AllUsers';
                contentDocumentLinkList.add(cl);                
                //add the attchments for deletion process
                deleteAttachmentList.add(attach);
            }            
        }
        //Insert the ContentDocumentLink records        
        try{
            if(contentDocumentLinkList.size() > 0 && ContentDocumentLink.sObjectType.getDescribe().isCreateable()) {
                insert contentDocumentLinkList;
                deleteAttachmentsMigratedToFiles(deleteAttachmentList);
            }               
        } catch(exception ex){
            errorMessage = 'Error: '+ex;
        }
    }
    
    /***
    * @comment : deleteAttachmentsMigratedToFiles 
    * @description method to call delete the attachment records after migrated to files.
    * @param deleteAttachmentList         
    * **/     
    public static void deleteAttachmentsMigratedToFiles(list<Attachment> deleteAttachmentList) {        
        String errorMessage;
        try{
            if(deleteAttachmentList.size()>0 && Attachment.sObjectType.getDescribe().isDeletable()) { 
                delete deleteAttachmentList;
            }            
        } catch(exception ex){
            errorMessage = 'Error: '+ex;
        }
    }
}