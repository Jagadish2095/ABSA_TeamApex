public class CQupdateChargesDetailsV12_Resp_IB_v1 {
    public CQupdateChargesDetailsV12_Resp_IB_v1(){}
    //Techmagic - Igor 

    @AuraEnabled public NBSAPDPO NBSAPDPO;
    @AuraEnabled public CQS446O CQS446O;
    @AuraEnabled public NBSMSGO3 NBSMSGO3;
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    //First level
    public class NBSAPDPO {
        @AuraEnabled public NBSAPLO NBSAPLO;
    }

    public class CQS446O {
        @AuraEnabled public CQS446O_OUTPUT_AREA CQS446O_OUTPUT_AREA;
    }

    public class NBSMSGO3 {
        @AuraEnabled public NBSMSGO3_internal NBSMSGO3;
    }
    //END First level

    public class NBSAPLO {
        @AuraEnabled public Long NBNAPLO_REASON_CODE;
        @AuraEnabled public Long NBNAPLO_RETURN_CODE;
        @AuraEnabled public String NBNAPLO_SERVICE_VERSION;
    }

    public class CQS446O_OUTPUT_AREA {
        @AuraEnabled public String CQS446O_CBP_SCHEME_DESC_OUT;
        @AuraEnabled public String CQS446O_CHARGE_CAT_OUT;
        @AuraEnabled public Decimal CQS446O_INT_STMTCRG_AMT_OUT;
        @AuraEnabled public Long CQS446O_MINBAL_AMT_OUT;
        @AuraEnabled public String CQS446O_SCHEME_DATE_RSET_OUT;
        @AuraEnabled public String CQS446O_D_CRG_CAT;
        @AuraEnabled public Long CQS446O_MGTCRG_EASY_TIER_OUT;

        @AuraEnabled public List<CQS446O_CSHDEP_OUT> CQS446O_CSHDEP_OUT;

        @AuraEnabled public String CQS446O_OD_LDGR_CRG_TYPE_OUT;
        @AuraEnabled public String CQS446O_SCHEME_RSET_DESC_OUT;
        @AuraEnabled public String CQS446O_GVTLVY_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_TRNCRG_TYPE_OUT;

        @AuraEnabled public List<CQS446O_MGTCRG_BARRIER_OUT> CQS446O_MGTCRG_BARRIER_OUT;

        @AuraEnabled public String CQS446O_TRNCRG_TYPE_OUT_A;
        @AuraEnabled public Long CQS446O_NEXT_CHRG_CAP_DATE_OUT;
        @AuraEnabled public String CQS446O_D_GVTLVY_TYPE;
        @AuraEnabled public String CQS446O_CHARGE_FREQ_OUT_A;
        @AuraEnabled public String CQS446O_MGTCRG_TYPE_OUT;
        @AuraEnabled public Decimal CQS446O_EXCESS_CRG_AMT_OUT;

        @AuraEnabled public List<CQS446O_CSHCRG_OUT> CQS446O_CSHCRG_OUT;

        @AuraEnabled public Decimal CQS446O_MGTCRG_EZ_FLTFEE_OUT;
        @AuraEnabled public String CQS446O_MGTCRG_EASY_TIER_OUT_A;
        @AuraEnabled public String CQS446O_D_CRG_CAP_FREQ;
        @AuraEnabled public String CQS446O_D_CRG_CAP_DAY;
        @AuraEnabled public String CQS446O_SERV_FEE_FORM3_OUT_A;
        @AuraEnabled public String CQS446O_CHARGE_FREQ_OUT;
        @AuraEnabled public Decimal CQS446O_SERV_FEE_FORM3_OUT;
        @AuraEnabled public String CQS446O_D_FBKCRG_TYPE;
        @AuraEnabled public String CQS446O_FIX_FBK_AMT_OUT_A;
        @AuraEnabled public Long CQS446O_LAST_PROC_TIME;

        @AuraEnabled public String CQS446O_D_MGTCRG_TYPE;
        @AuraEnabled public String CQS446O_MANDATE_NUMBER_OUT_A;
        @AuraEnabled public String CQS446O_ACB_DBT_CRG_CLSS_OUT_A;
        @AuraEnabled public String CQS446O_GVTLVY_TYPE_OUT;
        @AuraEnabled public String CQS446O_D_OD_LDGR_CRG_TYPE;
        @AuraEnabled public Long CQS446O_CRG_EXPIRY_DATE_OUT;
        @AuraEnabled public String CQS446O_MGTCRG_EZ_FLTFEE_OUT_A;
        @AuraEnabled public String CQS446O_SERVICE_FEE_TYPE_OUT;
        @AuraEnabled public Long CQS446O_CBP_SCHEME_START_OUT;
        @AuraEnabled public String CQS446O_FBKCRG_TYPE_OUT;

        @AuraEnabled public String CQS446O_EXCESS_CRG_TYPE_OUT_A;
        @AuraEnabled public Decimal CQS446O_BNK_STMTCRG_AMT_OUT;
        @AuraEnabled public Long CQS446O_ACCOUNT_TYPE;
        @AuraEnabled public String CQS446O_D_TRNCRG_TYPE;
        @AuraEnabled public Decimal CQS446O_OD_LDGR_FIXD_AMT_OUT;
        @AuraEnabled public String CQS446O_BNK_STMTCRG_TYPE_OUT;
        @AuraEnabled public String CQS446O_STAFF_ACCOUNT;
        @AuraEnabled public Decimal CQS446O_SERV_FEE_FORM2_OUT;
        @AuraEnabled public String CQS446O_D_SRVCRG_TYPE;
        @AuraEnabled public String CQS446O_ADMCRG_TYPE_OUT;

        @AuraEnabled public String CQS446O_CHARGE_CAP_DAY_OUT;
        @AuraEnabled public String CQS446O_MINBAL_AMT_OUT_A;
        @AuraEnabled public Decimal CQS446O_MONTH_MIN_OUT;
        @AuraEnabled public Long CQS446O_ACCOUNT_NBR_OUT;
        @AuraEnabled public Decimal CQS446O_SERV_FEE_FORM1_OUT;
        @AuraEnabled public String CQS446O_D_EXCESS_CRG_TYPE;
        @AuraEnabled public Decimal CQS446O_FIX_FBK_AMT_OUT;
        @AuraEnabled public String CQS446O_INT_STMTCRG_AMT_OUT_A;
        @AuraEnabled public String CQS446O_CHARGE_CAP_DAY_OUT_A;
        @AuraEnabled public String CQS446O_D_ACB_DBT_CRG_CLASS;

        @AuraEnabled public String CQS446O_FIX_AMT_OUT_A;
        @AuraEnabled public String CQS446O_D_INT_STMTCRG_TYPE;
        @AuraEnabled public String CQS446O_CBP_SCHEME_CODE_OUT;
        @AuraEnabled public String CQS446O_SERV_FEE_FORM2_OUT_A;
        @AuraEnabled public String CQS446O_INT_STMTCRG_TYPE_OUT_A;
        @AuraEnabled public Decimal CQS446O_FIX_AMT_OUT;
        @AuraEnabled public String CQS446O_OD_LDGR_FIXD_AMT_OUT_A;
        @AuraEnabled public Long CQS446O_PRIMARY_ACCOUNT_OUT;
        @AuraEnabled public String CQS446O_FBKCRG_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_BNK_STMTCRG_TYPE_OUT_A;

        @AuraEnabled public String CQS446O_ADMCRG_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_CLIENT_NAME;
        @AuraEnabled public String CQS446O_EXCESS_CRG_AMT_OUT_A;
        @AuraEnabled public String CQS446O_ACCOUNT_NAME;
        @AuraEnabled public String CQS446O_MGTCRG_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_OD_LDGR_CRG_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_SERVICE_FEE_TYPE_OUT_A;
        @AuraEnabled public String CQS446O_SCHEME_DATE_RSET_OUT_A;
        @AuraEnabled public String CQS446O_CBP_CRGSTMT_REQ_OUT;
        @AuraEnabled public String CQS446O_ACB_DBT_CRG_CLSS_OUT;

        @AuraEnabled public String CQS446O_D_ADMCRG_TYPE;
        @AuraEnabled public Long CQS446O_MANDATE_NUMBER_OUT;
        @AuraEnabled public String CQS446O_CBP_SCHEME_CODE_OUT_A;
        @AuraEnabled public String CQS446O_D_BNK_STMTCRG_TYPE;
        @AuraEnabled public Long CQS446O_LAST_PROC_DATE;
        @AuraEnabled public String CQS446O_SERV_FEE_FORM1_OUT_A;
        @AuraEnabled public String CQS446O_SCHEME_RSET_DESC_OUT_A;
        @AuraEnabled public String CQS446O_EXCESS_CRG_TYPE_OUT;
        @AuraEnabled public String CQS446O_CRG_EXPIRY_DATE_OUT_A;
        @AuraEnabled public String CQS446O_INT_STMTCRG_TYPE_OUT;
        @AuraEnabled public String CQS446O_BNK_STMTCRG_AMT_OUT_A;
        @AuraEnabled public String CQS446O_PRIMARY_ACCOUNT_OUT_A;
    }

    public class CQS446O_CSHDEP_OUT {
        @AuraEnabled public Decimal CQS446O_CSHCRG_MCDF_FEE_OUT;
        @AuraEnabled public String CQS446O_CSHCRG_MCDF_FEE_OUT_A;
        @AuraEnabled public String CQS446O_CSHCRG_BASE_FEE_OUT_A;
        @AuraEnabled public String CQS446O_CSH_DEP_FEE_TYPE_OUT;
        @AuraEnabled public String CQS446O_CSH_DEP_FEE_TYPE_OUT_A;
        @AuraEnabled public Decimal CQS446O_CSHCRG_BASE_FEE_OUT;
        @AuraEnabled public String CQS446O_D_CSHCRG_TYPE;
    }

    public class CQS446O_MGTCRG_BARRIER_OUT {
        @AuraEnabled public Long CQS446O_TRNCRG_TYPE_OUT;
        @AuraEnabled public Decimal CQS446O_MGTCRG_MNTH_FEE_OUT;
        @AuraEnabled public String CQS446O_MGTCRG_NR_DT_TRN_OUT_A;
        @AuraEnabled public String CQS446O_MGTCRG_MNTH_FEE_OUT_A;
    }

    public class CQS446O_CSHCRG_OUT {
        @AuraEnabled public Long CQS446O_CSHCRG_DEP_AMT_OUT;
        @AuraEnabled public String CQS446O_CSHCRG_DEP_AMT_OUT_A;
        @AuraEnabled public Decimal CQS446O_CSHCRG_PERC_OUT;
        @AuraEnabled public String CQS446O_CSHCRG_PERC_OUT_A;
    }

    public class NBSMSGO3_internal {
        @AuraEnabled public Integer NBNMSGO3_NBR_USER_ERRS;
        @AuraEnabled public String NBSMSGO3_VERSION;
        @AuraEnabled public String NBNMSGO3_SYS_ERR_TXT;
        @AuraEnabled public Integer NBNMSGO3_NBR_USER_MSGS;  
        @AuraEnabled public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;  
    }

    public class NBNMSGO3_MSG_ENTRY {
        @AuraEnabled public String NBNMSGO3_MSG_ERR_IND;
        @AuraEnabled public String NBNMSGO3_MSG_TXT;
        @AuraEnabled public String NBNMSGO3_MSG_CLASS;
        @AuraEnabled public String NBNMSGO3_MSG_CODE;
    }

    public static CQupdateChargesDetailsV12_Resp_IB_v1 dummyResponse() {
        CQupdateChargesDetailsV12_Resp_IB_v1 responseBean = new CQupdateChargesDetailsV12_Resp_IB_v1();

        CQupdateChargesDetailsV12_Resp_IB_v1.NBSAPDPO NBSAPDPO_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.NBSAPDPO();
        CQupdateChargesDetailsV12_Resp_IB_v1.NBSAPLO NBSAPLO_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.NBSAPLO();
        NBSAPDPO_bean.NBSAPLO = NBSAPLO_bean;

        NBSAPLO_bean.NBNAPLO_REASON_CODE = 0;
        NBSAPLO_bean.NBNAPLO_RETURN_CODE = 0;
        NBSAPLO_bean.NBNAPLO_SERVICE_VERSION = 'test';

        CQupdateChargesDetailsV12_Resp_IB_v1.NBSMSGO3 NBSMSGO3_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.NBSMSGO3();
        CQupdateChargesDetailsV12_Resp_IB_v1.NBSMSGO3_internal NBSMSGO3_internal_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.NBSMSGO3_internal();
        CQupdateChargesDetailsV12_Resp_IB_v1.NBNMSGO3_MSG_ENTRY NBNMSGO3_MSG_ENTRY_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();
        NBSMSGO3_bean.NBSMSGO3 = NBSMSGO3_internal_bean;

        NBSMSGO3_internal_bean.NBNMSGO3_NBR_USER_ERRS = 0;
        NBSMSGO3_internal_bean.NBSMSGO3_VERSION = 'test';
        NBSMSGO3_internal_bean.NBNMSGO3_SYS_ERR_TXT = 'test';
        NBSMSGO3_internal_bean.NBNMSGO3_NBR_USER_MSGS = 0;
        NBSMSGO3_internal_bean.NBNMSGO3_MSG_ENTRY = new List<CQupdateChargesDetailsV12_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>{NBNMSGO3_MSG_ENTRY_bean};

        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_ERR_IND = 'test';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_TXT = 'test';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_CLASS = 'test';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_CODE = 'test';

        CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O CQS446O_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O();
        CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_OUTPUT_AREA CQS446O_OUTPUT_AREA_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_OUTPUT_AREA();

        CQS446O_OUTPUT_AREA_bean.CQS446O_CBP_SCHEME_DESC_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CHARGE_CAT_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_INT_STMTCRG_AMT_OUT = 0.0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_MINBAL_AMT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_SCHEME_DATE_RSET_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_CRG_CAT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_EASY_TIER_OUT = 0;

        CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHDEP_OUT CQS446O_CSHDEP_OUT_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHDEP_OUT();
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSHCRG_MCDF_FEE_OUT = 0.0;
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSHCRG_MCDF_FEE_OUT_A = 'test';
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSHCRG_BASE_FEE_OUT_A = 'test';
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSH_DEP_FEE_TYPE_OUT = 'test';
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSH_DEP_FEE_TYPE_OUT_A = 'test';
        CQS446O_CSHDEP_OUT_bean.CQS446O_CSHCRG_BASE_FEE_OUT = 0.0;
        CQS446O_CSHDEP_OUT_bean.CQS446O_D_CSHCRG_TYPE = 'test';

        CQS446O_OUTPUT_AREA_bean.CQS446O_CSHDEP_OUT = new List<CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHDEP_OUT>{CQS446O_CSHDEP_OUT_bean};

        CQS446O_OUTPUT_AREA_bean.CQS446O_OD_LDGR_CRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SCHEME_RSET_DESC_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_GVTLVY_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_TRNCRG_TYPE_OUT = 'test';

        CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_MGTCRG_BARRIER_OUT CQS446O_MGTCRG_BARRIER_OUT_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_MGTCRG_BARRIER_OUT();
        CQS446O_MGTCRG_BARRIER_OUT_bean.CQS446O_TRNCRG_TYPE_OUT = 0;
        CQS446O_MGTCRG_BARRIER_OUT_bean.CQS446O_MGTCRG_MNTH_FEE_OUT = 0.0;
        CQS446O_MGTCRG_BARRIER_OUT_bean.CQS446O_MGTCRG_NR_DT_TRN_OUT_A = 'test';
        CQS446O_MGTCRG_BARRIER_OUT_bean.CQS446O_MGTCRG_MNTH_FEE_OUT_A = 'test';

        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_BARRIER_OUT = new List<CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_MGTCRG_BARRIER_OUT>{CQS446O_MGTCRG_BARRIER_OUT_bean};

        CQS446O_OUTPUT_AREA_bean.CQS446O_TRNCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_NEXT_CHRG_CAP_DATE_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_GVTLVY_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CHARGE_FREQ_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_EXCESS_CRG_AMT_OUT = 0.0;

        CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHCRG_OUT CQS446O_CSHCRG_OUT_bean = new CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHCRG_OUT();
        CQS446O_CSHCRG_OUT_bean.CQS446O_CSHCRG_DEP_AMT_OUT = 0;
        CQS446O_CSHCRG_OUT_bean.CQS446O_CSHCRG_DEP_AMT_OUT_A = 'test';
        CQS446O_CSHCRG_OUT_bean.CQS446O_CSHCRG_PERC_OUT = 0.0;
        CQS446O_CSHCRG_OUT_bean.CQS446O_CSHCRG_PERC_OUT_A = 'test';

        CQS446O_OUTPUT_AREA_bean.CQS446O_CSHCRG_OUT = new List<CQupdateChargesDetailsV12_Resp_IB_v1.CQS446O_CSHCRG_OUT>{CQS446O_CSHCRG_OUT_bean};

        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_EZ_FLTFEE_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_EASY_TIER_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_CRG_CAP_FREQ = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_CRG_CAP_DAY = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM3_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CHARGE_FREQ_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM3_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_FBKCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_FIX_FBK_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_LAST_PROC_TIME = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_MGTCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MANDATE_NUMBER_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_ACB_DBT_CRG_CLSS_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_GVTLVY_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_OD_LDGR_CRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CRG_EXPIRY_DATE_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_EZ_FLTFEE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERVICE_FEE_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CBP_SCHEME_START_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_FBKCRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_EXCESS_CRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_BNK_STMTCRG_AMT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_ACCOUNT_TYPE = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_TRNCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_OD_LDGR_FIXD_AMT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_BNK_STMTCRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_STAFF_ACCOUNT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM2_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_SRVCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_ADMCRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CHARGE_CAP_DAY_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MINBAL_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MONTH_MIN_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_ACCOUNT_NBR_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM1_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_EXCESS_CRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_FIX_FBK_AMT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_INT_STMTCRG_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CHARGE_CAP_DAY_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_ACB_DBT_CRG_CLASS = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_FIX_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_INT_STMTCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CBP_SCHEME_CODE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM2_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_INT_STMTCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_FIX_AMT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_OD_LDGR_FIXD_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_PRIMARY_ACCOUNT_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_FBKCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_BNK_STMTCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_ADMCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CLIENT_NAME = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_EXCESS_CRG_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_ACCOUNT_NAME = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MGTCRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_OD_LDGR_CRG_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERVICE_FEE_TYPE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SCHEME_DATE_RSET_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CBP_CRGSTMT_REQ_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_ACB_DBT_CRG_CLSS_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_ADMCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_MANDATE_NUMBER_OUT = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_CBP_SCHEME_CODE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_D_BNK_STMTCRG_TYPE = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_LAST_PROC_DATE = 0;
        CQS446O_OUTPUT_AREA_bean.CQS446O_SERV_FEE_FORM1_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_SCHEME_RSET_DESC_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_EXCESS_CRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_CRG_EXPIRY_DATE_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_INT_STMTCRG_TYPE_OUT = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_BNK_STMTCRG_AMT_OUT_A = 'test';
        CQS446O_OUTPUT_AREA_bean.CQS446O_PRIMARY_ACCOUNT_OUT_A = 'test';  
        
        responseBean.NBSAPDPO = NBSAPDPO_bean;
        responseBean.CQS446O = CQS446O_bean;
        responseBean.NBSMSGO3 = NBSMSGO3_bean;
        responseBean.status = 'OK';
        responseBean.statusCode = 200;
        responseBean.message = 'test';

        return responseBean;
    }
}