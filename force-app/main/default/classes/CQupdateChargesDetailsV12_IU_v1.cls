public class CQupdateChargesDetailsV12_IU_v1 {
    
    //Techmagic

    public static CQupdateChargesDetailsV12_Req_IB_v1 mapRequestFields(Map<String, Object> requestFieldsValues) {

        CQupdateChargesDetailsV12_Req_IB_v1 requestBean = new CQupdateChargesDetailsV12_Req_IB_v1();

        CQupdateChargesDetailsV12_Req_IB_v1.NBSAPDPI NBSAPDPI_bean = new CQupdateChargesDetailsV12_Req_IB_v1.NBSAPDPI();
        CQupdateChargesDetailsV12_Req_IB_v1.NBSMSGI NBSMSGI_bean = new CQupdateChargesDetailsV12_Req_IB_v1.NBSMSGI();
        CQupdateChargesDetailsV12_Req_IB_v1.CQS446I CQS446I_bean = new CQupdateChargesDetailsV12_Req_IB_v1.CQS446I();

        CQupdateChargesDetailsV12_Req_IB_v1.NBSAPLI NBSAPLI_bean = new CQupdateChargesDetailsV12_Req_IB_v1.NBSAPLI();
        NBSAPLI_bean.channelName = 'Cheques';
        NBSAPLI_bean.applicationName = 'API';
        NBSAPLI_bean.traceIndicator = 'Y';

        CQupdateChargesDetailsV12_Req_IB_v1.NBSMSGI_internal NBSMSGI_internal_bean = new CQupdateChargesDetailsV12_Req_IB_v1.NBSMSGI_internal();
        NBSMSGI_internal_bean.NBNMSGI_MSG_LANGUAGE = 'E';
        NBSMSGI_internal_bean.NBNMSGI_MSG_TARGET = 'STD';

        CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_INPUT_AREA CQS446I_INPUT_AREA_bean = new CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_INPUT_AREA();

        /**
         * CQS445O_OUTPUT_AREA object is from CQgetChargesDetails response
         * "CQS446I_" fields of requestFieldsValues Map are new values from Delinking component to be updated
         */
        Map<Object, Object> cqs445o_output_area = (Map<Object, Object>) requestFieldsValues.get('CQS445O_OUTPUT_AREA');

        CQS446I_INPUT_AREA_bean.CQS446I_ACCOUNT_NBR = (String) requestFieldsValues.get('CQS446I_ACCOUNT_NBR');
        CQS446I_INPUT_AREA_bean.CQS446I_MANDATE_NUMBER = (String) requestFieldsValues.get('CQS446I_MANDATE_NUMBER');        
        CQS446I_INPUT_AREA_bean.CQS446I_CBP_SCHEME_CODE = (String) requestFieldsValues.get('CQS446I_CBP_SCHEME_CODE');
        CQS446I_INPUT_AREA_bean.CQS446I_CBP_SCHEME_START = (String) requestFieldsValues.get('CQS446I_CBP_SCHEME_START');
        CQS446I_INPUT_AREA_bean.CQS446I_SCHEME_RSET_DESC = (String) requestFieldsValues.get('CQS446I_SCHEME_RSET_DESC');
        CQS446I_INPUT_AREA_bean.CQS446I_NEXT_CHRG_CAP_DATE = (String) requestFieldsValues.get('CQS446I_NEXT_CHRG_CAP_DATE');
        ////
        User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());

        CQS446I_INPUT_AREA_bean.CQS446I_PROCESSING_SITE = Long.valueOf(loggedInUserInfo.SiteCode__c);
        CQS446I_INPUT_AREA_bean.CQS446I_PROCESSING_SITE_TYPE = '034';
        CQS446I_INPUT_AREA_bean.CQS446I_TELLER_NBR = (Long) 2334;
        CQS446I_INPUT_AREA_bean.CQS446I_AGENCY_CODE = (Long) 0;
        CQS446I_INPUT_AREA_bean.CQS446I_AGENCY_TYPE = '';
        CQS446I_INPUT_AREA_bean.CQS446I_CONTROLLER_NBR = (Long) 2334;
        CQS446I_INPUT_AREA_bean.CQS446I_CORP_CODE = 'ABS';
        //CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_CAT = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_CAT = (String) cqs445o_output_area.get('CQS445O_CHARGE_CAT');

        // CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_FREQ = 'M';
        CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_FREQ = (String) requestFieldsValues.get('CQS446I_CHARGE_FREQ');
        // CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_CAP_DAY = '3';
        CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_CAP_DAY = (String) cqs445o_output_area.get('CQS445O_CHARGE_CAP_DAY');
        //CQS446I_INPUT_AREA_bean.CQS446I_NEXT_CHRG_CAP_DATE = (Long) 20210403;//cap date??
        // CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_TYPE = (String) cqs445o_output_area.get('CQS445O_SERVICE_FEE_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_1 = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_1 = Double.valueOf((String) cqs445o_output_area.get('CQS445O_SERVICE_FEE_FORMULA_1'));
        // CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_2 = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_2 = Double.valueOf((String) cqs445o_output_area.get('CQS445O_SERVICE_FEE_FORMULA_2'));
        // CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_3 = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_SERVICE_FEE_FORMULA_3 = Double.valueOf((String) cqs445o_output_area.get('CQS445O_SERVICE_FEE_FORMULA_3'));

        // CQS446I_INPUT_AREA_bean.CQS446I_FIX_AMT = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_FIX_AMT = Double.valueOf((String) cqs445o_output_area.get('CQS445O_FIX_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_MONTH_MIN = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_MONTH_MIN = Double.valueOf((String) cqs445o_output_area.get('CQS445O_MONTH_MIN'));
        
        //cashDeps
        List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHDEP_DETAIL> cashDepsList = new List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHDEP_DETAIL>();
        for (Object cashDep : (List<Object>)requestFieldsValues.get('CQS446I_CSHDEP_DETAIL')) {
            Map<Object, Object> cashDepMap = (Map<Object, Object>) cashDep;

            CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHDEP_DETAIL cashDepRequest = new CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHDEP_DETAIL();

            cashDepRequest.CQS446I_CSHCRG_BASE_FEE = Double.valueOf((String) cashDepMap.get('CQS445O_CSHCRG_BASE_FEE'));
            cashDepRequest.CQS446I_CASH_DEP_FEE_TYPE = (String) cashDepMap.get('CQS445O_CASH_DEP_FEE_TYPE');
            cashDepRequest.CQS446I_CSHCRG_MCDF_FEE = Double.valueOf((String) cashDepMap.get('CQS445O_CSHCRG_MCDF_FEE'));

            cashDepsList.add(cashDepRequest);
        }
        CQS446I_INPUT_AREA_bean.CQS446I_CSHDEP_DETAIL = cashDepsList;
        //END cashDeps

        //cashCharges
        List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHCRG> cashChargesRequestList = new List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHCRG>();
        
        for (Object cashCharge : (List<Object>)requestFieldsValues.get('CQS446I_CSHCRG')) {
            Map<Object, Object> cashChargeMap = (Map<Object, Object>) cashCharge;

            CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHCRG cashChargeRequest = new CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_CSHCRG();

            cashChargeRequest.CQS446I_CSHCRG_DEP_AMT = Long.valueOf((String) cashChargeMap.get('CQS445O_CSHCRG_DEP_AMT'));
            cashChargeRequest.CQS446I_CSHCRG_PERC = Integer.valueOf((String) cashChargeMap.get('CQS445O_CSHCRG_PERC'));

            cashChargesRequestList.add(cashChargeRequest);
        }
        CQS446I_INPUT_AREA_bean.CQS446I_CSHCRG = cashChargesRequestList;
        //END cashCharges

        // CQS446I_INPUT_AREA_bean.CQS446I_ACB_DBT_CRG_CLASS = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_ACB_DBT_CRG_CLASS = (String) cqs445o_output_area.get('CQS445O_ACB_DBT_CRG_CLASS');
        // CQS446I_INPUT_AREA_bean.CQS446I_TRNCRG_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_TRNCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_TRNCRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_ADMCRG_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_ADMCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_ADMCRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_OD_LDGR_CRG_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_OD_LDGR_CRG_TYPE = (String) cqs445o_output_area.get('CQS445O_OD_LDGR_CRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_OD_LDGR_FIXED_AMT = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_OD_LDGR_FIXED_AMT = Double.valueOf((String) cqs445o_output_area.get('CQS445O_OD_LDGR_FIXED_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_EXCESS_CRG_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_EXCESS_CRG_TYPE = (String) cqs445o_output_area.get('CQS445O_EXCESS_CRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_EXCESS_CRG_AMT = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_EXCESS_CRG_AMT = Double.valueOf((String) cqs445o_output_area.get('CQS445O_EXCESS_CRG_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_EXPIRY_DATE = (Long) 99999999;
        CQS446I_INPUT_AREA_bean.CQS446I_CHARGE_EXPIRY_DATE = Long.valueOf((String) cqs445o_output_area.get('CQS445O_CHARGE_EXPIRY_DATE'));
        // CQS446I_INPUT_AREA_bean.CQS446I_BNK_STMTCRG_TYPE = 'P';
        CQS446I_INPUT_AREA_bean.CQS446I_BNK_STMTCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_BNK_STMTCRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_BNK_STMTCRG_AMT = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_BNK_STMTCRG_AMT = Double.valueOf((String) cqs445o_output_area.get('CQS445O_BNK_STMTCRG_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_INT_STMTCRG_TYPE = 'P';CQS445O_INT_STMTCRG_TYPE
        CQS446I_INPUT_AREA_bean.CQS446I_INT_STMTCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_INT_STMTCRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_INT_STMTCRG_AMT = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_INT_STMTCRG_AMT = Double.valueOf((String) cqs445o_output_area.get('CQS445O_INT_STMTCRG_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_GVTLVY_TYPE = 'E';
        CQS446I_INPUT_AREA_bean.CQS446I_GVTLVY_TYPE = (String) cqs445o_output_area.get('CQS445O_GVTLVY_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_FBKCRG_TYPE = '*';
        CQS446I_INPUT_AREA_bean.CQS446I_FBKCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_FBKCRG_TYPE');
        // CQS446I_INPUT_AREA_bean.CQS446I_MINBAL_AMT = 0;
        CQS446I_INPUT_AREA_bean.CQS446I_MINBAL_AMT = Long.valueOf((String) cqs445o_output_area.get('CQS445O_MINBAL_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_TYPE = '*';
        CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_TYPE = (String) cqs445o_output_area.get('CQS445O_MGTCRG_TYPE');

        //mgtcrgBariers
        List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_MGTCRG_BARRIER> bariersRequestList = new List<CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_MGTCRG_BARRIER>();
        
        for (Object barier : (List<Object>)requestFieldsValues.get('CQS446I_MGTCRG_BARRIER')) {
            Map<Object, Object> barierMap = (Map<Object, Object>) barier;

            CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_MGTCRG_BARRIER barierRequest = new CQupdateChargesDetailsV12_Req_IB_v1.CQS446I_MGTCRG_BARRIER();

            barierRequest.CQS446I_MGTCRG_NBR_DBT_TRAN = Long.valueOf((String) barierMap.get('CQS445O_MGTCRG_NBR_DBT_TRAN'));
            barierRequest.CQS446I_MGTCRG_MNTH_FEE = Double.valueOf((String) barierMap.get('CQS445O_MGTCRG_MNTH_FEE'));

            bariersRequestList.add(barierRequest);
        }
        CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_BARRIER = bariersRequestList;
        //END mgtcrgBariers

        // CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_EASY_FLAT_FEE = 0.00;
        CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_EASY_FLAT_FEE = Double.valueOf((String) cqs445o_output_area.get('CQS445O_MGTCRG_EASY_FLAT_FEE'));
        // CQS446I_INPUT_AREA_bean.CQS446I_FIX_FBK_AMT = 0;
        CQS446I_INPUT_AREA_bean.CQS446I_FIX_FBK_AMT = Long.valueOf((String) cqs445o_output_area.get('CQS445O_FIX_FBK_AMT'));
        // CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_EASY_TIER = 0;
        CQS446I_INPUT_AREA_bean.CQS446I_MGTCRG_EASY_TIER = Long.valueOf((String) cqs445o_output_area.get('CQS445O_MGTCRG_EASY_TIER'));
        CQS446I_INPUT_AREA_bean.CQS446I_PRIMARY_ACCOUNT = 0;
        CQS446I_INPUT_AREA_bean.CQS446I_SCHEME_DATE_RSET = '';
        // CQS446I_INPUT_AREA_bean.CQS446I_CBP_CRGSTMT_REQ = 'N';
        CQS446I_INPUT_AREA_bean.CQS446I_CBP_CRGSTMT_REQ = (String) cqs445o_output_area.get('CQS445O_CBP_CRGSTMT_REQ');
        CQS446I_INPUT_AREA_bean.CQS446I_UNIQUE_PACKAGE_ID = 0;
        CQS446I_INPUT_AREA_bean.CQS446I_OPTION = 'U';
        ////

        NBSAPDPI_bean.NBSAPLI = NBSAPLI_bean;
        NBSMSGI_bean.NBSMSGI = NBSMSGI_internal_bean;
        CQS446I_bean.CQS446I_INPUT_AREA = CQS446I_INPUT_AREA_bean;

        requestBean.NBSAPDPI = NBSAPDPI_bean;
        requestBean.NBSMSGI = NBSMSGI_bean;
        requestBean.CQS446I = CQS446I_bean;

        return requestBean;
    }

    public static CQupdateChargesDetailsV12_Resp_IB_v1 mapFailedResponseFields(String status, Integer statusCode, String message){
        CQupdateChargesDetailsV12_Resp_IB_v1 responseBean = new CQupdateChargesDetailsV12_Resp_IB_v1();
        responseBean.status = status;
        responseBean.statusCode = statusCode;
        responseBean.message = message;
        
        return responseBean;
    }
}