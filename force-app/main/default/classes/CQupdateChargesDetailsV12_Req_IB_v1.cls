public class CQupdateChargesDetailsV12_Req_IB_v1 {
    public CQupdateChargesDetailsV12_Req_IB_v1(){}
    //Techmagic

    public NBSAPDPI NBSAPDPI;
    public NBSMSGI NBSMSGI;
    public CQS446I CQS446I;
    
    //First level
    public class NBSAPDPI {
        public NBSAPLI NBSAPLI;
    }

    public class NBSMSGI {
        public NBSMSGI_internal NBSMSGI;
    }

    public class CQS446I {
        public CQS446I_INPUT_AREA CQS446I_INPUT_AREA;
    }
    //END first level

    public class NBSAPLI {
        public String channelName;
        public String applicationName;
        public String traceIndicator;
    }

    public class NBSMSGI_internal {
        public String NBNMSGI_MSG_LANGUAGE;
        public String NBNMSGI_MSG_TARGET;
    }    

    public class CQS446I_INPUT_AREA {
        // public Long CQS446I_ACCOUNT_NBR;
        public String CQS446I_ACCOUNT_NBR;
        public Long CQS446I_PROCESSING_SITE;
        public String CQS446I_PROCESSING_SITE_TYPE;
        public Long CQS446I_TELLER_NBR;
        public Long CQS446I_AGENCY_CODE;
        public String CQS446I_AGENCY_TYPE;
        public Long CQS446I_CONTROLLER_NBR;
        public String CQS446I_CORP_CODE;
        public String CQS446I_CHARGE_CAT;
        public String CQS446I_CHARGE_FREQ;
        public String CQS446I_CHARGE_CAP_DAY;
        public String CQS446I_NEXT_CHRG_CAP_DATE;
        // public Long CQS446I_NEXT_CHRG_CAP_DATE;
        public String CQS446I_SERVICE_FEE_TYPE;
        public Double CQS446I_SERVICE_FEE_FORMULA_1;
        public Double CQS446I_SERVICE_FEE_FORMULA_2;
        public Double CQS446I_SERVICE_FEE_FORMULA_3;
        public Double CQS446I_FIX_AMT;
        public Double CQS446I_MONTH_MIN;
        public List<CQS446I_CSHDEP_DETAIL> CQS446I_CSHDEP_DETAIL;
        public List<CQS446I_CSHCRG> CQS446I_CSHCRG;
        public String CQS446I_ACB_DBT_CRG_CLASS;
        public String CQS446I_TRNCRG_TYPE;
        public String CQS446I_ADMCRG_TYPE;
        public String CQS446I_OD_LDGR_CRG_TYPE;
        public Double CQS446I_OD_LDGR_FIXED_AMT;
        public String CQS446I_EXCESS_CRG_TYPE;
        public Double CQS446I_EXCESS_CRG_AMT;
        public Long CQS446I_CHARGE_EXPIRY_DATE;
        public String CQS446I_BNK_STMTCRG_TYPE;
        public Double CQS446I_BNK_STMTCRG_AMT;
        public String CQS446I_INT_STMTCRG_TYPE;
        public Double CQS446I_INT_STMTCRG_AMT;
        public String CQS446I_GVTLVY_TYPE;
        public String CQS446I_FBKCRG_TYPE;
        public Long CQS446I_MINBAL_AMT;
        public String CQS446I_MGTCRG_TYPE;
        public List<CQS446I_MGTCRG_BARRIER> CQS446I_MGTCRG_BARRIER;
        public Double CQS446I_MGTCRG_EASY_FLAT_FEE;
        public Long CQS446I_MGTCRG_EASY_TIER;
        public String CQS446I_MANDATE_NUMBER;
        // public Long CQS446I_MANDATE_NUMBER;
        public Double CQS446I_FIX_FBK_AMT;
        public String CQS446I_CBP_SCHEME_CODE;
        public String CQS446I_CBP_SCHEME_START;
        // public Long CQS446I_CBP_SCHEME_START;
        public Long CQS446I_PRIMARY_ACCOUNT;
        public String CQS446I_SCHEME_RSET_DESC;
        public String CQS446I_SCHEME_DATE_RSET;
        public String CQS446I_CBP_CRGSTMT_REQ;
        public Long CQS446I_UNIQUE_PACKAGE_ID;
        public String CQS446I_OPTION;
    }

    public class CQS446I_CSHDEP_DETAIL {
        public Double CQS446I_CSHCRG_BASE_FEE;
        public String CQS446I_CASH_DEP_FEE_TYPE;
        public Double CQS446I_CSHCRG_MCDF_FEE;
    }

    public class CQS446I_CSHCRG {
        public Long CQS446I_CSHCRG_DEP_AMT;
        public Double CQS446I_CSHCRG_PERC;
    }

    public class CQS446I_MGTCRG_BARRIER {
        public Long CQS446I_MGTCRG_NBR_DBT_TRAN;
        public Double CQS446I_MGTCRG_MNTH_FEE;
    }
}