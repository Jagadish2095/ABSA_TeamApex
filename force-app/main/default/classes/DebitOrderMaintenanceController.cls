/*
 * DebitOrderMaintenanceController for getting account details
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-07-10
 * @W-006725
 */
public class DebitOrderMaintenanceController {
	/*
	 *Added by : Humbelani Denge
	 *Date : 2021/02/18
	 *@W-007785 & @W-007780
	 */
	@AuraEnabled
	public static Map<String, Object> getExergyDataForAbsaLife(String policyNumber, List<String> fieldList) {
		Map<String, Object> absaLifeDataMap = new Map<String, Object>();

		PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

		absaLifeDataMap.put('responseBean', responseBean);
		absaLifeDataMap.put('picklistValues', Sys_Utilities_General.getMultipleSelectOptions(fieldList));

		return absaLifeDataMap;
	}

	/*
	 *Added by : Humbelani Denge
	 *Date : 2021/02/18
	 *@W-007785 & @W-007780
	 *Updated by Koketso Mpshane - 05-03-21
	 */
	@AuraEnabled
	public static string exergyBankAndContractInfoChange(
		String policyNo,
		String accName,
		String accNo,
		String accTypeID,
		String branchID,
		String bankID,
		String dayOfPayment,
		String sourceOfFunds,
		Boolean bankDetailsChanged
	) {
		String accTypeStr = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'Exergy',
			'Account Type',
			accTypeID,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String bankStr;
		String branchStr;

		if (bankDetailsChanged) {
			bankStr = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('Exergy', 'Bank Name', bankID, StringConstants.OUTBOUND_RECORD_TYPE);
			branchStr = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('Exergy', 'Branch ID', branchID, StringConstants.OUTBOUND_RECORD_TYPE);
		} else {
			bankStr = bankID;
			branchStr = branchID;
		}

		ExergyChangeBankInformation_Resp_IB_v1 responseBean = ExergyChangeBankInformation_IH_v1.ExergyChangeBankInformation(
			policyNo,
			accName,
			accNo,
			Integer.valueOf(accTypeStr),
			Integer.valueOf(branchStr),
			Integer.valueOf(bankStr),
			Integer.valueOf(dayOfPayment),
			Integer.valueOf(sourceOfFunds)
		);

		if (String.isEmpty(responseBean?.Contract_ChangeBankInformationResponse?.Contract_ChangeBankInformationResult)) {
			return 'Error: Blank response received from service.';
		}

		if (responseBean.Contract_ChangeBankInformationResponse.Contract_ChangeBankInformationResult.equals('0')) {
			return 'Error:' + responseBean.Contract_ChangeBankInformationResponse.pcolValidationMessages.V3_DC2_LoggedMsg.Message;
		}

		if (
			responseBean.Contract_ChangeBankInformationResponse.Contract_ChangeBankInformationResult != '1' &&
			responseBean.Contract_ChangeBankInformationResponse.pcolValidationMessages?.V3_DC2_LoggedMsg?.Message == null
		) {
			return 'Error: Change of information unsuccessful, please contact your administrator';
		}

		if (responseBean.Contract_ChangeBankInformationResponse.Contract_ChangeBankInformationResult != '1') {
			return 'Error: Change of information unsuccessful, please contact your administrator';
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		return JSON.serialize(responseBean);
	}

	@AuraEnabled
	public static NHGetAccountDetailv3_Resp_IB_v1 getHomeLoansData(String combiNumberP, String accountNumberP) {
		return NHGetAccountDetailv3_IH_v1.nhgetaccountdetailv3(combiNumberP, accountNumberP);
	}

	@AuraEnabled
	public static Map<String, Object> getAbsaLifeData(String policyNumber, List<String> fieldList) {
		Map<String, Object> absaLifeDataMap = new Map<String, Object>();
		LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = LAListPolicyDetailsByPolicyV7_IH_v1.LAListPolicyDetailsByPolicyV7(policyNumber);
		absaLifeDataMap.put('responseBean', responseBean);
		absaLifeDataMap.put('picklistValues', Sys_Utilities_General.getMultipleSelectOptions(fieldList));

		Integer branchCode = responseBean?.LAlistPolicyDetailsbyPolicyNumberV7Response?.la950p3o?.branchCode;

		if (branchCode != null && branchCode > 0) {
			List<Lookup__c> lookupList = new LookupsSelector().selectByBranchCode(new Set<String>{ String.valueOf(branchCode) });
			if (lookupList != null && lookupList.size() > 0) {
				absaLifeDataMap.put('bankName', lookupList[0].Bank__r.Name);
				absaLifeDataMap.put('branchName', lookupList[0].Name);
			}
		}
		return absaLifeDataMap;
	}

	@AuraEnabled
	public static LAUpdateBankingDetailsV3_Resp_IB_v1 updateLABankingDetails(
		String clientCode,
		String policyNumber,
		String bankName,
		String sourceOfIncome,
		String sourceOfFund,
		String bankAccountNo,
		String accountHolderName,
		String collectionDay,
		String frequency,
		String accountType,
		String branchCode,
		String amount
	) {
		return LAUpdateBankingDetailsV3_IH_v1.LAUpdateBankingDetailsV3(
			clientCode,
			policyNumber,
			bankName,
			sourceOfIncome,
			sourceOfFund,
			bankAccountNo,
			accountHolderName,
			collectionDay,
			frequency,
			accountType,
			branchCode,
			amount
		);
	}

	@AuraEnabled
	public static Boolean checkBankAccount(String accountNumber, String branchCode, String accountType) {
		String accType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Account Type', accountType, 'Outbound');
		CheckDigitVerification_Resp_IB_v1 accountResponse = CheckDigitVerification_IH_v1.checkDigitVerification(
			accountNumber,
			branchCode,
			accType,
			'DR',
			'',
			'',
			'Sales',
			'Salesforce',
			'E',
			'STD',
			'N'
		);
		if (accountResponse?.rc == '0') {
			return true;
		} else {
			return false;
		}
	}
}