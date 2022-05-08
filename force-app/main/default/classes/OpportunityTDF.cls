/**
 * @description       : To create test data for the Opportunity object, the class caters for each Opportunity record type
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-21
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-21   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class OpportunityTDF {
	private static Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	public OpportunityTDF() {
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addCAFOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity cafOpp = new Opportunity();
		cafOpp.RecordTypeId = opportunityRecordTypeMap.get('CAF_Application').getRecordTypeId();
		cafOpp.Name = name;
		cafOpp.CloseDate = closeDate;
		cafOpp.StageName = stage;
		cafOpp.AccountId = accountId;
		insert cafOpp;
		return cafOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addCPFOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity cpfOpp = new Opportunity();
		cpfOpp.RecordTypeId = opportunityRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
		cpfOpp.Name = name;
		cpfOpp.CloseDate = closeDate;
		cpfOpp.StageName = stage;
		cpfOpp.AccountId = accountId;
		insert cpfOpp;
		return cpfOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addCreditMaintenanceOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity crMaintOpp = new Opportunity();
		crMaintOpp.RecordTypeId = opportunityRecordTypeMap.get('Credit_Maintenance').getRecordTypeId();
		crMaintOpp.Name = name;
		crMaintOpp.CloseDate = closeDate;
		crMaintOpp.StageName = stage;
		crMaintOpp.AccountId = accountId;
		insert crMaintOpp;
		return crMaintOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addCreditOnboardingOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity crOnboardOpp = new Opportunity();
		crOnboardOpp.RecordTypeId = opportunityRecordTypeMap.get('Credit_Onboarding').getRecordTypeId();
		crOnboardOpp.Name = name;
		crOnboardOpp.CloseDate = closeDate;
		crOnboardOpp.StageName = stage;
		crOnboardOpp.AccountId = accountId;
		insert crOnboardOpp;
		return crOnboardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addCustomerRemediationOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity custRemedOpp = new Opportunity();
		custRemedOpp.RecordTypeId = opportunityRecordTypeMap.get('Customer_Remediation').getRecordTypeId();
		custRemedOpp.Name = name;
		custRemedOpp.CloseDate = closeDate;
		custRemedOpp.StageName = stage;
		custRemedOpp.AccountId = accountId;
		insert custRemedOpp;
		return custRemedOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addDDSalesOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity ddSalesOpp = new Opportunity();
		ddSalesOpp.RecordTypeId = opportunityRecordTypeMap.get('Direct_Delivery_Sales_Opportunity').getRecordTypeId();
		ddSalesOpp.Name = name;
		ddSalesOpp.CloseDate = closeDate;
		ddSalesOpp.StageName = stage;
		ddSalesOpp.AccountId = accountId;
		insert ddSalesOpp;
		return ddSalesOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addGeneralOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity generalOpp = new Opportunity();
		generalOpp.RecordTypeId = opportunityRecordTypeMap.get('General').getRecordTypeId();
		generalOpp.Name = name;
		generalOpp.CloseDate = closeDate;
		generalOpp.StageName = stage;
		generalOpp.AccountId = accountId;
		insert generalOpp;
		return generalOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addMerchantOnboardingOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity merOnboardOpp = new Opportunity();
		merOnboardOpp.RecordTypeId = opportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
		merOnboardOpp.Name = name;
		merOnboardOpp.CloseDate = closeDate;
		merOnboardOpp.StageName = stage;
		merOnboardOpp.AccountId = accountId;
		insert merOnboardOpp;
		return merOnboardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addBusinessBankOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity busBankOpp = new Opportunity();
		busBankOpp.RecordTypeId = opportunityRecordTypeMap.get('Opportunity_Business_Bank').getRecordTypeId();
		busBankOpp.Name = name;
		busBankOpp.CloseDate = closeDate;
		busBankOpp.StageName = stage;
		busBankOpp.AccountId = accountId;
		insert busBankOpp;
		return busBankOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addStandardOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity standardOpp = new Opportunity();
		standardOpp.RecordTypeId = opportunityRecordTypeMap.get('Opportunity_Standard').getRecordTypeId();
		standardOpp.Name = name;
		standardOpp.CloseDate = closeDate;
		standardOpp.StageName = stage;
		standardOpp.AccountId = accountId;
		insert standardOpp;
		return standardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addPhysicalChannelsOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity physChanOpp = new Opportunity();
		physChanOpp.RecordTypeId = opportunityRecordTypeMap.get('Physical_Channels').getRecordTypeId();
		physChanOpp.Name = name;
		physChanOpp.CloseDate = closeDate;
		physChanOpp.StageName = stage;
		physChanOpp.AccountId = accountId;
		insert physChanOpp;
		return physChanOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addProductOnboardingOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity prodOnboardOpp = new Opportunity();
		prodOnboardOpp.RecordTypeId = opportunityRecordTypeMap.get('Product_Onboarding').getRecordTypeId();
		prodOnboardOpp.Name = name;
		prodOnboardOpp.CloseDate = closeDate;
		prodOnboardOpp.StageName = stage;
		prodOnboardOpp.AccountId = accountId;
		insert prodOnboardOpp;
		return prodOnboardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addRetailOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity retailOpp = new Opportunity();
		retailOpp.RecordTypeId = opportunityRecordTypeMap.get('Retail').getRecordTypeId();
		retailOpp.Name = name;
		retailOpp.CloseDate = closeDate;
		retailOpp.StageName = stage;
		retailOpp.AccountId = accountId;
		insert retailOpp;
		return retailOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addRetirementPlanningOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity retPlanOpp = new Opportunity();
		retPlanOpp.RecordTypeId = opportunityRecordTypeMap.get('RetirementPlanning').getRecordTypeId();
		retPlanOpp.Name = name;
		retPlanOpp.CloseDate = closeDate;
		retPlanOpp.StageName = stage;
		retPlanOpp.AccountId = accountId;
		insert retPlanOpp;
		return retPlanOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addSPMOnboardingOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity spmOnboardOpp = new Opportunity();
		spmOnboardOpp.RecordTypeId = opportunityRecordTypeMap.get('SPM_Onboarding').getRecordTypeId();
		spmOnboardOpp.Name = name;
		spmOnboardOpp.CloseDate = closeDate;
		spmOnboardOpp.StageName = stage;
		spmOnboardOpp.AccountId = accountId;
		insert spmOnboardOpp;
		return spmOnboardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addSTIOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity stiOpp = new Opportunity();
		stiOpp.RecordTypeId = opportunityRecordTypeMap.get('STI').getRecordTypeId();
		stiOpp.Name = name;
		stiOpp.CloseDate = closeDate;
		stiOpp.StageName = stage;
		stiOpp.AccountId = accountId;
		insert stiOpp;
		return stiOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addStokvelOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity stokvelOpp = new Opportunity();
		stokvelOpp.RecordTypeId = opportunityRecordTypeMap.get('Stokvel').getRecordTypeId();
		stokvelOpp.Name = name;
		stokvelOpp.CloseDate = closeDate;
		stokvelOpp.StageName = stage;
		stokvelOpp.AccountId = accountId;
		insert stokvelOpp;
		return stokvelOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addSuretyOnboardingOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity surOnboardOpp = new Opportunity();
		surOnboardOpp.RecordTypeId = opportunityRecordTypeMap.get('Surety_Onboarding').getRecordTypeId();
		surOnboardOpp.Name = name;
		surOnboardOpp.CloseDate = closeDate;
		surOnboardOpp.StageName = stage;
		surOnboardOpp.AccountId = accountId;
		insert surOnboardOpp;
		return surOnboardOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addVirtualAdvisorOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity virtualAdvisorOpp = new Opportunity();
		virtualAdvisorOpp.RecordTypeId = opportunityRecordTypeMap.get('Virtual_Advisor').getRecordTypeId();
		virtualAdvisorOpp.Name = name;
		virtualAdvisorOpp.CloseDate = closeDate;
		virtualAdvisorOpp.StageName = stage;
		virtualAdvisorOpp.AccountId = accountId;
		insert virtualAdvisorOpp;
		return virtualAdvisorOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addWalletShareOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity walletShareOpp = new Opportunity();
		walletShareOpp.RecordTypeId = opportunityRecordTypeMap.get('WalletShareOpportunity').getRecordTypeId();
		walletShareOpp.Name = name;
		walletShareOpp.CloseDate = closeDate;
		walletShareOpp.StageName = stage;
		walletShareOpp.AccountId = accountId;
		insert walletShareOpp;
		return walletShareOpp;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @param stage
	 * @param closeDate
	 * @param accountId
	 * @return Opportunity
	 **/
	public static Opportunity addWillsOpp(String name, String stage, Date closeDate, Id accountId) {
		Opportunity willsOpp = new Opportunity();
		willsOpp.RecordTypeId = opportunityRecordTypeMap.get('Wills').getRecordTypeId();
		willsOpp.Name = name;
		willsOpp.CloseDate = closeDate;
		willsOpp.StageName = stage;
		willsOpp.AccountId = accountId;
		insert willsOpp;
		return willsOpp;
	}
}