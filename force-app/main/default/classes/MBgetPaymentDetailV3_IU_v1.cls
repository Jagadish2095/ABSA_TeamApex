/**
 * @description Integration Utility class for MBgetPaymentDetailV3 Service
 * @author Chandra Bhushan
 * @created 2021-03-20

 * @updated 2021-04-09
 */

public class MBgetPaymentDetailV3_IU_v1 {

    /**
     * @description Creates a request bean
     * @param uniqueEft - String Identifier to get the payment details for
     * @return MBgetPaymentDetailV3_Req_IB_v1 bean object
     */
    public static MBgetPaymentDetailV3_Req_IB_v1 mapRequestFields(String  uniqueEft) {
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
        requestBean.MBgetPaymentDetailV3.Mbp323i.inFunction = Label.InfunctionValue;
        requestBean.MBgetPaymentDetailV3.Mbp323i.maxRetrieve = '99';
        requestBean.MBgetPaymentDetailV3.Mbp323i.processInd = '';
        requestBean.MBgetPaymentDetailV3.Mbp323i.instrType = 'VP';
        requestBean.MBgetPaymentDetailV3.Mbp323i.uniqueEft = uniqueEft;
        requestBean.MBgetPaymentDetailV3.Mbp323i.paymNo = '0';
        requestBean.MBgetPaymentDetailV3.Mbp323i.paymIipInd = '';

        return requestBean;
    }
}