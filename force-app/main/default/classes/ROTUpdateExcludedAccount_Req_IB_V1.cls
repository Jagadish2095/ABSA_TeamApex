public class ROTUpdateExcludedAccount_Req_IB_V1 extends Base_IB{

    public UpdateExcludedAccount UpdateExcludedAccount;
    
	public class UpdateExcludedAccount{
		public String user;
		public excludedAccount excludedAccount;
	}
	public class excludedAccount{
		public String IsEffectiveEndDateInfinity;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String EffectiveStartDate;
		public String AccountNumber;
		public String EffectiveEndDate;
		public String OriginalEffectiveStartDate;
		public String Description;
	}
    
    public static ROTUpdateExcludedAccount_Req_IB_V1 createDummyRequest(){
        ROTUpdateExcludedAccount_Req_IB_V1 requestBean = new ROTUpdateExcludedAccount_Req_IB_V1();
        requestBean.UpdateExcludedAccount = new ROTUpdateExcludedAccount_Req_IB_V1.UpdateExcludedAccount();
        requestBean.UpdateExcludedAccount.excludedAccount = new ROTUpdateExcludedAccount_Req_IB_V1.excludedAccount();
        requestBean.UpdateExcludedAccount.excludedAccount.AccountNumber = '4048017641';
        requestBean.UpdateExcludedAccount.excludedAccount.Description = 'JB Pillar';
        requestBean.UpdateExcludedAccount.excludedAccount.EffectiveEndDate = '2021-02-06T00:00:00';
        requestBean.UpdateExcludedAccount.excludedAccount.EffectiveStartDate = '2021-01-20T00:00:00';
        requestBean.UpdateExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateExcludedAccount.excludedAccount.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.UpdateExcludedAccount.excludedAccount.IsEffectiveEndDateInfinity = 'true';
        requestBean.UpdateExcludedAccount.excludedAccount.OriginalEffectiveStartDate = '2021-01-20T00:00:00';
        requestBean.UpdateExcludedAccount.user = 'SALESFORCE';
        return requestBean;
    }
}