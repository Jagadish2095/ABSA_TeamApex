/**
* Descripton: Wrapper class for UpdateCustomer Service Response.
* Class Name: ROTUpdateCustomer_Resp_IB_v1
* @author  	: Manish
**/
public class ROTUpdateCustomer_Resp_IB_v1 extends Base_IB{
    
    public UpdateCustomerResponse UpdateCustomerResponse;
    public class UpdateCustomerResult{
        public String Tag;
        public String SystemErrorMessage;
        public String GroupRestrictionClusterID;
        public Information Information;
        public String GroupRestrictionObjectID;
        public Result Result;
        public String CustomerKey;
        public String HasValidationErrors;
        public String EffectiveStartDate;
        public String HasSystemError;
        public String HasErrors;
        public ValidationErrors ValidationErrors;
    }
    public class UpdateCustomerResponse{
        public UpdateCustomerResult UpdateCustomerResult;
    }
    public class ServiceInformationResult{
        public String MessageCode;
        public String Message;
    }
    public class ServiceValidationResult{
        public String MessageCode;
        public String Message;
    }
    public class Result{
        public String EffectiveEndDate;
        public String ObjectID;
        public String EntityType;
        public String IsEffectiveEndDateInfinity;
        public String ParentSchemeNodeID;
        public String EffectiveStartDate;
        public String SchemeNodeID;
        public String Description;
    }
    public class Information{
        public list<ServiceInformationResult> ServiceInformationResult;
    }
    public class ValidationErrors{
        public list<ServiceValidationResult> ServiceValidationResult;
    }
    
    
	
    
}