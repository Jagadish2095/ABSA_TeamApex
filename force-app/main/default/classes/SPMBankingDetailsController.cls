/**
 * @description Controller for SPMBankingDetails Component
 *
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-03-08
 * @param paymentplan object
 */
public class SPMBankingDetailsController {
	/**
	 * @description Method that returns an paymentpaln details
	 * @param   objObject
	 * @param   fld
	 * @return  The Account object record
	 */
	@AuraEnabled
	public static List<String> getSelectOptions(sObject objObject, string fld) {
		List<String> allOpts = new List<String>();
		Schema.sObjectType objType = objObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

		for (Schema.PicklistEntry a : values) {
			allOpts.add(a.getValue());
		}
		return allOpts;
	}
	/**
	 * @description Method that returns an paymentpaln details
	 * @param   recId
	 * @param   accNumber
	 * @param   accType
	 * @param   bankName
	 * @param   branchCode
	 * @param   branchName
	 * @param   bicval
	 * @param   accountName
	 * @param   name
	 * @param   type
	 */
	@AuraEnabled
	public static void submitPaymentPlanDetail(
		Id recId,
		String accNumber,
		String accType,
		String bankName,
		String branchCode,
		String branchName,
		string bicval,
		string accountName,
		String name,
		String type
	) {
		system.debug('recId-----' + recId);
		system.debug('type-----' + type);
		String sObjName = recId.getSObjectType().getDescribe().getName();
		if (sObjName == 'Account') {
			List<Payment_Plan__c> paymentPlansList = [
				SELECT
					id,
					Account__c,
					Account__r.SPM_Platform_Type__c,
					Account_Number__c,
					Account_Type__c,
					Bank_Name__c,
					Branch_Code__c,
					Branch_Name__c,
					Type__c,
					Name,
					BIC_Code__c,
					Account_Name__c
				FROM Payment_Plan__c
				WHERE Account__c = :recId
			];
			system.debug('paymentPlansList' + paymentPlansList);
			if (paymentPlansList == null || paymentPlansList.isEmpty()) {
				system.debug('paymentPlansListenterif' + paymentPlansList);
				//Insert New Banking Details
				Payment_Plan__c paymentPlan = new Payment_Plan__c();
				paymentPlan.Account__c = recId;
				paymentPlan.Account_Number__c = accNumber;
				paymentPlan.Account_Type__c = accType;
				paymentPlan.Bank_Name__c = bankName;
				if (String.isNotBlank(branchCode)) {
					paymentPlan.Branch_Code__c = Integer.valueOf(branchCode);
				}
				paymentPlan.Branch_Name__c = branchName;
				paymentPlan.Name = name;
				paymentPlan.Type__c = type;
				paymentPlan.Status__c = 'New';
				paymentPlan.Method__c = 'Debit Order';
				paymentPlan.BIC_Code__c = bicval;
				paymentPlan.Account_Name__c = accountName;
				insert paymentPlan;
				system.debug('paymentPlan' + paymentPlan);
			} else {
				//Update Existing Banking Details
				system.debug('paymentPlansListenterelse' + paymentPlansList);
				Payment_Plan__c paymentPlanToUpdate;
				//paymentPlanToUpdate.Account__c=accId;
				paymentPlanToUpdate = paymentPlansList.get(0);
				paymentPlanToUpdate.Account_Number__c = accNumber;
				paymentPlanToUpdate.Account_Type__c = accType;
				paymentPlanToUpdate.Bank_Name__c = bankName;
				paymentPlanToUpdate.Status__c = 'New';
				paymentPlanToUpdate.Method__c = 'Debit Order';
				if (String.isNotBlank(branchCode)) {
					paymentPlanToUpdate.Branch_Code__c = Integer.valueOf(branchCode);
				}
				paymentPlanToUpdate.Branch_Name__c = branchName;
				paymentPlanToUpdate.Name = name;
				paymentPlanToUpdate.Type__c = type;
				paymentPlanToUpdate.BIC_Code__c = bicval;
				paymentPlanToUpdate.Account_Name__c = accountName;
				update paymentPlanToUpdate;
				system.debug('paymentPlanToUpdate' + paymentPlanToUpdate);
			}
		}
		if (sObjName == 'Opportunity') {
			Account accounts = new AccountsSelector().selectByOpportunityId(recId);
			List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(recId);
			// List<Application_Product__c> applPrdct= new ApplicationProductSelector().selectByOpportunityId(recId);
			List<Payment_Plan__c> paymentPlansList = [
				SELECT
					id,
					Account__c,
					Account__r.SPM_Platform_Type__c,
					Account_Number__c,
					Account_Type__c,
					Bank_Name__c,
					Branch_Code__c,
					Branch_Name__c,
					Type__c,
					Name,
					BIC_Code__c,
					Account_Name__c,
					Application__c,
					Application_Product__c
				FROM Payment_Plan__c
				WHERE Application__c = :app[0].Id AND Type__c = 'SPM Product'
			];
			System.debug('=======paymentPlansList====>' + paymentPlansList);
			if (paymentPlansList != null && !paymentPlansList.isEmpty() && accounts.SPM_Platform_Type__c == null) {
				System.debug('=======paymentPlansList====>' + paymentPlansList);
				Payment_Plan__c paymentRec = new Payment_Plan__c();
				paymentRec.Id = paymentPlansList[0].Id;
				paymentRec.Account_Number__c = accNumber;
				paymentRec.Account_Type__c = accType;
				paymentRec.Bank_Name__c = bankName;
				if (String.isNotBlank(branchCode)) {
					paymentRec.Branch_Code__c = Integer.valueOf(branchCode);
				}
				paymentRec.Branch_Name__c = branchName;
				paymentRec.Name = name;
				paymentRec.Type__c = type;
				paymentRec.Status__c = 'New';
				paymentRec.Method__c = 'Debit Order';
				paymentRec.BIC_Code__c = bicval;
				paymentRec.Account_Name__c = accountName;
				paymentRec.Application__c = app[0].Id;
				//paymentPlan.Application_Product__c = applPrdct[0].Id;
				update paymentRec;
				System.debug('=======paymentRec====>' + paymentRec);
			} else if ((paymentPlansList == null || paymentPlansList.isEmpty()) && accounts.SPM_Platform_Type__c == null) {
				//Insert New Banking Details
				Payment_Plan__c paymentPlan = new Payment_Plan__c();
				paymentPlan.Account_Number__c = accNumber;
				paymentPlan.Account_Type__c = accType;
				paymentPlan.Bank_Name__c = bankName;
				if (String.isNotBlank(branchCode)) {
					paymentPlan.Branch_Code__c = Integer.valueOf(branchCode);
				}
				paymentPlan.Branch_Name__c = branchName;
				paymentPlan.Name = name;
				paymentPlan.Type__c = type;
				paymentPlan.Status__c = 'New';
				paymentPlan.Method__c = 'Debit Order';
				paymentPlan.BIC_Code__c = bicval;
				paymentPlan.Account_Name__c = accountName;
				paymentPlan.Application__c = app[0].Id;
				paymentPlan.Type__c = 'SPM Product';
				//paymentPlan.Application_Product__c = applPrdct[0].Id;
				insert paymentPlan;
				system.debug('paymentPlan' + paymentPlan);
			}
		}
	}
	/**
	 * @description Method that get paymentplan record
	 * @param   recId
	 * @return  LIST<Payment_Plan__c
	 */
	@AuraEnabled
	public static LIST<Payment_Plan__c> getPaymentplanRec(Id recId) {
		system.debug('recId====' + recId);
		String sObjName = recId.getSObjectType().getDescribe().getName();

		LIST<Payment_Plan__c> paymentplanList;
		if (sObjName == 'Account') {
			paymentplanList = [
				SELECT
					id,
					Account__c,
					Account__r.SPM_Platform_Type__c,
					Account_Number__c,
					Account_Type__c,
					Bank_Name__c,
					Branch_Code__c,
					Branch_Name__c,
					Type__c,
					Name,
					BIC_Code__c,
					Account_Name__c,
					Application__c,
					Application_Product__c
				FROM Payment_Plan__c
				WHERE Account__c = :recId
			];
			system.debug('paymentplanList' + paymentplanList);
		}
		if (sObjName == 'Opportunity') {
			Account accounts = new AccountsSelector().selectByOpportunityId(recId);
			List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(recId);
			if (accounts.SPM_Platform_Type__c != null) {
				paymentplanList = [
					SELECT
						id,
						Account__c,
						Account__r.SPM_Platform_Type__c,
						Account_Number__c,
						Account_Type__c,
						Bank_Name__c,
						Branch_Code__c,
						Branch_Name__c,
						Type__c,
						Name,
						BIC_Code__c,
						Account_Name__c,
						Application__c,
						Application_Product__c
					FROM Payment_Plan__c
					WHERE Application__c = :app[0].Id AND Type__c = 'SPM Product' AND Account__r.SPM_Platform_Type__c != NULL AND Account__c = :accounts.Id
				];
			} else {
				paymentplanList = [
					SELECT
						id,
						Account__c,
						Account_Number__c,
						Account__r.SPM_Platform_Type__c,
						Account_Type__c,
						Bank_Name__c,
						Branch_Code__c,
						Branch_Name__c,
						Type__c,
						Name,
						BIC_Code__c,
						Account_Name__c,
						Application__c,
						Application_Product__c
					FROM Payment_Plan__c
					WHERE Application__c = :app[0].Id AND Type__c = 'SPM Product'
				];
			}
			system.debug('paymentplanList' + paymentplanList);
		}

		return paymentplanList;
	}
	/**
	 * @description Method that returns an Account based on Opportunity Id
	 * @param   recordId
	 * @return  The Account object record
	 */
	@AuraEnabled
	public static Account getAccount(Id recordId) {
		String sObjName = recordId.getSObjectType().getDescribe().getName();
		if (sObjName == 'Opportunity') {
			Account accounts = new AccountsSelector().selectByOpportunityId(recordId);
			System.debug('accounts>>>>>>' + accounts);
			return accounts;
		}
		if (sObjName == 'Account') {
			Account accounts = new AccountsSelector().selectAllById(recordId);
			System.debug('accounts>>>>>>' + accounts);
			return accounts;
		}
		return null;
	}
	/**
	 * @description Method that returns bankingdetails based on Opportunity Id
	 * @param clientOppId
	 * @return The Account object record
	 */
	@AuraEnabled
	public static String getBankingDetails(String clientOppId) {
		Set<Id> oppIdSet = new Set<Id>();
		oppIdSet.add(clientOppId);

		List<Opportunity> opportunityList = new OpportunitiesSelector().selectComplianceSummaryFields(clientOppId);

		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(opportunityList[0].AccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

		if (accountList?.size() != 1) {
			return 'Error: Account not found with Id: ' + opportunityList[0].AccountId;
		}

		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(
			StringConstants.SALESFORCE_STRING,
			accountList[0].CIF__c
		);

		if (response == null) {
			return 'Error: Blank response received from service.';
		}
		if (String.isNotBlank(response.nbsmsgo3?.msgEntry?.msgTxt)) {
			return 'Error: ' + response.nbsmsgo3.msgEntry.msgTxt;
		}
		if (response.statusCode != 200) {
			return 'Error: ' + response.message;
		}
		if (response.cip047o?.outputTable == null) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(response);
		}

		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = response.cip047o.outputTable;
		for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable currentRecord : accTypes) {
			currentRecord.productTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				StringConstants.CIF,
				'Account Type',
				currentRecord.productType,
				StringConstants.INBOUND_RECORD_TYPE
			);
		}
		return JSON.serialize(accTypes);
	}
	/**
	 * @description Method that maps request parameters based on Opportunity Id
	 * @param OppId
	 * @return  SPMMarbleCreateAccount_Req_IB_V1
	 */
	@AuraEnabled
	public static SPMMarbleCreateAccount_Req_IB_V1 mapRequestFields(Id OppId) {
		Account accRec = new AccountsSelector().selectByOpportunityId(OppId);
		system.debug('OppId' + OppId);
		Opportunity oppRec = new OpportunitiesSelector().selectByOppId(OppId);
		List<OpportunityLineItem> oppLineItemList = [
			SELECT id, name, Investment_amount_R__c, Investment_Allocation__c, product2id, product2.Name
			FROM OpportunityLineItem
			WHERE OpportunityId = :OppId AND Investment_Allocation__c != NULL AND product2.Name = 'Global Equity Portfolio'
		];
		List<OpportunityLineItem> oppLineItemList2 = [
			SELECT id, name, Investment_amount_R__c, Investment_Allocation__c, product2id, product2.Name
			FROM OpportunityLineItem
			WHERE OpportunityId = :OppId AND Investment_Allocation__c != NULL AND product2.Name != 'Global Equity Portfolio'
		];
		List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(OppId);
		List<Application_Product__c> appPrdctRec = new ApplicationProductSelector().selectByOpportunityId(OppId);
		system.debug('appPrdctRec' + appPrdctRec);
		LIST<Payment_Plan__c> paymentplanList = [
			SELECT
				id,
				Account__c,
				Account_Number__c,
				Account_Type__c,
				Bank_Name__c,
				Branch_Code__c,
				Branch_Name__c,
				Type__c,
				Name,
				BIC_Code__c,
				Account_Name__c,
				Application__c,
				Application_Product__c
			FROM Payment_Plan__c
			WHERE Type__c = 'SPM Product' AND (Account__c = :accRec.Id OR Application__c = :app[0].Id)
		];
		list<OpportunityTeamMember> oppteammember = [
			SELECT id, TeamMemberRole, OpportunityId, User.Advisor_Code__c
			FROM OpportunityTeamMember
			WHERE OpportunityId = :OppId AND TeamMemberRole = 'Financial Investment Advisor'
		];

		List<AccountContactRelation> availableDirectorsList = [
			SELECT id, Account.Name, ContactId, AccountId, Roles
			FROM AccountContactRelation
			WHERE AccountId = :accRec.Id AND Roles INCLUDES ('Contact Person')
		];
		List<AccountContactRelation> availableAccConList = [
			SELECT id, Account.Name, Contact.MobilePhone, Contact.Work_Phone__c, Contact.Email, ContactId, AccountId, Roles
			FROM AccountContactRelation
			WHERE AccountId = :accRec.Id AND Roles INCLUDES ('Individual with Authority to Act')
		];
		List<Address__c> accAddress = new AddressesSelector().addressRelatedToAcc(accRec.Id, 'Physical Address');
		List<Address__c> accAddressReg = new AddressesSelector().addressRelatedToAcc(accRec.Id, 'Registered');
		List<Address__c> accAddressBus = new AddressesSelector().addressRelatedToAcc(accRec.Id, 'Business Address');
		List<Address__c> accAddressPostal = new AddressesSelector().addressRelatedToAcc(accRec.Id, 'Postal Address');
		Map<String, Address__c> addressMap = new Map<String, Address__c>();
		SPMMarbleCreateAccount_Req_IB_V1 requestBean = new SPMMarbleCreateAccount_Req_IB_V1();
		requestBean.Entity = new SPMMarbleCreateAccount_Req_IB_V1.Entity();
		requestBean.Entity.crmEntityCustomData = new SPMMarbleCreateAccount_Req_IB_V1.CrmEntityCustomData();
		requestBean.Beneficiary = new SPMMarbleCreateAccount_Req_IB_V1.Beneficiary();
		requestBean.MarbleAccountTypeList = new List<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList>();
		SPMMarbleCreateAccount_Req_IB_V1.Fund accFund = new SPMMarbleCreateAccount_Req_IB_V1.Fund();
		SPMMarbleCreateAccount_Req_IB_V1.MarblePortfolio accMarblePortfolio = new SPMMarbleCreateAccount_Req_IB_V1.MarblePortfolio();
		SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList marblelistaccType = new SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList();
		list<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList> listmarbleacctype = new List<SPMMarbleCreateAccount_Req_IB_V1.MarbleAccountTypeList>();
		string myDate =
			Datetime.now().format('yyyyMMdd').substring(2, 4) +
			'' +
			Datetime.now().hour() +
			'' +
			Datetime.now().minute() +
			'' +
			Datetime.now().second();
		accFund.fundID = 0;
		string fcode;
		if (
			accRec.Client_Group__c != null &&
			(accRec.Client_Group__c == 'Non individual' ||
			accRec.Client_Group__c == 'Estate Client' ||
			accRec.Client_Group__c == 'PARTNERSHIP CLIENT' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT')
		) {
			fcode = accRec.Name.substring(0, 8) + '' + myDate;
			accFund.fundCode = fcode.deleteWhitespace();
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Individual') {
			if (accRec.FirstName.length() > 7) {
				fcode = accRec.FirstName.substring(0, 7) + '' + accRec.LastName.substring(0, 1) + '' + myDate;
			} else {
				fcode = accRec.FirstName + '' + accRec.LastName.substring(0, 1) + '' + myDate;
			}
			accFund.fundCode = fcode.deleteWhitespace();
		}
		if (accRec.Name != null) {
			accFund.fundName = accRec.Name;
		} else {
			accFund.fundName = null;
		}
		accFund.fundReportingCurrencyID = 1; //ZAR
		string partnerIdTranslation;
		if (app[0].Platform__c != null) {
			partnerIdTranslation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Partner ID',
				app[0].Platform__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			accFund.partnerID = integer.valueOf(partnerIdTranslation);
		} else if (app[0].Platform__c == null && oppLineItemList.size() > 0) {
			accFund.partnerID = 51;
		} else if (app[0].Platform__c == null && oppLineItemList2.size() >= 0) {
			accFund.partnerID = 50;
		} else {
			accFund.partnerID = null;
		}
		accFund.inceptionDate = string.valueOf(system.today());
		accFund.defaultSectorTreeID = 8;
		accFund.defaultPerformanceTemplateiD = 1;
		accFund.defaultRiskTemplateID = 1;
		accFund.defaultModelPortfolioID = 1;
		accFund.externalSystemReference1 = 'SPM';
		accFund.externalSystemReference2 = 'SPM';
		accMarblePortfolio.portfolioID = 0;
		if (
			accRec.Client_Group__c != null &&
			(accRec.Client_Group__c == 'Non individual' ||
			accRec.Client_Group__c == 'Estate Client' ||
			accRec.Client_Group__c == 'PARTNERSHIP CLIENT' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT')
		) {
			accMarblePortfolio.portfolioCode = accRec.Name.substring(0, 8) + '' + myDate;
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Individual') {
			accMarblePortfolio.portfolioCode = accRec.FirstName + '' + accRec.LastName.substring(0, 1) + '' + myDate; //Account.Initials__pc + '' + Account.LastName;
		} else {
			accMarblePortfolio.portfolioCode = null;
		}
		accMarblePortfolio.portfolioName = accRec.Name;
		accMarblePortfolio.portfolioBaseCurrencyID = 1; //ZAR
		accMarblePortfolio.portfolioCapitaliseBrokerage = 1;
		accMarblePortfolio.glSetupID = 1;
		accMarblePortfolio.useGeneratedCorporateActions = true;
		accMarblePortfolio.isUnitisedPortfolio = true;
		accMarblePortfolio.customSectorTreeID = 8;
		accMarblePortfolio.performanceTemplateID = 1;
		accMarblePortfolio.riskTemplateID = 1;
		accMarblePortfolio.modelPortfolioTemplateID = 1;
		accMarblePortfolio.inceptionDate = string.valueOf(system.today());
		accMarblePortfolio.yearEndMonth = 2;
		accMarblePortfolio.defaultCustodianAccountID = 49;
		accMarblePortfolio.fundID = 0;
		accMarblePortfolio.defaultAccountingTypeID = 1;
		accMarblePortfolio.useFIFOBVCalculation = false;
		accMarblePortfolio.dayEndTime = '23:59:00.0000000';
		accMarblePortfolio.defaultTXTime = '12:00:00.0000000';
		accMarblePortfolio.requiresMTM = false;
		accMarblePortfolio.postMTMAmortisation = false;
		accMarblePortfolio.requiresMTMFromDate = null; //system.today();
		accMarblePortfolio.requiresSettlements = true;
		accMarblePortfolio.requiresSettlementsFromDate = string.valueOf(system.today());
		accMarblePortfolio.requiresMargins = true;
		accMarblePortfolio.requiresMarginsFromDate = string.valueOf(system.today());
		accMarblePortfolio.requiresCorporateActions = true;
		accMarblePortfolio.requiresCorporateActionsFromDate = string.valueOf(system.today());
		accMarblePortfolio.requiresAccruals = true;
		accMarblePortfolio.requiresAccrualsFromDate = string.valueOf(system.today());
		accMarblePortfolio.portfolioTypeID = 1;
		accMarblePortfolio.portfolioProductTypeID = 15;
		accMarblePortfolio.investmentObjectiveID = 7;
		if (app[0].Total_Score__c != null) {
			string riskAppetite = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Risk Appetite',
				app[0].Total_Score__c,
				'Outbound'
			);
			accMarblePortfolio.riskAppetiteID = Integer.valueOf(riskAppetite);
		} else {
			accMarblePortfolio.riskAppetiteID = null;
		}
		accMarblePortfolio.feeScaleID = 1;
		accMarblePortfolio.monthlyIncomeRequired = 0;
		accMarblePortfolio.isActive = true;
		accMarblePortfolio.portfolioManagerID = 1;
		accMarblePortfolio.portfolioReportingGroupID = 365;
		accMarblePortfolio.liableForDividendWithholdingTax = true; //TBC
		accMarblePortfolio.liableForInterestWithholdingTax = true; //TBC
		accMarblePortfolio.portfolioAdministratorID = 4;
		accMarblePortfolio.portfolioAdvisorID = 1;
		accMarblePortfolio.portfolioIntroducerID = 1;
		accMarblePortfolio.portfolioSalesRepID = 1;
		accMarblePortfolio.dividendPayoutOptionID = 1;
		accMarblePortfolio.dividendPayoutPercentage = 0;
		accMarblePortfolio.regularInvestmentFrequencyID = 1;
		accMarblePortfolio.regularInvestmentValue = 0;
		accMarblePortfolio.regularInvestmentAnnualIncreaseRate = 0;
		accMarblePortfolio.regularInvestmentStartDate = string.valueOf(system.today());
		accMarblePortfolio.regularInvestmentDayOfMonth = 25; //praneel confirmed
		if (appPrdctRec[0].Frequency_of_payment_required__c != null) {
			string frequencypayment = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Payment Frequency',
				appPrdctRec[0].Frequency_of_payment_required__c,
				'Outbound'
			);
			accMarblePortfolio.regularWithdrawalFrequencyID = Integer.valueOf(frequencypayment);
		} else {
			accMarblePortfolio.regularWithdrawalFrequencyID = 1;
		}
		if (appPrdctRec[0].Regular_withdrawal_amount_R__c != null) {
			accMarblePortfolio.regularWithdrawalValue = Integer.valueOf(appPrdctRec[0].Regular_withdrawal_amount_R__c);
		} else {
			accMarblePortfolio.regularWithdrawalValue = null;
		} //Regular withdrawal amount R
		accMarblePortfolio.regularWithdrawalPercentageOfMV = 0;
		accMarblePortfolio.regularWithdrawalStartDate = string.valueOf(system.today());
		accMarblePortfolio.regularWithdrawalDayOfMonth = 25;
		accMarblePortfolio.performanceCalculationStartDate = string.valueOf(system.today());
		accMarblePortfolio.deactivatedDate = '2100-12-31 12:00:00.000';
		accMarblePortfolio.useHistoricPerformanceData = true;
		accMarblePortfolio.historicPerformanceDataStartDate = string.valueOf(system.today());
		accMarblePortfolio.historicPerformanceDataEndDate = string.valueOf(system.today());
		accMarblePortfolio.externalSystemReference1 = 'SPM';
		accMarblePortfolio.externalSystemReference2 = 'SPM';
		marblelistaccType.fund = accFund;
		marblelistaccType.marblePortfolio = accMarblePortfolio;
		requestBean.MarbleAccountTypeList.add(marblelistaccType);
		requestBean.Beneficiary.portfolioID = null;
		if (
			accRec.Client_Group__c != null &&
			(accRec.Client_Group__c == 'Non individual' ||
			accRec.Client_Group__c == 'Estate Client' ||
			accRec.Client_Group__c == 'PARTNERSHIP CLIENT' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT')
		) {
			requestBean.Beneficiary.beneficiaryName = accRec.Name;
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Individual') {
			requestBean.Beneficiary.beneficiaryName = accRec.Initials__pc + '' + accRec.LastName;
		} else {
			requestBean.Beneficiary.beneficiaryName = null;
		}
		if (!paymentplanList.isEmpty()) {
			if (paymentplanList[0].Account_Type__c != null) {
				requestBean.Beneficiary.accountType = paymentplanList[0].Account_Type__c;
			} else {
				requestBean.Beneficiary.accountType = 'Cheque';
			}
			if (paymentplanList[0].Bank_Name__c != null) {
				requestBean.Beneficiary.accountName = paymentplanList[0].Bank_Name__c;
			} else {
				requestBean.Beneficiary.accountName = 'absa bank';
			}
			if (paymentplanList[0].Account_Number__c != null) {
				requestBean.Beneficiary.accountNumber = paymentplanList[0].Account_Number__c;
			} else {
				requestBean.Beneficiary.accountNumber = '1234567890';
			}
			if (paymentplanList[0].Branch_Code__c != null) {
				requestBean.Beneficiary.branchCode = string.valueOf(paymentplanList[0].Branch_Code__c);
			} else {
				requestBean.Beneficiary.branchCode = '123456';
			}
		} else {
			requestBean.Beneficiary.accountType = null; //'Cheque';
			requestBean.Beneficiary.accountName = null; //'absa bank';
			requestBean.Beneficiary.accountNumber = null; //'1234567890';
			requestBean.Beneficiary.branchCode = null; //'123456';
		}
		requestBean.Beneficiary.beneficiaryReference = 'ABSA SPM CLIENT PAYMENT';
		requestBean.Beneficiary.currency_Z = 'ZAR';
		requestBean.Entity.crmEntityCustomData.entityID = 0;
		if (accRec.Gender__pc != null) {
			if (accRec.Gender__pc == 'Male') {
				requestBean.Entity.crmEntityCustomData.sex = 'M';
			} else if (accRec.Gender__pc == 'Female') {
				requestBean.Entity.crmEntityCustomData.sex = 'F';
			}
		} else {
			requestBean.Entity.crmEntityCustomData.sex = null; //'M';
		}
		requestBean.Entity.crmEntityCustomData.languageCode = 'E';
		requestBean.Entity.crmEntityCustomData.staffIndicatorAbsaGroup = 'N'; //new field
		requestBean.Entity.crmEntityCustomData.staffIndicatorAbsaSPM = 'N'; //new field
		requestBean.Entity.crmEntityCustomData.settlementTypeCode = 'C';
		if (accRec.Country_of_Registration__c != 'South Africa' && (accRec.Client_Group__c == 'Non individual' || accRec.Client_Group__c == 'Estate Client')) {
			requestBean.Entity.crmEntityCustomData.nonResidentIndicator = 'Y';
		} else if (
			(accRec.Client_Group__c == 'Individual' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT') && accRec.Country_of_Residence__c != 'South Africa'
		) {
			requestBean.Entity.crmEntityCustomData.nonResidentIndicator = 'Y';
		} else if (accRec.Client_Group__c == 'PARTNERSHIP CLIENT' && accRec.Country_of_Incorporation__c != 'South Africa') {
			requestBean.Entity.crmEntityCustomData.nonResidentIndicator = 'Y';
		} else {
			requestBean.Entity.crmEntityCustomData.nonResidentIndicator = 'N';
		}
		requestBean.Entity.crmEntityCustomData.exchangeControl = 'N';
		if (accRec.Country_of_Registration__c != null && (accRec.Client_Group__c == 'Non individual' || accRec.Client_Group__c == 'Estate Client')) {
			requestBean.Entity.crmEntityCustomData.countryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Country_of_Registration__c,
				'Outbound'
			);
		} else if (
			(accRec.Client_Group__c == 'Individual' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT') && accRec.Country_of_Residence__c != null
		) {
			requestBean.Entity.crmEntityCustomData.countryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Country_of_Residence__c,
				'Outbound'
			);
		} else if (accRec.Client_Group__c == 'PARTNERSHIP CLIENT' && accRec.Country_of_Incorporation__c != null) {
			requestBean.Entity.crmEntityCustomData.countryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Country_of_Incorporation__c,
				'Outbound'
			);
		} else {
			requestBean.Entity.crmEntityCustomData.countryCode = 'ZA';
		}
		requestBean.Entity.crmEntityCustomData.principalAgentIndicator = 'Y';
		requestBean.Entity.crmEntityCustomData.electionIndicator = null;
		requestBean.Entity.crmEntityCustomData.electronicReportIndicator = 'A';
		requestBean.Entity.crmEntityCustomData.beeIndicator = null;
		requestBean.Entity.crmEntityCustomData.beeExpiryDate = null;
		requestBean.Entity.crmEntityCustomData.postalAddressCareOfAddressIndicator = 'N';
		requestBean.Entity.crmEntityCustomData.addressCareOfName = 'N/A';
		if (oppRec.Risk_Rating__c != null) {
			requestBean.Entity.crmEntityCustomData.clientRiskRating = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Risk Rating',
				oppRec.Risk_Rating__c,
				'Outbound'
			);
		} else {
			requestBean.Entity.crmEntityCustomData.clientRiskRating = 'low';
		}
		requestBean.Entity.crmEntityCustomData.shareholderPercentage = null;
		if (!availableDirectorsList.isEmpty()) {
			if (availableDirectorsList[0].Account.Name != null) {
				requestBean.Entity.crmEntityCustomData.contactPerson = availableDirectorsList[0].Account.Name;
			} else {
				requestBean.Entity.crmEntityCustomData.contactPerson = 'N/A';
			}
		} else {
			requestBean.Entity.crmEntityCustomData.contactPerson = 'N/A';
		}
		requestBean.Entity.crmEntityCustomData.powerOffAttorney = 'N';
		if (app[0].Intermediary_Client_Name__c != null || app[0].Intermediary_Client_Number__c != null) {
			requestBean.Entity.crmEntityCustomData.refferedBy = app[0].Intermediary_Client_Name__c + '' + app[0].Intermediary_Client_Number__c;
		} else {
			requestBean.Entity.crmEntityCustomData.refferedBy = null;
		}
		requestBean.Entity.crmEntityCustomData.portfolioManagementCHGCode = '00';
		requestBean.Entity.crmEntityCustomData.safeCustodyChargeCode = '01';
		requestBean.Entity.crmEntityCustomData.nameOFPOA = null;
		if (accRec.Source_of_Income__c != null) {
			requestBean.Entity.crmEntityCustomData.sourceOfIncome = accRec.Source_of_Income__c;
		} else {
			requestBean.Entity.crmEntityCustomData.sourceOfIncome = null;
		}
		if (accRec.Reason_For_Not_Providing_SA_Tax_Number__c != null) {
			requestBean.Entity.crmEntityCustomData.reasonForNoTaxNumber = accRec.Reason_For_Not_Providing_SA_Tax_Number__c;
		} else {
			requestBean.Entity.crmEntityCustomData.reasonForNoTaxNumber = null;
		}
		requestBean.Entity.crmEntityCustomData.tfsaIndicator = 'N';
		requestBean.Entity.crmEntityCustomData.email2 = null;
		if (accRec.ID_Type__c != null && accRec.ID_Type__c == 'SA Identity Document') {
			requestBean.Entity.crmEntityCustomData.idType = '001';
		} else if (accRec.ID_Type__c != null && accRec.ID_Type__c == 'Passport') {
			requestBean.Entity.crmEntityCustomData.idType = '003';
		} else if (accRec.Client_Type__c == 'Trusts') {
			requestBean.Entity.crmEntityCustomData.idType = '007';
		} else if (
			accRec.Client_Type__c == 'Private Company' ||
			accRec.Client_Type__c == 'Public Company' ||
			accRec.Client_Type__c == 'Public Listed Company' ||
			accRec.Client_Type__c == 'Close Corporation' ||
			accRec.Client_Type__c == 'Incorporated Company'
		) {
			requestBean.Entity.crmEntityCustomData.idType = '004';
		} else if (accRec.Client_Type__c == 'Foreign Listed Company' || accRec.Client_Type__c == 'Foreign Company') {
			requestBean.Entity.crmEntityCustomData.idType = '005';
		} else {
			requestBean.Entity.crmEntityCustomData.idType = null;
		}
		if ((accRec.Client_Group__c == 'Individual' || accRec.Client_Group__c == 'SOLE TRADER CLIENT') && accRec.ID_Number__pc != null) {
			requestBean.Entity.crmEntityCustomData.idNumber = string.valueOf(accRec.ID_Number__pc);
		} else if (
			(accRec.Client_Group__c == 'Non individual' || accRec.Client_Group__c == 'Estate Client' || accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT') &&
			accRec.Registration_Number__c != null
		) {
			requestBean.Entity.crmEntityCustomData.idNumber = string.valueOf(accRec.Registration_Number__c);
		} else {
			requestBean.Entity.crmEntityCustomData.idNumber = null;
		}
		if (accRec.Country_Passport_Issued__pc != null) {
			requestBean.Entity.crmEntityCustomData.countryOfIssue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Country_Passport_Issued__pc,
				'Outbound'
			); //accRec.Country_Passport_Issued__pc;
		} else {
			requestBean.Entity.crmEntityCustomData.countryOfIssue = null;
		}
		if (accRec.Passport_Expiry_Date__c != null) {
			requestBean.Entity.crmEntityCustomData.ppExpiryDate = string.valueOf(accRec.Passport_Expiry_Date__c);
		} else {
			requestBean.Entity.crmEntityCustomData.ppExpiryDate = null;
		}
		if (accRec.Country_of_Birth__pc != null) {
			requestBean.Entity.crmEntityCustomData.countryOfBirth = accRec.Country_of_Birth__pc;
		} else {
			requestBean.Entity.crmEntityCustomData.countryOfBirth = null;
		}
		if (accAddress.size() > 0) {
			if (accAddress[0].Shipping_Country__c != null) {
				requestBean.Entity.crmEntityCustomData.countryOfResForDWT = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					'NetReveal',
					'Country',
					accAddress[0].Shipping_Country__c,
					'Outbound'
				);
			} else {
				requestBean.Entity.crmEntityCustomData.countryOfResForDWT = null;
			}
		}
		if (accRec.Country_of_Foreign_tax__c != null) {
			requestBean.Entity.crmEntityCustomData.taxResidency1 = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Country_of_Foreign_tax__c,
				'Outbound'
			);
		} else {
			requestBean.Entity.crmEntityCustomData.taxResidency1 = null;
		}
		requestBean.Entity.crmEntityCustomData.taxResidency2 = null;
		requestBean.Entity.crmEntityCustomData.taxResidency3 = null;
		requestBean.Entity.crmEntityCustomData.taxResidency4 = null;
		requestBean.Entity.crmEntityCustomData.taxResidency5 = null;
		if (accRec.Foreign_Tax_Number__c != null) {
			requestBean.Entity.crmEntityCustomData.foreignTaxNumbers1 = string.valueOf(accRec.Foreign_Tax_Number__c);
		} else {
			requestBean.Entity.crmEntityCustomData.foreignTaxNumbers1 = null;
		}
		requestBean.Entity.crmEntityCustomData.foreignTaxNumbers2 = null;
		requestBean.Entity.crmEntityCustomData.foreignTaxNumbers3 = null;
		requestBean.Entity.crmEntityCustomData.foreignTaxNumbers4 = null;
		requestBean.Entity.crmEntityCustomData.foreignTaxNumbers5 = null;
		if (accRec.Nationality__pc != null) {
			requestBean.Entity.crmEntityCustomData.nationality1 = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Nationality__pc,
				'Outbound'
			); //accRec.Nationality__pc;
		} else {
			requestBean.Entity.crmEntityCustomData.nationality1 = null;
		}
		if (accRec.Standard_Industry_SIC_Code__c != null) {
			requestBean.Entity.crmEntityCustomData.sicCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'CIF',
				'Standard Industry SIC Code',
				accRec.Standard_Industry_SIC_Code__c,
				'Outbound'
			); //accRec.Standard_Industry_SIC_Code__c;
		} else {
			requestBean.Entity.crmEntityCustomData.sicCode = '';
		}
		if (accRec.Date_Identified__c != null && accRec.Date_Verified__c == null) {
			requestBean.Entity.crmEntityCustomData.ficaCompliant = 'Y'; //needs clarity
			requestBean.Entity.crmEntityCustomData.dateOfFICACompliant = string.valueOf(accRec.Date_Identified__c);
		} else if (accRec.Date_Identified__c == null && accRec.Date_Verified__c != null) {
			requestBean.Entity.crmEntityCustomData.ficaCompliant = 'Y'; //needs clarity
			requestBean.Entity.crmEntityCustomData.dateOfFICACompliant = string.valueOf(accRec.Date_Verified__c);
		} else {
			requestBean.Entity.crmEntityCustomData.ficaCompliant = 'N';
			requestBean.Entity.crmEntityCustomData.dateOfFICACompliant = null;
		}
		if (oppRec.PEP_Status__c == 'PEP') {
			requestBean.Entity.crmEntityCustomData.sanctionsOnPoliticalPeron = 'Y';
		} else {
			requestBean.Entity.crmEntityCustomData.sanctionsOnPoliticalPeron = 'N';
		}
		requestBean.Entity.crmEntityCustomData.dwtExemption = null; //'Y'
		requestBean.Entity.crmEntityCustomData.iT3BExcl = 'N';
		requestBean.Entity.crmEntityCustomData.iT3CExcl = 'N';
		requestBean.Entity.crmEntityCustomData.dwtFormAorB = null;
		requestBean.Entity.crmEntityCustomData.dividendPassThrough = 'N';
		requestBean.Entity.crmEntityCustomData.reportingAccount = 'N';
		requestBean.Entity.crmEntityCustomData.financialInstitutionsGIIN = null;
		requestBean.Entity.crmEntityCustomData.countryOfJurisdiction1 = null;
		requestBean.Entity.crmEntityCustomData.countryOfJurisdiction2 = null;
		if (oppteammember.size() > 0 && oppRec.Independent_Financial_Advisor__c != null) {
			if (oppteammember[0].User.AB_Number__c != null) {
				requestBean.Entity.crmEntityCustomData.advisorCode = oppteammember[0].User.AB_Number__c;
			} else {
				requestBean.Entity.crmEntityCustomData.advisorCode = oppteammember[0].User.Name;
			}
		} else if (oppteammember.size() > 0 && oppRec.Independent_Financial_Advisor__c == null) {
			if (oppteammember[0].User.AB_Number__c != null) {
				requestBean.Entity.crmEntityCustomData.advisorCode = oppteammember[0].User.AB_Number__c;
			} else {
				requestBean.Entity.crmEntityCustomData.advisorCode = oppteammember[0].User.Name;
			}
		} else if (oppteammember.size() < 0 && oppRec.Independent_Financial_Advisor__c != null) {
			requestBean.Entity.crmEntityCustomData.advisorCode = oppRec.Independent_Financial_Advisor__c;
		} else {
			requestBean.Entity.crmEntityCustomData.advisorCode = null;
		}
		if (oppRec.Owner != null) {
			requestBean.Entity.crmEntityCustomData.pfadv = oppRec.Owner.FirstName.substring(0, 1) + '' + oppRec.Owner.LastName.substring(0, 1);
		} else {
			requestBean.Entity.crmEntityCustomData.pfadv = null;
		}
		requestBean.Entity.crmEntityCustomData.portfolioIntroducerID = '1';
		requestBean.Entity.crmEntityCustomData.newsletter = 'E';
		requestBean.Entity.crmEntityCustomData.newsletterPER = 'E';
		requestBean.Entity.crmEntityCustomData.liableForInterestWithholdingTax = null;
		requestBean.Entity.crmEntityCustomData.type = 'C';
		requestBean.Entity.crmEntityCustomData.entConsolidation = 'N';
		requestBean.Entity.crmEntityCustomData.ermCheck = 'Y';
		requestBean.Entity.crmEntityCustomData.mancoCode = null;
		requestBean.Entity.crmEntityCustomData.reitsExemption = null;
		requestBean.Entity.crmEntityCustomData.brokerTrusteeFee = '0';
		requestBean.Entity.crmEntityCustomData.feeSharing = null;
		requestBean.Entity.crmEntityCustomData.upfrontStructuringFee = null;
		requestBean.Entity.crmEntityCustomData.dividendTaxProvisionPercentage = null;
		requestBean.Entity.crmEntityCustomData.cgtProvisionPercentage = null;
		requestBean.Entity.crmEntityCustomData.incomeTaxProvisionPercentage = null;
		requestBean.Entity.crmEntityCustomData.incomeAccount = null;
		requestBean.Entity.crmEntityCustomData.beneficiaryID = null;
		requestBean.Entity.crmEntityCustomData.beneficiaryName = null;
		requestBean.Entity.crmEntityCustomData.recordofAdvice = null;

		requestBean.Entity.crmName = accRec.Name + '' + myDate;
		if (app[0].Platform__c != null) {
			string partnerIdTranslation1 = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Partner ID',
				app[0].Platform__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			requestBean.partnerID = integer.valueOf(partnerIdTranslation1);
		} else if (app[0].Platform__c == null && oppLineItemList.size() > 0) {
			requestBean.partnerID = 51;
		} else if (app[0].Platform__c == null && oppLineItemList2.size() > 0) {
			requestBean.partnerID = 50;
		} else {
			requestBean.partnerID = null;
		}
		if (app[0].Platform__c != null) {
			string partnerIdTranslation2 = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Partner ID',
				app[0].Platform__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			requestBean.Entity.partnerID = integer.valueOf(partnerIdTranslation2);
		} else if (app[0].Platform__c == null && oppLineItemList.size() > 0) {
			requestBean.Entity.partnerID = 51;
		} else if (app[0].Platform__c == null && oppLineItemList2.size() > 0) {
			requestBean.Entity.partnerID = 50;
		} else {
			requestBean.Entity.partnerID = null;
		}

		requestBean.Entity.entityID = 0;
		if (accRec.Client_Type__c != null) {
			string entityType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Client Type',
				accRec.Client_Type__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			requestBean.Entity.entityTypeID = Integer.valueOf(entityType);
		} else {
			requestBean.Entity.entityTypeID = 0;
		}
		if (accRec.PersonTitle != null) {
			string Title = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'SPM Marble',
				'Title',
				accRec.PersonTitle,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			system.debug('Title' + Title);
			if (Title != '' || Title != null) {
				requestBean.Entity.titleID = Integer.valueOf(Title);
			} else {
				requestBean.Entity.titleID = null;
			}
		} else {
			requestBean.Entity.titleID = 8;
		}
		requestBean.Entity.crmStatusID = 1;
		if (accRec.FirstName != null) {
			requestBean.Entity.firstName = accRec.FirstName;
		} else {
			requestBean.Entity.firstName = null;
		}
		if (accRec.MiddleName != null) {
			requestBean.Entity.middleName = accRec.MiddleName;
		} else {
			requestBean.Entity.middleName = null;
		}
		if (accRec.Initials__pc != null) {
			requestBean.Entity.initials = accRec.Initials__pc;
		} else {
			requestBean.Entity.initials = null;
		}
		if (accRec.LastName != null) {
			requestBean.Entity.lastName = accRec.LastName;
		} else {
			requestBean.Entity.lastName = null;
		}
		if (accRec.PersonBirthdate != null) {
			requestBean.Entity.dateOfBirth = accRec.PersonBirthdate;
		} else {
			requestBean.Entity.dateOfBirth = null;
		}
		requestBean.Entity.takeOnDate = string.valueOf(system.today());
		if (app[0].Intermediary_Client_Name__c != null) {
			requestBean.Entity.appelation = app[0].Intermediary_Client_Name__c;
		} else {
			requestBean.Entity.appelation = null;
		}
		requestBean.Entity.terminationDate = null;
		requestBean.Entity.terminationReason = null;
		if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Non individual') {
			requestBean.Entity.company = accRec.Name;
		} else {
			requestBean.Entity.company = null;
		}
		if (accRec.Registration_Number__c != null) {
			requestBean.Entity.registrationNumber = accRec.Registration_Number__c;
		} else {
			requestBean.Entity.registrationNumber = null;
		}
		if (accRec.Income_Tax_Number__c != null && accRec.Income_Tax_Number__pc == null) {
			requestBean.Entity.incomeTaxNumber = string.valueOf(accRec.Income_Tax_Number__c);
		} else if (accRec.Income_Tax_Number__c == null && accRec.Income_Tax_Number__pc != null) {
			requestBean.Entity.incomeTaxNumber = string.valueOf(accRec.Income_Tax_Number__pc);
		} else {
			requestBean.Entity.incomeTaxNumber = null;
		}
		if (accRec.VAT_Registration_Number__c != null) {
			requestBean.Entity.vatNumber = string.valueOf(accRec.VAT_Registration_Number__c);
		} else {
			requestBean.Entity.vatNumber = null;
		}
		if (accRec.Nationality__pc != null) {
			requestBean.Entity.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'NetReveal',
				'Country',
				accRec.Nationality__pc,
				'Outbound'
			);
		} else {
			requestBean.Entity.nationality = null;
		}
		if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Individual') {
			if (accAddress.size() > 0) {
				requestBean.Entity.addressLine1 = accAddress[0].Shipping_Street__c;
				requestBean.Entity.addressLine2 = accAddress[0].Shipping_Street_2__c;
				requestBean.Entity.addressLine3 = accAddress[0].Shipping_City__c;
				requestBean.Entity.addressLine4 = accAddress[0].Shipping_Suburb__c;
				requestBean.Entity.addressLine5 = accAddress[0].Shipping_Zip_Postal_Code__c;
			}
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'SOLE TRADER CLIENT') {
			if (accAddressBus.size() > 0) {
				requestBean.Entity.addressLine1 = accAddressBus[0].Shipping_Street__c;
				requestBean.Entity.addressLine2 = accAddress[0].Shipping_Street_2__c;
				requestBean.Entity.addressLine3 = accAddressBus[0].Shipping_City__c;
				requestBean.Entity.addressLine4 = accAddressBus[0].Shipping_Suburb__c;
				requestBean.Entity.addressLine5 = accAddressBus[0].Shipping_Zip_Postal_Code__c;
			}
		} else if (
			accRec.Client_Group__c != null &&
			(accRec.Client_Group__c == 'Non individual' ||
			accRec.Client_Group__c == 'Estate Client' ||
			accRec.Client_Group__c == 'PARTNERSHIP CLIENT')
		) {
			if (accAddressReg.size() > 0) {
				requestBean.Entity.addressLine1 = accAddressReg[0].Shipping_Street__c;
				//if(accAddressReg[0].Shipping_Street_2__c!=null){
				requestBean.Entity.addressLine2 = accAddressReg[0].Shipping_Street_2__c;
				//}else{requestBean.Entity.addressLine2 = null;}
				requestBean.Entity.addressLine3 = accAddressReg[0].Shipping_City__c;
				requestBean.Entity.addressLine4 = accAddressReg[0].Shipping_Suburb__c;
				requestBean.Entity.addressLine5 = accAddressReg[0].Shipping_Zip_Postal_Code__c;
			}
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT') {
			if (accAddressPostal.size() > 0) {
				requestBean.Entity.addressLine1 = accAddressPostal[0].Shipping_Street__c;
				if (accAddressPostal[0].Shipping_Street_2__c != null) {
					requestBean.Entity.addressLine2 = accAddressPostal[0].Shipping_Street_2__c;
				} else {
					requestBean.Entity.addressLine2 = null;
				}
				requestBean.Entity.addressLine3 = accAddressPostal[0].Shipping_City__c;
				requestBean.Entity.addressLine4 = accAddressPostal[0].Shipping_Suburb__c;
				requestBean.Entity.addressLine5 = accAddressPostal[0].Shipping_Zip_Postal_Code__c;
			}
		} else {
			requestBean.Entity.addressLine1 = null;
			requestBean.Entity.addressLine2 = null;
			requestBean.Entity.addressLine3 = null;
			requestBean.Entity.addressLine4 = null;
			requestBean.Entity.addressLine5 = null;
		}
		if (
			accRec.Client_Group__c != null &&
			(accRec.Client_Group__c == 'Non individual' ||
			accRec.Client_Group__c == 'Estate Client' ||
			accRec.Client_Group__c == 'PARTNERSHIP CLIENT' ||
			accRec.Client_Group__c == 'SOLE TRADER CLIENT' ||
			accRec.Client_Group__c == 'JOINT AND SEVERAL CLIENT')
		) {
			if (!availableAccConList.isEmpty()) {
				requestBean.Entity.contactNumber1 = availableAccConList[0].Contact.MobilePhone;
				requestBean.Entity.contactNumber2 = availableAccConList[0].Contact.Work_Phone__c;
				requestBean.Entity.cellphoneNumber = availableAccConList[0].Contact.MobilePhone;
				requestBean.Entity.emailAddress = availableAccConList[0].Contact.Email;
			}
		} else if (accRec.Client_Group__c != null && accRec.Client_Group__c == 'Individual') {
			requestBean.Entity.contactNumber1 = accRec.PersonMobilePhone;
			requestBean.Entity.contactNumber2 = accRec.PersonHomePhone;
			requestBean.Entity.cellphoneNumber = accRec.PersonMobilePhone;
			requestBean.Entity.emailAddress = accRec.PersonEmail;
		}
		requestBean.Entity.faxNumber = null;
		if (accRec.Financial_Year_End__c != null) {
			requestBean.Entity.financialYearEndMonth = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'CIF',
				'Financial Year End',
				accRec.Financial_Year_End__c,
				'Outbound'
			); //accRec.Financial_Year_End__c;
		} else {
			requestBean.Entity.financialYearEndMonth = null;
		}
		requestBean.Entity.financialYearEndDay = null;
		requestBean.Entity.sendStatementsViaEmail = true;
		requestBean.Entity.externalSystemReference1 = 'SPM';
		requestBean.Entity.externalSystemReference2 = 'SPM';

		system.debug('requestBean!!!!' + requestBean);
		return requestBean;
	}
	/**
	 * @description Method that calls marble create account on Opportunity Id
	 * @param   oppId
	 * @return Application__c
	 */
	@AuraEnabled
	public static Application__c marblecreateAccount(Id oppId) {
		List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(OppId);
		Opportunity oppRec = new OpportunitiesSelector().selectByOppId(OppId);
		//Map request
		SPMMarbleCreateAccount_Req_IB_V1 requestBean = mapRequestFields(oppId);
		system.debug('requestBean' + requestBean);
		SPMMarbleCreateAccount_Resp_IB_V1 responseBean = SPMMarbleCreateAccount_IH_V1.getMarbleAccountNumber(requestBean);
		system.debug('responseBean---' + responseBean);
		if(requestBean.Beneficiary.accountName ==null || requestBean.Beneficiary.accountType ==null || requestBean.Beneficiary.accountNumber ==null || requestBean.Beneficiary.branchCode ==null){
            throw new AuraHandledException('Please complete the mandatory fields Branch Code, Account Number, Account Name, Account Type in the Banking Details Section');
        }else if ((responseBean != null) && (responseBean.statusCode == 200)) {
            if(responseBean.statusCode == 200 && responseBean.Result.status != 200 && responseBean.partnerID ==0){
                throw new AuraHandledException(responseBean.Result.status + ' ' + responseBean.Result.errorCode + ' ' + responseBean.Result.errorMessage+'\r\n'+'Platform Client - Please select a Platform Type.'+'\r\n'+'Non-Platform Client - Please allocate % to the Portfolio(s) in the Risk Profile Table.');
            }else if (responseBean.statusCode == 200 && responseBean.Result.status != 200 && responseBean.partnerID !=0) {
                //SPMMarbleCreateAccount_Resp_IB_V1 response = (SPMMarbleCreateAccount_Resp_IB_V1)JSON.deserialize(responseBean.Result.errorMessage,SPMMarbleCreateAccount_Resp_IB_V1.class);
                throw new AuraHandledException(responseBean.Result.errorMessage);
            } else {
                System.debug('#####' + responseBean.serialize(responseBean) + '#####');
                app[0].Account_Number__c = string.valueOf(responseBean.entityId);
                update app[0];
                oppRec.stageName = 'Closed Won';
                update oppRec;
            }
        }

        return app[0];
	}
	/**
	 * @description Method that returns an Application__c based on Opportunity Id
	 * @param oppId
	 * @return The Application__c object record
	 */
	@AuraEnabled
	public static Application__c getAppRec(Id oppId) {
		List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
		return app[0];
	}
	/**
	 * @description Method that returns an Application__c based on Opportunity Id
	 * @param oppId
	 * @param firstname
	 * @param trustname
	 * @param absatrust2
	 * @param platform
	 * @return The Application__c object record
	 */
	@AuraEnabled
	public static Application__c saveadditionalinfo(Id oppId, string firstname, string trustname, string absatrust2, string platform) {
		system.debug('platform---' + platform);
		List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
		if (
			platform == 'Absa Trust - Burg Managed (BD)' ||
			platform == 'Absa Trust - Burg Managed Portfolio (BG)' ||
			platform == 'Absa Trust - Ex TR (BK)' ||
			platform == 'Absa Trust Discretionary (BP)'
		) {
			app[0].Intermediary_Client_Name__c = trustname;
			app[0].Intermediary_Client_Number__c = absatrust2;
		} else if (
			platform != 'Absa Trust - Burg Managed (BD)' ||
			platform != 'Absa Trust - Burg Managed Portfolio (BG)' ||
			platform != 'Absa Trust - Ex TR (BK)' ||
			platform != 'Absa Trust Discretionary (BP)'
		) {
			app[0].Intermediary_Client_Name__c = firstname;
			//app[0].Intermediary_Client_Number__c=absatrust1;
		}
		update app[0];
		return app[0];
	}
	/**
	 * @description Method that returns an Application_Product__c based on Opportunity Id
	 * @param oppId
	 * @return The Application_Product__c object record
	 */
	@AuraEnabled
	public static Application_Product__c getAppPrdctRec(Id oppId) {
		List<Application_Product__c> appPrdctRec = new ApplicationProductSelector().selectByOpportunityId(oppId);
		return appPrdctRec[0];
	}

	/**
	 * @description
	 * @author
	 * @param oppId
	 * @return string
	 **/
	@AuraEnabled
	public static string updateOppStage(Id oppId) {
		try {
			Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
			if (opp != null) {
				opp.StageName = 'Upload Documents';

				update opp;
			}
			return 'SUCCESS';
		} catch (Exception ex) {
			system.debug(ex.getMessage());
			return 'FAILURE';
		}
	}
}