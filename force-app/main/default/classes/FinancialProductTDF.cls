/**
 * @description       : To create test data for the Financial_Product__c object
 * @author            : robertml@absa.africa
 * @group             :
 * @last modified on  : 09-09-2021
 * @last modified by  : robertml@absa.africa
 **/
@isTest
public with sharing class FinancialProductTDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 **/
	public FinancialProductTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @return Financial_Product__c
	 **/
	public static Financial_Product__c addFinProduct(String name) {
		Financial_Product__c finProd = new Financial_Product__c();
		finProd.Name = name;
		insert finProd;
		return finProd;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param productType
	 * @param businessUnit
	 * @param product
	 * @return Financial_Product__c
	 **/
	public static Financial_Product__c addFinProduct(String name, String productType, String businessUnit, String product, String productFamily) {
		Financial_Product__c finProd = new Financial_Product__c();
		finProd.Name = name;
		finProd.Product_Type__c = productType;
		finProd.Business_Unit__c = businessUnit;
		finProd.Product__c = productFamily;
		finProd.Sub_Product__c = product;
		insert finProd;
		return finProd;
	}
}