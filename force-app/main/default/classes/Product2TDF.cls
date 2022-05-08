/**
 * @description       : To create test data for the Product2 object
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-07-01
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-07-01   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class Product2TDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 **/
	public Product2TDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param name
	 * @param active
	 * @return Product2
	 **/
	public static Product2 addProduct(String name, Boolean active) {
		Product2 prod = new Product2();
		prod.Name = name;
		prod.IsActive = active;
		insert prod;
		return prod;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param name
	 * @param active
	 * @param family
	 * @param productcode
	 * @return Product2
	 **/
	public static Product2 addProduct(String name, Boolean active, String family, String productcode) {
		Product2 prod = new Product2();
		prod.Name = name;
		prod.IsActive = active;
		prod.Family = family;
		prod.ProductCode = productcode;
		insert prod;
		return prod;
	}
}