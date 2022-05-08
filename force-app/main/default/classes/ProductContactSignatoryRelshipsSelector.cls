/**
 * @description       : Selector layer for ProductContactSignatoryRelationship__c objects
 * @author            : Tinashe M Shoko (Jordiflash)
 * @last modified on  : 2021-09-07
 * @last modified by  : Manish.battu@absa.africa
**/
public class  ProductContactSignatoryRelshipsSelector extends fflib_SObjectSelector{
    /**
    * @description Method to retrieve the sObjectType
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType() {
        return ProductContactSignatoryRelationship__c.sObjectType;

    }
    /**
    * @description Method to retrieve the list of fields on the sObject
    * @return List<Schema.SObjectField> The list of sObjectFields
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            ProductContactSignatoryRelationship__c.Id,
                ProductContactSignatoryRelationship__c.AccountContactRelationshipId__c,
                ProductContactSignatoryRelationship__c.CreatedById,
                ProductContactSignatoryRelationship__c.In_terms_of_Resolution_date__c,
                ProductContactSignatoryRelationship__c.LastModifiedById,
                ProductContactSignatoryRelationship__c.Number_of_Signatories_for_account__c,
                ProductContactSignatoryRelationship__c.OpportunityProductId__c,
                ProductContactSignatoryRelationship__c.OwnerId,
                ProductContactSignatoryRelationship__c.PrimaryAccountId__c,
                ProductContactSignatoryRelationship__c.Product_Name__c,
                ProductContactSignatoryRelationship__c.Name,
                ProductContactSignatoryRelationship__c.Signing_Instructions__c,
                ProductContactSignatoryRelationship__c.Signing_Purpose__c,
                ProductContactSignatoryRelationship__c.SigningAuthorityFromDate__c,
                ProductContactSignatoryRelationship__c.Special_Instruction__c
                };
                    }

    //Custom Selectors
    /**
    * @description Method to retrieve an Application__c based on its ACR Id
    * @param AccountContactRelationshipId 
    * @return List<ProductContactSignatoryRelationship__c> 
    **/
    public List<ProductContactSignatoryRelationship__c> selectByAccountContactRelationshipId(Id AccountContactRelationshipId) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('AccountContactRelationshipId__c').
            selectField('CreatedById').
            selectField('In_terms_of_Resolution_date__c').
            selectField('LastModifiedById').
            selectField('Number_of_Signatories_for_account__c').
            selectField('OpportunityProductId__c').
            selectField('OwnerId').
            selectField('PrimaryAccountId__c').
            selectField('Product_Name__c').
            selectField('Name').
            selectField('Signing_Instructions__c').
            selectField('Signing_Purpose__c').
            selectField('SigningAuthorityFromDate__c').
            selectField('Special_Instruction__c').
            setCondition('AccountContactRelationshipId__c =: AccountContactRelationshipId').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL()
        );
    }

    /**
    * @description 
    * @param AccountContactRelationshipId 
    * @return Map<id, ProductContactSignatoryRelationship__c> 
    **/
    public Map<id,ProductContactSignatoryRelationship__c> selectMapByAccountContactRelationshipId(Id AccountContactRelationshipId) {
        return new  Map<id,ProductContactSignatoryRelationship__c>([SELECT Id, AccountContactRelationshipId__c, CreatedById, In_terms_of_Resolution_date__c, LastModifiedById,
                                                                    Number_of_Signatories_for_account__c,OpportunityProductId__c,OwnerId,PrimaryAccountId__c, Product_Name__c, Name,Signing_Instructions__c,
                                                                    Signing_Purpose__c,SigningAuthorityFromDate__c, Special_Instruction__c, Compulsory_Signature__c, Group_No__c
                                                                    FROM ProductContactSignatoryRelationship__c WHERE OpportunityProductId__c =: AccountContactRelationshipId
                                                                    ORDER BY LastModifiedDate DESC]);
    }
    /**
    * @description Method to retrieve an ProductContactSignatoryRelationship__c based on its Account Id
    * @param PrimaryAccountId 
    * @return List<ProductContactSignatoryRelationship__c> 
    **/
    public List<ProductContactSignatoryRelationship__c> selectByPrimaryAccountId(Id PrimaryAccountId) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('AccountContactRelationshipId__c').
            selectField('CreatedById').
            selectField('In_terms_of_Resolution_date__c').
            selectField('LastModifiedById').
            selectField('Number_of_Signatories_for_account__c').
            selectField('OpportunityProductId__c').
            selectField('OwnerId').
            selectField('PrimaryAccountId__c').
            selectField('Product_Name__c').
            selectField('Name').
            selectField('Signing_Instructions__c').
            selectField('Signing_Purpose__c').
            selectField('SigningAuthorityFromDate__c').
            selectField('Special_Instruction__c').
            selectField('Compulsory_Signature__c').
            selectField('Group_No__c').
            setCondition('PrimaryAccountId__c =: PrimaryAccountId').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL()
        );
    }
    /**
    * @description Method to retrieve an ProductContactSignatoryRelationship__c based on its Account Id
    * @param OpportunityProductId 
    * @return List<ProductContactSignatoryRelationship__c> 
    **/
    public List<ProductContactSignatoryRelationship__c> selectByOpportunityProductId(Id OpportunityProductId) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('AccountContactRelationshipId__c').
            selectField('CreatedById').
            selectField('In_terms_of_Resolution_date__c').
            selectField('LastModifiedById').
            selectField('Number_of_Signatories_for_account__c').
            selectField('OpportunityProductId__c').
            selectField('OwnerId').
            selectField('PrimaryAccountId__c').
            selectField('Product_Name__c').
            selectField('Name').
            selectField('Signing_Instructions__c').
            selectField('Signing_Purpose__c').
            selectField('SigningAuthorityFromDate__c').
            selectField('Special_Instruction__c').
            selectField('Compulsory_Signature__c').
            selectField('Group_No__c').
            setCondition('OpportunityProductId__c =: OpportunityProductId').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL()
        );
    }
    /**
    * @description Method to retrieve an ProductContactSignatoryRelationship__c based on its Account Id
    * @author Manish.battu@absa.africa
    * @param primaryAccountIds
    * @return List<ProductContactSignatoryRelationship__c>
    **/
    public List<ProductContactSignatoryRelationship__c> selectByPrimaryAccountIds(Set<Id> primaryAccountIds) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('AccountContactRelationshipId__c').
            selectField('CreatedById').
            selectField('In_terms_of_Resolution_date__c').
            selectField('LastModifiedById').
            selectField('Number_of_Signatories_for_account__c').
            selectField('OpportunityProductId__c').
            selectField('OwnerId').
            selectField('PrimaryAccountId__c').
            selectField('Product_Name__c').
            selectField('Name').
            selectField('Signing_Instructions__c').
            selectField('Signing_Purpose__c').
            selectField('SigningAuthorityFromDate__c').
            selectField('Special_Instruction__c').
            selectField('Compulsory_Signature__c').
            selectField('Group_No__c').
            setCondition('PrimaryAccountId__c  IN : primaryAccountIds').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL()
        );
    }
}