/**
 * @description       : Client detail by Id Request Bean
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-31
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class GetClientDetailsByIdCIF_Req_IB_v2 extends Base_IB {
    /**
     * @description       : CIgetClientDetailsByIDNOV2
     **/
    public CIgetClientDetailsByIDNOV2 CIgetClientDetailsByIDNOV2 { get; set; }

    /**
     * @description       : CIgetClientDetailsByIDNOV2
     **/
    public class CIgetClientDetailsByIDNOV2 {
        public Nbsapdpi nbsapdpi;
        public Nbsmsgi nbsmsgi;
        public Cip008i cip008i;
    }

    /**
     * @description       : Nbsapdpi
     **/
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }

    /**
     * @description       : Nbsmsgi
     **/
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }

    /**
     * @description       : Cip008i
     **/
    public class Cip008i {
        public String idNbr;
        public String inpIdDocType;
        public String inpCifClntGroup;
        public String inpCifClntType;
        public String maxRecsToRtrv;
        public String startAfterSearchPos;
        public String siteCode;
    }

    /**
     * @description       : FinalMsgId
     **/
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }

    /**
     * @description getNewInstance
     * @author PaulJohn.duRand@absa.africa | 2021-08-31
     * @return GetClientDetailsByIdCIF_Req_IB_v2.CIgetClientDetailsByIDNOV2
     **/
    public GetClientDetailsByIdCIF_Req_IB_v2.CIgetClientDetailsByIDNOV2 getNewInstance() {
        GetClientDetailsByIdCIF_Req_IB_v2 requestBean = new GetClientDetailsByIdCIF_Req_IB_v2();
        requestBean.CIgetClientDetailsByIDNOV2 = new GetClientDetailsByIdCIF_Req_IB_v2.CIgetClientDetailsByIDNOV2();
        requestBean.CIgetClientDetailsByIDNOV2.nbsapdpi = new GetClientDetailsByIdCIF_Req_IB_v2.Nbsapdpi();
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi = new GetClientDetailsByIdCIF_Req_IB_v2.Nbsmsgi();
        requestBean.CIgetClientDetailsByIDNOV2.cip008i = new GetClientDetailsByIdCIF_Req_IB_v2.Cip008i();
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi.finalMsgId = new GetClientDetailsByIdCIF_Req_IB_v2.FinalMsgId();
        requestBean.CIgetClientDetailsByIDNOV2.nbsapdpi.trace = 'N';
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi.msgTarget = 'STD';
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIgetClientDetailsByIDNOV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        return requestBean.CIgetClientDetailsByIDNOV2;
    }
}