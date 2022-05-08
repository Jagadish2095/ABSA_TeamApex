/**
 * @description       : To create test data for the PriceBook2 object
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-07-01
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-07-01   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class PriceBook2TDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 **/
	public PriceBook2TDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param name
	 * @param active
	 * @return Pricebook2
	 **/
	public static Pricebook2 addPriceBook(String name, Boolean active) {
		Pricebook2 priceBook = new Pricebook2();
		priceBook.Name = name;
		priceBook.IsActive = active;
		insert priceBook;
		return priceBook;
	}
}