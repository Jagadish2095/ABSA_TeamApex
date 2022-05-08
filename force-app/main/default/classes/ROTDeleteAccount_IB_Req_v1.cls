public class ROTDeleteAccount_IB_Req_v1 extends Base_IB{
    
    public class Account {
		public String EffectiveStartDate;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String AccountNumber;
	}

	public DeleteAccount DeleteAccount;

	public class DeleteAccount {
		public Account account;
		public String user;
	}
    
    public static ROTDeleteAccount_IB_Req_v1 createDummyRequest(){
        ROTDeleteAccount_IB_Req_v1 requestBean = new ROTDeleteAccount_IB_Req_v1();
        requestBean.DeleteAccount = new ROTDeleteAccount_IB_Req_v1.DeleteAccount();
        requestBean.DeleteAccount.account = new ROTDeleteAccount_IB_Req_v1.Account();
        requestBean.DeleteAccount.account.EffectiveStartDate = '2021-01-10T00:00:00';
        requestBean.DeleteAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteAccount.account.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.DeleteAccount.account.AccountNumber = '4048430986';
        requestBean.DeleteAccount.user = 'SALESFORCE';
        return requestBean;
    }

}