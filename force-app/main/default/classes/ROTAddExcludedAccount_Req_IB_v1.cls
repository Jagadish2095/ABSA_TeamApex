public class ROTAddExcludedAccount_Req_IB_v1 extends Base_IB {
    
    public AddExcludedAccount AddExcludedAccount;
    
    public class excludedAccount{
        public String IsEffectiveEndDateInfinity;
        public String GroupRestrictionObjectID;
        public String GroupRestrictionClusterID;
        public String AccountNumber;
        public String EffectiveStartDate;
        public String EffectiveEndDate;
        public String Description;
    }
    public class AddExcludedAccount{
        public excludedAccount excludedAccount;
        public String user;
    }
    
    public static ROTAddExcludedAccount_Req_IB_v1 createDummyRequest(){
        
        ROTAddExcludedAccount_Req_IB_v1 requestBean = new ROTAddExcludedAccount_Req_IB_v1();
        requestBean.AddExcludedAccount = new ROTAddExcludedAccount_Req_IB_v1.AddExcludedAccount();
        requestBean.AddExcludedAccount.excludedAccount = new ROTAddExcludedAccount_Req_IB_v1.excludedAccount();
        requestBean.AddExcludedAccount.excludedAccount.Description = 'JB Pillar';
        requestBean.AddExcludedAccount.excludedAccount.EffectiveEndDate = '2021-06-29T00:00:00';
        requestBean.AddExcludedAccount.excludedAccount.EffectiveStartDate = '2021-06-22T00:00:00';
        requestBean.AddExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.AddExcludedAccount.excludedAccount.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.AddExcludedAccount.excludedAccount.IsEffectiveEndDateInfinity = 'true';
        requestBean.AddExcludedAccount.excludedAccount.AccountNumber = '4048017641';
        requestBean.AddExcludedAccount.user = 'SALESFORCE';
        
        return requestBean;
        
    }
}