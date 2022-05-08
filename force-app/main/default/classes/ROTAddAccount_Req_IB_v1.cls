public class ROTAddAccount_Req_IB_v1 extends Base_IB {
	

	public class AddAccount {
		public Account account;
		public String user;
	}

	public AddAccount AddAccount;

	public class Account {
		public String Description;
		public String EffectiveEndDate;
		public String EffectiveStartDate;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String IsEffectiveEndDateInfinity;
		public String AccountNumber;
	}

	
    
    public static ROTAddAccount_Req_IB_v1 createDummyRequest(){
        ROTAddAccount_Req_IB_v1 requestBean = new ROTAddAccount_Req_IB_v1();
        requestBean.AddAccount = new ROTAddAccount_Req_IB_v1.AddAccount();
        requestBean.AddAccount.account = new ROTAddAccount_Req_IB_v1.Account();
        requestBean.AddAccount.account.Description = 'JB Pillar';
        requestBean.AddAccount.account.EffectiveEndDate = '2021-02-06T00:00:00';
        requestBean.AddAccount.account.EffectiveStartDate = '2021-01-16T00:00:00';
        requestBean.AddAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.AddAccount.account.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.AddAccount.account.IsEffectiveEndDateInfinity = 'true';
        requestBean.AddAccount.account.AccountNumber = '4048017641';
        requestBean.AddAccount.user = 'SALESFORCE';
        
        return requestBean;
        
    }
}