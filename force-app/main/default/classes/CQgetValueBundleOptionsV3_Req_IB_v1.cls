public class CQgetValueBundleOptionsV3_Req_IB_v1 {
    public CQgetValueBundleOptionsV3_Req_IB_v1(){}
    //Techmagic 

    public NBSAPDPI NBSAPDPI;
    public NBSMSGI NBSMSGI;
    public CQS044I CQS044I;

    //First level
    public class NBSAPDPI {
        public NBSAPLI NBSAPLI;
    }

    public class NBSMSGI {
        public NBSMSGI_internal NBSMSGI;
    }   

    public class CQS044I {
        public CQS044I_INPUT_AREA CQS044I_INPUT_AREA;
    }
    //END First level 

    public class NBSAPLI {
        public String channelName;
        public String applicationName;
        public String traceIndicator;
    } 

    public class NBSMSGI_internal {
        public String NBNMSGI_MSG_LANGUAGE;
        public String NBNMSGI_MSG_TARGET;
    }

    public class CQS044I_INPUT_AREA {
        public String productType;
        public String processingSiteCode;
        public String processingSiteType;
        public String tellerNumber;
        public String agencySiteCode;
        public String agencySiteType;
        public String controllerNumber;
        public String corpCode;
        public String clientKey;
        public String packageIndicator;
    }
}