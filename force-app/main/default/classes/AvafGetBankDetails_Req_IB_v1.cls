/*
 * Request Integration Bean for AvafGetPartner Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafGetBankDetails_Req_IB_v1 extends Base_IB {
    public BAPI_BUPA_BANKDETAILS_GET BAPI_BUPA_BANKDETAILS_GET;

    public class BAPI_BUPA_BANKDETAILS_GET {
        public String BUSINESSPARTNER;
        public String VALID_DATE;
    }

    public static AvafGetBankDetails_Req_IB_v1 createDummyRequest() {
        AvafGetBankDetails_Req_IB_v1 requestBean = new AvafGetBankDetails_Req_IB_v1();
        requestBean.BAPI_BUPA_BANKDETAILS_GET = new AvafGetBankDetails_Req_IB_v1.BAPI_BUPA_BANKDETAILS_GET();

        requestBean.BAPI_BUPA_BANKDETAILS_GET.BUSINESSPARTNER = '1000019193';
        requestBean.BAPI_BUPA_BANKDETAILS_GET.VALID_DATE = '';

        return requestBean;
    }
}