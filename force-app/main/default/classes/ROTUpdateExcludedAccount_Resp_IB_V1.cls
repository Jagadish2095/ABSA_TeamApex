public class ROTUpdateExcludedAccount_Resp_IB_V1 extends Base_IB{
	//constructor
    public ROTUpdateExcludedAccount_Resp_IB_V1(){}
    public UpdateExcludedAccountResponse UpdateExcludedAccountResponse;
	public class ValidationErrors{
		public list<ServiceValidationResult> ServiceValidationResult;
	}
	public class UpdateExcludedAccountResult{
		public ValidationErrors ValidationErrors;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String Tag;
		public Result Result;
		public String SystemErrorMessage;
		public String AccountNumber;
		public String HasValidationErrors;
		public String EffectiveStartDate;
		public String HasSystemError;
		public String HasErrors;
        public Information Information;
	}
	public class UpdateExcludedAccountResponse{
		public UpdateExcludedAccountResult UpdateExcludedAccountResult;
	}
    public class Information{
		public list<ServiceValidationResult> ServiceInformationResult;
	}
	public class ServiceValidationResult{
		public String MessageCode;
		public String Message;
	}
	public class Result{
		public String EffectiveEndDate;
		public String EntityType;
		public String ObjectID;
		public String ParentSchemeNodeID;
		public String IsEffectiveEndDateInfinity;
		public String SchemeNodeID;
		public String EffectiveStartDate;
		public String Description;
	}
}