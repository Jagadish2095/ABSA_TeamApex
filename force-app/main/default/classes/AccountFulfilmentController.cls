/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-11-15
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class AccountFulfilmentController {
	public static List<User> userRec;
	public static Opportunity opportunity;
	public static OpportunityLineItem opportunityLineItem;
	public static Account account;
	public static Site site;
	public static RiskRating rate;
	public static String responseBeanobj;
	public static ROAProduct__c ROAProduct;
	
	public static String ApplicationID;
	private static void setOpportunityDetails(String opportunityId) {
		opportunity = [SELECT CIF_Number__c, AccountId, Risk_Rating__c FROM opportunity WHERE id = :opportunityId];
		account = new AccountsSelector().selectByOpportunityId(opportunityId);

		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		opportunityLineItem = [
			SELECT ProductCode, Product2Id, Product_Name__c, Price_Scheme_Code__c, Policy_Number__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId AND Product_Family__c = 'Savings'
		];
	}
	/**
	 * @description FraudCallDetails
	 * @return string
	 * @param opportunityId
	 */
	@AuraEnabled
	public static Map<String, String> FraudCallDetails(String opportunityId) {
		Map<String, String> fraudResponse = new Map<String, String>();
		fraudResponse = FraudCallDetailsController.FraudCallDetails(opportunityId);

		return fraudResponse;
	}

	/**
	 * @description createSavingsAccount
	 * @return string
	 * @param opportunityId
	 * @param withdrawalPercentage
	 * @param sourceOfFunds
	 * @param noticePeriod
	 * @param brokerNumber
	 * @param investTerm
	 * @param riskRating
	 * @param crpCode
	 * @param creditChannel
	 * @param creditSource
	 * @param debitReason
	 * @param fraudApplicationId
	 * @param fraudIndicator
	 */
	@AuraEnabled
	public static string createSavingsAccount(
		String opportunityId,
		String withdrawalPercentage,
		String sourceOfFunds,
		String noticePeriod,
		String brokerNumber,
		String investTerm,
		String riskRating,
		String crpCode,
		String creditChannel,
		String creditSource,
		String debitReason,
		String fraudApplicationId,
		String fraudIndicator
	) {
		try {
			setOpportunityDetails(opportunityId);
			if (crpCode == null || crpCode == '') {
				string productName = opportunityLineItem.Product_Name__c;
				productName = productName.replace(' ', '_');
				ROAProduct = [SELECT Code__c, PackageChargeOption__c, ProductId__c FROM ROAProduct__c WHERE ProductId__c LIKE :productName];
			} else {
				ROAProduct = [SELECT Code__c, PackageChargeOption__c, ProductId__c FROM ROAProduct__c WHERE ProductId__c LIKE :crpCode];
			}
			if (String.isBlank(OpportunityLineItem.Policy_Number__c)) {
				SVcreateLinkSavingsAccount_IH_v1 savingsAccount = new SVcreateLinkSavingsAccount_IH_v1();
				SVcreateLinkSavingsAccount_Req_IB_v1 requestBean = createRequestBeanForSavingsAccount(
					withdrawalPercentage,
					sourceOfFunds,
					noticePeriod,
					brokerNumber,
					investTerm,
					riskRating,
					creditChannel,
					creditSource,
					debitReason,
					fraudApplicationId,
					fraudIndicator
				);
				String requestBeanBeanobj = JSON.serializePretty(requestBean);
				SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = SVcreateLinkSavingsAccount_IH_v1.SVcreateLinkSavingsAccount(requestBean);
				responseBeanobj = JSON.serializePretty(responseBean);
				
				if (responseBean != null && responseBean.Data != null) {
					if (responseBean.Data != null && responseBean.Data.AccountNumber > '1') {
						OpportunityLineItem.Policy_Number__c = String.valueOf(responseBean.Data.AccountNumber);
						update OpportunityLineItem;
						Regulatory_Financial_Account__c financialProduct = new Regulatory_Financial_Account__c();
						financialProduct.Account__c = account.Id;
						financialProduct.Credits_Received_via_EFT_Cash_etc__c = creditChannel;
						financialProduct.Where_will_the_Credits_be_Coming_from__c = creditSource;
						financialProduct.Reason_for_Debit_Orders__c = debitReason;

						insert financialProduct;
					}
				}
			}

			return JSON.serialize(new AccountFulfillmentResult());
		} catch (Exception e) {
			throw e;
		}
	}

	private static SVcreateLinkSavingsAccount_Req_IB_v1 createRequestBeanForSavingsAccount(
		String withdrawalPercentage,
		String sourceOfFunds,
		String noticePeriod,
		String brokerNumber,
		String investTerm,
		String riskRating,
		String creditChannel,
		String creditSource,
		String debitReason,
		String fraudApplicationId,
		String fraudIndicator
	) {
		SVcreateLinkSavingsAccount_Req_IB_v1 requestBean = new SVcreateLinkSavingsAccount_Req_IB_v1();

		SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity expAccActivityRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity();
		expAccActivityRequest.creditChannel = creditChannel;
		expAccActivityRequest.creditSource = creditSource;
		expAccActivityRequest.debitReason = debitReason;

		SVcreateLinkSavingsAccount_Req_IB_v1.Header headerRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Header();
		headerRequest.sitecode = userRec[0].SiteCode__c;
		headerRequest.sitetype = userRec[0].SiteType__c;
		headerRequest.tellerNumber = userRec[0].Teller_Operator_Code__c;
		headerRequest.marketerCode = userRec[0].EmployeeNumber;
		headerRequest.brokersSrc = '1';
		headerRequest.brokersCode = brokerNumber;
		headerRequest.supervisorCode = userRec[0].Supervisor__c;
		headerRequest.agencyCode = '34';
		headerRequest.divisionCode = 'ABS';
		headerRequest.userid = userRec[0].Name;
		headerRequest.deviceid = 'laptop';
		headerRequest.workStation = '12';

		//string SouceOfFunds = StokvelEntityCasaCIFController.getTranslationValues('CIFCodesList', sourceOfFunds, 'Sofsoi', 'Outbound');

		SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome sourceOfIncomeRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome();
		sourceOfIncomeRequest.sourceOfFunds1 = sourceOfFunds;//SouceOfFunds;
		sourceOfIncomeRequest.sourceOfFunds2 = '';
		sourceOfIncomeRequest.sourceOfFunds3 = '';
		sourceOfIncomeRequest.sourceOfFunds4 = '';

		SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails customerdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails();
		customerdetailsRequest.cifCode = opportunity.CIF_Number__c;

		SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails incomedetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails();
		incomedetailsRequest.sourceOfIncome = sourceOfIncomeRequest;

		SVcreateLinkSavingsAccount_Req_IB_v1.Application applicationRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Application();
		applicationRequest.applicationNumber = fraudApplicationId;//'12340987103';
		applicationRequest.organization = 'ABS';
		applicationRequest.applicationDateTime = ('' + system.today()); //.substring(0, 10).replace('-', '');

		SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails productdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails();
		productdetailsRequest.rbaRiskHoldIndicator = riskRating;
		productdetailsRequest.fraudHold = fraudIndicator; //'Y';

		Account accoountStatus = [SELECT CASA_Screening_Status__c FROM Account WHERE Id = :account.Id];

		if (
			accoountStatus.CASA_Screening_Status__c == 'MATCHED' ||
			accoountStatus.CASA_Screening_Status__c == 'PENDING_APPROVAL' ||
			accoountStatus.CASA_Screening_Status__c == 'DECLINED'
		) {
			productdetailsRequest.casaHold = 'Y';
		} else {
			productdetailsRequest.casaHold = 'N';
		}

		if (riskRating == 'VH' || riskRating == 'H') {
			productdetailsRequest.digitalRiskIndicator = 'Y';
		} else {
			productdetailsRequest.digitalRiskIndicator = 'N';
		}

		productdetailsRequest.accountName = '1234';
		productdetailsRequest.accountOpenDate = ('' + system.today()); //.substring(0, 10).replace('-', '');
		productdetailsRequest.accountOpenReason = '';
		productdetailsRequest.investTerm = investTerm;
		productdetailsRequest.investmentAmount = '1000';
		productdetailsRequest.rateOption = '';
		productdetailsRequest.crpCode = ROAProduct.Code__c;
		productdetailsRequest.freqCode = '12';
		productdetailsRequest.groupSchCode = '1234';
		productdetailsRequest.homeEmpPlan = 'A';
		productdetailsRequest.grantType = '1';
		productdetailsRequest.specAcctType = 'V';
		productdetailsRequest.versionNbr = '';
		productdetailsRequest.productCode = opportunityLineItem.ProductCode;
		productdetailsRequest.productVersionNumber = '0';
		productdetailsRequest.noticePeriod = noticePeriod;
		productdetailsRequest.withdrwlPerc = withdrawalPercentage;
		productdetailsRequest.channelInd = '0';

		requestBean.Productdetails = productdetailsRequest;
		requestBean.Application = applicationRequest;
		requestBean.Incomedetails = incomedetailsRequest;
		requestBean.Customerdetails = customerdetailsRequest;
		requestBean.Header = headerRequest;
		requestBean.ExpAccActivity = expAccActivityRequest;

		return requestBean;
	}

	/**
	 * @description getValidatedTranslationValues
	 * @return Map<String,String>
	 * @param systemName
	 * @param valueType
	 * @param direction
	 * @param objObject
	 * @param objField
	 */
	@AuraEnabled
	public static Map<String, String> getValidatedTranslationValues(String systemName, String valueType, String direction, sObject objObject, string objField) {
		return BranchFunctions.getValidTranslations(systemName, valueType, direction, objObject, objField);
	}
	/**
	 * @description getTranslationValues
	 * @return List<String>
	 * @param systemName
	 * @param valueType
	 * @param direction
	 */
	@AuraEnabled
	public static List<String> getTranslationValues(String systemName, String valueType, String direction) {
		return BranchFunctions.getTranslationValues(systemName, valueType, direction);
	}
	/**
	 * @description attempEntityRiskProfiling
	 * @return  String
	 * @param opportunityId
	 */
	@AuraEnabled
	public static String attempEntityRiskProfiling(String opportunityId) {
		setOpportunityDetails(opportunityId);
		String riskRating = '';
   
        if (opportunity.Risk_Rating__c == null || opportunity.Risk_Rating__c == '') {
			riskRating = EntityRiskProfiling.getEntityRiskProfiling(account.Id, opportunityId);
          
			// riskRating = EntityRiskProfiling.getEntityRiskProfiling(account.Id ,opportunityLineItem.ProductCode);
			if (riskRating != null) {
				opportunity.Risk_Rating__c = riskRating;//getRiskRating(riskRating);//
				update opportunity;
			}
		} else {
          
			riskRating = opportunity.Risk_Rating__c;
		}
      
		return riskRating;
	}

	/**
	 * @description callGenerateDocs
	 * @param oppId
	 * @return value as String
	 */
	@AuraEnabled
	public static string callGenerateDocs(id oppId) {
		String versionNumber = ROAAnalysisController.callGenerateDocsStokvel(oppId);
		//versionNumber= ROAAnalysisController.callGenerateDocsForRelatedParty(oppId);
		return versionNumber;
	}

	/**
	 * @description callGenerateDocs
	 * @param oppId
	 * @return String
	 */

	public static String callGenerateDocsStokvel(id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		Account account = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c, Teller_Operator_Code__c, AB_Number__c FROM User WHERE Id = :usr];
		CASAGeneratedocumentsV7_Req_IB_v1 requestBean = CASAGeneratedocumentsV7_Req_IB_v1.GetInstance();
		requestBean.GetDocsRequest.RefNumber = account.CASA_Reference_Number__c;
		requestBean.GetDocsRequest.SBU = 'F';
		requestBean.GetDocsRequest.OriginatingSystem = 'BDP';
		requestBean.GetDocsRequest.Additional_Docs = '';
		requestBean.GetDocsRequest.Branch = userInfo.SiteCode__c;
		requestBean.GetDocsRequest.InitialAB = userInfo.AB_Number__c;
		CASAGeneratedocumentsV7_Resp_IB_v1 response = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsV7(requestBean);
		string versionNumber = response.Envelope.Body.GetDocsResponse.VersionNo;
		if (!versionNumber.contains('Error')) {
			account = [SELECT Id, Casa_Sequence_Number__c FROM Account WHERE Id = :account.Id];
			account.Casa_Sequence_Number__c = versionNumber;
			update account;
		}

		return versionNumber;
	}
	/**
	 * @description getRiskRating
	 * @return string
	 * @param riskRating
	 */
	public static String getRiskRating(String riskRating) {
		string retRiskRating = '';
		switch on riskRating {
			when 'L' {
				retRiskRating = 'Low';
			}
			when 'M' {
				retRiskRating = 'Medium';
			}
			when 'H' {
				retRiskRating = 'High';
			}
			when 'VL' {
				retRiskRating = 'Very Low';
			}
			when 'VH' {
				retRiskRating = 'Very High';
			}
		}
		return retRiskRating;
	}

	/**
* @description RiskRating

*/
	public enum RiskRating {
		L,
		M,
		H,
		VL,
		VH
	}
	/**
	 * @description updateAccountOpeningDet
	 * @param opportunityId
	 * @param accountNumber
	 * @param brokerNumber
	 *@param openReasonCode
	 *@param accountname
	 * @param clientCode
	 * @return string
	 */
	@AuraEnabled
	public static string updateAccountOpeningDet(
		String opportunityId,
		String accountNumber,
		String brokerNumber,
		String openReasonCode,
		String accountname,
		String clientCode
	) {
		string openRsnCode = StokvelEntityCasaCIFController.getTranslationValues('Savings', openReasonCode, 'Reason', 'Outbound');


		if (clientCode == null || clientCode == '') {
			setOpportunityDetails(opportunityId);
			string productName = opportunityLineItem.Product_Name__c;
			productName = productName.replace(' ', '_');
			ROAProduct = [SELECT Code__c, PackageChargeOption__c, ProductId__c FROM ROAProduct__c WHERE ProductId__c LIKE :productName];
			
		} else {
			ROAProduct = [SELECT Code__c, PackageChargeOption__c, ProductId__c FROM ROAProduct__c WHERE ProductId__c LIKE :clientCode];
		}

		string depositType = 'D';
		if (ROAProduct.Code__c == 'SVO0907201' || ROAProduct.Code__c == 'SVO0907202' || ROAProduct.Code__c == 'SVO0907203') {
			depositType = 'S';
		}

	return 	SVupdateAccountController.updateAccountOpeningDetails(
			opportunityId,
			accountNumber,
			brokerNumber,
			openRsnCode,
			accountname,
			ROAProduct.Code__c,
			depositType
		);
	}
	/**
	 * @description AccountFulfillmentResult
	 *  * @param customerName
	 *  * @param productType
	 *  * @param accountNumber
	 *  * @param productCode
	 *  * @param domicileBranch
	 *  * @param domicileBranchCode
	 *  * @param salesConsultant
	 *  * @param bankClearingCode
	 *  * @param response
	 */
	public class AccountFulfillmentResult {
		public String customerName;
		public String productType;
		public String accountNumber;
		public String productCode;
		public String domicileBranch;
		public String domicileBranchCode;
		public String salesConsultant;
		public String bankClearingCode;
		public String response;

		/**
* @description AccountFulfillmentResult

*/
		public AccountFulfillmentResult() {
			this.customerName = account.Name;
			this.productType = opportunityLineItem.Product_Name__c;
			this.accountNumber = OpportunityLineItem.Policy_Number__c;
			this.productCode = opportunityLineItem.ProductCode;
			this.domicileBranch = (new SitesSelector().selectBySiteCode(userRec[0].SiteCode__c))[0].Name;
			this.domicileBranchCode = userRec[0].SiteCode__c;
			this.salesConsultant = userRec[0].Name;
			this.bankClearingCode = '632005';
			this.response = responseBeanobj;
		}
	}
}