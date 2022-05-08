public class ExergyChangeBankInformation_Resp_IB_v1 extends BASE_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	public class Contract_ChangeBankInformationResponse {
		@AuraEnabled
		public String Contract_ChangeBankInformationResult;
		@AuraEnabled
		public PcolValidationMessages pcolValidationMessages;
	}

	public class V3_DC2_LoggedMsg {
		@AuraEnabled
		public Integer CreatedBy;
		@AuraEnabled
		public String CreatedDate;
		@AuraEnabled
		public String GID;
		@AuraEnabled
		public String Level;
		@AuraEnabled
		public Integer LevelID;
		@AuraEnabled
		public String Message;
		@AuraEnabled
		public Integer MessageID;
		@AuraEnabled
		public Integer OverRideLevelID;
		@AuraEnabled
		public String OverRideReason;
		//@AuraEnabled public Object OverrideLevel;
	}

	@AuraEnabled
	public Contract_ChangeBankInformationResponse Contract_ChangeBankInformationResponse;

	public class PcolValidationMessages {
		@AuraEnabled
		public V3_DC2_LoggedMsg V3_DC2_LoggedMsg;
	}

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('Contract_ChangeBankInformation.pobjBankContract.AccountTypeID', 'Exergy;Account Type');
	}
}