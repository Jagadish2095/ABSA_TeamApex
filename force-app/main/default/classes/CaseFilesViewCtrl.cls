/**
* Apex controller class for the Aura bundle CaseFilesUpload.
* Allow a user to Add comments and Attach Files 
* When Case Recordtype is NBFS Dispute Resolution
* @author  Chenna
* @since   2020-09-11
*
**/
public class CaseFilesViewCtrl {
    @AuraEnabled 
    public static List<ContentVersion> fetchContentDocument(Id caseId){
        List<ContentVersion> cvList = new List<ContentVersion>();
        Set<id> cdIdSet = new Set<Id>();
        //List<ContentDocumentLink> cdlList = [Select id,ContentDocumentId From ContentDocumentLink where LinkedEntityId=:caseId];
        List<ContentDocumentLink> cdlList = new CasesSelector().selectByIdContentDocLink(caseId); //Added by divya
        if(cdlList.size() > 0){
        	for(ContentDocumentLink cdl : cdlList)
        	{
            	cdIdSet.add(cdl.ContentDocumentId);
            }
        	if(!cdIdSet.isempty()){
            	//cvList = [Select id,Title,FileType,LastModifiedBy.Name,ContentSize,Description,Owner.Name,LastModifiedDate,
                        //Comments__c,ContentDocumentId  from ContentVersion where ContentDocumentId IN :cdIdSet];
                 cvList =  new CasesSelector().selectByIdContentVersion(cdIdSet); //Added by divya
            }
        }
        return cvList;
    }
    @AuraEnabled
    public static ContentVersion saveCurrentRec(ContentVersion contentVsnObj) {
        
        try{
            update contentVsnObj;
        }
        catch(Exception ex){ 
            system.debug(LoggingLevel.FINE, '**uploadResult**'+ex.getMessage());
        }
        return contentVsnObj;
    }
    
    @AuraEnabled 
    public static String fetchCaseNo(Id caseId){
        //return [Select id, CaseNumber From Case where Id=:caseId].CaseNumber;
        list<case> casenum = new CasesSelector().selectByCaseId(caseId); //Added by divya
        return casenum[0].CaseNumber;
    }
    
    @AuraEnabled 
    public static string deleteDocument(String documentId){
        ContentDocument cdObj = new ContentDocument(Id=documentId);
         try{
            	delete cdObj;
            	return 'true';
        }catch(Exception e){
            return 'false';   
        }
    }
    
    
}