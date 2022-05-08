public class CQgetChargesDetailsMaintV9_Req_IB_v1 {
    
    //Techmagic
    public NBSAPDPI NBSAPDPI;
    public NBSMSGI NBSMSGI;
    public CQS445I CQS445I;

    //first level
    public class NBSAPDPI {
        public NBSAPLI NBSAPLI;
    }

    public class NBSMSGI {
        public NBSMSGI_internal NBSMSGI;
    }

    public class CQS445I {
        public CQS445I_INPUT_AREA CQS445I_INPUT_AREA;
    }
    //first level end

    public class NBSAPLI {
        public String channelName;
        public String applicationName;
        public String traceIndicator;
    }

    public class NBSMSGI_internal {
        public String NBNMSGI_MSG_LANGUAGE;
        public String NBNMSGI_MSG_TARGET;
    }

    public class CQS445I_INPUT_AREA {
        public String CQS445I_ACCOUNT_NBR;
        public String CQS445I_PROCESSING_SITE;
        public String CQS445I_PROCESSING_SITE_TYPE;
        public String CQS445I_TELLER_NBR;
        public String CQS445I_AGENCY_CODE;
        public String CQS445I_AGENCY_TYPE;
        public String CQS445I_CONTROLLER_NBR;
        public String CQS445I_CORP_CODE;
        public String CQS445I_NEW_CHARGE_CAT;
    }

    public static CQgetChargesDetailsMaintV9_Req_IB_v1 createDummyRequest() {
        CQgetChargesDetailsMaintV9_Req_IB_v1 requestBean = new CQgetChargesDetailsMaintV9_Req_IB_v1();

        /*CQgetChargesDetailsMaintV9_Req_IB_v1.nbsapdpi nbsapdpiBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.nbsapdpi();
        CQgetChargesDetailsMaintV9_Req_IB_v1.nbsmsgi nbsmsgiBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.nbsmsgi();
        CQgetChargesDetailsMaintV9_Req_IB_v1.cqh445i cqh445iBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.cqh445i();
        CQgetChargesDetailsMaintV9_Req_IB_v1.finalMsgId finalMsgIdBean = new CQgetChargesDetailsMaintV9_Req_IB_v1.finalMsgId();

        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'N';

        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'BDP';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';

        // cqh445iBean.accountNbr = '4049681885';
        cqh445iBean.accountNbr = Long.valueOf('4049681885');
        //cqh445iBean.processingSite = '8198';
        cqh445iBean.processingSite = 8198;
        cqh445iBean.processingSiteType = '034';
        // cqh445iBean.tellerNbr = '878';
        cqh445iBean.tellerNbr = 878;
        // cqh445iBean.agencyCode = '0';
        cqh445iBean.agencyCode = 0;
        cqh445iBean.agencyType = '';
        // cqh445iBean.controllerNbr = '878';
        cqh445iBean.controllerNbr = 878;
        cqh445iBean.corpCode = 'ABS';
        cqh445iBean.newChargeCat = '';

        CQgetChargesDetailsMaintV9_Req_IB_v1.CQgetChargesDetailsMaintV9 CQgetChargesDetailsMaintV9bean  = new CQgetChargesDetailsMaintV9_Req_IB_v1.CQgetChargesDetailsMaintV9();
        CQgetChargesDetailsMaintV9bean.nbsapdpi = nbsapdpiBean;
        CQgetChargesDetailsMaintV9bean.nbsmsgi = nbsmsgiBean;
        CQgetChargesDetailsMaintV9bean.cqh445i = cqh445iBean;
        
        requestBean.CQgetChargesDetailsMaintV9 = CQgetChargesDetailsMaintV9bean;*/

        return requestBean;
    }
}