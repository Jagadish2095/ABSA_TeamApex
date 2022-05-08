/*
 * Request Integration Bean for MLgetPayoffDetailsV1 Service
 * @author Jason Quevauvilliers
 * @created 2020-10-20
 */
public class MLgetPayoffDetailsV1_Req_IB_v1 extends Base_IB{

    public MLgetPayoffDetailsV1 MLgetPayoffDetailsV1;

    public class MLgetPayoffDetailsV1{
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Mlp778i mlp778i;
    }

    public class Nbsapdpi{
        public String channel;
        public String application;
        public String trace;
    }

    public class Nbsmsgi{
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }

    public class Mlp778i{
        public String origin;
        public String corpCode;
        public String branchCode;
        public String tellerCode;
        public String mortgageLoanNo;
        public String payAllAcc;
        public String effectiveDate;
        public String includeCommit;
    }

    public class FinalMsgId{

    }

    public static MLgetPayoffDetailsV1_Req_IB_v1 createDummyRequest() {

        MLgetPayoffDetailsV1_Req_IB_v1 requestBean = new MLgetPayoffDetailsV1_Req_IB_v1();
        requestBean.mLgetPayoffDetailsV1 = new MLgetPayoffDetailsV1_Req_IB_v1.MLgetPayoffDetailsV1();
        requestBean.mLgetPayoffDetailsV1.nbsapdpi = new MLgetPayoffDetailsV1_Req_IB_v1.Nbsapdpi();
        requestBean.mLgetPayoffDetailsV1.nbsmsgi = new MLgetPayoffDetailsV1_Req_IB_v1.Nbsmsgi();
        requestBean.mLgetPayoffDetailsV1.mlp778i = new MLgetPayoffDetailsV1_Req_IB_v1.Mlp778i();

        requestBean.mLgetPayoffDetailsV1.nbsapdpi.channel = 'BDP';
        requestBean.mLgetPayoffDetailsV1.nbsapdpi.application = 'BDP';
        requestBean.mLgetPayoffDetailsV1.nbsapdpi.trace = 'Y';

        requestBean.mLgetPayoffDetailsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.mLgetPayoffDetailsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.mLgetPayoffDetailsV1.nbsmsgi.finalMsgId = new MLgetPayoffDetailsV1_Req_IB_v1.FinalMsgId();

        requestBean.mLgetPayoffDetailsV1.mlp778i.origin = 'B';
        requestBean.mLgetPayoffDetailsV1.mlp778i.corpCode = 'ABS';
        requestBean.mLgetPayoffDetailsV1.mlp778i.branchCode = '8091';
        requestBean.mLgetPayoffDetailsV1.mlp778i.tellerCode = '999999';
        requestBean.mLgetPayoffDetailsV1.mlp778i.mortgageLoanNo = '8050374990';
        requestBean.mLgetPayoffDetailsV1.mlp778i.payAllAcc = 'Y';
        requestBean.mLgetPayoffDetailsV1.mlp778i.effectiveDate = '20201020';
        requestBean.mLgetPayoffDetailsV1.mlp778i.includeCommit = 'N';

        return requestBean;
    }

}