public class ROTDeleteExcludedAccount_Resp_IB_v1 extends Base_IB {
    public ROTDeleteExcludedAccount_Resp_IB_v1(){}
    public DeleteExcludedAccountResponse DeleteExcludedAccountResponse;
	public class ValidationErrors{
		public ServiceValidationResult ServiceValidationResult;
	}
	public class Tag{
		public Boolean nil;
	}
	public class SystemErrorMessage{
		public Boolean nil;
	}
	public class ServiceValidationResult{
		public String MessageCode;
		public String Message;
		public MemberNames MemberNames;
	}
	public class Result{
		public String IsEffectiveEndDateInfinity;
		public String EffectiveStartDate;
		public String ObjectID;
		public String EffectiveEndDate;
		public String EntityType;
		public String Description;
		public String ParentSchemeNodeID;
		public String SchemeNodeID;
	}
	public class MemberNames{
		public Boolean nil;
	}
	public class DeleteExcludedAccountResult{
		public ValidationErrors ValidationErrors;
		public String AccountNumber;
		public String Tag;
		public String EffectiveStartDate;
		public String SystemErrorMessage;
		public String GroupRestrictionClusterID;
		public String Information;
		public String GroupRestrictionObjectID;
		public String HasValidationErrors;
		public Result Result;
		public String HasSystemError;
		public String HasErrors;
	}
	public class DeleteExcludedAccountResponse{
		public DeleteExcludedAccountResult DeleteExcludedAccountResult;
	}

}