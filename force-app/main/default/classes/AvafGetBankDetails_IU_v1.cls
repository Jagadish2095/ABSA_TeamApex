/*
 * Integration Utility class for AvafGetBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafGetBankDetails_IU_v1 {
    public static AvafGetBankDetails_Req_IB_v1 mapRequestFields(String businessPartnerNumber) {
        AvafGetBankDetails_Req_IB_v1 requestBean = new AvafGetBankDetails_Req_IB_v1();
        requestBean.BAPI_BUPA_BANKDETAILS_GET = new AvafGetBankDetails_Req_IB_v1.BAPI_BUPA_BANKDETAILS_GET();

        requestBean.BAPI_BUPA_BANKDETAILS_GET.BUSINESSPARTNER = businessPartnerNumber;
        requestBean.BAPI_BUPA_BANKDETAILS_GET.VALID_DATE = ''; //Which value should be passed here?

        return requestBean;
    }
}