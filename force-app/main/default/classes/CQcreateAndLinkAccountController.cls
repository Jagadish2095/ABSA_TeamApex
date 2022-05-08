/**
 * @description       : CQcreateAndLinkAccountController
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-25
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Apex PMD Compliance
 * 1.1   2021-07-05   André Pietersen (IQ Business)   Moved Fraud and metadata call to seperate helper
 * 1.2   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 **/
public without sharing class CQcreateAndLinkAccountController {
	public static Account acc;
	public static Application__c app;
	public static Opportunity opp;
	public static OpportunityLineItem oppproduct;
	public static User userRec;
	public static Address__c addr;

	/**
	 * @description callCQcreateAcct
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 * @param common (CreateRetailAccountCommon)
	 * @return String
	 **/
	@AuraEnabled
	public static String callCQcreateAcct(String oppId, CreateRetailAccountCommon common) {
		String returnMessage = '';
		setOpportunityDetails(oppId);
		//If opportunityLineItem already has account number skip Create and Link and continue with process
		if (!string.isBlank(oppproduct.Policy_Number__c) || !string.isEmpty(oppproduct.Policy_Number__c)) {
			if (common.usePackageAccount) {
				Payment_Plan__c paymentPlan = [
					SELECT Account_Holder_Name__c, Account_Number__c, Account_Type__c, Bank_Name__c
					FROM Payment_Plan__c
					WHERE Id = :common.paymentPlanId
					WITH SECURITY_ENFORCED
				];
				paymentPlan.Account_Holder_Name__c = acc.Name;
				paymentPlan.Account_Number__c = oppproduct.Policy_Number__c;
				paymentPlan.Account_Type__c = 'Cheque';
				paymentPlan.Bank_Name__c = 'ABSA';
				update paymentPlan;
			}
			returnMessage = 'Existing';
			return returnMessage;
		}
		CQcreateAndLinkAccountV9_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV9_Req_IB_v1();
		requestBean.NBSAPDPI = new CQcreateAndLinkAccountV9_Req_IB_v1.NBSAPDPI();
		requestBean.MSGI = new CQcreateAndLinkAccountV9_Req_IB_v1.MSGI();
		requestBean.CQS411I = new CQcreateAndLinkAccountV9_Req_IB_v1.CQS411I();

		requestBean.CQS411I.CQN411I_INPUT_AREA = new CQcreateAndLinkAccountV9_Req_IB_v1.CQN411I_INPUT_AREA();
		requestBean.CQS411I.CQN411I_INPUT_AREA.accountNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSite = userRec.SiteCode__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSite = userRec.SiteCode__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.cifKey = opp.CIF_Number__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.tellerNbr = userRec.Teller_Operator_Code__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controllerNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.workstationNbr = '0';
		requestBean.CQS411I.CQN411I_INPUT_AREA.product = Integer.valueOf(oppproduct.ProductCode);
		requestBean.CQS411I.CQN411I_INPUT_AREA.applicationNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSiteType = userRec.SiteType__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSiteType = userRec.SiteType__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.effectiveDate = Integer.valueOf((String.valueof(System.today())).replace('-', ''));
		requestBean.CQS411I.CQN411I_INPUT_AREA.marketersCode = Integer.valueOf(userRec.EmployeeNumber);
		requestBean.CQS411I.CQN411I_INPUT_AREA.provChqBookInd = 'N';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpSchemeCode = oppproduct.Product2.Price_Scheme_Code__c;
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpPrimaryAccount = Long.valueOf(common.spouseAccountNumber == null ? '0' : common.spouseAccountNumber);

		List<String> sofs = new List<string>();
		if (app != null && app.Source_of_Funds_Savings__c != null) {
			sofs = app.Source_of_Funds_Savings__c.split(';', 0);
		}

		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds1 = 0 < sofs.size() ? sofs[0] : common.sourceOfFunds;
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds2 = 1 < sofs.size() ? sofs[1] : '';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds3 = 2 < sofs.size() ? sofs[2] : '';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds4 = 3 < sofs.size() ? sofs[3] : '';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds5 = 4 < sofs.size() ? sofs[4] : '';

		requestBean.CQS411I.CQN411I_INPUT_AREA.digitalChannel = 'F';
		requestBean.CQS411I.CQN411I_INPUT_AREA.rbaEdd = determineEddLevel(acc.CASA_Risk_Status__c);
		requestBean.CQS411I.CQN411I_INPUT_AREA.odRequired = 'N';
		requestBean.CQS411I.CQN411I_INPUT_AREA.packageId = opp.CBPIndicator__c == null ? 0 : Long.valueOf(opp.CBPIndicator__c);

		requestBean.CQS411I.CQN411I_INPUT_AREA.fraudInd = common.fraudIndicator;

		requestBean.NBSAPDPI.NBSAPLI = new CQcreateAndLinkAccountV9_Req_IB_v1.NBSAPLI();
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'N';

		requestBean.MSGI.NBSMSGI = new CQcreateAndLinkAccountV9_Req_IB_v1.NBSMSGI();
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		try {
			CQcreateAndLinkAccountV9_Resp_IB_v1 responseBean = CQcreateAndLinkAccountV9_IH_v1.createAndLinkAccount(requestBean);

			if (responseBean.errorMessage != null) {
				returnMessage = 'Unable to open Cheque account: ' + responseBean.errorMessage;
				throw new AuraHandledException(returnMessage);
			} else if (responseBean.CQS411O.outputErrorMessage.AccountNbrOut.length() > 1) {
				oppproduct.Policy_Number__c = responseBean.CQS411O.outputErrorMessage.AccountNbrOut;
				oppproduct.FraudIndicator__c = common.fraudIndicator;
				oppproduct.FraudSyncStatus__c = common.fraudStatus;
				oppproduct.Fraud_Application_Number__c = common.applicationNumber;
				update oppproduct;
				Application_Product__c[] appProductList = [
					SELECT ChequeAccountBasicManagerNumber__c, ChequeAccountBasicOpenDate__c
					FROM Application_Product__c
					WHERE Opportunity_Product_Id__c = :oppproduct.Id
					WITH SECURITY_ENFORCED
				];

				if (appProductList.size() > 0) {
					Application_Product__c appProduct = appProductList[0];
					appProduct.ChequeAccountBasicManagerNumber__c = responseBean.CQS411O.outputErrorMessage.managerNbrA;
					appProduct.ChequeAccountBasicOpenDate__c = String.valueOf(responseBean.CQS411O.outputErrorMessage.acctOpenDate);
					update appProduct;
				}

				if (common.usePackageAccount) {
					Payment_Plan__c paymentPlan = [
						SELECT Account_Holder_Name__c, Account_Number__c, Account_Type__c, Bank_Name__c
						FROM Payment_Plan__c
						WHERE Id = :common.paymentPlanId
						WITH SECURITY_ENFORCED
					];
					paymentPlan.Account_Holder_Name__c = acc.Name;
					paymentPlan.Account_Number__c = oppproduct.Policy_Number__c;
					paymentPlan.Account_Type__c = 'Cheque';
					paymentPlan.Bank_Name__c = 'ABSA';
					update paymentPlan;
				}
			} else {
				returnMessage = 'Unable to open Cheque account: ' + responseBean.MSGO.NBSMSGO3.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT;
				throw new AuraHandledException(returnMessage);
			}

			if (oppproduct.FraudSyncStatus__c != 'CLEAN') {
				returnMessage = oppproduct.FraudSyncStatus__c;
			} else {
				returnMessage = 'Success';
			}
			return returnMessage;
		} catch (Exception ex) {
			throw new AuraHandledException(returnMessage);
		}
	}

	/**
	 * @description setOpportunityDetails
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 **/
	@AuraEnabled
	public static void setOpportunityDetails(String oppId) {
		opp = [SELECT Id, AccountId, CIF_Number__c, CBPIndicator__c FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED];

		acc = [
			SELECT
				Id,
				Name,
				FirstName,
				LastName,
				Income_Source__pc,
				CASA_Risk_Status__c,
				PersonBirthdate,
				Employer_Name__pc,
				Employer_Sector__pc,
				Occupation_Level__pc,
				Occupation_Status__pc,
				Employer_Phone__c,
				Gender__pc,
				ID_Number__pc,
				ID_Type__pc,
				Nationality__pc,
				Language__c,
				Marital_Status__pc,
				Number_Of_Dependents__c,
				Highest_Qualification__pc,
				Residential_Status__pc,
				PersonEmail,
				PersonMobilePhone,
				AccountNumber
			FROM Account
			WHERE Id = :opp.AccountId
			LIMIT 1
		];

		userRec = [
			SELECT Id, SiteCode__c, SiteType__c, Teller_Operator_Code__c, AB_Number__c, EmployeeNumber
			FROM USER
			WHERE Id = :UserInfo.getUserId()
			WITH SECURITY_ENFORCED
		];

		addr = [
			SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :acc.Id AND Address_TYpe__c = 'Residential'
			WITH SECURITY_ENFORCED
		];

		List<OpportunityLineItem> oppproducts = [
			SELECT Id, Product_Family__c, ProductCode, Product2.Price_Scheme_Code__c, Policy_Number__c, FraudIndicator__c, FraudSyncStatus__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :oppId
			WITH SECURITY_ENFORCED
		];

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Cheque') {
				oppproduct = o;
				break;
			}
		}

		app = [SELECT Id, Source_of_Funds_Savings__c FROM Application__c WHERE Opportunity__c = :oppId WITH SECURITY_ENFORCED];
	}

	/**
	 * @description determineEddLevel
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param CASAstatus
	 * @return String
	 **/
	@AuraEnabled
	public static String determineEddLevel(String CASAstatus) {
		String rating = 'M';
		if (CASAstatus == 'Very Low') {
			rating = 'VL';
		} else if (CASAstatus == 'Low') {
			rating = 'L';
		} else if (CASAstatus == 'Medium') {
			rating = 'M';
		} else if (CASAstatus == 'High') {
			rating = 'H';
		} else if (CASAstatus == 'Very High') {
			rating = 'VH';
		}
		return rating;
	}

	/**
	 * @description chequeUpdateAccountOpenDetails
	 * @author Brian Maswanganyi | 2021-05-27
	 * @param oppId
	 * @param common (CreateRetailAccountCommon)
	 * @return String
	 **/
	@AuraEnabled
	public static String chequeUpdateAccountOpenDetails(String oppId, CreateRetailAccountCommon common) {
		setOpportunityDetails(oppId);
		Application_Product__c appProduct = [
			SELECT ChequeAccountBasicManagerNumber__c, ChequeAccountBasicOpenDate__c
			FROM Application_Product__c
			WHERE Opportunity_Product_Id__c = :oppproduct.Id
			WITH SECURITY_ENFORCED
		];
		CQupdAcctOpenDetailV4Service_Req_IB_v1 requestBean = new CQupdAcctOpenDetailV4Service_Req_IB_v1();

		requestBean.NBSAPDPI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSAPDPI();
		requestBean.NBSAPDPI.NBSAPLI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSAPLI();

		requestBean.NBSMSGI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSMSGI();
		requestBean.NBSMSGI.NBSMSGI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSMSGI();

		requestBean.CQT413I = new CQupdAcctOpenDetailV4Service_Req_IB_v1.CQT413I();
		requestBean.CQT413I.inputArea = new CQupdAcctOpenDetailV4Service_Req_IB_v1.InputArea();

		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'N';

		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		requestBean.CQT413I.inputArea.accountNbr = oppproduct.Policy_Number__c;
		requestBean.CQT413I.inputArea.openSite = userRec.SiteCode__c;
		requestBean.CQT413I.inputArea.controlSite = userRec.SiteCode__c;
		requestBean.CQT413I.inputArea.CIFkey = opp.CIF_Number__c;
		requestBean.CQT413I.inputArea.tellerNbr = userRec.Teller_Operator_Code__c;
		requestBean.CQT413I.inputArea.controllerNbr = '111';
		requestBean.CQT413I.inputArea.empleyeeNbr = userRec.EmployeeNumber;
		requestBean.CQT413I.inputArea.workstationNbr = userRec.Teller_Operator_Code__c;
		requestBean.CQT413I.inputArea.applicationNbr = '0';
		requestBean.CQT413I.inputArea.openSiteType = userRec.SiteType__c;
		requestBean.CQT413I.inputArea.clientName = acc.Name;
		requestBean.CQT413I.inputArea.accountName = common.accountName != '' ? common.accountName : acc.Name;
		requestBean.CQT413I.inputArea.acctOpenDate = appProduct.ChequeAccountBasicOpenDate__c;
		requestBean.CQT413I.inputArea.acctOpenReason = common.openingReason != '' ? common.openingReason : '02';
		requestBean.CQT413I.inputArea.managerNbr = common.managerNumber != '' ? common.managerNumber : appProduct.ChequeAccountBasicManagerNumber__c;
		requestBean.CQT413I.inputArea.riskType = CQcreateAndLinkAccountController.determineEddLevel(acc.CASA_Risk_Status__c);
		requestBean.CQT413I.inputArea.lowRiskHoldAmount = '0';
		requestBean.CQT413I.inputArea.acctStoppedInd = 'N';
		requestBean.CQT413I.inputArea.unilateralLimitInd = 'N';
		requestBean.CQT413I.inputArea.ACBUser = 'N';
		requestBean.CQT413I.inputArea.debitBackdateLimit = 'S';
		requestBean.CQT413I.inputArea.CreditBackdateLimit = 'S';
		requestBean.CQT413I.inputArea.corpSubProduct = '0';
		requestBean.CQT413I.inputArea.businessAcct = '0';
		requestBean.CQT413I.inputArea.trustS781Acct = '0';
		requestBean.CQT413I.inputArea.lawSocietyRegion = '';
		requestBean.CQT413I.inputArea.studentNbr = '';
		requestBean.CQT413I.inputArea.fulTimeStudent = '';
		requestBean.CQT413I.inputArea.postGradStudent = '';
		requestBean.CQT413I.inputArea.studyCourse = '';
		requestBean.CQT413I.inputArea.normalDuration = '0';
		requestBean.CQT413I.inputArea.currentAcademicYear = '0';
		requestBean.CQT413I.inputArea.finalYear = '';
		requestBean.CQT413I.inputArea.studyInstitution = '';
		requestBean.CQT413I.inputArea.nbrYearsRepeated = '0';
		requestBean.CQT413I.inputArea.extraFinanceReqrd = '';
		requestBean.CQT413I.inputArea.studiesCompleted = '';
		requestBean.CQT413I.inputArea.repayingInd = '';
		requestBean.CQT413I.inputArea.repaymentStartDate = '0';
		requestBean.CQT413I.inputArea.mandateNbr = common.mandateNumber != '' ? common.mandateNumber : '113'; //ui fields
		requestBean.CQT413I.inputArea.trustSweepingInd = '';
		requestBean.CQT413I.inputArea.shadowLimitInd = 'N';

		try {
			CQupdAcctOpenDetailV4Service_Resp_IB_v1 responseBean = CQupdAcctOpenDetailV4Service_IH_v1.CQupdAcctOpenDetailV4Service(requestBean);
			return JSON.serialize(responseBean);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}