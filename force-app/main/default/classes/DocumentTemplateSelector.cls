/**
* @description Apex Enterprise Design Patters
* @description Selector layer for Document Template object
*
* @author  Kyle Alexander (CloudSmiths)
* @since   24/06/2019 
*/

public class DocumentTemplateSelector extends fflib_SObjectSelector{

    /**
     * @description getSObjectType description
     *
     * @return Schema.SObjectType: Return description
     */
    public Schema.SObjectType getSObjectType() {
        return Document_Template__c.sObjectType;
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {

        return new List<Schema.SObjectField>{

            Document_Template__c.Id,
                Document_Template__c.Name
                };
                    }

    /**
* @description Returns all associated OpportunityLineItems
*
* @param docName     The Opportunity Id
*
* @return  Document_Template__c   A list of Document_Template__c
*/
    public Document_Template__c selectTemplateByName(String docName) {

        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('XML__c').
            selectField('PID__c').
            selectField('Document_Type__c').
            selectField('Template_Id__c').
            selectField('ECM_Item_Type__c').
            selectField('Signature_Required__c').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            setCondition('Document_Type__c =: docName'). // Tinashe - Theory is the name and type are the same but because the name is limited to 80 so rather search by Type
            toSOQL()
        );
    }

        /**
    * @description Returns all associated Document_Template__c
    *
    * @param parentDocumentType    The Parent Document Type
    *
    * @return  List<Document_Template__c>   A list of Document_Template__c
    */
    public List<Document_Template__c> selectTemplateByParentDocumentType(String parentDocumentType){

        if (parentDocumentType == 'Other' || parentDocumentType == '' || parentDocumentType == null)
        return Database.query(
        newQueryFactory().
        selectField('Name').
        selectField('XML__c').
        selectField('PID__c').
        selectField('Document_Type__c').
        selectField('Template_Id__c').
        selectField('ECM_Item_Type__c').
        selectField('Signature_Required__c').
        selectField('Generate_Document__c').
        selectField('Generated_Document_Format__c').
        setCondition('Parent_Document_Type__c = ' +  null).
        toSOQL()
    );
    else
    return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('XML__c').
            selectField('PID__c').
            selectField('Document_Type__c').
            selectField('Template_Id__c').
            selectField('ECM_Item_Type__c').
            selectField('Signature_Required__c').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            setCondition('Parent_Document_Type__c =: parentDocumentType').
            toSOQL()
        );
    }

    /**
*
* @description Selector layer for Document Template object
*
* @author  Thulani Maseko
* @since   20/03/2020
* @param clientType
* @return List<Document_Template__c>
*/
    public List<Document_Template__c> selectTemplateByClientType(String clientType) {

        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            setCondition('Client_Type__c =: clientType').
            toSOQL()
        );
    }

    /**
     * @description selectTemplateNames description
     *
     * @return List<Document_Template__c>: Return description
     */
    public List<Document_Template__c> selectTemplateNames() {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            toSOQL()
        );
    }

    /**
     * @description selectTemplateByType description
     *
     * @param docType (String): docType
     * @return Document_Template__c: Return description
     */
    public Document_Template__c selectTemplateByType(String docType) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('XML__c').
            selectField('PID__c').
            selectField('Document_Type__c').
            selectField('ECM_Item_Type__c').
            selectField('ECM_Filing_Date_Metadata__c').
            selectField('ECM_ID_Number_Metadata__c').
            selectField('ECM_CIF_Code_Metadata__c').
            selectField('ECM_Origin_Metadata__c').
            selectField('ECM_Business_Unit_Metadata__c').
            selectField('ECM_Account_Number_Metadata__c').
            selectField('Signature_Required__c').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            setCondition('Document_Type__c =: docType').
            toSOQL()
        );
    }

    /**
     * @description getAllDocumentTemplates description
     *
     * @return List<Document_Template__c>: Return description
     */
    public List<Document_Template__c> getAllDocumentTemplates() {
        return (List<Document_Template__c>) Database.query('SELECT Id, CreatedDate, OwnerId, Signature_Required__c, Document_Type__c, Generate_Document__c, Generated_Document_Format__c, Document_Source__c FROM Document_Template__c');
    }
	
	/**
    * @description Returns all associated Document_Template__c by Mohammed Junaid U
    * @param parentDocumentType    The Parent Document Type
    * @return  List<Document_Template__c>   A list of Document_Template__c
    */
    public List<Document_Template__c> selectTemplateByECMItemType(String parentDocumentType){
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('XML__c').
            selectField('PID__c').
            selectField('Document_Type__c').
            selectField('Template_Id__c').
            selectField('ECM_Item_Type__c').
            selectField('Signature_Required__c').
            selectField('Generate_Document__c').
            selectField('Generated_Document_Format__c').
            setCondition('ECM_Item_Type__c =: parentDocumentType').
            toSOQL()
        );
    }
    /**
     * @description select Document Types based on ECM Type and Parent Document Type
     *
     * @param ecmTypes
     * @param opportunityType
     * @return List<Document_Template__c>
     */
    public List<Document_Template__c> selectByECMType(Set<String> ecmTypes, String opportunityType) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Parent_Document_Type__c').
            selectField('Document_Type__c').
            selectField('ECM_Item_Type__c'). 
            selectField('Generate_Document__c'). 
            setCondition('ECM_Item_Type__c IN :ecmTypes AND Opportunity_Record_Types__c INCLUDES(:opportunityType)').
            toSOQL()
        );
    }
}