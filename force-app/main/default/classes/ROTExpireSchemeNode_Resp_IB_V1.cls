public class ROTExpireSchemeNode_Resp_IB_V1 extends Base_IB{
    //constructor
    public ROTExpireSchemeNode_Resp_IB_V1(){}
	public ExpireSchemeNodeResponse ExpireSchemeNodeResponse;
	public class ValidationErrors{
		public list<ServiceValidationResult> ServiceValidationResult;
	}
	public class ServiceValidationResult{
		public String MessageCode;
		public String Message;
	}
	public class ExpireSchemeNodeResult{
		public ValidationErrors ValidationErrors;
		public String GroupRestrictionObjectID;
		public String GroupRestrictionClusterID;
		public String EffectiveEndDate;
		public String Tag;
		public String EffectiveStartDate;
		public String SystemErrorMessage;
		public String EntityType;
		public String HasValidationErrors;
		public String ObjectID;
		public String HasSystemError;
		public String HasErrors;
	}
	public class ExpireSchemeNodeResponse{
		public ExpireSchemeNodeResult ExpireSchemeNodeResult;
	}	
}