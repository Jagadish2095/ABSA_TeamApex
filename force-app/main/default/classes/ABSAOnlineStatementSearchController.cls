/**
 * @description Controller Class for Lightning Component ABSAOnlineStatementSearch
 * @author  Srikanth : Absa
 * @version v2.0
 * @since   2020-10-20
 * @updated by Humbelani Denge
 **/
public class ABSAOnlineStatementSearchController {
	/**
	 * @description getCIFValue
	 * @param clientAccountId
	 * @return String
	 * **/
	@AuraEnabled
	public static String getCIFValue(String clientAccountId) {
		string cifKeyValue;
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		cifKeyValue = accountList[0].CIF__c;
		return cifKeyValue;
	}

	/**
	 * @description getAccountDetails
	 * @param selectedAccNumber
	 * @param accountType
	 * @param startDate
	 * @param endDate
	 * @param cifkey
	 * @param isRateChange
	 * @return ABSAOnlineStatementSearch_Resp_IB_v1
	 **/
	@AuraEnabled
	public static ABSAOnlineStatementSearch_Resp_IB_v1 getAccountDetails(
		String selectedAccNumber,
		String accountType,
		String startDate,
		String endDate,
		string cifkey,
		Boolean isRateChange
	) {
		try {
			String accountTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				isRateChange == true ? StringConstants.EPS_STRING : 'RSD',
				StringConstants.ACCOUNT_TYPE,
				accountType,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (accountTypeTranslated == null) {
				ABSAOnlineStatementSearch_Resp_IB_v1 errorResponse = new ABSAOnlineStatementSearch_Resp_IB_v1();
				errorResponse.error = 'Provide Valid Account Type';
				return errorResponse;
			}

			return ABSAOnlineStatementSearch_IH_v1.ABSAOnlineStatementSearch(
				selectedAccNumber,
				Integer.valueOf(accountTypeTranslated),
				cifKey,
				startDate +
				':' +
				endDate
			);
		} catch (Exception e) {
			ABSAOnlineStatementSearch_Resp_IB_v1 errorResponse = new ABSAOnlineStatementSearch_Resp_IB_v1();
			errorResponse.error = e.getMessage();
			return errorResponse;
		}
	}

	/**
	 * @description pdfFileService
	 * @param accountId
	 * @param cifKey
	 * @param selectedDocDate
	 * @param accountType
	 * @param selectedAccNumber
	 * @param listRef
	 * @param isRateChange
	 * @return ABSAOnlineStatementDownload_Resp_IB_v1
	 **/
	@AuraEnabled
	public static ABSAOnlineStatementDownload_Resp_IB_v1 pdfFileService(
		String accountId,
		String cifKey,
		String selectedDocDate,
		String accountType,
		String selectedAccNumber,
		String listRef,
		Boolean isRateChange
	) {
		String accountTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			isRateChange == true ? StringConstants.EPS_STRING : 'RSD',
			StringConstants.ACCOUNT_TYPE,
			accountType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		if (accountTypeTranslated == null) {
			throw new ApplicationException('Provide Valid Account Type');
		}
		String password;
		Account caseAccount = new AccountsSelector().selectAllById(accountId);

		if (caseAccount.isPersonAccount && String.isNotBlank(caseAccount.ID_Number__pc)) {
			password = '' + caseAccount.ID_Number__pc;
		} else if (caseAccount.isPersonAccount && String.isNotBlank(caseAccount.Passport_Number__pc)) {
			password = '' + caseAccount.Passport_Number__pc;
		} else if (!caseAccount.isPersonAccount) {
			password = '' + selectedAccNumber;
		}

		String attachmentName = selectedDocDate + '-xxxx' + selectedAccNumber.right(4);
		ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = ABSAOnlineStatementDownload_IH_v1.ABSAOnlineStatementDownload(
			selectedAccNumber,
			Integer.valueOf(accountTypeTranslated),
			cifKey,
			'PDF',
			listRef,
			selectedDocDate,
			password
		);
		return responseBean;
	}

	/**
	 * @description statementDownload
	 * @author Humbelani Denge
	 * @param accountId
	 * @param cifKey
	 * @param selectedDocDate
	 * @param accountType
	 * @param selectedAccNumber
	 * @param listRef
	 * @return ABSAOnlineStatementDownload_Resp_IB_v1
	 **/
	@AuraEnabled
	public static ABSAOnlineStatementDownload_Resp_IB_v1 statementDownload(
		String accountId,
		String cifKey,
		String selectedDocDate,
		String accountType,
		String selectedAccNumber,
		String listRef
	) {
		String accountTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'RSD',
			StringConstants.ACCOUNT_TYPE,
			accountType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		if (accountTypeTranslated == null) {
			throw new ApplicationException('Provide Valid Account Type');
		}

		if (!string.isNotBlank(selectedAccNumber)) {
			throw new ApplicationException('No value provided for document password');
		}
		ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = ABSAOnlineStatementDownload_IH_v1.ABSAOnlineStatementDownload(
			selectedAccNumber,
			Integer.valueOf(accountTypeTranslated),
			cifKey,
			'PDF',
			listRef,
			selectedDocDate,
			selectedAccNumber
		);
		return responseBean;
	}

	/**
	 * @description get Account Category from Account Number
	 * @param accountNumber
	 * @return String
	 * **/
	@AuraEnabled
	public static String getAccountCategory(String accountNumber) {
		List<String> accountCategory = AVAFAccountTypeClassification.getContractDetailsCorpCode(new List<String>{ accountNumber });
		return accountCategory[0];
	}
}