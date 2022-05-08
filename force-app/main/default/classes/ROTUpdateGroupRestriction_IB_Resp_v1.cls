public class ROTUpdateGroupRestriction_IB_Resp_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
	public class ServiceInformationResult {
		public String Message;
		public String MessageCode;
	}

	public class UpdateGroupRestrictionResult {
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		public Information Information;
		public String SystemErrorMessage;
		public String Tag;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public Result Result;
	}

	public class UpdateGroupRestrictionResponse {
		public UpdateGroupRestrictionResult UpdateGroupRestrictionResult;
	}

	public UpdateGroupRestrictionResponse UpdateGroupRestrictionResponse;

	public class Information {
		public List<ServiceInformationResult> ServiceInformationResult;
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
    
    public ROTUpdateGroupRestriction_IB_Resp_v1(){
        
    }
}