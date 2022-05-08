public class ROTAddCustomer_Resp_IB_v1 extends Base_IB {
    
    public AddCustomerResponse AddCustomerResponse;
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
        public String EffectiveStartDate;
        public String ObjectID;
        public String Description;
        public String EntityType;
        public String SchemeNodeID;
        public String ParentSchemeNodeID;
    }
    public class AddCustomerResult{
        public String GroupRestrictionObjectID;
        public ValidationErrors ValidationErrors;
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
    public class AddCustomerResponse{
        public AddCustomerResult AddCustomerResult;
    }
    
    
}