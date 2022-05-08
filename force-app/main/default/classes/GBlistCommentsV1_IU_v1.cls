public class GBlistCommentsV1_IU_v1 {
  
public static GBlistCommentsV1_Req_IB_v1 mapRequestFields(string dateFrom, string clientCode, string inputBranch) {

    GBlistCommentsV1_Req_IB_v1 requestBean= new GBlistCommentsV1_Req_IB_v1();
    requestBean.GBlistCommentsV1= new GBlistCommentsV1_Req_IB_v1.GBlistCommentsV1();
    requestBean.GBlistCommentsV1.nbsapdpi= new GBlistCommentsV1_Req_IB_v1.nbsapdpi();
    requestBean.GBlistCommentsV1.gsp007i = new GBlistCommentsV1_Req_IB_v1.gsp007i();
    requestBean.GBlistCommentsV1.nbsmsgi = new GBlistCommentsV1_Req_IB_v1.nbsmsgi();
    requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId= new GBlistCommentsV1_Req_IB_v1.finalMsgId();
    requestBean.GBlistCommentsV1.nbsapdpi.application='SF';
    requestBean.GBlistCommentsV1.nbsapdpi.channel='SF';
    requestBean.GBlistCommentsV1.nbsapdpi.trace='Y';
    requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId.finalMsgClass='';
    requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId.finalMsgCode='';
    requestBean.GBlistCommentsV1.nbsmsgi.msgLanguage='E';
    requestBean.GBlistCommentsV1.nbsmsgi.msgTarget='STD';
    requestBean.GBlistCommentsV1.gsp007i.clientCode=clientCode;
    requestBean.GBlistCommentsV1.gsp007i.dateFrom= dateFrom;
    requestBean.GBlistCommentsV1.gsp007i.inputBranch=inputBranch;
    requestBean.GBlistCommentsV1.gsp007i.option='E';
    requestBean.GBlistCommentsV1.gsp007i.type='FAL';

    return requestBean;
}
}