public class ROTDeleteAccount_IB_Resp_v1 extends Base_IB {
    
    public class ServiceValidationResult {
		public String Message;
		public String MessageCode;
	}

	public DeleteAccountResponse DeleteAccountResponse;

	public class ValidationErrors {
		public List<ServiceValidationResult> ServiceValidationResult;
	}

	public class DeleteAccountResponse {
		public DeleteAccountResult DeleteAccountResult;
	}

	public class DeleteAccountResult {
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		public Object SystemErrorMessage;
		public Object Tag;
		public ValidationErrors ValidationErrors;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public Result Result;
		public String AccountNumber;
		public String EffectiveStartDate;
	}

	public class Result {
		public Object Description;
		public Object EffectiveEndDate;
		public Object EffectiveStartDate;
		public Object IsEffectiveEndDateInfinity;
		public Object ObjectID;
		public Object EntityType;
		public Object ParentSchemeNodeID;
		public Object SchemeNodeID;
	}
    
    public ROTDeleteAccount_IB_Resp_v1(){
        
    }

}