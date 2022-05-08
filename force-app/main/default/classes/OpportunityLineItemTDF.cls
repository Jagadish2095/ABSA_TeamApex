/**
 * @description       : To create test data for the Application__c object
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-07-01
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-07-01   robertml@absa.africa   Initial Version
 **/
public with sharing class OpportunityLineItemTDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 **/
	public OpportunityLineItemTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-07-01
	 * @param opportunity
	 * @param product
	 * @param proicebookentry
	 * @param quantity
	 * @param totalprice
	 * @param application
	 * @param policynumber
	 * @return OpportunityLineItem
	 **/
	public static OpportunityLineItem addOppLineItem(
		Id opportunity,
		Id product,
		Id proicebookentry,
		Integer quantity,
		Integer totalprice,
		Id application,
		String policynumber
	) {
		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opportunity;
		oppLineItem.Product2Id = product;
		oppLineItem.PricebookEntryId = proicebookentry;
		oppLineItem.Quantity = quantity;
		oppLineItem.TotalPrice = totalprice;
		oppLineItem.Application__c = application;
		oppLineItem.Policy_Number__c = policynumber;
		insert oppLineItem;
		return oppLineItem;
	}
}