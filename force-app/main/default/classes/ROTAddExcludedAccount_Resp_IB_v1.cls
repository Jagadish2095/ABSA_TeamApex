public class ROTAddExcludedAccount_Resp_IB_v1 extends Base_IB {
    public ROTAddExcludedAccount_Resp_IB_v1(){}
    public AddExcludedAccountResponse AddExcludedAccountResponse;
    public class ValidationErrors{
        public List<ServiceValidationResult> ServiceValidationResult;
    }
    public class Tag{
        public Boolean nil;
    }
    public class SystemErrorMessage{
        public Boolean nil;
    }
    public class ServiceValidationResult{
        public String MessageCode;
        public String Message;
        //public MemberNames MemberNames;
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
    public class MemberNames{
        public Boolean nil;
    }
    public class Information{
		public list<ServiceValidationResult> ServiceInformationResult;
	}
    public class AddExcludedAccountResult{
        public ValidationErrors ValidationErrors;
        public String AccountNumber;
        public String Tag;
        public String EffectiveStartDate;
        public SystemErrorMessage SystemErrorMessage;
        public String GroupRestrictionClusterID;
        //public String Information;
        public String GroupRestrictionObjectID;
        public Information Information;
        public String HasValidationErrors;
        public Result Result;
        public String HasSystemError;
        public String HasErrors;
    }
    public class AddExcludedAccountResponse{
        public AddExcludedAccountResult AddExcludedAccountResult;
    }
    
}