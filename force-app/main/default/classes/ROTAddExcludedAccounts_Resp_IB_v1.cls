public class ROTAddExcludedAccounts_Resp_IB_v1 extends Base_IB{
    
   	public AddExcludedAccountsResponse AddExcludedAccountsResponse;
	public class ValidationErrors{
		public list<ServiceValidationResult> ServiceValidationResult;
	}
	public class ServiceValidationResult{
		public String MessageCode;
		public String Message;
	}
	public class Result{
		public String EffectiveEndDate;
		public String IsEffectiveEndDateInfinity;
		public String ObjectID;
		public String EffectiveStartDate;
		public String EntityType;
		public String Description;
		public String ParentSchemeNodeID;
		public String SchemeNodeID;
	}
    public class Information{
		public list<ServiceValidationResult> ServiceInformationResult;
	}
    
	public class ExcludedAccountActionDataResponse{
		public String GroupRestrictionObjectID;
		public String GroupRestrictionClusterID;
		public ValidationErrors ValidationErrors;
		public Result Result;
        public Information Information;
		public String Tag;
		public String AccountNumber;
		public String SystemErrorMessage;
		public String EffectiveStartDate;
		public String HasValidationErrors;
		public String HasSystemError;
		public String HasErrors;
	}
	public class AddExcludedAccountsResult{
		public list<ExcludedAccountActionDataResponse> ExcludedAccountActionDataResponse;
	}
	public class AddExcludedAccountsResponse{
		public AddExcludedAccountsResult AddExcludedAccountsResult;
	}
    
}