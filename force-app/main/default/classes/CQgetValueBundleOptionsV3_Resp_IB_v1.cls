public class CQgetValueBundleOptionsV3_Resp_IB_v1 {
    public CQgetValueBundleOptionsV3_Resp_IB_v1(){}
    
    //Techmagic - Igor
    public CQS044O CQS044O;
    public NBSAPDPO NBSAPDPO;
    public NBSMSGO3 NBSMSGO3;

    //First level
    public class CQS044O {
        public CQS044O_OUTPUT_AREA CQS044O_OUTPUT_AREA;
    }

    public class NBSAPDPO {
        public NBSAPLO NBSAPLO;
    }

    public class NBSMSGO3 {
        public NBSMSGO3_internal NBSMSGO3;
    }
    // End First level

    public class CQS044O_OUTPUT_AREA {
        public Long PRODUCT_TYPE;
        public List<SCHEME_CODE_TABLE> SCHEME_CODE_TABLE;
    }

    public class SCHEME_CODE_TABLE {
        @AuraEnabled public String PRICING_SCHEME_INDICATOR;
        @AuraEnabled public String CBP_SCHEME_DESCRIPTION;
        @AuraEnabled public String CBP_PRICING_SCHEME_CODE;
    }

    public class NBSAPLO {
        public Long NBNAPLO_REASON_CODE;
        public Long NBNAPLO_RETURN_CODE;
        public String NBNAPLO_SERVICE_VERSION;
    }

    public class NBSMSGO3_internal {
        public Long NBNMSGO3_NBR_USER_ERRS;
        public String NBSMSGO3_VERSION;
        public String NBNMSGO3_SYS_ERR_TXT;
        public Long NBNMSGO3_NBR_USER_MSGS;
        public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
    }

    public class NBNMSGO3_MSG_ENTRY {
        public String NBNMSGO3_MSG_ERR_IND;
        public String NBNMSGO3_MSG_TXT;
        public String NBNMSGO3_MSG_CLASS;
        public String NBNMSGO3_MSG_CODE;
    }
}