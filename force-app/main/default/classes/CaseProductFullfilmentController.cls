/**
 * CaseProductFullfilmentController Description
 * @description This class is the Apex Controller for Lightning Components: CaseProductFullfilment, CaseCustomSecurities
 * @Test Class: TestCaseProductFullfilmentController
 * @Created By: Raviteja
 * Story: W-005659
 */
public with sharing class CaseProductFullfilmentController{
	/**
	 * @description Method that fetches application product information and childs related to the case
	 * @param caseId
	 * @return list<Application_Product__c>
	 * @Created By: Raviteja
	 * Story: W-005659
	 *
	 */
	@auraEnabled
	public static list<Application_Product__c> getdetails(String caseId){
		list<Application_Product__c> appproductList = new list<Application_Product__c>();
		Case cs = [Select Id, Opportunity__c, Application_Product_Id__c
		           from Case
		           where Id = :caseId];
		if (String.isNotBlank(cs.Application_Product_Id__c)){
			appproductList = [Select Id, Name, Product_Code__c, Product_Name__c, Beneficiary_Name__c, Guarantee_Amount__c, Guarantee_Expiry_Date__c, Guarantee_Created_Date__c, Application_Product_Parent__c, Opportunity__c, Opportunity_Product_Id__c
			                  from Application_Product__c
			                  where Id = :cs.Application_Product_Id__c OR Application_Product_Parent__c = :cs.Application_Product_Id__c];
		}
		return appproductList;
	}

	/**
	 *
	 * @description Method that fetches account related to the case for getting securities
	 * @param caseId
	 * @return String
	 * @Created By: Raviteja
	 * Story: W-005659
	 *
	 */
	@auraEnabled
	public static String getaccountid(String caseId){
		Case cs = [Select Id, AccountId
		           from Case
		           where Id = :caseId];
		if (String.isNotBlank(cs.AccountId)){
			return cs.AccountId;
		}
		return null;
	}

	/**
	 *
	 * @description Method that deletes the Application Products
	 * @param productid
	 * @param caseId
	 * @return list<Application_Product__c>
	 * @Created By: Raviteja
	 * Story: W-005659
	 *
	 */
	@auraEnabled
	public static list<Application_Product__c> deleteproducts(String productid, String caseId){
		Application_Product__c app = new Application_Product__c(Id = productid);
		database.delete(app, false);
		return getdetails(caseId);
	}

	/**
	 *
	 * @description Method that get relevant fields to be shown based on child LDP Type
	 * @param labelName
	 * @param applicationprodid
	 * @return string
	 * @Created By: Raviteja
	 * Story: W-005659
	 *
	 */
	@auraEnabled
	public static String getLabelString(String labelName, String applicationprodid){
		if (String.isBlank(labelName)){
			list<OpportunitylineItem> oppitems = [Select Id, Productcode
			                                      from OpportunitylineItem
			                                      where id = :applicationprodid];
			if (oppitems.size() > 0 && String.isNotBlank(oppitems[0].Productcode)){
				labelName = oppitems[0].Productcode;
			}
		}
		Pagereference pageRef = Page.DynamicCustomLabel;
		pageRef.setRedirect(true);
		pageRef.getParameters().put('labelName', labelName);
		String body = '';
		try{
			body = pageRef.getContent().toString();
		} catch (Exception e){
			system.debug('Error!');
		}
		return body;
	}
}