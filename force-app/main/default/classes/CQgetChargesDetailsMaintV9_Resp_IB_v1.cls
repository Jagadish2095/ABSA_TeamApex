public class CQgetChargesDetailsMaintV9_Resp_IB_v1 {
    
    //Techmagic 
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public NBSAPDPO NBSAPDPO;
    @AuraEnabled public NBSMSGO3 NBSMSGO3;
    @AuraEnabled public CQS445O CQS445O;

    //first level
    public class NBSAPDPO {
        @AuraEnabled public NBSAPLO NBSAPLO;
    }

    public class NBSMSGO3 {
        @AuraEnabled public NBSMSGO3_internal NBSMSGO3;
    }

    public class CQS445O {
        @AuraEnabled public CQS445O_OUTPUT_AREA CQS445O_OUTPUT_AREA; 
    }
    //END first level

    public class NBSAPLO {
        @AuraEnabled public String NBNAPLO_REASON_CODE;
        @AuraEnabled public String NBNAPLO_RETURN_CODE;
        @AuraEnabled public String NBNAPLO_SERVICE_VERSION;
    }

    public class NBSMSGO3_internal {
        @AuraEnabled public String NBNMSGO3_NBR_USER_ERRS;
        @AuraEnabled public String NBNMSGO3_NBR_USER_MSGS;
        @AuraEnabled public String NBNMSGO3_SYS_ERR_TXT;
        @AuraEnabled public String NBSMSGO3_VERSION;
        @AuraEnabled public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
    }

    public class NBNMSGO3_MSG_ENTRY {
        @AuraEnabled public String NBNMSGO3_MSG_ERR_IND;
        @AuraEnabled public String NBNMSGO3_MSG_TXT;
        @AuraEnabled public String NBNMSGO3_MSG_CLASS;
        @AuraEnabled public String NBNMSGO3_MSG_CODE;        
    }

    public class CQS445O_OUTPUT_AREA {        
        @AuraEnabled public String CQS445O_CHARGE_FREQ;
        @AuraEnabled public String CQS445O_CHARGE_EXPIRY_DATE_A;
        @AuraEnabled public String CQS445O_D_CRG_CAP_FREQ;
        @AuraEnabled public String CQS445O_INT_STMTCRG_TYPE;
        @AuraEnabled public String CQS445O_GVTLVY_TYPE;
        @AuraEnabled public String CQS445O_NEXT_CHRG_CAP_DATE;
        @AuraEnabled public String CQS445O_D_OD_LDGR_CRG_TYPE;
        @AuraEnabled public String CQS445O_MGTCRG_TYPE_A;
        @AuraEnabled public String CQS445O_STAFF_ACCOUNT;
        @AuraEnabled public String CQS445O_FBKCRG_TYPE_A;

        @AuraEnabled public String CQS445O_MGTCRG_EASY_FLAT_FEE_A;
        @AuraEnabled public String CQS445O_SERVICE_FEE_TYPE;
        @AuraEnabled public String CQS445O_CHARGE_CAP_DAY_A;
        @AuraEnabled public String CQS445O_GVTLVY_TYPE_A;
        @AuraEnabled public String CQS445O_FBKCRG_TYPE;
        @AuraEnabled public String CQS445O_D_BNK_STMTCRG_TYPE;
        @AuraEnabled public String CQS445O_CLIENT_NAME;
        @AuraEnabled public String CQS445O_D_EXCESS_CRG_TYPE;
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_3A;
        @AuraEnabled public String CQS445O_MGTCRG_EASY_FLAT_FEE;

        @AuraEnabled public String CQS445O_MANDATE_NUMBER_A;
        @AuraEnabled public String CQS445O_CHARGE_CAT;
        @AuraEnabled public String CQS445O_INT_STMTCRG_AMT;
        @AuraEnabled public String CQS445O_MGTCRG_EASY_TIER_A;
        @AuraEnabled public String CQS445O_CBP_SCHEME_DESC;
        @AuraEnabled public String CQS445O_OD_LDGR_CRG_TYPE_A;
        @AuraEnabled public String CQS445O_CBP_SCHEME_START;
        @AuraEnabled public String CQS445O_CBP_SCHEME_RSET_DESC;
        @AuraEnabled public String CQS445O_CHARGE_FREQ_A;
        @AuraEnabled public String CQS445O_EXCESS_CRG_TYPE_A;

        @AuraEnabled public String CQS445O_D_TRNCRG_TYPE;
        @AuraEnabled public String CQS445O_ADMCRG_TYPE;
        @AuraEnabled public String CQS445O_D_ACB_DBT_CRG_CLASS;
        @AuraEnabled public String CQS445O_SERVICE_FEE_TYPE_A;
        @AuraEnabled public String CQS445O_FIX_AMT_A;
        @AuraEnabled public String CQS445O_FIX_FBK_AMT_A;
        @AuraEnabled public String CQS445O_ACCOUNT_TYPE;
        @AuraEnabled public String CQS445O_OD_LDGR_FIXED_AMT_A;
        @AuraEnabled public String CQS445O_INT_STMTCRG_AMT_A;
        @AuraEnabled public String CQS445O_D_SRVCRG_TYPE;

        @AuraEnabled public String CQS445O_MINBAL_AMT_A;
        @AuraEnabled public String CQS445O_D_CRG_CAP_DAY;
        @AuraEnabled public String CQS445O_EXCESS_CRG_AMT_A;
        @AuraEnabled public String CQS445O_BNK_STMTCRG_AMT;
        @AuraEnabled public String CQS445O_EXCESS_CRG_TYPE;
        @AuraEnabled public String CQS445O_CHARGE_EXPIRY_DATE;
        @AuraEnabled public String CQS445O_ACB_DBT_CRG_CLASS;
        @AuraEnabled public String CQS445O_MINBAL_AMT;
        @AuraEnabled public String CQS445O_ACCOUNT_NBR_OUT;
        @AuraEnabled public String CQS445O_CBP_PRIMARY_ACCOUNT;

        @AuraEnabled public String CQS445O_ACCOUNT_NAME;
        @AuraEnabled public String CQS445O_TRNCRG_TYPE_A;
        @AuraEnabled public String CQS445O_OD_LDGR_FIXED_AMT;
        @AuraEnabled public String CQS445O_CBP_CRGSTMT_REQ;
        @AuraEnabled public String CQS445O_MONTH_MIN;
        @AuraEnabled public String CQS445O_BNK_STMTCRG_TYPE_A;
        @AuraEnabled public String CQS445O_CBP_SCHEME_CODE;
        @AuraEnabled public String CQS445O_CBP_PRIMARY_ACCOUNT_A;
        @AuraEnabled public String CQS445O_OD_LDGR_CRG_TYPE;
        @AuraEnabled public String CQS445O_EXCESS_CRG_AMT;

        @AuraEnabled public String CQS445O_CBP_SCHEME_CODE_A;
        @AuraEnabled public String CQS445O_D_CRG_CAT;
        @AuraEnabled public String CQS445O_D_INT_STMTCRG_TYPE;
        @AuraEnabled public String CQS445O_INT_STMTCRG_TYPE_A;
        @AuraEnabled public String CQS445O_MANDATE_NUMBER;
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_1A;

        @AuraEnabled public List<CQS445O_CSHCRG> CQS445O_CSHCRG;

        @AuraEnabled public String CQS445O_D_GVTLVY_TYPE;
        @AuraEnabled public String CQS445O_MGTCRG_TYPE;
        @AuraEnabled public String CQS445O_CHARGE_CAP_DAY;
        @AuraEnabled public String CQS445O_D_FBKCRG_TYPE;

        @AuraEnabled public List<CQS445O_MGTCRG_BARRIER> CQS445O_MGTCRG_BARRIER;

        @AuraEnabled public String CQS445O_CBP_SCHEME_RSET_DESC_A;
        @AuraEnabled public String CQS445O_D_MGTCRG_TYPE;
        @AuraEnabled public String CQS445O_BNK_STMTCRG_AMT_A;
        @AuraEnabled public String CQS445O_CBP_SCHEME_DATE_RSET_A;

        @AuraEnabled public List<CQS445O_CSHDEP> CQS445O_CSHDEP;     
        
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_3;
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_2;
        @AuraEnabled public String CQS445O_ADMCRG_TYPE_A;
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_1;
        @AuraEnabled public String CQS445O_FIX_FBK_AMT;
        @AuraEnabled public String CQS445O_FIX_AMT;
        @AuraEnabled public String CQS445O_BNK_STMTCRG_TYPE;
        @AuraEnabled public String CQS445O_ACB_DBT_CRG_CLASS_A;
        @AuraEnabled public String CQS445O_CBP_SCHEME_DATE_RSET;
        @AuraEnabled public String CQS445O_MGTCRG_EASY_TIER;
        @AuraEnabled public String CQS445O_SERVICE_FEE_FORMULA_2A;
        @AuraEnabled public String CQS445O_TRNCRG_TYPE;
        @AuraEnabled public String CQS445O_D_ADMCRG_TYPE;        
    }

    public class CQS445O_CSHCRG {
        @AuraEnabled public String CQS445O_CSHCRG_DEP_AMT;
        @AuraEnabled public String CQS445O_CSHCRG_PERC_A;
        @AuraEnabled public String CQS445O_CSHCRG_DEP_AMT_A;
        @AuraEnabled public String CQS445O_CSHCRG_PERC;
    }

    public class CQS445O_MGTCRG_BARRIER {
        @AuraEnabled public String CQS445O_MGTCRG_MNTH_FEE;
        @AuraEnabled public String CQS445O_MGTCRG_MNTH_FEE_A;
        @AuraEnabled public String CQS445O_MGTCRG_NBR_DBT_TRAN_A;
        @AuraEnabled public String CQS445O_MGTCRG_NBR_DBT_TRAN;
    }

    public class CQS445O_CSHDEP {
        @AuraEnabled public String CQS445O_CSHCRG_MCDF_FEE;
        @AuraEnabled public String CQS445O_CSHCRG_MCDF_FEE_A;
        @AuraEnabled public String CQS445O_CASH_DEP_FEE_TYPE;
        @AuraEnabled public String CQS445O_CSHCRG_BASE_FEE_A;
        @AuraEnabled public String CQS445O_CASH_DEP_FEE_TYPE_A;
        @AuraEnabled public String CQS445O_CSHCRG_BASE_FEE;
        @AuraEnabled public String CQS445O_D_CSHCRG_TYPE;
    }

    public static CQgetChargesDetailsMaintV9_Resp_IB_v1 dummyResponse() {
        CQgetChargesDetailsMaintV9_Resp_IB_v1 responseBean = new CQgetChargesDetailsMaintV9_Resp_IB_v1();

        CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSAPDPO NBSAPDPO_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSAPDPO();
        CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSAPLO NBSAPLO_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSAPLO();
        NBSAPDPO_bean.NBSAPLO = NBSAPLO_bean;

        NBSAPLO_bean.NBNAPLO_REASON_CODE = '0';
        NBSAPLO_bean.NBNAPLO_RETURN_CODE = '0';
        NBSAPLO_bean.NBNAPLO_SERVICE_VERSION = '0';

        CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSMSGO3 NBSMSGO3_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSMSGO3();
        CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSMSGO3_internal NBSMSGO3_internal_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.NBSMSGO3_internal();
        CQgetChargesDetailsMaintV9_Resp_IB_v1.NBNMSGO3_MSG_ENTRY NBNMSGO3_MSG_ENTRY_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();
        NBSMSGO3_bean.NBSMSGO3 = NBSMSGO3_internal_bean;

        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_ERR_IND = '0';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_TXT = '0';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_CLASS = '0';
        NBNMSGO3_MSG_ENTRY_bean.NBNMSGO3_MSG_CODE = '0';
        
        NBSMSGO3_internal_bean.NBNMSGO3_NBR_USER_ERRS = '0';
        NBSMSGO3_internal_bean.NBNMSGO3_NBR_USER_MSGS = '0';
        NBSMSGO3_internal_bean.NBNMSGO3_SYS_ERR_TXT = '0';
        NBSMSGO3_internal_bean.NBSMSGO3_VERSION = '0';
        NBSMSGO3_internal_bean.NBNMSGO3_MSG_ENTRY = new List<CQgetChargesDetailsMaintV9_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>{NBNMSGO3_MSG_ENTRY_bean};    

        CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O CQS445O_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O();
        CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_OUTPUT_AREA CQS445O_OUTPUT_AREA_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_OUTPUT_AREA();
        CQS445O_bean.CQS445O_OUTPUT_AREA = CQS445O_OUTPUT_AREA_bean;

        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_FREQ = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_EXPIRY_DATE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_CRG_CAP_FREQ = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_INT_STMTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_GVTLVY_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_NEXT_CHRG_CAP_DATE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_OD_LDGR_CRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_STAFF_ACCOUNT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FBKCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_EASY_FLAT_FEE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_CAP_DAY_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_GVTLVY_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FBKCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_BNK_STMTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CLIENT_NAME = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_EXCESS_CRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_3A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_EASY_FLAT_FEE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MANDATE_NUMBER_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_CAT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_INT_STMTCRG_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_EASY_TIER_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_DESC = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_OD_LDGR_CRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_START = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_RSET_DESC = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_FREQ_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_EXCESS_CRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_TRNCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ADMCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_ACB_DBT_CRG_CLASS = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FIX_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FIX_FBK_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ACCOUNT_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_OD_LDGR_FIXED_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_INT_STMTCRG_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_SRVCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MINBAL_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_CRG_CAP_DAY = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_EXCESS_CRG_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_BNK_STMTCRG_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_EXCESS_CRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_EXPIRY_DATE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ACB_DBT_CRG_CLASS = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MINBAL_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ACCOUNT_NBR_OUT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_PRIMARY_ACCOUNT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ACCOUNT_NAME = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_TRNCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_OD_LDGR_FIXED_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_CRGSTMT_REQ = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MONTH_MIN = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_BNK_STMTCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_CODE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_PRIMARY_ACCOUNT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_OD_LDGR_CRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_EXCESS_CRG_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_CODE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_CRG_CAT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_INT_STMTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_INT_STMTCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MANDATE_NUMBER = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_1A = '0';

        CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHCRG CQS445O_CSHCRG_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHCRG();
        CQS445O_CSHCRG_bean.CQS445O_CSHCRG_DEP_AMT = '0';
        CQS445O_CSHCRG_bean.CQS445O_CSHCRG_PERC_A = '0';
        CQS445O_CSHCRG_bean.CQS445O_CSHCRG_DEP_AMT_A = '0';
        CQS445O_CSHCRG_bean.CQS445O_CSHCRG_PERC = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CSHCRG = new List<CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHCRG>{CQS445O_CSHCRG_bean};

        CQS445O_OUTPUT_AREA_bean.CQS445O_D_GVTLVY_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CHARGE_CAP_DAY = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_FBKCRG_TYPE = '0';

        CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_MGTCRG_BARRIER CQS445O_MGTCRG_BARRIER_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_MGTCRG_BARRIER();
        CQS445O_MGTCRG_BARRIER_bean.CQS445O_MGTCRG_MNTH_FEE = '0';
        CQS445O_MGTCRG_BARRIER_bean.CQS445O_MGTCRG_MNTH_FEE_A = '0';
        CQS445O_MGTCRG_BARRIER_bean.CQS445O_MGTCRG_NBR_DBT_TRAN_A = '0';
        CQS445O_MGTCRG_BARRIER_bean.CQS445O_MGTCRG_NBR_DBT_TRAN = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_BARRIER = new List<CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_MGTCRG_BARRIER>{CQS445O_MGTCRG_BARRIER_bean};

        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_RSET_DESC_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_MGTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_BNK_STMTCRG_AMT_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_DATE_RSET_A = '0';

        CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHDEP CCQS445O_CSHDEP_bean = new CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHDEP();
        CCQS445O_CSHDEP_bean.CQS445O_CSHCRG_MCDF_FEE = '0';
        CCQS445O_CSHDEP_bean.CQS445O_CSHCRG_MCDF_FEE_A = '0';
        CCQS445O_CSHDEP_bean.CQS445O_CASH_DEP_FEE_TYPE = '0';
        CCQS445O_CSHDEP_bean.CQS445O_CSHCRG_BASE_FEE_A = '0';
        CCQS445O_CSHDEP_bean.CQS445O_CASH_DEP_FEE_TYPE_A = '0';
        CCQS445O_CSHDEP_bean.CQS445O_CSHCRG_BASE_FEE = '0';
        CCQS445O_CSHDEP_bean.CQS445O_D_CSHCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CSHDEP = new List<CQgetChargesDetailsMaintV9_Resp_IB_v1.CQS445O_CSHDEP>{CCQS445O_CSHDEP_bean};

        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_3 = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_2 = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ADMCRG_TYPE_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_1 = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FIX_FBK_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_FIX_AMT = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_BNK_STMTCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_ACB_DBT_CRG_CLASS_A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_CBP_SCHEME_DATE_RSET = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_MGTCRG_EASY_TIER = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_SERVICE_FEE_FORMULA_2A = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_TRNCRG_TYPE = '0';
        CQS445O_OUTPUT_AREA_bean.CQS445O_D_ADMCRG_TYPE = '0';        

        responseBean.NBSAPDPO = NBSAPDPO_bean;
        responseBean.NBSMSGO3 = NBSMSGO3_bean;
        responseBean.CQS445O = CQS445O_bean;
        responseBean.status = 'OK';
        responseBean.statusCode = 200;
        responseBean.message = 'test';

        return responseBean;
    }
}