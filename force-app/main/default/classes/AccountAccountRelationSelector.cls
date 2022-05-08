/**
* @description Apex Enterprise Design Patterns
* Selector Layer for AccountAccountRelation objects
*
* @author       Chandra (ABSA)
* @since        2020-07-26
*/

public class AccountAccountRelationSelector  extends fflib_SObjectSelector {

    /**
    *@description MANDATORY ABSTRACT METHODS - START
    *@param 
    *@return 
    */
    public Schema.SObjectType getSObjectType() {
        return FinServ__AccountAccountRelation__c.sObjectType;
    }

    /**
    *@description Get fields
    *@param 
    *@return List<Schema.SObjectField>
    */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                FinServ__AccountAccountRelation__c.Id,
                FinServ__AccountAccountRelation__c.FinServ__Account__c,
                FinServ__AccountAccountRelation__c.FinServ__RelatedAccount__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    /**
    *@description Select by Id
    *@param idSet
    *@return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectById(Set<Id> idSet) {
        return (List<FinServ__AccountAccountRelation__c>) selectSObjectsById(idSet);
    }

    /**
    * @description Chandra (26/07/2020)
    * @param primaryEntityId
    * @param relatedAccountId
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectbyPrimaryEntityIdAndRelatedAccId(String primaryEntityId, Id relatedAccountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            setCondition('Primary_Entity_Id__c =: primaryEntityId AND FinServ__RelatedAccount__c =: relatedAccountId').
            toSOQL()
        );
    }
    
    /**
    * @description Account-Accountt Relations
    * @Owner: Chandra (26/07/2020)
    * @param accAccRelId
    * @return FinServ__AccountAccountRelation__c
    */
    public FinServ__AccountAccountRelation__c selectbyAccAccRelId(Id accAccRelId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__RelatedAccount__r.ID_Type__c').
            selectField('FinServ__RelatedAccount__r.Name').//updated by amit   
            selectField('FinServ__RelatedAccount__r.Months_Since_Shareholding__c').//updated by amit
            selectField('FinServ__RelatedAccount__r.FinServ__RelationshipStartDate__c').
            setCondition('Id =: accAccRelId').
            toSOQL()
        );
    }
    
    /**
    * @description returns Account-Accountt Relations
    * @Owner: Chandra (26/07/2020)
    * @param primaryEntityId
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectbyPrimaryEntityId(String primaryEntityId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('Primary_Entity_Id__c =: primaryEntityId').
            toSOQL()
        );
    }
    
  /**
    * @description Returns Account-Accountt Relations
    * @Owner: Chandra (26/07/2020)
    * @param primaryEntityId
    * @param accountId
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectbyLevel0RelatedParty(String primaryEntityId, Id accountId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            selectField('FinServ__RelatedAccount__r.ID_Type__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('Roles__c').
            selectField('Primary_Entity_Id__c').
            selectField('Client_Type__c').
            setCondition('Primary_Entity_Id__c =: primaryEntityId AND FinServ__Account__c =: accountId').
            toSOQL()
        );
    }
    
     /**
    * @description Returns Account-Accountt Relations
    * @Owner: Masechaba Maseli 
    * @param primaryEntityId
    * @param inverseRelationship
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectbyPrimaryEntityIdFiltered(String primaryEntityId, String inverseRelationship) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            selectField('FinServ__RelatedAccount__r.ID_Type__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__InverseRelationship__c').
            selectField('FinServ__Role__r.Name').
            selectField('Roles__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('FinServ__Account__c =: primaryEntityId AND FinServ__Role__r.Name !=: inverseRelationship AND Shareholding_Percentage__c > 0').
            toSOQL()
        );
    }
    
      /**
    * @description Returns Account-Accountt Relations
    * @Owner: Masechaba Maseli 
    * @param primaryEntityId
    * @param inverseRelationship
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectbyPrimaryEntityListFiltered(List<String> primaryEntityId, String inverseRelationship) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('Controlling_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            selectField('FinServ__RelatedAccount__r.ID_Type__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__InverseRelationship__c').
            selectField('FinServ__Role__r.Name').
            selectField('Roles__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            setCondition('FinServ__Account__c in: primaryEntityId AND FinServ__Role__r.Name !=: inverseRelationship AND Shareholding_Percentage__c > 0').
            toSOQL()
        );
        
    }
  
     /**
    * @description Returns Account-Accountt Relations
    * @param relatedAccount
    * @param PrimaryEntity
    * @return FinServ__AccountAccountRelation__c
    */
    public FinServ__AccountAccountRelation__c selectbyRelatedPrimaryEntity(Id relatedAccount, String PrimaryEntity) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            setCondition('FinServ__RelatedAccount__c =: relatedAccount AND Primary_Entity_Id__c =:PrimaryEntity').
            toSOQL()
        );
    }
    
        /**
        * @description Returns Account-Accountt Relations
        * @param PrimaryEntity
        * @return List<FinServ__AccountAccountRelation__c>
        */
        public List<FinServ__AccountAccountRelation__c> getFirstLevel(String PrimaryEntity) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            setCondition('FinServ__Account__c =: PrimaryEntity AND Primary_Entity_Id__c =:PrimaryEntity').
            toSOQL()
        );
    }    

    /**
    * @description Returns Account-Accountt Relations
    * @param PrimaryEntity
    * @return List<FinServ__AccountAccountRelation__c>
    */
     public List<FinServ__AccountAccountRelation__c> searchByParent(String PrimaryEntity) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__Role__r.Name').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            setCondition('Primary_Entity_Id__c =: PrimaryEntity').
            toSOQL()
        );
    }
    
    /**
    * @description Returns Account-Accountt Relations
    * @param PrimaryEntity
    * @return List<FinServ__AccountAccountRelation__c>
    */
     public List<FinServ__AccountAccountRelation__c> searchByParentIn(List<Id> PrimaryEntity) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__RelatedAccount__r.FinServ__RelationshipStartDate__c').	
            selectField('FinServ__RelatedAccount__r.Business_Registered_in_South_Africa__c').	
            selectField('FinServ__RelatedAccount__r.Months_Since_Shareholding__c').	
            selectField('FinServ__RelatedAccount__r.Months_Actively_Involved_In_The_Business__c').
            setCondition('FinServ__Account__c in: PrimaryEntity').
            toSOQL()
        );
    }

    /**
    * @description Returns Account-Account Relations for Relationships section and not UBO
    * @param PrimaryEntity
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectByPrimaryForRelationshipSection(String PrimaryEntity) {
        String inverseRelationship = 'Inverse Testing';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.Trust_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__Role__r.Name').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            setCondition('Primary_Entity_Id__c =: PrimaryEntity AND FinServ__Role__r.Name != :inverseRelationship AND Shareholding_Percentage__c <= 0').
            toSOQL()
        );
    }
    /**
    * @description Returns Account-Account Relations for Documents
    * @param PrimaryEntity
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public List<FinServ__AccountAccountRelation__c> selectByPrimaryForDocuments(String PrimaryEntity) {
        String inverseRelationship = 'Inverse Testing';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__Role__r.Name').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            setCondition('Primary_Entity_Id__c =: PrimaryEntity AND FinServ__Role__r.Name != :inverseRelationship').
            toSOQL()
        );
    }
    /**
    * @description selectByByRelatedPartySection
    * @param PrimaryEntity 
    * @return List<FinServ__AccountAccountRelation__c> 
    **/
    public List<FinServ__AccountAccountRelation__c> selectByByRelatedPartySection(String PrimaryEntity) {
        String inverseRelationship = 'Inverse Testing';
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__Role__r.Name').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            setCondition('Primary_Entity_Id__c =: PrimaryEntity AND FinServ__Role__r.Name != :inverseRelationship AND Shareholding_Percentage__c = 0').
            toSOQL()
        );
    }
    
    
    /**
    * @description selectbyIdSet
    * @param ids 
    * @return List<FinServ__AccountAccountRelation__c> 
    **/
    public List<FinServ__AccountAccountRelation__c> selectbyIdSet(Set<Id> ids) {
   return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('FinServ__Account__c').
            selectField('Shareholding_Percentage__c').
            selectField('FinServ__RelatedAccount__c').
            selectField('Primary_Entity_Id__c').
            selectField('ParentRelationshipId__c').
            selectField('FinServ__RelatedAccount__r.Registration_Number__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('FinServ__RelatedAccount__r.CIF__c').
            selectField('FinServ__RelatedAccount__r.Type').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Status__c').
            selectField('FinServ__RelatedAccount__r.CASA_Reference_Number__c').
            selectField('Roles__c').
            selectField('FinServ__StartDate__c').
            selectField('FinServ__RelatedAccount__r.CASA_Screening_Date__c').
            selectField('FinServ__RelatedAccount__r.Name').
            selectField('FinServ__Role__r.Name').
            selectField('FinServ__RelatedAccount__r.Client_Type__c').
            setCondition('Id IN :ids').
            toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}