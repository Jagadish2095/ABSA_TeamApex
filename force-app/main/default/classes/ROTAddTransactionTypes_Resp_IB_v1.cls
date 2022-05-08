public class ROTAddTransactionTypes_Resp_IB_v1 extends Base_IB{
    //constructor
    public ROTAddTransactionTypes_Resp_IB_v1(){}
    public AddTransactionTypesResponse AddTransactionTypesResponse;
    public class ValidationErrors{
        public list<ServiceValidationResult> ServiceValidationResult;
    }
    public class TransactionTypeActionDataResponse{
        public ValidationErrors ValidationErrors;
        public String GroupRestrictionClusterID;
        public String Tag;
        public String GroupRestrictionObjectID;
        public String SystemErrorMessage;
        public Result Result;
        public String HasValidationErrors;
        public String Code;
        public String HasSystemError;
        public String EffectiveStartDate;
        public String HasErrors;
    }
    public class ServiceValidationResult{
        public String MessageCode;
        public String Message;
    }
    public class Result{
        public String EffectiveEndDate;
        public String ParentSchemeNodeID;
        public String EntityType;
        public String SchemeNodeID;
        public String ObjectID;
        public String IsEffectiveEndDateInfinity;
        public String EffectiveStartDate;
        public String Description;
    }
    public class AddTransactionTypesResult{
        public list<TransactionTypeActionDataResponse> TransactionTypeActionDataResponse;
    }
    public class AddTransactionTypesResponse{
        public AddTransactionTypesResult AddTransactionTypesResult;
    }
    
    /*public AddTransactionTypesResponse AddTransactionTypesResponse;
    public class ValidationErrors{
        public list<ServiceValidationResult> ServiceValidationResult;
    }
    public class TransactionTypeActionDataResponse{
        public ValidationErrors ValidationErrors;
        public String GroupRestrictionClusterID;
        public String Tag;
        public String GroupRestrictionObjectID;
        public String SystemErrorMessage;
        public Result Result;
        public String HasValidationErrors;
        public String Code;
        public String HasSystemError;
        public String EffectiveStartDate;
        public String HasErrors;
    }
    public class ServiceValidationResult{
        public String MessageCode;
        public String Message;
    }
    public class Result{
        public String EffectiveEndDate;
        public String ParentSchemeNodeID;
        public String EntityType;
        public String SchemeNodeID;
        public String ObjectID;
        public String IsEffectiveEndDateInfinity;
        public String EffectiveStartDate;
        public String Description;
    }
    public class AddTransactionTypesResult{
        public TransactionTypeActionDataResponse TransactionTypeActionDataResponse;
    }
    public class AddTransactionTypesResponse{
        public AddTransactionTypesResult AddTransactionTypesResult;
    }*/
    
}