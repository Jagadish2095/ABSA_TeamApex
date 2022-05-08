/*
* Integration Response Bean for CQGetPaymentDue Service
* @author Haritha Police
* @created 2019-09-14
*/

public class CQgetPaymentDue_Resp_IB_V1 extends Base_IB {
    @auraenabled public String status;
    @auraenabled public Integer statusCode;
    @auraenabled public String message;
    
    public class Nbsapdpo {
        @auraenabled	public String version;
        @auraenabled public String returnCode;
        @auraenabled public String reasonCode;
        @auraenabled public String serviceVersion;
        @auraenabled public String echoKey;
    }
    
    @auraenabled public CQgetPaymentDueV1Response CQgetPaymentDueV1Response;
    
    public class Nbsmsgo3 {
        @auraenabled public String version;
        @auraenabled public String sysErrTxt;
        @auraenabled public String nbrUserMsgs;
        @auraenabled public String nbrUserErrs;
    }
    
    public class CQgetPaymentDueV1Response {
        @auraenabled public Nbsapdpo nbsapdpo;
        @auraenabled public Nbsmsgo3 nbsmsgo3;
        @auraenabled public Cqh844o cqh844o;
    }
    
    public class Cqh844o {
        @auraenabled public String accountName;
        @auraenabled public String accountNbr;
        @auraenabled public String dateLastPayment;
        @auraenabled public String amountDue;
        @auraenabled public String arrearsAmount;
    }
    
    public static CQgetPaymentDue_Resp_IB_V1 dummyResponse(){
        CQgetPaymentDue_Resp_IB_V1 responseBean = new CQgetPaymentDue_Resp_IB_V1();
        responseBean.status='Ok';
        responseBean.statusCode=12;
        responseBean.message='Test Message';
        CQgetPaymentDue_Resp_IB_V1.CQgetPaymentDueV1Response cqRes = new CQgetPaymentDue_Resp_IB_V1.CQgetPaymentDueV1Response();
        CQgetPaymentDue_Resp_IB_V1.Cqh844o cq844 = new CQgetPaymentDue_Resp_IB_V1.Cqh844o();
        cq844.accountName='Test';
        cq844.accountNbr='1234';
        cq844.amountDue='1234';
        cq844.arrearsAmount='321';
        cq844.dateLastPayment='1234';
            return responseBean;
    }
    
}