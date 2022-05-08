public class ROTUpdateTransactionType_Req_IB_v1 extends Base_IB{
    
    public UpdateTransactionType UpdateTransactionType;
    
    public class UpdateTransactionType {
        public account account;
        public String user;
    }

    public class account {
        public String Description;
        public String EffectiveEndDate;
        public String EffectiveStartDate;
        public String GroupRestrictionClusterID;
        public String GroupRestrictionObjectID;
        public String IsEffectiveEndDateInfinity;
        public String Code;
        public String OriginalEffectiveStartDate;
    }
    
    public static ROTUpdateTransactionType_Req_IB_v1 createDummyRequest(){
        ROTUpdateTransactionType_Req_IB_v1 requestBean = new ROTUpdateTransactionType_Req_IB_v1(); 
        requestBean.UpdateTransactionType = new ROTUpdateTransactionType_Req_IB_v1.UpdateTransactionType();
        requestBean.UpdateTransactionType.account = new ROTUpdateTransactionType_Req_IB_v1.account();
        requestBean.UpdateTransactionType.account.Description = '4047738913';
        requestBean.UpdateTransactionType.account.EffectiveEndDate = '2021-02-06T00:00:00';
        requestBean.UpdateTransactionType.account.EffectiveStartDate = '2021-01-07T00:00:00';
        requestBean.UpdateTransactionType.account.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateTransactionType.account.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.UpdateTransactionType.account.IsEffectiveEndDateInfinity = 'true';
        requestBean.UpdateTransactionType.account.Code = 'FN71 FIA';
        requestBean.UpdateTransactionType.account.OriginalEffectiveStartDate = '2021-01-07T00:00:00';
        requestBean.UpdateTransactionType.user ='TEST';
        return requestBean;
    }
    

}