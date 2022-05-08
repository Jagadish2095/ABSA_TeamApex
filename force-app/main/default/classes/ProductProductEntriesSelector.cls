/**
 * @description       : Selector Layer for Product_Product_Entry__c objects
 * @author            : Tracy de Bruin - CloudSmiths
 * @last modified on  : 2021-06-08
 * @last modified by  : Manish.battu@absa.africa
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   2020-04-21   Tracy de Bruin - CloudSmiths   Initial Version
 * 2.0   2021-01-14   Sipho Mbulawa                  Removed the jimmyclass method
 * 3.0   2021-06-08   Manish                         Added selectByParentProductName method
**/
public class ProductProductEntriesSelector extends fflib_SObjectSelector {
    /**
    * @description MANDATORY ABSTRACT METHODS
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType(){
        return Product_Product_Entry__c.sObjectType;
    }

    /**
    * @description getSObjectFieldList
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product_Product_Entry__c.Id,
                Product_Product_Entry__c.Name,
                Product_Product_Entry__c.Parent_Product__c,
                Product_Product_Entry__c.Related_Product__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    //INHERIT FROM BASE CLASS - START
    /**
    * @description get Product_Product_Entry__c by id's
    * @param idSet
    * @return List<Product_Product_Entry__c>
    **/
    public List<Product_Product_Entry__c> selectById(Set<Id> idSet) {
        return (List<Product_Product_Entry__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    /**
    * @description selectByParentProductId
    * @author PJAIN: 20200422
    * @param parentProductId
    * @return List<Product_Product_Entry__c>
    **/
    public List<Product_Product_Entry__c> selectByParentProductId(Id parentProductId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Related_Product__c').
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Parent_Product__r.Name').
            selectField('Parent_Product__c').
            setCondition('Parent_Product__c =: parentProductId').
            toSOQL()
        );
    }
     /**
     * @description selectByRelatedProductId
     * @param relatedProductId
     * @return Product_Product_Entry__c
     **/
     public Product_Product_Entry__c selectByRelatedProductId(Id relatedProductId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Related_Product__c').
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Parent_Product__r.Name').
            selectField('Parent_Product__c').
            setCondition('Related_Product__c =: relatedProductId').
            toSOQL()
        );
    }
        /**
        * @description selectByParentNameProductCode
        * @param parentName
        * @param productCode
        * @return Product_Product_Entry__c
        **/
        public List<Product_Product_Entry__c> selectByParentNameProductCode(String parentName, String productCode) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Related_Product__c').
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Parent_Product__r.Name').
            selectField('Parent_Product__r.ProductCode').
            selectField('Parent_Product__c').
            setCondition('Parent_Product__r.Name =: parentName AND Related_Product__r.ProductCode =: productCode').
            toSOQL()
        );
    }
      /**
      * @description  selectAL: products
      * @return List<Product_Product_Entry__c> products
      **/
      public List<Product_Product_Entry__c> selectAll() {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Related_Product__c').
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Parent_Product__r.Name').
            selectField('Parent_Product__c').
            selectField('Parent_Product__r.Name').
            toSOQL()
        );
    }
    /**
     * RNIEHAUS: 20201026 : US #W-006349
     * @description selectByParentProductCode select by parent product code
     * @param  parentProductCode parentProductCode The product code of the parent product
     * @return Product_Product_Entry__c  List of related products
     */
    public List<Product_Product_Entry__c> selectByParentProductCode(String parentProductCode) {
            return Database.query(
            newQueryFactory().
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Related_Product__r.Price_Scheme_Code__c').
            setCondition('Parent_Product__r.ProductCode =: parentProductCode').
            toSOQL()
        );
    }
    /**
     * @description selectByParentProductName select by parent product Name
     * @param  parentProductName  The product Name of the parent product
     * @return Product_Product_Entry__c  List of products
     */
    public List<Product_Product_Entry__c> selectByParentProductName(String parentProductName) {
            return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Related_Product__r.Name').
            selectField('Related_Product__r.ProductCode').
            selectField('Related_Product__r.Price_Scheme_Code__c').
            selectField('Related_Product__r.Risk_Profile__c').
            selectField('Parent_Product__r.name').
            setCondition('Parent_Product__r.Name =: parentProductName').
            toSOQL()
        );
    }
}