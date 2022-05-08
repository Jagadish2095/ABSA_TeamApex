public class ROTCreateGroupRestriction_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public class ServiceValidationResult {
		public String Message;
		public String MessageCode;
	}
    
	public CreateGroupRestrictionResponse CreateGroupRestrictionResponse;
    
    public class ValidationErrors {
		public List<ServiceValidationResult> ServiceValidationResult;
	}

	public class CreateGroupRestrictionResponse {
		public CreateGroupRestrictionResult CreateGroupRestrictionResult;
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

	public class CreateGroupRestrictionResult {
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		public String SystemErrorMessage;
		public String Tag;
        public ValidationErrors ValidationErrors;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public Result Result;
	}
    
    public ROTCreateGroupRestriction_Resp_IB_v1(){
        
    }
}