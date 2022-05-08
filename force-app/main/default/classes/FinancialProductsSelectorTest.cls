/**
* @description est Class for FinancialProductsSelector
*
* @author  Tracy de Bruin
* @since   2019-04-10
*/
@isTest 
private class FinancialProductsSelectorTest {

    @isTest
    private static void testSelectById() {
        
        Financial_Product__c testFinancialProduct = new Financial_Product__c(Name = 'Test', Product_Type__c = null, 
                                                                             Business_Unit__c = 'Business Banking',Product_Code__c = 'AV01');
        insert testFinancialProduct;
        FinancialProductsSelector testFinancialProductsSelector = new FinancialProductsSelector();
        Set<Id> setIds = new Set<Id>();
        setIds.add(testFinancialProduct.Id);
        List<Financial_Product__c> productList = testFinancialProductsSelector.selectById(setIds);
        List<Financial_Product__c> productListName = testFinancialProductsSelector.selectByProductName('Test');
        Set<String> setCodes = new Set<String>();
        setCodes.add(testFinancialProduct.Product_Code__c);
        List<Financial_Product__c> productListCodes = testFinancialProductsSelector.selectByProductCode(setCodes);
        System.assertEquals(productList.size(), 1); 
    }
}