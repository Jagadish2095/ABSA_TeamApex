/**
* @description Request Integration Bean for MBgetPaymentDetailV3 Service
* @author Chandra Bhushan
* @created 2021-03-20

 * @updated 2021-04-09

*/

public class MBgetPaymentDetailV3_Req_IB_v1 extends Base_IB {
    /**
* @description wrapper class MBgetPaymentDetailV3
*/
    public class MBgetPaymentDetailV3 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Mbp323i mbp323i;
    }

    public MBgetPaymentDetailV3 MBgetPaymentDetailV3;
    /**
* @description wrapper class FinalMsgId
*/
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }
    /**
* @description wrapper class Nbsapdpi
*/
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }
    /**
* @description wrapper class Mbp323i
*/
    public class Mbp323i {
        public String inChannel;
        public String inFunction;
        public String maxRetrieve;
        public String processInd;
        public String instrType;
        public String uniqueEft;
        public String paymNo;
        public String paymIipInd;
    }
    /**
* @description wrapper class Nbsmsgi
*/
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    /**
* @description method used for dummy request
* @return MBgetPaymentDetailV3_Req_IB_v1
*/
    public static MBgetPaymentDetailV3_Req_IB_v1 createDummyRequest() {
        MBgetPaymentDetailV3_Req_IB_v1 requestBean = new MBgetPaymentDetailV3_Req_IB_v1();
        requestBean.MBgetPaymentDetailV3 = new MBgetPaymentDetailV3_Req_IB_v1.MBgetPaymentDetailV3();
        requestBean.MBgetPaymentDetailV3.nbsapdpi = new MBgetPaymentDetailV3_Req_IB_v1.Nbsapdpi();
        requestBean.MBgetPaymentDetailV3.Nbsmsgi = new MBgetPaymentDetailV3_Req_IB_v1.Nbsmsgi();
        requestBean.MBgetPaymentDetailV3.Mbp323i = new MBgetPaymentDetailV3_Req_IB_v1.Mbp323i();
        requestBean.MBgetPaymentDetailV3.Nbsapdpi.channel = 'SALESFOR';
        requestBean.MBgetPaymentDetailV3.Nbsapdpi.application = 'SALESFOR';
        requestBean.MBgetPaymentDetailV3.Nbsapdpi.trace = 'Y';
        requestBean.MBgetPaymentDetailV3.Nbsmsgi.msgLanguage = 'E';
        requestBean.MBgetPaymentDetailV3.Nbsmsgi.msgTarget = 'STD';
        requestBean.MBgetPaymentDetailV3.Nbsmsgi.finalMsgId = new MBgetPaymentDetailV3_Req_IB_v1.FinalMsgId();
        requestBean.MBgetPaymentDetailV3.Nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBgetPaymentDetailV3.Nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.MBgetPaymentDetailV3.Mbp323i.inChannel = 'SALESFOR';
        requestBean.MBgetPaymentDetailV3.Mbp323i.inFunction = '';
        requestBean.MBgetPaymentDetailV3.Mbp323i.maxRetrieve = '99';
        requestBean.MBgetPaymentDetailV3.Mbp323i.processInd = '';
        requestBean.MBgetPaymentDetailV3.Mbp323i.instrType = 'VP';
        requestBean.MBgetPaymentDetailV3.Mbp323i.uniqueEft = '80002D83AB';
        requestBean.MBgetPaymentDetailV3.Mbp323i.paymNo = '0';
        requestBean.MBgetPaymentDetailV3.Mbp323i.paymIipInd = '';

        return requestBean;
    }
}