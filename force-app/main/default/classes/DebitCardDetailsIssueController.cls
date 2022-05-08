/**
 * @description       : DebitCardDetailsIssueController
 * 09-09-2021        Brian Maswanganyi   Re-deploy to SIT
 * 13-09-2021        Brian Maswanganyi   Change method name due to errors
 * 10-10-2021        André Pietersen   Added card issued status field
 **/
public with sharing class DebitCardDetailsIssueController {
	/**
	 * @description CombiProductDetails description
	 **/
	public class CombiProductDetails {
		@AuraEnabled
		public String AccountNumber;
		@AuraEnabled
		public String ProductFamily;
		@AuraEnabled
		public String PersonaliseName;
		@AuraEnabled
		public String ApplicationId;
		@AuraEnabled
		public Boolean CardIssuedStatus;
		@AuraEnabled
		public Boolean AllowPersonalisedCard;
	}

	public static Account acc;
	public static Opportunity opp;
	public static List<User> userRec;
	public static OpportunityLineItem oppProduct;
	/**
	 * @description getAppProdAndAccountWithFamily description
	 * @param oppId (String): oppId
	 * @return String: Return description
	 */
	@AuraEnabled
	public static CombiProductDetails getAppProdAndAccount(String oppId) {
		CombiProductDetails result = new CombiProductDetails();

		List<OpportunityLineItem> oppproducts = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
		OpportunityLineItem oppproduct = new OpportunityLineItem();
		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Cheque' || o.Product_Family__c == 'Savings') {
				oppproduct = o;
				break;
			}
		}
		String AccountNumber = oppproduct.Policy_number__c;
		Application_Product__c app = [SELECT Id, Card_Issued_Status__c FROM Application_Product__c WHERE Opportunity_Product_Id__c = :oppproduct.Id LIMIT 1];

		Opportunity opportunity = [SELECT AccountId, CBPIndicator__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
		Account account = [SELECT Titles__pc, Name FROM Account WHERE Id = :opportunity.AccountId LIMIT 1];

		result.AccountNumber = AccountNumber;
		result.ApplicationId = app.Id;
		result.PersonaliseName = account.Titles__pc + ' ' + account.Name;
		result.CardIssuedStatus = app.Card_Issued_Status__c == 'Active';
		result.AllowPersonalisedCard = opportunity.CBPIndicator__c == null;
		result.ProductFamily = oppproduct.Product_Family__c;

		return result;
	}

	/**
	 * @description getBrands description
	 * @param oppId
	 * @param numberofBrand (String): numberofBrand
	 * @return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> getBrands(String oppId, String numberofBrand) {
		setOpportunityDetails(oppId);
		String errorMessage = '';

		CClistCombiBrandsForPrefProdV1_Req_IB_v1 requestBean = new CClistCombiBrandsForPrefProdV1_Req_IB_v1();
		requestBean.CClistCombiBrandsForPreferredProductV1 = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CClistCombiBrandsForPreferredProductV1();
		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.CCS306I();
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.NBSAPDPI();
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.NBSMSGI();
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.finalMsgId = new CClistCombiBrandsForPrefProdV1_Req_IB_v1.finalMsgId();

		requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.channel = 'SF';
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.application = 'SF';
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsapdpi.trace = 'N';

		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgLanguage = 'E';
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.msgTarget = 'STD';
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.finalMsgId.finalMsgClass = new List<String>();
		requestBean.CClistCombiBrandsForPreferredProductV1.nbsmsgi.finalMsgId.finalMsgCode = new List<String>();

		if (oppProduct.Product_Family__c == 'Savings') {
			requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodType = 'SV';
		} else {
			requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodType = 'CQ';
		}

		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.prodCode = oppProduct.ProductCode;

		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nxtBrand = '0';
		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.nbrBrandReq = numberofBrand;
		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.cardType = 'C';
		requestBean.CClistCombiBrandsForPreferredProductV1.ccp306i.functionInd = 'N';

		try {
			CClistCombiBrandForPrefProdV1_Resp_IB_v1 responseBean = CClistCombiBrandsForPrefProdV1_IH_v1.cclistcombibrandsforpreferredproduct(requestBean);
			if (responseBean != null) {
				if (responseBean.wsd_CClistCombiBrandsForPreferredProductV1Response.nbsmsgo.nbrUserErrs == 0) {
					List<String> brands = new List<String>();
					for (
						CClistCombiBrandForPrefProdV1_Resp_IB_v1.prdBrandLst brand : responseBean.wsd_CClistCombiBrandsForPreferredProductV1Response.ccp306o.prdBrandDetails.prdBrandLst
					) {
						if (brand.brandNbr != '') {
							brands.add(brand.brandNbr);
						}
					}
					return brands;
				} else {
					errorMessage = responseBean.wsd_CClistCombiBrandsForPreferredProductV1Response.nbsmsgo.msgEntry.msgTxt;
					throw new AuraHandledException(errorMessage);
				}
			}
			List<String> errorMessages = new List<String>();
			errorMessages.add('Error: No response from service.');
			return errorMessages;
		} catch (Exception e) {
			throw new AuraHandledException(errorMessage == '' ? e.getMessage() : errorMessage);
		}
	}

	/**
	 * @description issueCard description
	 *
	 * @param cdo (string): cdo
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String issueCard(string cdo) {
		String errorMessage = '';
		CombiDetails combiDetails = (CombiDetails) JSON.deserialize(cdo, CombiDetails.class);
		setOpportunityDetails(combiDetails.oppId);

		CCissueCombiCardV1_Req_IB_v1 requestBean = new CCissueCombiCardV1_Req_IB_v1();
		requestBean.channel = 'SF';
		requestBean.application = 'SF';
		requestBean.trace = 'N';

		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';

		requestBean.tellerCode = userRec[0].Teller_Operator_Code__c;
		requestBean.workStation = '0';
		requestBean.supervisor = '0';
		requestBean.branchCode = userRec[0].SiteCode__c;
		requestBean.consumerId = '';
		requestBean.cardType = 'C';

		Account account = [SELECT FirstName, Titles__pc, Initials__pc, LastName FROM Account WHERE Id = :acc.Id LIMIT 1];

		if (combiDetails.isPersonalisedCard == 'Yes') {
			requestBean.cardNbr = '0';
			requestBean.persInd = 'Y';
			requestBean.persName = account.FirstName;
			requestBean.persTitl = account.Titles__pc;
			requestBean.persInit = account.Initials__pc;
			requestBean.persSurn = account.LastName;
			requestBean.delvMethod = combiDetails.deliveryMethod == 'F2F' ? '0' : '1';
			requestBean.delvBranch = combiDetails.deliveryBranch == '0' ? userRec[0].SiteCode__c : combiDetails.deliveryBranch;
		} else {
			requestBean.cardNbr = combiDetails.CardNumber;
			requestBean.persInd = 'N';
			requestBean.persName = '';
			requestBean.persTitl = '';
			requestBean.persInit = '';
			requestBean.persSurn = '';
			requestBean.delvMethod = '';
			requestBean.delvBranch = userRec[0].SiteCode__c;
		}

		requestBean.clntCode = opp.CIF_Number__c;
		requestBean.acctNbr = combiDetails.AccountNumber;
		requestBean.prodCode = oppProduct.ProductCode;
		requestBean.brandNbr = combiDetails.BrandNumber;
		requestBean.issueBranch = userRec[0].SiteCode__c;
		requestBean.sbuCode = '';

		requestBean.idType = '1';
		requestBean.idNbr = '';
		if (oppProduct.Product_Family__c == 'Cheque') {
			requestBean.nomCheq = combiDetails.NomCheq == '' ? combiDetails.AccountNumber : combiDetails.NomCheq;
			requestBean.nomSavs = combiDetails.NomSavs == '' ? '0' : combiDetails.NomSavs;
		} else if (oppProduct.Product_Family__c == 'Savings') {
			requestBean.nomSavs = combiDetails.NomSavs == '' ? combiDetails.AccountNumber : combiDetails.NomSavs;
			requestBean.nomCheq = combiDetails.NomCheq == '' ? '0' : combiDetails.NomCheq;
		}
		requestBean.nomCred = combiDetails.NomCred == '' ? '0' : combiDetails.NomCred;
		requestBean.autoLink = 'Y';
		requestBean.blindInd = '';
		requestBean.secClntCde = '';

		try {
			CCIssueCombiCardV1_Resp_IB_v1 responseBean = CCIssueCombiCardV1_IH_v2.CCIssueCombiCardV1(requestBean);
			if (responseBean != null) {
				if (responseBean.CCissueCombiCardV1Response.nbsmsgo3.nbrUserErrs == '0') {
					Application_Product__c appProd = [
						SELECT Id, Card_Issued_Status__c
						FROM Application_Product__c
						WHERE Opportunity_Product_Id__c = :oppproduct.Id
						LIMIT 1
					];
					appProd.Card_Issued_Status__c = 'Active';
					update appProd;
					return responseBean.CCissueCombiCardV1Response.ccp348o.newCombiNbr;
				} else {
					errorMessage = responseBean.CCissueCombiCardV1Response.nbsmsgo3.msgEntry[0].msgTxt;
					throw new AuraHandledException(errorMessage);
				}
			}
			throw new AuraHandledException('Error: No response from CCissueCombiCardV1 service.');
		} catch (Exception e) {
			throw new AuraHandledException(errorMessage == '' ? e.getMessage() : errorMessage);
		}
	}

	/**
	 * @description getNominatableAccounts description
	 *
	 * @param accountNumber (String): accountNumber
	 * @param oppId (String): oppId
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String getNominatableAccounts(String accountNumber, String oppId) {
		String errorMessage = '';
		opp = new OpportunitiesSelector().selectByOpptId(oppId);
		CClistNominatableAccountsV1_Req_IB_v1 requestBean = new CClistNominatableAccountsV1_Req_IB_v1();
		CClistNominatableAccountsV1_Req_IB_v1.Nbsapdpi NbsapdpiBean = new CClistNominatableAccountsV1_Req_IB_v1.Nbsapdpi();
		CClistNominatableAccountsV1_Req_IB_v1.Nbsmsgi NbsmsgiBean = new CClistNominatableAccountsV1_Req_IB_v1.Nbsmsgi();
		CClistNominatableAccountsV1_Req_IB_v1.Ccp315i Ccp315iBean = new CClistNominatableAccountsV1_Req_IB_v1.Ccp315i();
		CClistNominatableAccountsV1_Req_IB_v1.CClistNominatableAccountsV1 CClistNominatableAccountsV1RequestBean = new CClistNominatableAccountsV1_Req_IB_v1.CClistNominatableAccountsV1();

		NbsmsgiBean.msgTarget = 'STD';
		NbsmsgiBean.msgLanguage = 'E';
		NbsmsgiBean.finalMsgId = new CClistNominatableAccountsV1_Req_IB_v1.FinalMsgId();
		NbsmsgiBean.finalMsgId.finalMsgClass = '';
		NbsmsgiBean.finalMsgId.finalMsgCode = '';

		NbsapdpiBean.channel = 'SF';
		NbsapdpiBean.application = 'SF';
		NbsapdpiBean.trace = 'N';

		Ccp315iBean.clientCode = opp.CIF_Number__c;
		Ccp315iBean.inpAccntNbr = accountNumber;
		Ccp315iBean.inpNxtAccnt = '0';
		Ccp315iBean.inpNbrAccnt = '20';

		CClistNominatableAccountsV1RequestBean.nbsapdpi = NbsapdpiBean;
		CClistNominatableAccountsV1RequestBean.nbsmsgi = NbsmsgiBean;
		CClistNominatableAccountsV1RequestBean.ccp315i = Ccp315iBean;

		requestBean.CClistNominatableAccountsV1 = CClistNominatableAccountsV1RequestBean;

		try {
			CClistNominatableAccountsV1_Resp_IB_v1 responseBean = CClistNominatableAccountsV1_IH_v1.CClistNominatableAccounts(requestBean);
			if (responseBean != null) {
				if (responseBean.CClistNominatableAccountsV1Response.nbsmsgo.nbrUserErrs == 0) {
					return JSON.serialize(responseBean);
				} else {
					errorMessage = responseBean.CClistNominatableAccountsV1Response.nbsmsgo.msgEntry.msgTxt;
					throw new AuraHandledException(errorMessage);
				}
			}
			return errorMessage = 'Error: No response from service.';
		} catch (Exception e) {
			throw new AuraHandledException(errorMessage == '' ? e.getMessage() : errorMessage);
		}
	}

	/**
	 * @description getDailyLimits description
	 *
	 * @param selectedCombiNumber (String): selectedCombiNumber
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String getDailyLimits(String selectedCombiNumber) {
		String errorMessage = '';
		CCgetDailyLimitsV2_Req_IB_v1 requestBean = new CCgetDailyLimitsV2_Req_IB_v1();
		CCgetDailyLimitsV2_Req_IB_v1.Nbsapdpi NbsapdpiBean = new CCgetDailyLimitsV2_Req_IB_v1.Nbsapdpi();
		CCgetDailyLimitsV2_Req_IB_v1.Ccp312i Ccp312iiBean = new CCgetDailyLimitsV2_Req_IB_v1.Ccp312i();
		CCgetDailyLimitsV2_Req_IB_v1.Nbsmsgi NbsmsgiBean = new CCgetDailyLimitsV2_Req_IB_v1.Nbsmsgi();
		CCgetDailyLimitsV2_Req_IB_v1.CCgetDailyLimitsV2 CCgetDailyLimitsV2RequestBean = new CCgetDailyLimitsV2_Req_IB_v1.CCgetDailyLimitsV2();

		NbsapdpiBean.channel = 'SF';
		NbsapdpiBean.application = 'SF';
		NbsapdpiBean.trace = 'N';

		NbsmsgiBean.msgLanguage = 'E';
		NbsmsgiBean.msgTarget = 'STD';
		NbsmsgiBean.finalMsgId = '';

		Ccp312iiBean.combiNbr = selectedCombiNumber;

		CCgetDailyLimitsV2RequestBean.nbsapdpi = NbsapdpiBean;
		CCgetDailyLimitsV2RequestBean.nbsmsgi = NbsmsgiBean;
		CCgetDailyLimitsV2RequestBean.ccp312i = Ccp312iiBean;

		requestBean.CCgetDailyLimitsV2 = CCgetDailyLimitsV2RequestBean;

		try {
			CCgetDailyLimitsV2_Resp_IB_v1 responseBean = CCgetDailyLimitsV2_IH_v1.CCgetDailyLimitsV2(requestBean);
			if (responseBean != null) {
				if (responseBean.CCgetDailyLimitsV2Response.nbsmsgo.nbrUserErrs == 0) {
					return JSON.serialize(responseBean);
				} else {
					errorMessage = responseBean.CCgetDailyLimitsV2Response.nbsmsgo.msgEntry.msgTxt;
					throw new AuraHandledException(errorMessage);
				}
			}
			return errorMessage = 'Error: No response from service.';
		} catch (Exception e) {
			throw new AuraHandledException(errorMessage == '' ? e.getMessage() : errorMessage);
		}
	}

	/**
	 * @description updateDailyLimits description
	 * @param cdl (String): cdl
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String updateDailyLimits(String cdl) {
		String errorMessage = '';
		CombiDailyLimits CombiDailyLimits = (CombiDailyLimits) JSON.deserialize(cdl, CombiDailyLimits.class);
		CCUpdDailyTansactionLimitsV2_Req_IB_v1 requestBean = new CCUpdDailyTansactionLimitsV2_Req_IB_v1();
		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		requestBean.channel = 'SF';
		requestBean.application = 'SF';
		requestBean.trace = 'N';

		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';

		requestBean.workStation = '0';
		requestBean.tellerCode = userRec[0].Teller_Operator_Code__c;
		requestBean.supervisor = userRec[0].Teller_Operator_Code__c;
		requestBean.branchCode = userRec[0].SiteCode__c;
		requestBean.combiNbr = CombiDailyLimits.CombiNbr; //'4483850000375887';
		requestBean.cardCshLim = CombiDailyLimits.CardCshLim;
		requestBean.cardTrfLim = CombiDailyLimits.CardTrfLim;
		requestBean.cardPosLim = CombiDailyLimits.CardPosLim;
		requestBean.cardCntLim = CombiDailyLimits.CardCntLim;
		requestBean.cheqNomAcc = CombiDailyLimits.CheqNomAcc;
		requestBean.cheqApplNo = '0';
		requestBean.cheqCshLim = '0';
		requestBean.cheqTrfLim = '0';
		requestBean.cheqPosLim = '0';
		requestBean.savsNomAcc = '0';
		requestBean.savsApplNo = '0';
		requestBean.savsCshLim = '0';
		requestBean.savsTrfLim = '0';
		requestBean.savsPosLim = '0';

		try {
			CCUpdDailyTansactionLimitsV2_Resp_IB_v1 responseBean = CCUpdDailyTansactionLimitsV2_IH_v1.CCUpdDailyTansactionLimitsV2(requestBean);
			if (responseBean != null) {
				if (responseBean.CCupdDailyTransactionLimitsV2Response.nbsmsgo.nbrUserErrs == '0') {
					return errorMessage = 'Updated limits successfully';
				} else {
					errorMessage = responseBean.CCupdDailyTransactionLimitsV2Response.nbsmsgo.msgEntry.msgTxt;
					throw new AuraHandledException(errorMessage);
				}
			}
			return errorMessage = 'Error: No response from service.';
		} catch (Exception e) {
			throw new AuraHandledException(errorMessage == '' ? e.getMessage() : errorMessage);
		}
	}

	/**
	 * @description createPinPadDeviceRequest description
	 *
	 * @param customerID (string): customerID
	 * @param deviceFunction (string): deviceFunction
	 * @param requestMetadata (string): requestMetadata
	 * @return string: Return description
	 */
	@AuraEnabled
	public static string CreatePinPadDeviceRequest(string customerID, string deviceFunction, string requestMetadata) {
		return ASPDeviceRequestHelper.CreateRequest(customerID, deviceFunction, requestMetadata);
	}

	/**
	 * @description getOpportunityDetails description
	 *
	 * @param oppId (string): oppId
	 *
	 */
	@AuraEnabled
	public static void setOpportunityDetails(String oppId) {
		opp = new OpportunitiesSelector().selectByOpptId(oppId);
		acc = new AccountsSelector().selectByOpportunityId(oppId);
		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		List<OpportunityLineItem> oppproducts = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Cheque' || o.Product_Family__c == 'Savings') {
				oppProduct = o;
				break;
			}
		}
	}

	/**
	 * @description issueGhostCard description
	 *
	 * @param oppId (string): oppId
	 * @param applicationId (string): applicationId
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String issueGhostCard(string oppId, string applicationId) {
		string brandNumber = '01565';

		setOpportunityDetails(oppId);
		try {
			CCIssueV2_Req_IB_v2 requestBean = CCIssueV2_Req_IB_v2.GetInstance();

			requestBean.CCS311I.inputCopybook.tellerCode = userRec[0].Teller_Operator_Code__c;
			requestBean.CCS311I.inputCopybook.workStation = 'A';
			requestBean.CCS311I.inputCopybook.supervisor = '0';
			requestBean.CCS311I.inputCopybook.branchCode = userRec[0].SiteCode__c;
			requestBean.CCS311I.inputCopybook.agencyCode = '0';
			requestBean.CCS311I.inputCopybook.persName = '';
			requestBean.CCS311I.inputCopybook.issueBranch = userRec[0].SiteCode__c;
			requestBean.CCS311I.inputCopybook.blindIndicator = 'N';
			requestBean.CCS311I.inputCopybook.cardReqdIndicator = 'N'; //Edmore advised that we can keep this as N
			requestBean.CCS311I.inputCopybook.persIndicator = 'N';
			requestBean.CCS311I.inputCopybook.cardNumber = '0';
			requestBean.CCS311I.inputCopybook.clientCode = acc.CIF__c;
			requestBean.CCS311I.inputCopybook.brandNumber = brandNumber; //01565 - According to Hannes Gouws
			requestBean.CCS311I.inputCopybook.prodCode = '09072'; // Feedback from Thea Du Plessis
			requestBean.CCS311I.inputCopybook.autoLink = 'N';
			requestBean.CCS311I.inputCopybook.nomCheq = '0';
			requestBean.CCS311I.inputCopybook.nomSavs = oppProduct.Policy_number__c; //'9051159122';
			requestBean.CCS311I.inputCopybook.nomCred = '0';
			requestBean.CCS311I.inputCopybook.pinReqdIndicator = 'N';
			requestBean.CCS311I.inputCopybook.cardFee = 'N';
			requestBean.CCS311I.inputCopybook.lostFee = 'N';
			requestBean.CCS311I.inputCopybook.idPspIndicator = '';
			requestBean.CCS311I.inputCopybook.idPspNumber = '';
			requestBean.CCS311I.inputCopybook.cardTypeIndicator = 'I'; //Feedback from Thea Du Plessis

			string req = JSON.serializePretty(requestBean + 'requestBean combi');
			CCIssueV2_Resp_IB_v2 responseBean = CCIssueV2_IH_v2.ccissue(requestBean);
			if (responseBean == null || responseBean.CCS311O == null || responseBean.CCS311O.outputCopybook == null) {
				return 'Issue card failed - no response from Card';
			}
			Application_Product__c application = [
				SELECT Id, Debit_Card_Number__c, Brand_Number__c
				FROM Application_Product__c
				WHERE Id = :applicationId
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			if (
				responseBean.NBSMSGO3 != null &&
				responseBean.NBSMSGO3.outputErrorMessage != null &&
				responseBean.NBSMSGO3.outputErrorMessage.numberUserMessages == '0'
			) {
				if (application != null && Application_Product__c.SObjectType.getDescribe().isUpdateable()) {
					application.Debit_Card_Number__c = responseBean.CCS311O.outputCopybook.combiNumber;
					application.Brand_Number__c = brandNumber;

					update application;
				}

				return responseBean.CCS311O.outputCopybook.combiNumber;
			}

			if (responseBean.NBSMSGO3.outputErrorMessage.systemErrorText == '' && responseBean.NBSMSGO3.outputErrorMessage.errorMessageTable != null) {
				string message = responseBean.NBSMSGO3.outputErrorMessage.errorMessageTable.get(0).errorMessageText;
				Pattern combiNumberPattern = Pattern.compile('^.*card is already active.*$');
				Matcher match = combiNumberPattern.matcher(message);

				if (match.matches()) {
					string accountNumber = message.remove('Combi').remove('card is already active');
					accountNumber = accountNumber.trim();

					if (Application_Product__c.SObjectType.getDescribe().isUpdateable()) {
						application.Debit_Card_Number__c = accountNumber;
						application.Brand_Number__c = brandNumber;

						update application;
					}

					return accountNumber;
				} else {
					throw new AuraHandledException(message);
				}
			}

			throw new AuraHandledException(responseBean.NBSMSGO3.outputErrorMessage.systemErrorText);
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * @description searchDeliveryBranchByName
	 *
	 * @param searchString (string): searchString
	 * @return Map<String,String>: Return Branch Site Code and Name
	 */
	@AuraEnabled
	public static Map<String, String> searchDeliveryBranchByName(String searchString) {
		searchString = '%' + searchString + '%';
		List<Site__c> sites = [SELECT Site_Code__c, Name FROM Site__c WHERE Name LIKE :searchString AND RecordType.Name = 'Branch Site'];

		Map<String, String> searchResults = new Map<String, String>();

		for (Site__c siteItem : sites) {
			searchResults.put(siteItem.Site_Code__c, siteItem.Name);
		}

		return searchResults;
	}

	private class CombiDetails {
		public string isPersonalisedCard;
		public string CardNumber;
		public string AccountNumber;
		public string NomCheq;
		public string NomSavs;
		public string NomCred;
		public string BrandNumber;
		public string oppId;
		public string deliveryMethod;
		public string deliveryBranch;
	}

	private class CombiDailyLimits {
		public string CombiNbr;
		public string CardCshLim;
		public string CardPosLim;
		public string CardCntLim;
		public string CardTrfLim;
		public string CheqNomAcc;
	}
}