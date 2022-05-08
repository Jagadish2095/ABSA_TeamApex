/**
 * @description       : To create test data for the PricebookEntry object
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-07-01
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-07-01   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class PricebookEntryTDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 **/
	public PricebookEntryTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param pricebook
	 * @param product
	 * @param unitprice
	 * @param active
	 * @return PricebookEntry
	 **/
	public static PricebookEntry addPriceBookEntry(Id pricebook, Id product, Integer unitprice, Boolean active) {
		PricebookEntry priceBookEntrey = new PricebookEntry();
		priceBookEntrey.Pricebook2Id = pricebook;
		priceBookEntrey.Product2Id = product;
		priceBookEntrey.UnitPrice = unitprice;
		priceBookEntrey.IsActive = active;
		insert priceBookEntrey;
		return priceBookEntrey;
	}
}