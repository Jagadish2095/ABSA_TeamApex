/**
* Document trigger handler
* @author  Tinashe M Shoko
* @created 2020-19-07
* @description DocumentTriggerHandler
*/
public class DocumentTriggerHandler {
    /**
     * @description handleTrigger
     * @param workingRecords
     * @param oldRecords
     * @param triggerEvent
     **/
    public static void handleTrigger(List<Document__c> workingRecords, List<Document__c> oldRecords, System.TriggerOperation triggerEvent ) {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> appIds = new Set<Id>();
        list<Document__c>LstDocument=new list<Document__c>();
        list<Document__c>LstCaseDocument=new list<Document__c>();
        list<Document__c>Rectoupdate=new list<Document__c>();
        list<String>str=new list<String>();
        switch on triggerEvent {
            when AFTER_INSERT, AFTER_UPDATE {      
                //handle after insert and/or after update
                for (Document__c doc : workingRecords) {
                    if (doc.Document_Status__c == 'Signed' || doc.Document_Status__c == 'Signed Manually') {
                        if ( doc.Type__c == 'Ent_Quotation') {
                            System.assert(true);
                            //oppIds.add(doc.Opportunity__c); // populate a list for bulkify purposes
                            //} else if ( doc.Type__c == 'Application Form') {
                            //    appIds.add(doc.Opportunity__c); // populate a list for bulkify purposes
                        } else {
                            system.debug('Document of type ' + doc.Type__c + ' has been signed.');
                        }
                    }
                    if(triggerEvent==TriggerOperation.AFTER_UPDATE && doc.Type__c!=null && doc.File_Id__c!=null && doc.File_Id__c.startsWith('069') ){
                            LstDocument.add(doc);
                        	
                        }
                }
                
                 for (Document__c doc : workingRecords) {
                    
                    if(triggerEvent==TriggerOperation.AFTER_INSERT && doc.Case_External_Reference__c!=null && !string.isblank(doc.Case_External_Reference__c) ){
                            LstCaseDocument.add(doc);
                        system.debug('List of case documents'+LstCaseDocument);
                            str.add(doc.Case_External_Reference__c);
                        system.debug('List of case documents'+doc.Case_External_Reference__c);
                        }
                }
            }
           
            
            when else {
                //do nothing for AFTER_UNDELETE, BEFORE_DELETE, or BEFORE_UPDATE
                System.debug('Unhandled trigger Operation - DocumentTriggerHandler');
            }
        }
        system.debug('LstDocument>>>'+LstDocument);
        if(!LstDocument.IsEmpty()){
           map<id,id>docIdAttachmentMap=new map<id,id>();
           docIdAttachmentMap.put(LstDocument[0].File_Id__c,LstDocument[0].case__c);
         
            system.debug('DocumentClassification.IsDocumentUpsert>>'+DocumentClassification.IsDocumentUpsert);
            if(DocumentClassification.IsDocumentUpsert==false){
            DocumentClassification.classifyAndUploadToCISService(docIdAttachmentMap,LstDocument[0].Type__c);
            } 
        }
        
        if(!LstCaseDocument.IsEmpty()){
            
            map<string,string> casedocs=new map<string,string>();
            List<Case> cslst = [Select id,External_Reference_Number__c from case where External_Reference_Number__c IN:str ];
            for(Case caselst: cslst){
                casedocs.put(caselst.External_Reference_Number__c,caselst.Id);
                system.debug('Case docsmap' +casedocs.values());
            }
            for(Document__c doccase:LstCaseDocument){
                Document__c doct = new Document__c(Id=doccase.Id);
                if(casedocs.containskey(doccase.Case_External_Reference__c)){
                    doct.case__c = casedocs.get(doccase.Case_External_Reference__c);
                Rectoupdate.add(doct);
                }
                
            }
            if(!Rectoupdate.IsEmpty()){
                update Rectoupdate;
            }
            
        }
        
       
    }
}