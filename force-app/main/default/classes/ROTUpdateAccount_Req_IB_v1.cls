public class ROTUpdateAccount_Req_IB_v1 extends Base_IB {
    
    public UpdateAccount UpdateAccount;
	
    public class UpdateAccount{
		public String user;
		public account account;
	}
	public class account{
        public String Description;
        public String EffectiveStartDate;
        public String EffectiveEndDate;
		public String IsEffectiveEndDateInfinity;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String AccountNumber;
		public String OriginalEffectiveStartDate;	
	}
    
    public static ROTUpdateAccount_Req_IB_v1 createDummyRequest(){
        ROTUpdateAccount_Req_IB_v1 requestBean = new ROTUpdateAccount_Req_IB_v1(); 
        requestBean.UpdateAccount = new ROTUpdateAccount_Req_IB_v1.UpdateAccount();
        requestBean.UpdateAccount.account = new ROTUpdateAccount_Req_IB_v1.Account();
        requestBean.UpdateAccount.account.Description = 'JB Pillar';
        requestBean.UpdateAccount.account.EffectiveEndDate = '2021-02-06T00:00:00';
        requestBean.UpdateAccount.account.EffectiveStartDate = '2021-01-10T00:00:00';
        requestBean.UpdateAccount.account.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateAccount.account.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.UpdateAccount.account.IsEffectiveEndDateInfinity = 'true';
        requestBean.UpdateAccount.account.AccountNumber = '4048430986';
        requestBean.UpdateAccount.account.OriginalEffectiveStartDate = '2021-01-10T00:00:00';
        requestBean.UpdateAccount.user = '?';
        return requestBean;  
    }  
}