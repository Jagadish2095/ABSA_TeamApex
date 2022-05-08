/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-13
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   04-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class EntityRiskProfiling {
	/**
	 * @description entityRiskProfiling
	 * @return string
	 * @param accountId
	 * @param opportunityId
	 */
	@AuraEnabled
	public static string getEntityRiskProfiling(string accountId, string opportunityId) {
		WQRiskProfileClientV7_Req_IB_v1 requestBean;
		Account mainAccount = [
			SELECT Id, CASA_Reference_Number__c, CIF__C, Client_Group__c, Countries_Traded_With__c, Source_of_Income__c, Name
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];

		requestBean = WQRiskProfileClientV7_Req_IB_v1.GetInstance();
		string clientTypeGrp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			StringConstants.CLIENT_TYPE_GROUP,
			mainAccount.Client_Group__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		requestBean.WQriskProfileClientV7Request.customerTypeCode = clientTypeGrp;
		requestBean.WQriskProfileClientV7Request.customerStatusCode = '';
		requestBean.WQriskProfileClientV7Request.customerSourceUniqueId = mainAccount.CASA_Reference_Number__c;
		requestBean.WQriskProfileClientV7Request.companyForm = '07401';
		requestBean.WQriskProfileClientV7Request.customerSourceRefID = mainAccount.CASA_Reference_Number__c;
		requestBean.WQriskProfileClientV7Request.cifkey = mainAccount.CIF__C;
		requestBean.WQriskProfileClientV7Request.occupation = '';
		requestBean.WQriskProfileClientV7Request.businessSegment1 = '95990';
		requestBean.WQriskProfileClientV7Request.employmentStatus = '';
		requestBean.WQriskProfileClientV7Request.primeBranchID = '2626';
		string countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.ECASA_STRING,
			'Country',
			mainAccount.Countries_Traded_With__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		requestBean.WQriskProfileClientV7Request.incorporationCountryCode = countryTranslated;
		WQRiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable sofEntry = new WQRiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable();
		sofEntry.absaSourceOfIncome = '45';
		requestBean.WQriskProfileClientV7Request.absaSourceOfIncomeTable.add(sofEntry);

		WQRiskProfileClientV7_Req_IB_v1.AbsaCountryTradedWithTable absaCountryTradeWithPrimaryClientObj = new WQRiskProfileClientV7_Req_IB_v1.AbsaCountryTradedWithTable();

		absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = countryTranslated;
		requestBean.WQriskProfileClientV7Request.absaCountryTradedWithTable.add(absaCountryTradeWithPrimaryClientObj);
		WQRiskProfileClientV7_Req_IB_v1.AbsaCountryOfOperationTable absaCountryOfOperationRelatedPartyObj = new WQRiskProfileClientV7_Req_IB_v1.AbsaCountryOfOperationTable();
		absaCountryOfOperationRelatedPartyObj.absaCountryOfOperation = countryTranslated;
		requestBean.WQriskProfileClientV7Request.absaCountryOfOperationTable.add(absaCountryOfOperationRelatedPartyObj);

		OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
		List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(opportunityId);
		List<String> lineItemIds = new List<String>();
		for (OpportunityLineItem item : oppLineItem) {
			lineItemIds.add(item.Id);
		}
		List<Product2> p = [
			SELECT ProductCode, Price_Scheme_Code__c
			FROM Product2
			WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE Id IN :lineItemIds AND ProductCode != NULL)
			WITH SECURITY_ENFORCED
		];
		for (Product2 item : p) {
			WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable prodEntry = new WQRiskProfileClientV7_Req_IB_v1.ProductCodeTable();
			WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable subProdEntry = new WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable();
			prodEntry.productCode = item.ProductCode;
			subProdEntry.subProductCode = item.Price_Scheme_Code__c;
			requestBean.WQriskProfileClientV7Request.productCodeTable.add(prodEntry);
			requestBean.WQriskProfileClientV7Request.subProductCodeTable.add(subProdEntry);
		}
		//System.debug('riskingtol  ' + json.serializePretty(requestBean));
		CASARiskProfileClientV7_Resp_IB_v1 response = RiskProfileNonIndividualClientV7_IH_v1.RiskProfileNonIndividualClientV7(requestBean);
		//System.debug('risking resp ' + json.serializePretty(response));
		string error = '';
		if ((response != null) && (response.WQriskProfileClientV7Response != null) && (response.WQriskProfileClientV7Response.msg != '')) {
			error = response.WQriskProfileClientV7Response.msg;
		}

		if (
			(response != null) &&
			(response.WQriskProfileClientV7Response != null) &&
			(response.WQriskProfileClientV7Response.msgNo == '200') &&
			(response.WQriskProfileClientV7Response.riskRating != null ||
			response.WQriskProfileClientV7Response.riskRating != '')
		) {
			return response.WQriskProfileClientV7Response.riskRating;
		} else {
			return 'error ' + error;
			//response.WQriskProfileClientV7Response.msg;
		}
	}

	/**
	 * @description entityRiskProfiling
	 * @return string
	 * @param accountId
	 * @param productCode
	 
	@AuraEnabled
	public static string getEntityRiskProfiling1(string accountId, string productCode) {
		//try {
		Usersselector us = new Usersselector();
		List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
		List<AccountContactRelation> relatedParties = AccountContactController.getRelatedAccounts(accountId);

		List<ID> contactids = new List<ID>();
		for (AccountContactRelation accountcontactrelation : relatedParties) {
			contactids.add(accountcontactrelation.ContactId);
		}
		List<Account> stokvelrelatedParty = AccountContactController.GetAccountRelatedpartyDetails(contactids);

		Account mainAccount = [
			SELECT Id, CASA_Reference_Number__c, Client_Group__c, Countries_Traded_With__c, Source_of_Income__c, Name
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];

		RiskProfileJointClient_Req_IB_v2 requestBean = RiskProfileJointClient_Req_IB_v2.createDummy();
		List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable> countryTradedwith = new List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable>();
		RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable absaCountryTradeWithPrimaryClientObj = new RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable();

		string clientTypeGrp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.ECASA_STRING,
			StringConstants.CLIENT_TYPE_GROUP,
			mainAccount.Client_Group__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		string countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			mainAccount.Countries_Traded_With__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = countryTranslated;
		RiskProfileJointClient_Req_IB_v2.PrimaryClient primaryClient = new RiskProfileJointClient_Req_IB_v2.PrimaryClient();
		primaryClient.primeBranchID = '2626';
		primaryClient.originatingsystem = 'BDP';
		primaryClient.occupation = '';
		primaryClient.IncorporationCountryCode = '';
		primaryClient.employmentStatus = '';
		primaryClient.customerTypeCode = clientTypeGrp;
		primaryClient.customerStatusCode = '';
		primaryClient.customerSourceUniqueId = mainAccount.CASA_Reference_Number__c;
		primaryClient.customerSourceRefID = mainAccount.CASA_Reference_Number__c;
		primaryClient.companyForm = '07401';
		primaryClient.cifKey = '';
		primaryClient.channel = 'F2F1';
		primaryClient.businessSegment1 = '01';
		primaryClient.sbu = '102';
		RiskProfileJointClient_Req_IB_v2.SubProductCodeTable subProductCodePrimaryClientObj = new RiskProfileJointClient_Req_IB_v2.SubProductCodeTable();
		subProductCodePrimaryClientObj.subProductCode = '';
		List<RiskProfileJointClient_Req_IB_v2.SubProductCodeTable> subProductCodePrimaryClientList = new List<RiskProfileJointClient_Req_IB_v2.SubProductCodeTable>();
		subProductCodePrimaryClientList.add(subProductCodePrimaryClientObj);
		primaryClient.subProductCodeTable = subProductCodePrimaryClientList;

		RiskProfileJointClient_Req_IB_v2.ProductCodeTable productCodePrimaryClientObj = new RiskProfileJointClient_Req_IB_v2.ProductCodeTable();
		productCodePrimaryClientObj.productCode = productCode;
		List<RiskProfileJointClient_Req_IB_v2.ProductCodeTable> productCodePrimaryClientList = new List<RiskProfileJointClient_Req_IB_v2.ProductCodeTable>();
		productCodePrimaryClientList.add(productCodePrimaryClientObj);
		primaryClient.productCodeTable = productCodePrimaryClientList;

		absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = '';
		List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable> absaCountryTradeWithPrimaryClientList = new List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable>();
		absaCountryTradeWithPrimaryClientList.add(absaCountryTradeWithPrimaryClientObj);
		primaryClient.absaCountryTradedWithTable = absaCountryTradeWithPrimaryClientList;

		RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable absaCountryOfOperationPrimaryClientObj = new RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable();
		absaCountryOfOperationPrimaryClientObj.absaCountryOfOperation = '';
		List<RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable> absaCountryOfOperationClientPrimaryClientList = new List<RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable>();
		absaCountryOfOperationClientPrimaryClientList.add(absaCountryOfOperationPrimaryClientObj);

		primaryClient.absaCountryOfOperationTable = absaCountryOfOperationClientPrimaryClientList;

		RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable absaSourceOfIncomePrimaryClientObj = new RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable();
		absaSourceOfIncomePrimaryClientObj.absaSourceOfIncome = '';
		List<RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable> absaSourceOfIncomePrimaryClientList = new List<RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable>();
		absaSourceOfIncomePrimaryClientList.add(absaSourceOfIncomePrimaryClientObj);
		primaryClient.absaSourceOfIncomeTable = absaSourceOfIncomePrimaryClientList;

		primaryClient.userId = userP[0].Teller_Operator_Code__c;
		List<RiskProfileJointClient_Req_IB_v2.RelatedParty> relatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.RelatedParty>();
		STRING occpation = '';
		RiskProfileJointClient_Req_IB_v2.RelatedParty relatedParty = new RiskProfileJointClient_Req_IB_v2.RelatedParty();
		for (Account stokvelrel : stokvelrelatedParty) {
			string relclientTypeGrp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.CLIENT_TYPE_GROUP,
				stokvelrel.Client_Group__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);

			List<Contact> lstContact = stokvelrel.Contacts;
			for (Contact con : lstContact) {
				if (!string.isblank(con.Occupation_Category__c)) {
					occpation = StokvelEntityCasaCIFController.getTranslationValues(
						StringConstants.ECASA_STRING,
						con.Occupation_Category__c,
						'Occupation Category',
						'Outbound'
					);
				}
			}
			relatedParty.primeBranchID = '2626';
			relatedParty.originatingsystem = 'BDP';
			relatedParty.occupation = occpation;
			relatedParty.IncorporationCountryCode = '';
			relatedParty.employmentStatus = '01';
			relatedParty.customerTypeCode = '';
			relatedParty.customerStatusCode = '';
			relatedParty.customerSourceUniqueId = stokvelrel.CASA_Reference_Number__c;
			relatedParty.customerSourceRefID = '';
			relatedParty.companyForm = '00101';
			relatedParty.cifKey = '';
			relatedParty.channel = 'F2F1';
			relatedParty.businessSegment1 = '';
			relatedParty.sbu = '102';
			RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable absaCountryTradeWithRelatedPartyObj = new RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable();
			absaCountryTradeWithRelatedPartyObj.absaCountriesTradedWith = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Country',
				stokvelrel.Countries_Traded_With__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable> absaCountryTradeWithRelatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.AbsaCountryTradedWithTable>();
			absaCountryTradeWithRelatedPartyList.add(absaCountryTradeWithRelatedPartyObj);
			relatedParty.absaCountryTradedWithTable = absaCountryTradeWithRelatedPartyList;

			RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable absaCountryOfOperationRelatedPartyObj = new RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable();
			absaCountryOfOperationRelatedPartyObj.absaCountryOfOperation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Country',
				stokvelrel.Countries_Traded_With__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			List<RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable> absaCountryOfOperationClientRelatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.AbsaCountryOfOperationTable>();
			absaCountryOfOperationClientRelatedPartyList.add(absaCountryOfOperationRelatedPartyObj);
			relatedParty.absaCountryOfOperationTable = absaCountryOfOperationClientRelatedPartyList;

			RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable absaSourceOfIncomeRelatedPartyObj = new RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable();
			absaSourceOfIncomeRelatedPartyObj.absaSourceOfIncome = '27'; //stokvelrel.Source_of_Income__c;
			List<RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable> absaSourceOfIncomeRelatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.AbsaSourceOfIncomeTable>();
			absaSourceOfIncomeRelatedPartyList.add(absaSourceOfIncomeRelatedPartyObj);
			relatedParty.absaSourceOfIncomeTable = absaSourceOfIncomeRelatedPartyList;

			RiskProfileJointClient_Req_IB_v2.ProductCodeTable productCodeRelatedPartyObj = new RiskProfileJointClient_Req_IB_v2.ProductCodeTable();
			productCodeRelatedPartyObj.productCode = productCode;
			List<RiskProfileJointClient_Req_IB_v2.ProductCodeTable> productCodeRelatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.ProductCodeTable>();
			productCodeRelatedPartyList.add(productCodeRelatedPartyObj);
			relatedParty.productCodeTable = productCodeRelatedPartyList;

			RiskProfileJointClient_Req_IB_v2.SubProductCodeTable subProductCodeRelatedPartyObj = new RiskProfileJointClient_Req_IB_v2.SubProductCodeTable();
			subProductCodeRelatedPartyObj.subProductCode = '';
			List<RiskProfileJointClient_Req_IB_v2.SubProductCodeTable> subProductCodeRelatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.SubProductCodeTable>();
			subProductCodeRelatedPartyList.add(subProductCodeRelatedPartyObj);
			relatedParty.subProductCodeTable = subProductCodeRelatedPartyList;

			relatedParty.userId = userP[0].Teller_Operator_Code__c;

			relatedPartyList.add(relatedParty);
		}
		RiskProfileJointClient_Req_IB_v2 bean = new RiskProfileJointClient_Req_IB_v2();

		bean.PrimaryClient = primaryClient;
		bean.relatedParties = relatedPartyList;
		// system.debug('riskprofile ' + json.serializePretty(bean));

		RiskProfileJointClient_Resp_IB_v1 response = RiskProfileJointClient_IH_v1.riskProfilejointrelatedParty(bean);
		//system.debug('riskprofileresp ' + json.serializePretty(response));
		if ((response != null) && (response.statusCode == 200)) {
			if (response.msgNo != 200) {
				throw new AuraHandledException(response.msg);
			}
		}
		return response.riskRating;
		/*	} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}*/
}