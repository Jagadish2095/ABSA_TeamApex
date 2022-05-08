/*
 * Response Integration Bean for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-12
 */
public class ContractCreateAdhocDO_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	public class V3_DC2_LoggedMsg {
		@AuraEnabled
		public Integer createdBy;
		@AuraEnabled
		public String createdDate;
		@AuraEnabled
		public String gID;
		@AuraEnabled
		public String level;
		@AuraEnabled
		public Integer levelID;
		@AuraEnabled
		public String message;
		@AuraEnabled
		public Integer messageID;
		@AuraEnabled
		public Integer overRideLevelID;
		//@AuraEnabled public Object OverRideReason;
		//@AuraEnabled public Object OverrideLevel;
	}

	@AuraEnabled
	public Contract_CreateAdhocDOResponse Contract_CreateAdhocDOResponse;

	public class Contract_CreateAdhocDOResponse {
		@AuraEnabled
		public String Contract_CreateAdhocDOResult;
		@AuraEnabled
		public PcolValidationMessages pcolValidationMessages;
	}

	public class PcolValidationMessages {
		@AuraEnabled
		public V3_DC2_LoggedMsg V3_DC2_LoggedMsg;
	}

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('Contract_CreateAdhocDO.pobjBankContract.AccountTypeID', 'Exergy;Account Type');
	}
}