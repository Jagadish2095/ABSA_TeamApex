/**
* @description STIFileUploadController
* @param  documentId String ContentDocument Object Id 
* @param  recordId String Opportunity Object Id
* @param description String DocumentType uploaded
* @return All ContentDocument object 
**/
public with sharing class STIFileUploadController {
    /** @description UpdateFiles
     * @param documentId
     * @param recordId
     * @param description
     * @return List<ContentDocument>
     **/
    @AuraEnabled 
    public static List<ContentDocument> UpdateFiles(string documentId,string recordId,string description){
        
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record
        cd.Description = description;
        try{
            update cd;  // Update ContentDocument (File)
        } 
        catch(DMLException e){ 
            string s= e.getMessage();
        }
        
        List<ContentDocument>  DocumentList=getFiles(recordId);
        return DocumentList;
    }
    /** @description getFiles
     * @param recordId
     * @return List<ContentDocument>
     **/
    @AuraEnabled
    public static List<ContentDocument> getFiles(string recordId){
        List<ContentDocument> DocumentList = new List<ContentDocument>();        
        Set<Id> documentIds = new Set<Id>();
        
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];
        for(ContentDocumentLink cdLink:cdl){
            documentIds.add(cdLink.ContentDocumentId);
        } 
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds AND FileType != 'SNOTE' Order By Description];
        return DocumentList;
    }
    /** @description uploadFiles
     * @param recordId
     * @param docId
     **/
    @AuraEnabled
    public static void uploadFiles(string recordId,String docId){
        if(!Test.isRunningTest()){
            MVP2_NoContactNoticeController.getUplodeEcm(docId);
        }
    }
    /** @description getDocumentTypes
     * @param oppId
     * @return List<String>
     **/
    @AuraEnabled
    public static List<String> getDocumentTypes(Id oppId){
        List<String> options = new List<String>();
        for(String str : InvestmentOppUtility.getRequiredDocs(oppId)){
            options.add(str);
        }
        return options;
    }
    /** @description saveDocTypes
     * @param recordId
     * @param docTypes
     **/
    @AuraEnabled
    public static void saveDocTypes(Id recordId,List<String> docTypes){
        if(String.isNotBlank(recordId)){
            Note notes = InvestmentOppUtility.getNotes(recordId);
            Note newNote = new Note();
            if(notes != null){
                newNote.Id = notes.Id;
            }else{
                newNote.ParentId = recordId;
            }
            newNote.IsPrivate = true;
            newNote.Title = 'RequiredDocuments';
            newNote.Body = String.join(docTypes, ';');
            upsert newNote;
        }
    }
}