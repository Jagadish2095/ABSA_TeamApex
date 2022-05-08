public class ROTDeleteTransactionType_Resp_IB_v1 extends Base_IB {
    //constructor
    public ROTDeleteTransactionType_Resp_IB_v1(){}
   public DeleteTransactionTypeResponse DeleteTransactionTypeResponse;
    public class Tag{
        public Boolean nil;
    }
    public class SystemErrorMessage{
        public Boolean nil;
    }
    public class Result{
        public Boolean nil;
    }
    public class DeleteTransactionTypeResult{
        public String ValidationErrors;
        public String Code;
        public String Tag;
        public String EffectiveStartDate;
        public String SystemErrorMessage;
        public String GroupRestrictionClusterID;
        public String Information;
        public String GroupRestrictionObjectID;
        public String HasValidationErrors;
        public Result Result;
        public String HasSystemError;
        public String HasErrors;
    }
    public class DeleteTransactionTypeResponse{
        public DeleteTransactionTypeResult DeleteTransactionTypeResult;
    }
}