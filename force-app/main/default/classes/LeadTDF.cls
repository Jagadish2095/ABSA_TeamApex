/**
 * @description       : To create test data for the Lead object, the class caters for each Lead record type
 * @author            : robertml@absa.africa
 * @group             :
 * @last modified on  : 09-09-2021
 * @last modified by  : robertml@absa.africa
 **/
@isTest
public with sharing class LeadTDF {
	private static Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 **/
	public LeadTDF() {
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadGeneral(String name, String lastName) {
		Lead leadGeneral = new Lead();
		leadGeneral.RecordTypeId = leadRecordTypeMap.get('General').getRecordTypeId();
		leadGeneral.Lead_Name__c = name;
		leadGeneral.LastName = lastName;
		insert leadGeneral;
		return leadGeneral;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadReferral(String name, String lastName) {
		Lead leadReferral = new Lead();
		leadReferral.RecordTypeId = leadRecordTypeMap.get('Referral').getRecordTypeId();
		leadReferral.Lead_Name__c = name;
		leadReferral.LastName = lastName;
		insert leadReferral;
		return leadReferral;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadRetirementPlanning(String name, String lastName) {
		Lead leadRetirementPlanning = new Lead();
		leadRetirementPlanning.RecordTypeId = leadRecordTypeMap.get('RetirementPlanning').getRecordTypeId();
		leadRetirementPlanning.Lead_Name__c = name;
		leadRetirementPlanning.LastName = lastName;
		insert leadRetirementPlanning;
		return leadRetirementPlanning;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadBusinessReferral(String name, String lastName) {
		Lead leadBusinessReferral = new Lead();
		leadBusinessReferral.RecordTypeId = leadRecordTypeMap.get('BusinessReferral').getRecordTypeId();
		leadBusinessReferral.Lead_Name__c = name;
		leadBusinessReferral.LastName = lastName;
		insert leadBusinessReferral;
		return leadBusinessReferral;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param financialProduct
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadBusinessBankLead(String name, Id financialProduct, String lastName) {
		Lead leadBusinessBankLead = new Lead();
		leadBusinessBankLead.RecordTypeId = leadRecordTypeMap.get('Business_Bank_Lead').getRecordTypeId();
		leadBusinessBankLead.Lead_Name__c = name;
		leadBusinessBankLead.Financial_Product__c = financialProduct;
		leadBusinessBankLead.LastName = lastName;
		insert leadBusinessBankLead;
		return leadBusinessBankLead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param financialProduct
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadWIMILead(String name, Id financialProduct, String lastName) {
		Lead leadWIMILead = new Lead();
		leadWIMILead.RecordTypeId = leadRecordTypeMap.get('WIMI_Lead').getRecordTypeId();
		leadWIMILead.Lead_Name__c = name;
		leadWIMILead.Financial_Product__c = financialProduct;
		leadWIMILead.LastName = lastName;
		insert leadWIMILead;
		return leadWIMILead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadMerchantLead(String name, String lastName) {
		Lead leadMerchantLead = new Lead();
		leadMerchantLead.RecordTypeId = leadRecordTypeMap.get('Merchant_Lead').getRecordTypeId();
		leadMerchantLead.Lead_Name__c = name;
		leadMerchantLead.LastName = lastName;
		insert leadMerchantLead;
		return leadMerchantLead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadSTILead(String name, String lastName) {
		Lead leadSTILead = new Lead();
		leadSTILead.RecordTypeId = leadRecordTypeMap.get('STI_Lead').getRecordTypeId();
		leadSTILead.Lead_Name__c = name;
		leadSTILead.LastName = lastName;
		insert leadSTILead;
		return leadSTILead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadIndividualBanking(String name, String lastName) {
		Lead leadIndividualBanking = new Lead();
		leadIndividualBanking.RecordTypeId = leadRecordTypeMap.get('Individual_Banking').getRecordTypeId();
		leadIndividualBanking.Lead_Name__c = name;
		leadIndividualBanking.LastName = lastName;
		insert leadIndividualBanking;
		return leadIndividualBanking;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadRetailSalesLead(String name, String lastName) {
		Lead leadRetailSalesLead = new Lead();
		leadRetailSalesLead.RecordTypeId = leadRecordTypeMap.get('Retail_Sales_Lead').getRecordTypeId();
		leadRetailSalesLead.Lead_Name__c = name;
		leadRetailSalesLead.LastName = lastName;
		insert leadRetailSalesLead;
		return leadRetailSalesLead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadRetailServiceLead(String name, String lastName) {
		Lead leadRetailServiceLead = new Lead();
		leadRetailServiceLead.RecordTypeId = leadRecordTypeMap.get('Retail_Service_Lead').getRecordTypeId();
		leadRetailServiceLead.Lead_Name__c = name;
		leadRetailServiceLead.LastName = lastName;
		insert leadRetailServiceLead;
		return leadRetailServiceLead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadStockbrokerLead(String name, String lastName) {
		Lead leadStockbrokerLead = new Lead();
		leadStockbrokerLead.RecordTypeId = leadRecordTypeMap.get('Stockbroker_Lead').getRecordTypeId();
		leadStockbrokerLead.Lead_Name__c = name;
		leadStockbrokerLead.LastName = lastName;
		insert leadStockbrokerLead;
		return leadStockbrokerLead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadVirtualSTILead(String name, String lastName) {
		Lead leadVirtualSTILead = new Lead();
		leadVirtualSTILead.RecordTypeId = leadRecordTypeMap.get('Virtual_STI_Lead').getRecordTypeId();
		leadVirtualSTILead.Lead_Name__c = name;
		leadVirtualSTILead.LastName = lastName;
		insert leadVirtualSTILead;
		return leadVirtualSTILead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadDirectDeliverySale(String name, String lastName) {
		Lead leadDirectDeliverySale = new Lead();
		leadDirectDeliverySale.RecordTypeId = leadRecordTypeMap.get('Direct_Delivery_Sale').getRecordTypeId();
		leadDirectDeliverySale.Lead_Name__c = name;
		leadDirectDeliverySale.LastName = lastName;
		insert leadDirectDeliverySale;
		return leadDirectDeliverySale;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadDDSTILead(String name, String lastName) {
		Lead leadDDSTILead = new Lead();
		leadDDSTILead.RecordTypeId = leadRecordTypeMap.get('DD_STI_Lead').getRecordTypeId();
		leadDDSTILead.Lead_Name__c = name;
		leadDDSTILead.LastName = lastName;
		insert leadDDSTILead;
		return leadDDSTILead;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadIdirect(String name, String lastName) {
		Lead leadIdirect = new Lead();
		leadIdirect.RecordTypeId = leadRecordTypeMap.get('Idirect').getRecordTypeId();
		leadIdirect.Lead_Name__c = name;
		leadIdirect.LastName = lastName;
		insert leadIdirect;
		return leadIdirect;
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 09-09-2021
	 * @param name
	 * @param lastName
	 * @return Lead
	 **/
	public static Lead addleadPersonalLines(String name, String lastName) {
		Lead leadPersonalLines = new Lead();
		leadPersonalLines.RecordTypeId = leadRecordTypeMap.get('Personal_Lines').getRecordTypeId();
		leadPersonalLines.Lead_Name__c = name;
		leadPersonalLines.LastName = lastName;
		insert leadPersonalLines;
		return leadPersonalLines;
	}
}