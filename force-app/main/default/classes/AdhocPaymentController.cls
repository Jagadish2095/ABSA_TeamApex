/**
 * @description Controller class to schedule Adhoc payment for policy
 * @author  Koketso Mpshane
 * @date    17/02/2021
 *
 * @updatedBy: Bhanumurty Rayala
 * @updatedDate: 2021/09/08
 * @updatedUserStory: W-011355
 */
public class AdhocPaymentController {

	/**
	 * @description method to fetch the policy details from service
	 * @param policyNumber
	 * @return String
	 */
	@AuraEnabled
	public static String fetchPolicyDetails(String policyNumber) {
		String errorMessages = '';
		PolicyLoadByRefNo_Resp_IB_v1 responseBean;

		try {
			responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

			if (responseBean.statusCode != 200) {
				return 'Error: ' + responseBean.message;
			}

			if (responseBean == null) {
				// check if response is null
				return 'Error: Blank response received from service;';
			}
		} catch (Exception ex) {
			return 'Error: ' + JSON.serialize(ex);
		}

		if (responseBean?.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult?.Contracts?.V3_DC2Contract != null) {
			PolicyLoadByRefNo_Resp_IB_v1.V3_DC2Contract policyDetails = responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract;
			return JSON.serialize(policyDetails);
		} else {
			return 'Error: Unexpected error occurred';
		}
	}

	/**
	 * @description method for debit order creation
	 * @param debitOrderParamsMap
	 * @return String
	 */
	@AuraEnabled
	public static String createAdhocDebitOrder(Map<String, String> debitOrderParamsMap) {

		String errorMessages = '';
		ContractCreateAdhocDO_Resp_IB_v1 responseBean;

		String policyNumber = debitOrderParamsMap.get('policyNumber');
		String collectionDate = debitOrderParamsMap.get('collectionDate');
		Boolean bankDetailsChanged = Boolean.valueOf(debitOrderParamsMap.get('bankDetailsChanged'));

		String translatedAccType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'Exergy',
			'Account Type',
			debitOrderParamsMap.get('accountType'),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		Integer accountTypeID = Integer.valueOf(translatedAccType);
		Integer branchID;
		Integer bankID;

		if (bankDetailsChanged) {
			String translatedBranch = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'Exergy',
				'Branch ID',
				debitOrderParamsMap.get('branchCode'),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			String translatedBank = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				'Exergy',
				'Bank Name',
				debitOrderParamsMap.get('bankName'),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			branchID = Integer.valueOf(translatedBranch);
			bankID = Integer.valueOf(translatedBank);
		} else {
			branchID = Integer.valueOf(debitOrderParamsMap.get('externalBranchID'));
			bankID = Integer.valueOf(debitOrderParamsMap.get('externalBankID'));
		}

		ContractCreateAdhocDO_Req_IB_v1.pobjBankContract bankAccountObj = new ContractCreateAdhocDO_Req_IB_v1.PobjBankContract();
		bankAccountObj.AccountName = debitOrderParamsMap.get('accountName');
		bankAccountObj.AccountNo = debitOrderParamsMap.get('accountNo');
		bankAccountObj.AccountTypeID = accountTypeID;
		bankAccountObj.BankBranchID = branchID;
		bankAccountObj.BankID = bankID;

		try {
			responseBean = ContractCreateAdhocDO_IH_v1.contractCreateAdhocDO(policyNumber, bankAccountObj, collectionDate);

			if (responseBean.statusCode != 200) {
				return 'Error: ' + responseBean.message;
			}

			if (responseBean == null || responseBean.Contract_CreateAdhocDOResponse.Contract_CreateAdhocDOResult == null) {
				// check if response is null
				return 'Error: Blank response received from service;';
			}

			if (responseBean.Contract_CreateAdhocDOResponse.Contract_CreateAdhocDOResult == '0') {
				// check if response is not successful
				if (responseBean?.Contract_CreateAdhocDOResponse?.pcolValidationMessages?.V3_DC2_LoggedMsg?.Message != null) {
					return 'Error: ' + responseBean.Contract_CreateAdhocDOResponse.pcolValidationMessages.V3_DC2_LoggedMsg.Message;
				} else {
					return 'Error: Unexpected error received from service;';
				}
			}


			if (responseBean.Contract_CreateAdhocDOResponse.Contract_CreateAdhocDOResult != '1') {
				return 'Error: An error occurred while submitting an Adhoc payment!';
			}

		} catch (Exception ex) {
			return 'Error: ' +  JSON.serialize(ex);
		}

		return JSON.serialize(responseBean);
	}

	/**
	 * @description method for the transactional history
	 * @param policyNumber
	 * @return String
	 */
	@AuraEnabled
	public static String getTransactionalHistory(String policyNumber){

		PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);
		if(responseBean.StatusCode != 200){
            return 'Error: unexpected error from service';
        }
        if (responseBean?.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult?.Contracts?.V3_DC2Contract?.FinTransactions?.V3_DC2FinTransaction == null) {
            return 'Error: No Transaction History Found';
        }
		List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction> updatedResponseBean = new List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction>();
		if (responseBean?.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult?.Contracts?.V3_DC2Contract != null) {
			for(PolicyLoadByRefNo_Resp_IB_v1.V3_DC2FinTransaction finTransaction : responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.FinTransactions.V3_DC2FinTransaction){
				finTransaction.CreatedDate = finTransaction.CreatedDate.replace(finTransaction.CreatedDate, finTransaction.CreatedDate.left(10));
				updatedResponseBean.add(finTransaction);
			}
		}
		return JSON.serialize(updatedResponseBean);
	}
}