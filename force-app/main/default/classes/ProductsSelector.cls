/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Product objects
 *@description       : ProductsSelector
 * @author  Kyle Alexander
 * @since   2018-09-04
 *
 * @update  Englarmerdge Mongwe
 * @since   2020-08-26
 * Adde selectByFamily method
*/

public class ProductsSelector extends fflib_SObjectSelector {
/** @description getSObjectType
     * @return Schema.SObjectType
     **/
	 //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Product2.sObjectType;
    }
/** @description getSObjectFieldList
     * @return List<Schema.SObjectField>
     **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Product2.id,
                Product2.name,
                Product2.ProductCode,
                Product2.Family  
        };
    }
    //MANDATORY ABSTRACT METHODS - END
/** @description selectById
 * @param idSet
     * @return List<Product2>
     **/
    //get cases by id's
    public List<Product2> selectById(Set<Id> idSet) {
        return (List<Product2>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START
/** @description selectByName
 * @param productName
 * @param recordLimit
     * @return Product2
     **/
    public Product2 selectByName(String productName, Integer recordLimit) {
        return Database.query(
            newQueryFactory().
            selectField('ProductCode').
            setCondition('Name = :productName').
            setLimit(recordLimit).
            toSOQL()
        );
    }

    /**
     * @description Returns a single product based on a given product name
     *
     * @param   productName   The name of the product
     *
     * @return  Product2    The Product2 object record
     */
    public Product2 selectByName(String productName) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Family').
            selectField('ProductCode').
            selectField('Financial_Product__c').
            selectField('Description').
            setCondition('Name = :productName').
            toSOQL()
        );
    }

    /**
     * @description Method that gets a list of active products by given financial product id
     * @param financialProductId
     * @param isActive
     * @return List<Product2> -  products with name
     */
    public List<Product2> selectByFinancialProductId(Id financialProductId, boolean isActive) {
        return (List<Product2>) Database.query(
            newQueryFactory().
            setCondition('Financial_Product__c =: financialProductId AND IsActive =: isActive').
            toSOQL()
        );
    }

    /**
     * @description Returns a single product based on a given product family
     *
     * @param family The family of the product
     * @return Product2 The Product2 object record
     */
    public List<Product2> selectByFamily(String family) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Family').
            selectField('ProductCode').
            setCondition('Family = :family').
            toSOQL()
        );
    }
     /**
     *  @description Returns a single product based on a given product Id
     *
     * @param   productId   The name of the product
     *
     * @return  Product2    The Product2 object record
     */
    public Product2 selectById(String productId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Family').
            selectField('ProductCode').
            selectField('Financial_Product__c').
            selectField('Primary_Service_Provider__c').
            selectField('Description').
            setCondition('Id = :productId').
            toSOQL()
        );
    }
    
      /**
     * @description Method that gets a list of active products
     * @param isActive
     * @return product -  products with name
     */
    public List<Product2> selectActiveProducts(boolean isActive) {
        return (List<Product2>) Database.query(
            newQueryFactory().
            setCondition('IsActive =: isActive').
            toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}