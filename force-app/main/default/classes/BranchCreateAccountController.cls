/**
 * @description       : BranchCreateAccountController
 * @author            : Ulwazi Mapukata : ABSA
 * @last modified on  : 2021-09-07
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                       		Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)		Switch cases fix
 * 1.1   2021-05-27   André Pietersen (IQ Business)		Added CORP code
 * 1.2   2021-05-27   André Pietersen (IQ Business)		Added Multiple SOF and error display
 * 1.3	 06-09-2021   Brian Maswanganyi 				add test to pull request
 **/
public class BranchCreateAccountController {
	public static Account acc;
	public static Application__c app;
	public static Opportunity opp;
	public static OpportunityLineItem oppproduct;
	public static User userRec;
	public static Address__c addr;
	/**
	 * @description setOpportunityDetails
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 * @param productFamily
	 **/
	public static void setOpportunityDetails(String oppId, String productFamily) {
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
				PersonMobilePhone
			FROM Account
			WHERE Id = :opp.AccountId
			WITH SECURITY_ENFORCED
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
			if (o.Product_Family__c == productFamily) {
				oppproduct = o;
				break;
			}
		}
		app = [SELECT Id, Source_of_Funds__c, Source_of_Funds_Savings__c FROM Application__c WHERE Opportunity__c = :oppId WITH SECURITY_ENFORCED];
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
	 * @description getTranslationValues
	 * @author Brian Maswanganyi | 2021-05-27
	 * @param systemName
	 * @param valueType
	 * @param direction
	 * @return Map<String, String>
	 **/
	@AuraEnabled
	public static List<String> getTranslationValues(String systemName, String valueType, String direction) {
		return BranchFunctions.getTranslationValues(systemName, valueType, direction);
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
	 * @author Brian Maswanganyi | 2021-05-27
	 * @param opportunityId
	 * @param valueType
	 * @param direction
	 * @return List<String>
	 **/
	@AuraEnabled
	public static List<String> getTranslationValuesByFamily(String opportunityId, String valueType, String direction) {
		OpportunityLineItem oppproduct = [
			SELECT Product_Family__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId
			AND Product_Family__c IN('Cheque','Savings')
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		return BranchFunctions.getTranslationValues(oppproduct.Product_Family__c, valueType, direction);
	}

	/**
	 * @description submitAccountMetadata
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 * @param productFamily
	 * @return string
	 **/
	@AuraEnabled
	public static string submitAccountMetadata(string oppId, string productFamily) {
		string response = '';
		productFamily = productFamily.toLowerCase();
		switch on productFamily {
			when 'cheque' {
				response = FraudMetadataHelper.submitAccountMetadata(oppId, FraudMetadataHelper.AccountType.CHEQUE);
			}
			when 'savings' {
				response = FraudMetadataHelper.submitAccountMetadata(oppId, FraudMetadataHelper.AccountType.SAVINGS);
			}
		}
		return response;
	}

	/**
	 * @description updateCIFWithAccountOpening
	 * @author Brian Maswanganyi | 2021-05-27
	 * @param oppId
	 * @param sourceOfFunds
	 * @param productFamily
	 * @return String
	 **/
	@AuraEnabled
	public static String updateCIFWithAccountOpening(String oppId, String sourceOfFunds, String productFamily) {
		string errorMessage;
		setOpportunityDetails(oppId, productFamily);
		CIupdAcctDtlsForClientV1_Req_IB_v1 requestBean = new CIupdAcctDtlsForClientV1_Req_IB_v1();
		requestBean.CIupdAcctDtlsForClientV1 = new CIupdAcctDtlsForClientV1_Req_IB_v1.CIupdAcctDtlsForClientV1();
		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi = new CIupdAcctDtlsForClientV1_Req_IB_v1.Nbsapdpi();
		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi = new CIupdAcctDtlsForClientV1_Req_IB_v1.Nbsmsgi();
		requestBean.CIupdAcctDtlsForClientV1.cip014di = new CIupdAcctDtlsForClientV1_Req_IB_v1.Cip014di();
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry = new CIupdAcctDtlsForClientV1_Req_IB_v1.AccEntry();

		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.channel = 'SF';
		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.application = 'SF';
		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.trace = 'N';

		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi.msgLanguage = 'E';
		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi.msgTarget = 'STD';

		requestBean.CIupdAcctDtlsForClientV1.cip014di.clientCode = opp.CIF_Number__c;
		requestBean.CIupdAcctDtlsForClientV1.cip014di.nbrOfRecords = '1'; // for now it 1
		requestBean.CIupdAcctDtlsForClientV1.cip014di.tellerNo = userRec.Teller_Operator_Code__c;
		requestBean.CIupdAcctDtlsForClientV1.cip014di.site = userRec.SiteCode__c;
		requestBean.CIupdAcctDtlsForClientV1.cip014di.corp = 'ABS';

		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.actionCode = 'A';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.accountNo = oppproduct.Policy_Number__c;
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.product = oppproduct.ProductCode;

		List<String> sofs = new List<string>();
		if (app != null && app.Source_of_Funds_Savings__c != null) {
			sofs = app.Source_of_Funds_Savings__c.split(';', 0);
		}
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds1 = 0 < sofs.size() ? sofs[0] : sourceOfFunds;
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds2 = 1 < sofs.size() ? sofs[1] : '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds3 = 2 < sofs.size() ? sofs[2] : '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds4 = 3 < sofs.size() ? sofs[3] : '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds5 = 4 < sofs.size() ? sofs[4] : '';
		try {
			CIupdAcctDtlsForClientV1_Resp_IB_v1 cifUpdateResponseBean = CIupdAcctDtlsForClientV1_IH_v1.CIupdAcctDtlsForClientV1(requestBean);
			if (cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response != null) {
				if (cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3 != null) {
					if (cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3.msgEntry != null) {
						if (cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3.msgEntry.size() > 0) {
							if (
								cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3.msgEntry[0].msgTxt != null &&
								cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3.msgEntry[0].msgTxt != ''
							) {
								errorMessage = cifUpdateResponseBean.CIupdAcctDtlsForClientV1Response.nbsmsgo3.msgEntry[0].msgTxt;
								throw new AuraHandledException(errorMessage);
							}
						}
					}
				}
			}
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage() + ' ' + errorMessage);
		}
		return 'Success';
	}

	/**
	 * @description
	 * @author Brian Maswanganyi | 2021-07-07
	 * @param applicationId
	 * @param oppId
	 * @return string
	 **/
	@AuraEnabled
	public static ProductDetails getProductDetails(Id applicationId, Id oppId) {

		ProductDetails details = new ProductDetails();

		OpportunityLineItem oppproduct = [
			SELECT Id, Product_Family__c, ProductCode, Product2.Price_Scheme_Code__c, Policy_Number__c, Product2.Description
			FROM OpportunityLineItem
			WHERE OpportunityId = :oppId AND Product_Family__c IN('Cheque','Savings')
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		details.SourceOfFunds = '';
		List<Application__c> applications = [SELECT Id, Source_of_Funds__c FROM Application__c WHERE Id = :applicationId WITH SECURITY_ENFORCED];
		if (applications == null || applications.size() == 0) {
			details.SourceOfFunds = '';
		} else {
			for (Application__c app : applications) {
				details.SourceOfFunds = app.Source_of_Funds__c;
			}
		}

		details.ProductFamily = oppproduct.Product_Family__c;

		details.IsGroupScheme = oppproduct.Product2.Description == 'Group Scheme';
		details.IsSpousal = oppproduct.Product2.Description == 'Spousal';

		return details;
	}

	/**
	 * @description callCQcreateAcct
	 * @author André Pietersen (IQ Business) | 2021-05-27
	 * @param oppId
	 * @param createRetailObj
	 * @return String
	 **/
	@AuraEnabled
	public static String createAndLinkProductByFamily(String oppId, String createRetailObj) {
		CreateRetailAccountCommon common = (CreateRetailAccountCommon) JSON.deserialize(createRetailObj, CreateRetailAccountCommon.class);
		setOpportunityDetails(oppId, common.productFamily);
		common.productFamily = common.productFamily.toLowerCase();
		//Call real time Fraud
		Map<String, String> fraudResponse = new Map<String, String>();
		switch on common.productFamily {
			when 'cheque' {
				fraudResponse = FraudMetadataHelper.getFraudIndicator(oppId, FraudMetadataHelper.AccountType.CHEQUE);
			}
			when 'savings' {
				fraudResponse = FraudMetadataHelper.getFraudIndicator(oppId, FraudMetadataHelper.AccountType.SAVINGS);
			}
		}
		common.fraudIndicator = fraudResponse.get('indicator');
		common.fraudStatus = fraudResponse.get('fraudStatus');
		common.applicationNumber = fraudResponse.get('applicationNbr');
		common.riskRating = determineEddLevel(acc.CASA_Risk_Status__c);
		switch on common.productFamily {
			when 'cheque' {
				return CQcreateAndLinkAccountController.callCQcreateAcct(oppId, common);
			}
			when 'savings' {
				return SVcreateAndLinkAccountController.createSavingsAccount(oppId, common);
			}
		}
		throw new AuraHandledException('Unable to determine create service for product family: ' + common.productFamily);
	}

	/**
	 * @description productUpdateAccountOpenDetails
	 * @author Brian Maswanganyi | 2021-07-12
	 * @param oppId
	 * @param createRetailObj
	 * @return String
	 **/
	@AuraEnabled
	public static string productUpdateAccountOpenDetails(String oppId, String createRetailObj) {
		CreateRetailAccountCommon common = (CreateRetailAccountCommon) JSON.deserialize(createRetailObj, CreateRetailAccountCommon.class);
		setOpportunityDetails(oppId, common.productFamily);
		common.productFamily = common.productFamily.toLowerCase();
		switch on common.productFamily {
			when 'cheque' {
				if(common.groupSchemeEmployer != null && common.groupSchemeEmployer != ''){
					String message = CVSServicesHelper.updateCIFWithGroupSchemeCode(acc.Id, opp.CIF_Number__c, common.groupSchemeEmployer);
					if(message != 'Success')
					{
						throw new AuraHandledException(message);
					}
				}
				return CQcreateAndLinkAccountController.chequeUpdateAccountOpenDetails(oppId, common);
			}
			when 'savings' {
				return SVcreateAndLinkAccountController.updateAccountOpeningDetails(oppId, common);
			}
		}
		throw new AuraHandledException('Unable to determine update product service for product family: ' + common.productFamily);
	}

	/**
	 * @description Product Details, including Source of funds and product family
	 * 
	 **/
	public class ProductDetails{
		@AuraEnabled
		public String SourceOfFunds;
		@AuraEnabled
		public String ProductFamily;
		@AuraEnabled
		public Boolean IsGroupScheme;
		@AuraEnabled
		public Boolean IsSpousal;
	}
}