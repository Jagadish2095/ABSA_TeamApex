public class ROTDeleteGroupRestriction_IB_Resp_v1 extends Base_IB {
    
    public DeleteGroupRestrictionResponse DeleteGroupRestrictionResponse;
	public class ValidationErrors{
		public List<ServiceValidationResult> ServiceValidationResult;
	}
	
	public class ServiceValidationResult{
		public String MessageCode;
		public String Message;
		
    }
	public class Result{
		public String Description;
        public String EffectiveEndDate;
        public String EffectiveStartDate;
        public String IsEffectiveEndDateInfinity;
        public String ObjectID;
        public String EntityType;
        public String ParentSchemeNodeID;
        public String SchemeNodeID;
        
	}
	
	public class DeleteGroupRestrictionResult{
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
	public class DeleteGroupRestrictionResponse{
		public DeleteGroupRestrictionResult DeleteGroupRestrictionResult;
	} 
    public ROTDeleteGroupRestriction_IB_Resp_v1(){
        
    } 
}