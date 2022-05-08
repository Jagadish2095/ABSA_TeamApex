/**
 * @description       : Controller for ASPDeviceCustomerVerification
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-09-07
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-06-28   PaulJohn.duRand@absa.africa   PMD refactor
 * 1.0   2021-06-28   Arrie.Castelyn@absa.africa    Added Residential and Postal Street 2
 * 2.0   2021-07-26   rajani.bommasani@absa.africa  Handled DEAConsent information
 * 2.0   2021-07-26   PaulJohn.duRand@absa.africa   Multiple Source of Funds and Refactor
 * 2.0   2021-08-31   PaulJohn.duRand@absa.africa   ProofOfIncome Indicator
 **/

public class ASPDeviceDocumentScanningController {
	public static ASPDeviceDocumentScanningRequest request;
	public static Account account;
	public static String applicationId;

	/**
	 * @description GetDocumentScanningRequestMetadata
	 * @param objectID
	 * @param documentUptakeProcess
	 * @param customerVerification
	 * @param isNoneScored
	 * @return String
	 */
	@AuraEnabled
	public static String GetDocumentScanningRequestMetadata(string objectID, string documentUptakeProcess, string customerVerification, Boolean isNoneScored) {
		populateAccountRecord(BranchFunctions.getAccountId(objectID));
		if (account.Id != objectID) {
			applicationId = BranchFunctions.getApplicationId(objectID);
		}
		request = ASPDeviceDocumentScanningRequest.getnewInstance();
		request.CIFCode = account.CIF__c;
		request.IdNumber = account.ID_Number__pc;
		request.CASAReference = account.CASA_Reference_Number__pc;
		switch on documentUptakeProcess {
			when 'IndividualOnboarding' {
				ASPDeviceDocumentScanningController.SetOnboardingDocuments(customerVerification, isNoneScored);
			}
		}
		String RequestJson = JSON.serialize(request);
		return RequestJson;
	}

