public class ROTUpdateTransactionType_Resp_IB_v1 extends Base_IB{
    
    public UpdateTransactionTypeResponse UpdateTransactionTypeResponse;
    public class UpdateTransactionTypeResult{
        public String Tag;
        public String SystemErrorMessage;
        public String GroupRestrictionClusterID;
        public Information Information;
        public String GroupRestrictionObjectID;
        public Result Result;
        public String Code;
        public String HasValidationErrors;
        public String EffectiveStartDate;
        public String HasSystemError;
        public String HasErrors;
    }
    public class UpdateTransactionTypeResponse{
        public UpdateTransactionTypeResult UpdateTransactionTypeResult;
    }
    public class ServiceInformationResult{
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
}