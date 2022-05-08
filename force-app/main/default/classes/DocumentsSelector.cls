/**
* @description A controller for retrieving and updating ECM documents.
* @author Troy Clark.
* @created 2019-03-31
**/

public class DocumentsSelector extends fflib_SObjectSelector {
    /**
     * @description getSObjectType description
     *
     * @return Schema.SObjectType: Return description
     */
        public Schema.SObjectType getSObjectType(){
            return Document__c.sObjectType;
        }
    
        /**
         * @description getSObjectFieldList description
         *
         * @return List<Schema.SObjectField>: Return description
         */
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> {
                Document__c.Id,
                    Document__c.Name,
                    Document__c.Account__c,
                    Document__c.Asset__c,
                    Document__c.Case__c,
                    Document__c.Content_Size__c,
                    Document__c.CreatedById,
                    Document__c.Extension__c,
                    Document__c.LastModifiedById,
                    Document__c.Type__c,
                    Document__c.Link__c,
                    Document__c.Reference__c,
                    Document__c.Document_Audit_Count__c,
                    Document__c.Opportunity__c
                    };
                        }
    /**
    * @description Method that gets a list of documents based on parent ID and parent type
    * Added by Robert McLean
    * @Updated 2019-07-29
    * @param parentId - Document__c ID
    * @param parentType - Document__c ID
    * @param recordLimit - Limit list
    * @return List<Document__c> - List of Documents
    *
    */
        public List<Document__c> getDocuments(Id parentId, String parentType, Integer recordLimit) {
            return (List<Document__c>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Name') .
            selectField('Account__c') .
            selectField('Asset__c') .
            selectField('Case__c') .
            selectField('Content_Size__c') .
            selectField('CreatedById') .
            selectField('Extension__c') .
            selectField('LastModifiedById') .
            selectField('Link__c') .
            selectField('Reference__c') .
            selectField('Type__c') .
            selectField('Opportunity__c').
            selectField('Document_Status__c').
            selectField('Parent_Document_Name__c') .
            selectField('Owner.Name') .
            selectField('CreatedDate').
            setCondition('Opportunity__c = :parentId OR Case__c = :parentId OR Account__c = :parentId OR Contact__c = :parentId OR Asset__c = :parentId  OR Security_Offered__c =: parentId OR Application_Product__c =: parentId'). // Tinashe W-005546 - so we can include the component to view docs on other Object record pages
            addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            setLimit(recordLimit).
            toSOQL()
            );
        }
    
    /**
    * @description Method that gets a single document by Id
    *
    * @param documentId - Document__c ID
    * @return Document__c - single Document
    */
        public Document__c selectById(Id documentId) {
													
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Parent_Document__c').
                selectField('Opportunity__c').
                selectField('Signed__c').
                selectField('Case__c').
                selectField('Document_Status__c').
                setCondition('Id =: documentId').
                toSOQL()
            );
        }
        // added by saiteja 
            /**
    *@description Method that gets a single document by Id
    *
    * @param documentId - Document__c ID
    * @return Document__c - single Document
    */
        public List<Document__c> selectByDocsId(Id documentId) {
												   
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Signed__c').
                selectField('Document_Status__c').
                selectField('Owner.Name').
                selectField('CreatedDate') .
                selectField('Account__r.Name').
                selectField('Name').
                setCondition('Id =: documentId').
                toSOQL()
            );
        }
            /**
    *@description Method that gets a single document by Id
    *
    * @param AccountId
    * @return Document__c - single Document
    */
         public List<Document__c> selectByAccountId(Id AccountId) {
												 
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Signed__c').
                selectField('Document_Status__c').
                selectField('Owner.Name').
                selectField('CreatedDate') .
                selectField('Account__r.Name').
                selectField('Name').
                setCondition('Account__c =: AccountId').
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                setLimit(1).
                toSOQL()
            );
        }
    
        /**
        *@description Method that gets a single document by contactId
        *
        * @param contact
        * @return Document__c - single Document
        */
        public List<Document__c> selectByContactId(String contact) {
												
            Id contactId = (Id)contact;
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Parent_Document__c').
                selectField('Opportunity__c').
                selectField('Signed__c').
                selectField('Contact__c').
                selectField('Type__c').
                selectField('Document_Status__c').
                setCondition('Contact__c =: contactId').
                toSOQL()
            );
        }
    
    /**
    * @description Method that gets a single document by Id
    *
    * @param caseId -  ID
    * @return Document__c - single Document
    */
        public Document__c selectByCaseId(Id caseId) {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Parent_Document__c').
                selectField('Opportunity__c').
                selectField('Signed__c').
                selectField('Case__c').
                selectField('Document_Status__c').
                setCondition('Case__c =: caseId').
                setLimit(1).
                toSOQL()
            );
        }
    
        /**
         * @description selectDocumentsByOppId description
         *
         * @param oppId (Id): oppId
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectDocumentsByOppId(Id oppId){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Name') .
                selectField('Type__c') .
                selectField('Owner.Name') .
                selectField('OwnerId') .
                selectField('CreatedDate') .
                selectField('Document_Status__c') .
                selectField('Account__c').
                selectField('Contact__c').
                selectField('Account__r.Name').
                selectField('Contact__r.Name').
                selectField('Covenant__c').
                selectField('ECM_Type__c').
                selectField('Salesforce_File_Id__c').
                selectField('Reference__c').
                selectField('Application_Vehicle_Make_Model__c').
                selectField('Type__c').
                selectField('Salesforce_File_Id__c').
			    selectField('Reference__c').
                selectField('Opportunity__r.Name').
                selectField('Application_Product_CAF__c').
                selectField('Deleted__c').
                selectField('Security_Offered__c').
                selectField('Source_System__c').
                selectField('Generated_Uploaded__c').
                selectField('Generate_Document__c').
                setCondition('(Opportunity__c = :oppId OR Case__c = :oppId OR Account__c = :oppId OR Contact__c = :oppId OR Asset__c = :oppId OR Security_Offered__c =: oppId  OR Application_Product__c =: oppId OR Covenant__c =: oppId) AND (Deleted__c = false)').
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                toSOQL()
            );
        }
    
        /**
         * @description selectByDocId description
         *
         * @param docId (Id): docId
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectByDocId(Id docId){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Reference__c') .
                setCondition('Id = :docId').
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                toSOQL()
            );
        }
    
        /**
        * author Tinashe Shoko - W-004373
        * @description Select Quote documents for the given Opportunity
        * 2020-07-14
         * @param oppId (Id): oppId
         * @param docType (String): docType
         * @return List<Document__c>: Return description
        */
        public List<Document__c> selectByTypeAndOppId(Id oppId, String docType){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Reference__c') .
                selectField('Document_Status__c') .
                selectField('Name') .
                setCondition('Opportunity__c =: oppId AND Type__c =: docType').
                addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                toSOQL()
               );
        }
    
        /**
        * Danie Booysen
        * @description Select Documents for the given Opportunity, Set of Document Types & Set of Statuses
        * 2020-08-07
         * selectByStatusTypeAndOppId description
         *
         * @param oppId (Id): oppId
         * @param docTypeSet (Set<String>): docTypeSet
         * @param statusSet (Set<String>): statusSet
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectByStatusTypeAndOppId(Id oppId, Set<String> docTypeSet, Set<String> statusSet){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Reference__c') .
                selectField('Document_Status__c') .
                selectField('Name') .
                setCondition('Opportunity__c =: oppId AND Type__c IN: docTypeSet AND Document_Status__c IN: statusSet').
                addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                toSOQL()
               );
        }
    
        /**
        * W-004392 - Documents Menu
        * @Author - Tinashe M Shoko
        * @Created 20200915
         * @description getOppDocuments description
         *
         * @param opportunityId (Id): opportunityId
         * @param accountId (Id): accountId
         * @return List<Document__c>: Return description
         */
        public List<Document__c> getOppDocuments(Id opportunityId, Id accountId) {
            return (List<Document__c>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Name') .
            selectField('Account__c') .
            selectField('Asset__c') .
            selectField('Case__c') .
            selectField('Content_Size__c') .
            selectField('CreatedById') .
            selectField('Extension__c') .
            selectField('LastModifiedById') .
            selectField('Link__c') .
            selectField('Reference__c') .
            selectField('Type__c') .
            selectField('Contact__c').
            selectField('Opportunity__c').
            selectField('Document_Status__c').
            selectField('Parent_Document_Name__c') .
            selectField('Owner.Name') .
            selectField('CreatedDate').
            selectField('ECM_Type__c').
            selectField('LastModifieddate').
            selectField('Required__c').
            selectField('Source_System__c').
            selectField('File_Id__c').
            setCondition('Opportunity__c =: opportunityId AND Type__c != null'). // Tinashe W-005546 - so we can include the component to view docs on other Object record pages
            toSOQL()
            );
        }
    
        /**
        * Tinashe Shoko - Certificates
        * @description Select certificates documents for the given Accounty
        * 2020-11-10
         * selectCerts description
         *
         * @param accId (Id): accId
         * @param docTypeSet (Set<String>): docTypeSet
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectCerts(Id accId, Set<String> docTypeSet){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Opportunity__c').
                setCondition('Account__c =: accId AND Opportunity__c = null AND Type__c IN: docTypeSet').
                toSOQL()
               );
        }

        /**
	* @description Select certificates documents for the given related Account 
	* @param accId set<Id> : accId
	* @param docTypeSet (Set<String>): docTypeSet
	* @return List<Document__c>: Return description
	*/
    public List<Document__c> selectCertRelatedParty(set<Id> accId, Set<String> docTypeSet){
        return (List<Document__c>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Opportunity__c').
            setCondition('Account__c IN: accId AND Opportunity__c = null AND Type__c IN: docTypeSet').
            toSOQL()
        );
    }
    
        /**
         * @description selectByContactId description
         *
         * @param contactIds (set<Id>): contactIds
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectByContactId(set<Id> contactIds) {
												   
            // Id contactId = (Id)contact;
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('Parent_Document__c').
                selectField('Opportunity__c').
                selectField('Signed__c').
                selectField('Contact__c').
                selectField('Type__c').
                selectField('Document_Status__c').
                selectField('ECM_Type__c').
                setCondition('Contact__c IN: contactIds OR Case__c in : contactIds').
                toSOQL()
            );
        }
    
        /**
         * @description getDocsRelatedToOpp description
         *
         * @param opportunityId (Id): opportunityId
         * @return List<Document__c>: Return description
         */
        public List<Document__c> getDocsRelatedToOpp(Id opportunityId) {
            return (List<Document__c>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Name') .
            selectField('Account__c') .
            selectField('Asset__c') .
            selectField('Case__c') .
            selectField('Content_Size__c') .
            selectField('CreatedById') .
            selectField('Extension__c') .
            selectField('LastModifiedById') .
            selectField('Link__c') .
            selectField('Reference__c') .
            selectField('Type__c') .
            selectField('Contact__c').
            selectField('Opportunity__c').
            selectField('Document_Status__c').
            selectField('Parent_Document_Name__c') .
            selectField('Owner.Name') .
            selectField('CreatedDate').
            selectField('ECM_Type__c').
            selectField('LastModifieddate').
            selectField('Required__c').
            selectField('Source_System__c').
            selectField('File_Id__c').
            selectField('Application_Product_CAF__c').
            setCondition('Opportunity__c =: opportunityId').
            toSOQL()
            );
        }
    
        /**
         * @description getDocsRelatedToCase description
         *
         * @param caseId (Id): caseId
         * @return List<Document__c>: Return description
         */
        public List<Document__c> getDocsRelatedToCase(Id caseId) {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Reference__c').
                selectField('File_Id__c').
                selectField('Parent_Document__c').
                selectField('Opportunity__c').
                selectField('Signed__c').
                selectField('Contact__c').
                selectField('Type__c').
                selectField('Document_Status__c').
                selectField('ECM_Type__c').
                selectField('createddate').
                selectField('Name').
                selectField('Owner.Name').
                setCondition('case__c =: caseId').
                toSOQL()
            );
        }
    
        /**
        * @description selectDocumentBycaseId
        * @param caseId
        * @return Document__c - single Document
        */
    
         public document__c selectDocumentBycaseId(String caseId){
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Case__c').
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                setCondition('Case__c =: CaseId').
                setLimit(1).
                toSOQL()
            );
           // return [select id from document__c where case__c =:CaseId order by Createddate desc limit 1];
        }
        // Added by Prashanth Boeni
         /**
        * @description selectDocumentBycaseId
        * @param caseIds
        * @return Document__c - single Document
        */
        public List<Document__c> selectByCaseIds(set<Id> caseIds) {
											  
            return Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Name') .
                selectField('Account__c') .
                selectField('Signed__c').
                selectField('Asset__c') .
                selectField('Case__c') .
                selectField('Content_Size__c') .
                selectField('CreatedById') .
                selectField('Extension__c') .
                selectField('LastModifiedById') .
                selectField('Link__c') .
                selectField('Reference__c') .
                selectField('Type__c') .
                selectField('Contact__c').
                selectField('Opportunity__c').
                selectField('Document_Status__c').
                selectField('Parent_Document_Name__c') .
                selectField('Owner.Name') .
                selectField('CreatedDate').
                selectField('ECM_Type__c').
                selectField('LastModifieddate').
                selectField('Required__c').
                selectField('Source_System__c').
                selectField('File_Id__c').
                setCondition('Case__c IN: caseIds').
                toSOQL()
            );
        }
    
    /**
         *Author-Himan
         *Return type list of document
     * @description selectDocumentListBycaseId description
     *
     * @param CaseId (String): CaseId
     * @return List<document__c>: Return description
     */
        public List<document__c> selectDocumentListBycaseId(String CaseId)
        {
            return getActiveDocumentBycaseId(CaseId);
        }
    
        /**
         * @description getActiveDocumentBycaseId description
         *
         * @param CaseId (String): CaseId
         * @return List<document__c>: Return description
         */
        public List<document__c> getActiveDocumentBycaseId(String CaseId)
        {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                selectField('Reference__c').
                setCondition('Case__c =: CaseId AND IsActive__c = true').
                toSOQL()
            );
        }
    
        /**
         * @description selectByDocId description
         *
         * @param documentIds (Set<string>): documentIds
         * @return List<Document__c>: Return description
         */
        public List<Document__c> selectByDocId(Set <string> documentIds)
        {
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                selectField('Reference__c').
                setCondition('Id IN: documentIds').
                toSOQL()
            );
        }
    
        /**
        * @description
        * @param accId
        * @param docType
        * @return List<Document__c>
        **/
        public List<Document__c> selectByTypeAndaccId(Id accId, String docType){
            return (List<Document__c>) Database.query(
                newQueryFactory().
                selectField('Id') .
                selectField('Reference__c').
                selectField('Account__c').
                selectField('Name').
                selectField('Type__c').
                selectField('Document_Sub_Type__c'). // Added the fields to capture the document subtype which is uploaded to Amber by Mohammed
                setCondition('Account__c =: accId AND Type__c =: docType').
                addOrdering('CreatedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
                setLimit(1).
                toSOQL()
               );
        }
    }