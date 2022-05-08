/**
** @description A controller Controller class for DocumentsCase Lightning Component
* @author  Himani Joshi
* @version v1.0
* @since   2020-12-09
*/
public class DocumentsCaseController {
    /**
     * @description getAllDocuments description
     * @param caseId (Id): caseId
     * @return List<Document__c>: Return description
     */
    @AuraEnabled
	public static List<Document__c> getAllDocuments(Id caseId){
        Id oppId;
        List<Case>caseList=new CasesSelector().selectByIdWithComplaintInfoTOM(caseId,1);
        if(caseList.size()>0){
            oppId=caseList[0].opportunity__c;
        }
        List<Document__c>docList1=new DocumentsSelector().getDocsRelatedToOpp(oppId);
        List<Document__c>docList2=new DocumentsSelector().getDocsRelatedToCase(caseId);
        List<Document__c>docList=new List<Document__c>();
        for(Document__c doc1:docList1){
           docList.add(doc1); 
           }
        for(Document__c doc2:docList2){
            docList.add(doc2); 
            }        
        return docList;
    }

    
	/**
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param docId 
	 * @return String: Return description
	 **/
	@AuraEnabled
	public static String deleteDocument(Id docId){
		return DocumentManagementControler.deleteDocument(docId);
	}
    	/**
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param docId .
	 * @return String: Return description
	 **/
    @AuraEnabled
    public static String restrictSystemDocs(Id docId) {
        return DocumentManagementControler.restrictSystemDocs(docId);
    }
    
    	/**
	 * @description get record type
	 * @param recordId (Id): recordId
	 * @return Boolean: Return description
	 */
    @AuraEnabled
    public static Boolean getRecordTypeName(Id recordId){
        List<Case> caseList = new casesSelector().selectByCaseId(recordId);       
        String recordTypeName = caseList[0].RecordType.Name;
        if (recordTypeName == 'LDP Fulfilment'){
            return true;
            
        } else{
            return false;
            
        }

    }
}