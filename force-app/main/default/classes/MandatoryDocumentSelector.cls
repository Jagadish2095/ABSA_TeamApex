/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Mandatory Document objects
 *
 * @author  Tracy de Bruin
 * @since   July 2021
 */ 
public class MandatoryDocumentSelector extends fflib_SObjectSelector
{
    /**
    * @description getSObjectType description
    * @return Schema.SObjectType: Return description
    */
    public Schema.SObjectType getSObjectType(){
        return Mandatory_Doc__mdt.sObjectType;
    }

    /**
    * @description Returns all MandatoryDocument
    * @return List<Schema.SObjectField>
    */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Mandatory_Doc__mdt.label,
                Mandatory_Doc__mdt.Entity_Type__c,
                Mandatory_Doc__mdt.ECM_Type__c,
                Mandatory_Doc__mdt.Process_Name__c
                };
    }

    /**
    * @description Returns all MandatoryDocuments by Entity Type
    * @param Entitytype
    * @return List<Mandatory_Doc__mdt>
    */
    public List<Mandatory_Doc__mdt> getMandatoryDocumentsWithEntitytype(String Entitytype) {
        return (List<Mandatory_Doc__mdt>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Label') .
            selectField('Entity_Type__c') .
            selectField('ECM_Type__c') .
            selectField('Process_Name__c') .
            setCondition('Entity_Type__c = :Entitytype  AND Optional_Document__c = FALSE').
            toSOQL()
            );
    }

    /*  this method is exactly the same as above?? Tinashe */
    /**
    * @description Returns all MandatoryDocuments by Entity Type
    * @param Entitytype
    * @return List<Mandatory_Doc__mdt>
    */
    public List<Mandatory_Doc__mdt> getRelatedMandatoryDocumentsWithEntitytype(String Entitytype) {
        return (List<Mandatory_Doc__mdt>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Label') .
            selectField('Entity_Type__c') .
            selectField('ECM_Type__c') .
            selectField('Process_Name__c') .
            setCondition('Entity_Type__c = :Entitytype').
            toSOQL()
            );
        }

    /**
    * @description Get mandatory documents base of entity types
    * @param entityTypes
    * @return List<Mandatory_Doc__mdt>
    */
     public List<Mandatory_Doc__mdt> getMandatoryDocumentsByEntityTypes(Set<String> entityTypes) {
        return (List<Mandatory_Doc__mdt>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Label') .
            selectField('Entity_Type__c') .
            selectField('ECM_Type__c') .
            selectField('Process_Name__c') .
            setCondition('Entity_Type__c IN :entityTypes').
            toSOQL()
            );
    }
    
    /**
     * @description Get all Mandatory Documents
     * @return List<Mandatory_Doc__mdt> 
     */
    public List<Mandatory_Doc__mdt> getAllMandatoryDocuments() {
        return (List<Mandatory_Doc__mdt>) Database.query(
            newQueryFactory().
            selectField('Id') .
            selectField('Label') .
            selectField('Entity_Type__c') .
            selectField('ECM_Type__c') .
            selectField('Process_Name__c') .
            setCondition('Entity_Type__c != NULL AND ECM_Type__c != NULL').
            toSOQL()
            );
    }
}