	/**
	 * @description populateAccountRecord
	 * @author PaulJohn.duRand@absa.africa | 2021-08-23
	 * @param accountId
	 **/
	private static void populateAccountRecord(string accountId) {
		account = [
			SELECT CIF__c, ID_Number__pc, Initials__pc, ID_Type__pc, CASA_Reference_Number__pc, CASA_Risk_Status__c, LastName
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
	}

	/**
	 * @description getIncomeAndExpenseIndicator
	 * @param category
	 * @param expenseValue
	 * @return boolean
	 **/
	private static boolean getIncomeAndExpenseIndicator(string category, string expenseValue) {
		boolean flag = false;
		List<Application_Income_and_Expense__c> result = [
			SELECT Id, Applicant_Value__c
			FROM Application_Income_and_Expense__c
			WHERE Application__c = :applicationId AND Category__c = :category AND Expense_Value__c = :expenseValue
			WITH SECURITY_ENFORCED
		];
		if (result.size() == 0 || result[0].Applicant_value__c > 0) {
			flag = true;
		}
		return flag;
	}

	/**
	 * @description GetBankStatementsDEAAccountHolderInfo
	 * @param accountPurpose
	 */
	private static void GetBankStatementDEASalaryInfo(string accountPurpose) {
		Application_Financial_Account__c financialAccount = [
			SELECT Account_Holder_Name__c, Account_Number__c, Account_Type__c, Institution_Name__c
			FROM Application_Financial_Account__c
			WHERE Application__c = :applicationId AND Account_Purpose__c = :accountPurpose
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		request.DEAConsentInformation.AccountNumber = financialAccount.Account_Number__c;
		request.DEAConsentInformation.AccountType = financialAccount.Account_Type__c;
		BankInfo__c bankInfo = [
			SELECT Bank_short_name__c, Branch_code__c
			FROM BankInfo__c
			WHERE Name = :financialAccount.Institution_Name__c
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		request.DEAConsentInformation.BankName = bankInfo.Bank_short_name__c;
		request.DEAConsentInformation.BranchCode = bankInfo.Branch_code__c;
	}

	/**
	 * @description GetBankStatementsDEAAccountHolderInfo
	 */
	private static void GetBankStatementsDEAAccountHolderInfo() {
		string idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'CIFCodesList',
			'Idtype',
			account.ID_Type__pc,
			StringConstants.INBOUND_RECORD_TYPE
		);
		request.DEAConsentInformation.IdTypeCode = idType;
		request.DEAConsentInformation.IdentificationNumber = account.ID_Number__pc;
		request.DEAConsentInformation.Initials = account.Initials__pc;
		request.DEAConsentInformation.LastName = account.LastName;
	}

	/**
	 * @description SetOnboardingDocuments
	 * @param customerVerification
	 * @param isNoneScored
	 */
	private static void SetOnboardingDocuments(string customerVerification, boolean isNoneScored) {
		AddProofOfIdentification(customerVerification);
		AddProofOfResident(customerVerification);
		if (!isNoneScored && applicationId != null) {
			if (getIncomeAndExpenseIndicator('Monthly Income', 'POI')) {
				request.ASPDocumentNameList.add(ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.ProofOfIncome);
			}
			request.DEAConsent = getIncomeAndExpenseIndicator('Monthly Income', 'Bank Statements Consent');
			if (request.DEAConsent) {
				GetBankStatementDEASalaryInfo('Salary');
				GetBankStatementsDEAAccountHolderInfo();
			}
			if ((account.CASA_Risk_Status__c == 'High' || account.CASA_Risk_Status__c == 'Very High')) {
				List<String> sourceOfFundsList = getApplicationSOF();
				integer sourceOfFundsSize = sourceOfFundsList.size();
				for (Integer item = 1; item <= sourceOfFundsSize && item <= 5; item++) {
					request.ASPDocumentNameList.add(ASPDeviceDocumentScanningController.getDocType('SourceOfFunds' + String.valueOf(item)));
				}
			}
		}
	}

	/**
	 * @description Get Source of Funds data from Application__c
	 * @return String
	 */
	private static List<string> getApplicationSOF() {
		Application__c app = [SELECT Source_of_Funds_Savings__c FROM Application__c WHERE Id = :applicationId WITH SECURITY_ENFORCED];
		List<String> sourceOfFundsList = new List<string>();
		if (app.Source_of_Funds_Savings__c != null && app.Source_of_Funds_Savings__c != '') {
			sourceOfFundsList = app.Source_of_Funds_Savings__c.split(';', 0);
		}
		return sourceOfFundsList;
	}

	/**
	 * @description AddProofOfIdentification
	 * @param customerVerification
	 */
	private static void AddProofOfIdentification(string customerVerification) {
		ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = new ASPDeviceCustomerVerificationResponse();
		deviceCustomerVerificationResponse = (ASPDeviceCustomerVerificationResponse) JSON.deserialize(
			customerVerification,
			ASPDeviceCustomerVerificationResponse.class
		);
		if (deviceCustomerVerificationResponse.HANISAttestationValue == 'YY' && deviceCustomerVerificationResponse.isHANISCertificateStoredInEcm) {
			ASPDeviceDocumentScanningRequest.DocumentToUpdateInEcm DocumentToUpdate = new ASPDeviceDocumentScanningRequest.DocumentToUpdateInEcm();
			DocumentToUpdate.ASPDocumentName = ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.IDDocument;
			DocumentToUpdate.DocumentId = deviceCustomerVerificationResponse.HANISCertECMdetails.DocumentId;
			DocumentToUpdate.Pid = deviceCustomerVerificationResponse.HANISCertECMdetails.Pid;
			request.DocumentsToUpdateInEcmList.add(DocumentToUpdate);
		} else {
			request.ASPDocumentNameList.add(ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.IDDocument);
		}
	}

	/**
	 * @description SetOnboardingDocuments
	 * @param customerVerification
	 */
	private static void AddProofOfResident(string customerVerification) {
		if (account.CASA_Risk_Status__c != 'Low' && account.CASA_Risk_Status__c != 'Very Low') {
			ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = (ASPDeviceCustomerVerificationResponse) JSON.deserialize(
				customerVerification,
				ASPDeviceCustomerVerificationResponse.class
			);
			if (
				deviceCustomerVerificationResponse.isCPBResidentialAddressCertificateStoredInEcm &&
				deviceCustomerVerificationResponse.CPBServiceResponse != null &&
				!isResAddressDifferentFromCPB(deviceCustomerVerificationResponse.CPBServiceResponse)
			) {
				ASPDeviceDocumentScanningRequest.DocumentToUpdateInEcm DocumentToUpdate = new ASPDeviceDocumentScanningRequest.DocumentToUpdateInEcm();
				DocumentToUpdate.ASPDocumentName = ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.ProofOfResidence;
				DocumentToUpdate.DocumentId = deviceCustomerVerificationResponse.CPBResidentialAddressCertECMdetails.DocumentId;
				DocumentToUpdate.Pid = deviceCustomerVerificationResponse.CPBResidentialAddressCertECMdetails.Pid;
				request.DocumentsToUpdateInEcmList.add(DocumentToUpdate);
			} else {
				request.ASPDocumentNameList.add(ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.ProofOfResidence);
			}
		}
	}

	/**
	 * @description is Residential Address Different FromCPB
	 * @author PaulJohn.duRand@absa.africa | 2021-08-23
	 * @param CPBServiceResponse
	 * @return boolean
	 **/
	private static boolean isResAddressDifferentFromCPB(ASPDeviceCustomerVerificationResponse.CPBResponse CPBServiceResponse) {
		Address__c residentialAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :account.Id AND Address_TYpe__c = 'Residential'
			LIMIT 1
		];
		if (
			residentialAddress != null &&
			toLowerCaseNullable(residentialAddress.Shipping_Street__c) ==
			toLowerCaseNullable(CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line1) &&
			toLowerCaseNullable(residentialAddress.Shipping_Street_2__c) ==
			toLowerCaseNullable(CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line2) &&
			toLowerCaseNullable(residentialAddress.Shipping_Suburb__c) ==
			toLowerCaseNullable(CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line3) &&
			toLowerCaseNullable(residentialAddress.Shipping_City__c) ==
			toLowerCaseNullable(CPBServiceResponse.Person.AddressInformation.ResidentialAddress.Line4) &&
			residentialAddress.Shipping_Zip_Postal_Code__c == CPBServiceResponse.Person.AddressInformation.ResidentialAddress.PostalCode.leftPad(4, '0')
		) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @description Nullable toLowerCase
	 * @author PaulJohn.duRand@absa.africa | 2021-08-23
	 * @param text
	 * @return string
	 **/
	private static string toLowerCaseNullable(String text) {
		if (text != null && !string.isEmpty(text)) {
			return text.toLowerCase();
		} else {
			return text;
		}
	}

	/**
	 * @description Get Enum from text reference.
	 * @author PaulJohn.duRand@absa.africa | 2021-08-23
	 * @param docTypeName
	 * @return ASPDeviceDocumentScanningRequest.ASPDocumentTypeName
	 **/
	private static ASPDeviceDocumentScanningRequest.ASPDocumentTypeName getDocType(String docTypeName) {
		for (ASPDeviceDocumentScanningRequest.ASPDocumentTypeName st : ASPDeviceDocumentScanningRequest.ASPDocumentTypeName.values()) {
			if (st.name().toUpperCase() == docTypeName.toUpperCase()) {
				return st;
			}
		}
		return null;
	}
}