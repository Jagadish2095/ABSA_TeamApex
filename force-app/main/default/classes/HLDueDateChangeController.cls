/** 
 * @description Apex contoller for HLDueDateChange Lightning Component
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public  class HLDueDateChangeController {
    
    /**
	 * @description Method to get Account Information 
	 * @param accountNumber
	 * @return MLgetAcctInfoCUS1V1_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MLgetAcctInfoCUS1V1_Resp_IB_v1 getAccountData(String accountNumber) {
		MLgetAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLgetAcctInfoCUS1V1_IH_v1.getAccountInfo(accountNumber, 'DUE');
		String schamaCodeTranslation;
		String interestRateTypeTransalation;
		String errorCodeTranslation;
		if(responseBean.statusCode == 200){
			
			//Add Translations
			schamaCodeTranslation = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('EOML', 'Schema Code', String.valueof(responseBean.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_SCHM_CODE), StringConstants.INBOUND_RECORD_TYPE);
			interestRateTypeTransalation = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('EOML', 'Interest Rate Type', responseBean.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_CUR_INT_RATE_TYPE, StringConstants.INBOUND_RECORD_TYPE);
			responseBean.MLB854O.MLB854O_OUTPUT_AREA.schemaCodeTranslated = schamaCodeTranslation;
			responseBean.MLB854O.MLB854O_OUTPUT_AREA.interestRateTypeTranslated = interestRateTypeTransalation;
			errorCodeTranslation = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('EOML', 'HL Error Code', String.valueof(responseBean.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_RETURN_CODE), StringConstants.INBOUND_RECORD_TYPE);
			responseBean.MLB854O.MLB854O_OUTPUT_AREA.returnCodeTranslated = errorCodeTranslation;
		}
		return responseBean;
	}

	/**
	* @description Method to update the due date 
	* @param accountNumber
	* @param primaryAccountId
	* @param newDueDay
	* @param refNumber
	* @param schemaCode
	* @return MLupdAcctInfoCUS1V1_Resp_IB_v1
	*/
	@AuraEnabled
	public static MLupdAcctInfoCUS1V1_Resp_IB_v1 updateDueDate(String accountNumber, String primaryAccountId, Integer newDueDay, Integer refNumber, Double schemaCode) {
		MLupdAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLupdAcctInfoCUS1V1_IH_v1.doUpdate(accountNumber, primaryAccountId, newDueDay, refNumber, schemaCode, 'DUE');
		String errorCodeTranslation;
		if(responseBean.statusCode == 200 && responseBean.errorMessage == null){
			errorCodeTranslation = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('EOML', 'HL Error Code', String.valueof(responseBean?.MLB855O?.MLB855O_OUTPUT_AREA?.MLB855O_RETURN_CODE), StringConstants.INBOUND_RECORD_TYPE);
			responseBean.MLB855O.MLB855O_OUTPUT_AREA.returnCodeTranslated = errorCodeTranslation;
		}
		
		return responseBean;
	}
}