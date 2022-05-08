public class ROTAddaccounts_IB_Resp_v1 extends Base_IB{
    
   public class ServiceInformationResult {
		public String Message;
		public String MessageCode;
	}

	public AddAccountsResponse AddAccountsResponse;

	public class AddAccountsResponse {
		public AddAccountsResult AddAccountsResult;
	}

	public class AccountActionDataResponse {
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		public Information Information;
		public String SystemErrorMessage;
		public String Tag;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public Result Result;
		public String AccountNumber;
		public String EffectiveStartDate;
	}

	public class Information {
		public List<ServiceInformationResult> ServiceInformationResult;
	}

	public class AddAccountsResult {
		public List<AccountActionDataResponse> AccountActionDataResponse;
	}

	public class Result {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String IsEffectiveEndDateInfinity;
		public String ObjectID;
		public String EntityType;
		public String ParentSchemeNodeID;
		public String SchemeNodeID;
	}

    
    public ROTAddaccounts_IB_Resp_v1(){
        
    }
}