/**
 * @description       :
 * @author            : Brian Maswanganyi
 * @group             :
 * @last modified on  : 05-03-2021
 * @last modified by  : Brian Maswanganyi
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-03-2021   Brian Maswanganyi   Initial Version
 **/
public without sharing class SVcreateAndLinkAccountController{
	public static List<User> userRec;
	public static Opportunity opportunity;
	public static OpportunityLineItem opportunityLineItem;
	public static Account account;
	private static void setOpportunityDetails(String opportunityId){
		opportunity = [SELECT CIF_Number__c, AccountId
		               FROM opportunity
		               where id = :opportunityId];
		account = new AccountsSelector().selectByOpportunityId(opportunityId);
		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		opportunityLineItem = [SELECT ProductCode, Product2Id, Price_Scheme_Code__c, Policy_Number__c
		                       FROM OpportunityLineItem
		                       WHERE OpportunityId = :opportunityId AND Product_Family__c = 'Savings'];
	}

	/**
	 * @description createSavingsAccount
	 * @param opportunityId
	 * @param common (CreateRetailAccountCommon)
	 * @return string
	 */
	@AuraEnabled
	public static string createSavingsAccount(String opportunityId, CreateRetailAccountCommon common){
		Boolean hasError = false;
		String message = '';

		setOpportunityDetails(opportunityId);

		if (OpportunityLineItem.Policy_Number__c == null || OpportunityLineItem.Policy_Number__c == ''){
			SVcreateLinkSavingsAccount_Req_IB_v1 requestBean = createRequestBeanForCreateAndLink(common);
			SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = SVcreateLinkSavingsAccount_IH_v1.SVcreateLinkSavingsAccount(requestBean);

			if (responseBean != null){
				if(responseBean.errors == null || responseBean.errors.size() == 0){
					if (responseBean.data != null || responseBean.data.AccountNumber != null){
						OpportunityLineItem.Policy_Number__c = responseBean.data.AccountNumber;
						update OpportunityLineItem;
					} else{
						message = 'Could not create account due to unknown error';
						hasError = true;
					}
				}
				else{
					for(SVcreateLinkSavingsAccount_Resp_IB_v1.Errors errormessage : responseBean.errors){
						if(errormessage != null ){
							message = message + '\n\r' + errormessage.message;
						}
					}
					hasError = true;
				}
			} else{
				message = 'Could not create account due to unknown error';
				hasError = true;
			}

			if (hasError == true){
				throw new AuraHandledException(message);
			} else{
				return OpportunityLineItem.Policy_Number__c;
			}

		} else{
			return OpportunityLineItem.Policy_Number__c;
		}
	}

	private static SVcreateLinkSavingsAccount_Req_IB_v1 createRequestBeanForCreateAndLink(CreateRetailAccountCommon common){

		SVcreateLinkSavingsAccount_Req_IB_v1 requestBean = new SVcreateLinkSavingsAccount_Req_IB_v1();

        SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity expAccActivityRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity ();
        expAccActivityRequest.creditChannel = 'N/A';
        expAccActivityRequest.creditSource = 'N/A';
        expAccActivityRequest.debitReason = 'N/A';
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Header headerRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Header ();
        headerRequest.sitecode = userRec[0].SiteCode__c;
        headerRequest.sitetype = userRec[0].SiteType__c;
        headerRequest.tellerNumber = userRec[0].Teller_Operator_Code__c;
        headerRequest.marketerCode = userRec[0].EmployeeNumber;
        headerRequest.brokersSrc = '0';
        headerRequest.brokersCode = '0';
        headerRequest.supervisorCode = '10';
        headerRequest.agencyCode = '34';
        headerRequest.divisionCode = 'ABS';
        headerRequest.userid = userRec[0].Name;
        headerRequest.deviceid = 'laptop';
        headerRequest.workStation = '12';
        
        SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome sourceOfIncomeRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome();
        sourceOfIncomeRequest.sourceOfFunds1 = common.sourceOfFunds;
        sourceOfIncomeRequest.sourceOfFunds2 = '';
        sourceOfIncomeRequest.sourceOfFunds3 = '';
        sourceOfIncomeRequest.sourceOfFunds4 = '';
       
        SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails customerdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails();
        customerdetailsRequest.cifCode = opportunity.CIF_Number__c;
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails incomedetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails();
        incomedetailsRequest.sourceOfIncome = sourceOfIncomeRequest;
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Application applicationRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Application();
        applicationRequest.applicationNumber = common.applicationNumber;
        applicationRequest.organization = 'ABS';
        applicationRequest.applicationDateTime = ('' + system.today());//.substring(0, 10).replace('-', '');
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails productdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails();
        productdetailsRequest.rbaRiskHoldIndicator =  common.riskRating;
        productdetailsRequest.fraudHold = 'Y';
        productdetailsRequest.casaHold = 'Y';
        productdetailsRequest.digitalRiskIndicator = 'Y';
        productdetailsRequest.accountName = '';
        productdetailsRequest.accountOpenDate = ('' + system.today());//.substring(0, 10).replace('-', '');
        productdetailsRequest.accountOpenReason = '';
        productdetailsRequest.investTerm = '0';
        productdetailsRequest.investmentAmount =  '0';
        productdetailsRequest.rateOption =  '';
        productdetailsRequest.crpCode = '';
        productdetailsRequest.freqCode = '0';
        productdetailsRequest.groupSchCode = '0';
        productdetailsRequest.homeEmpPlan = 'A';
        productdetailsRequest.grantType = '1';
        productdetailsRequest.specAcctType = 'V';
        productdetailsRequest.versionNbr = '';
        productdetailsRequest.productCode = opportunityLineItem.ProductCode;        
         productdetailsRequest.productVersionNumber = '0';
        productdetailsRequest.noticePeriod = '0';
        productdetailsRequest.withdrwlPerc = '0';
        productdetailsRequest.channelInd = 'F';
         
        requestBean.Productdetails = productdetailsRequest;
        requestBean.Application = applicationRequest;
        requestBean.Incomedetails = incomedetailsRequest;
        requestBean.Customerdetails = customerdetailsRequest;
        requestBean.Header = headerRequest;
        requestBean.ExpAccActivity = expAccActivityRequest;

        return requestBean;

	}

	/**
	 * @description updateAccountOpeningDetails
	 * @param opportunityId
	 * @param common (CreateRetailAccountCommon)
	 * @return string
	 */
	@AuraEnabled
	public static string updateAccountOpeningDetails(String opportunityId, CreateRetailAccountCommon common){
		setOpportunityDetails(opportunityId);

		SVupdateAccount_Req_IB_v1 requestBean = new SVupdateAccount_Req_IB_v1().getNewInstance();
		requestBean.SVSP09I = new SVupdateAccount_Req_IB_v1.SVSP09I();
		requestBean.SVSP09I.SVSP09I_INPUT_AREA = new SVupdateAccount_Req_IB_v1.SVSP09I_INPUT_AREA();
		requestBean.NBSAPDPI.NBSAPLI.channel = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.application = 'SF';
		requestBean.NBSAPDPI.NBSAPLI.trace = 'N';
		requestBean.MSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.MSGI.NBSMSGI.messageTarget = 'STD';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.accountNumber = opportunityLineItem.Policy_Number__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.savingsDepositType = 'D';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.openReasonCode = common.openingReason;//account.Client_Creation_Reason__c ;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.accountName = account.Name;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.groupSchemeCode = '0';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.homeEmployPlanCode = '';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.grantType = '0';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.specialAccountType = 'N';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.brokerSource = '';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.brokerNumber = '0';//common.brokerNumber;//use the one from the screen
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.crpCode = 'ABS';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.divisionCode = 'ABS';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.workStation = 'AA';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.branchCode = userRec[0].SiteCode__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.agencyCode = userRec[0].SiteCode__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.agencySiteType = userRec[0].SiteType__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.tellerCode = userRec[0].Teller_Operator_Code__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.supervisorCode = '0';//userRec[0].Supervisor__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.branchSiteType = userRec[0].SiteType__c;

		try{
			string retuncode = '';
			SVupdateAccount_Resp_IB_v1 responseBean = SVupdateAccountOpeningDetailsV2.updateAccountOpeningDetails(requestBean);
			if (responseBean != null && responseBean.NBSAPDPO != null && responseBean.NBSAPDPO.NBSAPLO != null && responseBean.NBSAPDPO.NBSAPLO.returnCode != null){
				retuncode = String.valueOf(responseBean.NBSAPDPO.NBSAPLO.returnCode);
			}
			return retuncode;
		} catch (Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}
}