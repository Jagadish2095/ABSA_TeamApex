public class ROTDeleteExcludedAccount_Req_IB_v1 extends Base_IB  {
    public DeleteExcludedAccount DeleteExcludedAccount;
    public class excludedAccount{
        public String AccountNumber;
        public String GroupRestrictionObjectID;
        public String GroupRestrictionClusterID;
        public String EffectiveStartDate;
    }
    public class DeleteExcludedAccount{
        public excludedAccount excludedAccount;
        public String user;
    }
    
    
    public static ROTDeleteExcludedAccount_Req_IB_v1 createDummyRequest(){
        ROTDeleteExcludedAccount_Req_IB_v1 requestBean = new ROTDeleteExcludedAccount_Req_IB_v1(); 
        requestBean.DeleteExcludedAccount = new ROTDeleteExcludedAccount_Req_IB_v1.DeleteExcludedAccount();
        requestBean.DeleteExcludedAccount.excludedAccount = new ROTDeleteExcludedAccount_Req_IB_v1.excludedAccount();
        requestBean.DeleteExcludedAccount.excludedAccount.AccountNumber ='4048430986'; 
        requestBean.DeleteExcludedAccount.excludedAccount.GroupRestrictionObjectID = 'CQGR0002-JUAT'; 
        requestBean.DeleteExcludedAccount.excludedAccount.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteExcludedAccount.excludedAccount.EffectiveStartDate = '2021-01-08T00:00:00';
         requestBean.DeleteExcludedAccount.user = '?';
       
        return requestBean;
    }
    
}