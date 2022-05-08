public class ROTAddAccount_Resp_IB_v1 extends Base_IB {
    /*
	public class ServiceInformationResult {
		public String Message;
		public String MessageCode;
	}*/
    
    public class ServiceValidationResult {
		public String Message;
		public String MessageCode;
	}

	public AddAccountResponse AddAccountResponse;

	public class AddAccountResult {
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		//public Information Information;
		public String SystemErrorMessage;
        public String Tag;
        public ValidationErrors ValidationErrors;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public Result Result;
		public String AccountNumber;
		public String EffectiveStartDate;
	}

	public class AddAccountResponse {
		public AddAccountResult AddAccountResult;
	}
    /*
	public class Information {
		public List<ServiceInformationResult> ServiceInformationResult;
	}*/
    
    public class ValidationErrors {
		public List<ServiceValidationResult> ServiceValidationResult;
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
    
    public ROTAddAccount_Resp_IB_v1(){
        
    }

}