public class ROTDeleteCustomer_Resp_IB_v1 extends Base_IB {
    
    	public DeleteCustomerResponse DeleteCustomerResponse;
   
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
	public class DeleteCustomerResult{
		public String GroupRestrictionObjectID;
		public String GroupRestrictionClusterID;
		public String Tag;
		public Result Result;
		public String SystemErrorMessage;
		public String CustomerKey;
		public String HasValidationErrors;
		public String EffectiveStartDate;
		public String HasSystemError;
		public String HasErrors;
	}
	public class DeleteCustomerResponse{
		public DeleteCustomerResult DeleteCustomerResult;
	}
  
}