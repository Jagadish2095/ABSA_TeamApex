/*
 * Request Integration Bean for AvafChangeDebit Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafChangeDebitOrder_Req_IB_v1 extends Base_IB {
    public List<BAPI_SF_DO_CHG> BAPI_SF_DO_CHG;
    public String I_ACCOUNT;
    public String I_USER;
    public String I_ACTION;

    public class BAPI_SF_DO_CHG {
        public String ZDEBIT_ORDER;
        public String ZCOLDAY;
        public String ZCOLSTARTDATE;
        public String ZCOLENDDATE;
        public String ZCOLAMOUNT;
        public String ZCOLBANKID;
        public String ZBANK_ACC;
        public String ZSTATUS;
    }

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('ZCOLBANKID___', 'ZCOLBANKID');
        fieldNameSubstitutionMap.put('ZBANK_ACC_', 'ZBANK_ACC');
        fieldNameSubstitutionMap.put('ZSTATUS______', 'ZSTATUS');
    }

    public override void setIntegrationTranslations() {
        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put('BAPI_SF_DO_CHG.ZDEBIT_ORDER', 'SAP;Debit Order Type');
    }

    public static AvafChangeDebitOrder_Req_IB_v1 createDummyRequest() {
        AvafChangeDebitOrder_Req_IB_v1 requestBean = new AvafChangeDebitOrder_Req_IB_v1();
        requestBean.BAPI_SF_DO_CHG = new List<AvafChangeDebitOrder_Req_IB_v1.BAPI_SF_DO_CHG>();
        BAPI_SF_DO_CHG BSDC = new BAPI_SF_DO_CHG();
        BSDC.ZDEBIT_ORDER = '1';
        BSDC.ZCOLDAY = '1';
        BSDC.ZCOLSTARTDATE = '2017-01-01';
        BSDC.ZCOLENDDATE = '2021-09-01';
        BSDC.ZCOLAMOUNT = '7066.88';
        BSDC.ZCOLBANKID = '0002';
        BSDC.ZBANK_ACC = '4047731050';
        BSDC.ZSTATUS = 'ACTIVE';
        requestBean.I_ACCOUNT = '00077129389';
        requestBean.I_ACTION = 'Add';
        requestBean.I_USER = 'ab0131R';
        requestBean.BAPI_SF_DO_CHG.add(BSDC);

        return requestBean;
    }
}