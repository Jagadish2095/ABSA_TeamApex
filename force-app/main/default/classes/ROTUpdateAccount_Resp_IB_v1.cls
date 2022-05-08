public class ROTUpdateAccount_Resp_IB_v1 extends Base_IB {
    //constructor
    public ROTUpdateAccount_Resp_IB_v1(){}
    public UpdateAccountResponse UpdateAccountResponse;
    public class ValidationErrors{
        public list<ServiceValidationResult> ServiceValidationResult;
    }
    public class UpdateAccountResult{
        public ValidationErrors ValidationErrors;
        public String GroupRestrictionClusterID;
        public String GroupRestrictionObjectID;
        public String Tag;
        public Result Result;
        public String SystemErrorMessage;
        public String AccountNumber;
        public String HasValidationErrors;
        public String EffectiveStartDate;
        public String HasSystemError;
        public String HasErrors;
    }
    public class UpdateAccountResponse{
        public UpdateAccountResult UpdateAccountResult;
    }
    public class ServiceValidationResult{
        public String MessageCode;
        public String Message;
    }
    public class Result{
        public String EffectiveEndDate;
        public String EntityType;
        public String ObjectID;
        public String ParentSchemeNodeID;
        public String IsEffectiveEndDateInfinity;
        public String SchemeNodeID;
        public String EffectiveStartDate;
        public String Description;
    }
}