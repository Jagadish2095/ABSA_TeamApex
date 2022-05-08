/**
* Descripton: Wrapper class for DeleteTransactionType Service Request.
* Class Name: ROTDeleteTransactionType_Req_IB_v1
* @author   : Manish
**/
public class ROTDeleteTransactionType_Req_IB_v1 extends Base_IB {
    
    public DeleteTransactionType DeleteTransactionType;
    
    public class DeleteTransactionType{
        public Account account;
        public String user;
    }
    public class Account{
        public String Code;
        public String GroupRestrictionClusterID;
        public String GroupRestrictionObjectID;
        public String EffectiveStartDate;
    }
    
    public static ROTDeleteTransactionType_Req_IB_v1 createDummyRequest(){
        ROTDeleteTransactionType_Req_IB_v1 requestBean = new ROTDeleteTransactionType_Req_IB_v1();
        requestBean.DeleteTransactionType =  new ROTDeleteTransactionType_Req_IB_v1.DeleteTransactionType();
        requestBean.DeleteTransactionType.account = new ROTDeleteTransactionType_Req_IB_v1.Account();
        requestBean.DeleteTransactionType.account.Code = 'FN71 FIA';
        requestBean.DeleteTransactionType.account.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteTransactionType.account.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.DeleteTransactionType.account.EffectiveStartDate = '2021-02-10T00:00:00';
        requestBean.DeleteTransactionType.user = '?';
        return requestBean;
        
    }

}