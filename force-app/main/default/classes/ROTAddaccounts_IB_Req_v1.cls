public class ROTAddaccounts_IB_Req_v1 extends Base_IB {
    
    public class AddAccounts {
		public Accounts accounts;
		public String user;
	}

	public AddAccounts AddAccounts;

	public class AddAccountModel {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String IsEffectiveEndDateInfinity;
		public String AccountNumber;
	}

	public class Accounts {
		public List<AddAccountModel> AddAccountModel;
	}
	public static ROTAddaccounts_IB_Req_v1 createDummyRequest(){
           ROTAddaccounts_IB_Req_v1 requestBean = new ROTAddaccounts_IB_Req_v1();
           requestBean.AddAccounts = new ROTAddaccounts_IB_Req_v1.AddAccounts();
           requestBean.AddAccounts.accounts = new ROTAddaccounts_IB_Req_v1.Accounts();
           requestBean.AddAccounts.accounts.AddAccountModel = new List<ROTAddaccounts_IB_Req_v1.AddAccountModel>();
           ROTAddaccounts_IB_Req_v1.AddAccountModel addAccountsModel = new ROTAddaccounts_IB_Req_v1.AddAccountModel();
           addAccountsModel.Description = 'JB Pillar';
           addAccountsModel.EffectiveEndDate = '2021-02-06T00:00:00';
           addAccountsModel.EffectiveStartDate = '2021-01-10T00:00:00';
           addAccountsModel.GroupRestrictionClusterID = 'ABS';
           addAccountsModel.GroupRestrictionObjectID = 'CQGR0002-JUAT';
           addAccountsModel.IsEffectiveEndDateInfinity = 'true';
           addAccountsModel.AccountNumber = '4047738913';
           requestBean.AddAccounts.accounts.AddAccountModel.add(addAccountsModel);
           requestBean.AddAccounts.user = 'SALESFORCE';
           return requestBean;
    }
}