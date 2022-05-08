/*
 * Integration Handler class for AvafGetBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafGetBankDetails_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AVAF Get Bank Details';

    public static AvafGetBankDetails_Resp_IB_v1 AvafGetBankDetails(String businessPartnerNumber) {
        AvafGetBankDetails_Req_IB_v1 requestBean = AvafGetBankDetails_IU_v1.mapRequestFields(businessPartnerNumber);

        AvafGetBankDetails_Resp_IB_v1 responseBean = (AvafGetBankDetails_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafGetBankDetails_Resp_IB_v1.class);
        return responseBean;
    }
}