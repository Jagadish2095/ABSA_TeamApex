/**
* Apex Enterprise Design Patterns
* @description Selector Layer for Financial Product objects
*
* @author  Tracy de Bruin
* @since   2019-04-02
*/
public class FinancialProductsSelector extends fflib_SObjectSelector {
    
	//MANDATORY ABSTRACT METHODS - START
    /**
     * @description getSObjectType Description
     *
     * @return  *  * Return datatype: Write the return description
     */
    public Schema.SObjectType getSObjectType(){
        return Financial_Product__c.sObjectType;
    }
/**
 * @description getSObjectFieldList Description
 *
 * @return  *  * Return datatype: Write the return description
 */
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Financial_Product__c.Id,
                Financial_Product__c.Business_Unit__c,
                Financial_Product__c.Product_Code__c,
                Financial_Product__c.Product_Group_Code__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    /**
     * @description selectById Description
     *
     * @param idSet (Set<Id>): Write the parameter description
     * @return List<Financial_Product__c>: Write the return description
     */
    public List<Financial_Product__c> selectById(Set<Id> idSet) {
        return (List<Financial_Product__c>) selectSObjectsById(idSet);
    }
	//Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //CUSTOM SELECTORS - START
    /**
     * @description selectByProductCode Description
     *
     * @param productCodes (Set<String>): Write the parameter description
     * @return List<Financial_Product__c>: Write the return description
     */
    public List<Financial_Product__c> selectByProductCode(Set<String> productCodes) {
        return Database.query(
            newQueryFactory().
            setCondition('Product_Code__c IN :productCodes').
            toSOQL()
        );
    }
    /**
     * @description selectByProductName Description
     *
     * @param productName (String): Write the parameter description
     * @return List<Financial_Product__c>: Write the return description
     */
    public List<Financial_Product__c> selectByProductName(String productName) {
        return Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('Id').
            setCondition('Name =:productName').
            toSOQL()
        );
    }
    
    //CUSTOM SELECTORS - END
}