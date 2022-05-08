public class ROTGetGovernanceModel_Resp_IB_v1 extends Base_IB{
    //constructor
    public ROTGetGovernanceModel_Resp_IB_v1(){}
    
    public GetGovernanceModelResponse GetGovernanceModelResponse;
    public class TransactionTypes{
        public list<GovernanceModelTransactionType> GovernanceModelTransactionType;
    }
    public class GovernanceModelTransactionType{
        public String Description;
        public String IsEffectiveEndDateInfinity;
        public String EffectiveStartDate;
        public String ObjectID;
        public String EffectiveEndDate;
    }
    public class GovernanceModelTransactionGroup{
        public String ObjectID;
        public String EffectiveEndDate;
        public String EffectiveStartDate;
        public String Description;
        public String IsEffectiveEndDateInfinity;
        public TransactionTypes TransactionTypes;
    }
    public class GetGovernanceModelResult{
        public String Tag;
        public String SystemErrorMessage;
        public String HasValidationErrors;
        public Data Data;
        public String HasSystemError;
        public String HasErrors;
    }
    public class GetGovernanceModelResponse{
        public GetGovernanceModelResult GetGovernanceModelResult;
    }
    public class Data{
        public list<GovernanceModelTransactionGroup> GovernanceModelTransactionGroup;
    }
    
/*public GetGovernanceModelResponse GetGovernanceModelResponse;
    public class TransactionTypes{
        public list<GovernanceModelTransactionType> GovernanceModelTransactionType;
    }
    public class Tag{
        public Boolean nil;
    }
    public class SystemErrorMessage{
        public Boolean nil;
    }
    public Class Description{
        public Boolean nil;
    }
    public class GovernanceModelTransactionType{
        public String EffectiveStartDate;
        //public Description Description;
        public String Description;
        public Boolean IsEffectiveEndDateInfinity;
        public String ObjectID;
        public String EffectiveEndDate;
    }
    public class GovernanceModelTransactionGroup{
        public String ObjectID;
        public String EffectiveStartDate;
        public Boolean IsEffectiveEndDateInfinity;
        public String EffectiveEndDate;
        public TransactionTypes TransactionTypes;
        public String Description;
    }
    public class GetGovernanceModelResult{
        public Data Data;
        public SystemErrorMessage SystemErrorMessage;
        public String Information;
        public Tag Tag;
        public Boolean HasValidationErrors;
        public String ValidationErrors;
        public Boolean HasSystemError;
        public Boolean HasErrors;
    }
    public class GetGovernanceModelResponse{
        public GetGovernanceModelResult GetGovernanceModelResult;
    }
    public class Data{
        public list<GovernanceModelTransactionGroup> GovernanceModelTransactionGroup;
    }*/
}