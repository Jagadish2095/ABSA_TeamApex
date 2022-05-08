/*
 * Request Integration Bean for AvafAddBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafAddBankDetails_Req_IB_v1 extends Base_IB {
    public BAPI_BUPA_BANKDETAIL_ADD BAPI_SF_DO_BUPA_BANKDETAIL_ADD;

    public class BAPI_BUPA_BANKDETAIL_ADD {
        public String BUSINESSPARTNER;
        public String BANK_CTRY;
        public String BANK_KEY;
        public String CTRL_KEY;
        public String BANK_ACCT;
        public String BANKDETAILID;
        public String BANK_REF;
        public String ACCOUNTHOLDER;
        public String BANKACCOUNTNAME;
        public String BANKACCOUNTTYPE;
        public String I_USER;
    }

    public static AvafAddBankDetails_Req_IB_v1 createDummyRequest() {
        AvafAddBankDetails_Req_IB_v1 requestBean = new AvafAddBankDetails_Req_IB_v1();
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD = new AvafAddBankDetails_Req_IB_v1.BAPI_BUPA_BANKDETAIL_ADD();

        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BUSINESSPARTNER = '1000018076';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKACCOUNTTYPE = '';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKACCOUNTNAME = 'absa';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.ACCOUNTHOLDER = 'test holder';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_REF = 'my bank ref';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKDETAILID = '004';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_ACCT = '1024545457';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.CTRL_KEY = '2';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_KEY = '632005';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_CTRY = 'ZA';
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.I_USER = 'ab0131R';

        return requestBean;
    }
}