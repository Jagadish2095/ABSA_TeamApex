public class ROTGetGrpRestriHierForCu_IB_Resp_v1 extends Base_IB {
    
    public GetGroupRestrictionHierarchiesForCustomerResponse GetGroupRestrictionHierarchiesForCustomerResponse;
    
    public class GetGroupRestrictionHierarchiesForCustomerResponse {
		public GetGroupRestrictionHierarchiesForCustomerResult GetGroupRestrictionHierarchiesForCustomerResult;
	}


    public class GroupRestrictionHierarchyModel {
		public Accounts Accounts;
		public String ClusterID;
		public Customers Customers;
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String EntityType;
		public ExcludedAccounts ExcludedAccounts;
		public String IsEffectiveEndDateInfinity;
		public String ObjectID;
		public ParentSchemeNodeID ParentSchemeNodeID;
		public Integer SchemeNodeID;
		public TransactionTypes TransactionTypes;
	}
   
	public class Description {
		public Boolean nil;
	}
    
    public class ParentSchemeNodeID {
		public Boolean nil;
	}
   

	public class AccountModel {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String EntityType;
		public String IsEffectiveEndDateInfinity;
		public Long ObjectID;
		public Integer ParentSchemeNodeID;
		public Integer SchemeNodeID;
	}

	public class Data {
		public List<GroupRestrictionHierarchyModel> GroupRestrictionHierarchyModel;
	}

	public class GetGroupRestrictionHierarchiesForCustomerResult {
		public Data Data;
		public String HasErrors;
		public String HasSystemError;
		public String HasValidationErrors;
		public String Information;
		public SystemErrorMessage SystemErrorMessage;
		public Description Tag;
		public String ValidationErrors;
	}
    public class SystemErrorMessage{
        public Boolean nil;
    }
    
    public class Tag{
        public Boolean nil;
    }
	
	public class TransactionTypeModel {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String EntityType;
		public String IsEffectiveEndDateInfinity;
		public String ObjectID;
		public Integer ParentSchemeNodeID;
		public Integer SchemeNodeID;
	}
  

	public class Accounts {
		public List<AccountModel> AccountModel;
	}

	public class CustomerModel {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String EntityType;
		public String IsEffectiveEndDateInfinity;
		public String ObjectID;
		public Integer ParentSchemeNodeID;
		public Integer SchemeNodeID;
	}

	public class Customers {
		public List<CustomerModel> CustomerModel;
	}

	public class ExcludedAccounts {
		public List<ExcludedAccountModel> ExcludedAccountModel;
	}
    
    public class ExcludedAccountModel {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String EntityType;
		public String IsEffectiveEndDateInfinity;
		public Long ObjectID;
		public Integer ParentSchemeNodeID;
		public Integer SchemeNodeID;
	}
    

	public class TransactionTypes {
		public List<TransactionTypeModel> TransactionTypeModel;
	}
   


}