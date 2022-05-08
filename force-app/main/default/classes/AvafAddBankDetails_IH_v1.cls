/*
 * Integration Handler class for AvafAddBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafAddBankDetails_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AVAF Add Bank Details';

    public static AvafAddBankDetails_Resp_IB_v1 AvafAddBankDetails(String partnerNumber, String accName, String accHolder, String bankRef, String bankAcc, String ctrlKey, String bankKey, String bankCtrlKey) {
        AvafAddBankDetails_Req_IB_v1 requestBean = AvafAddBankDetails_IU_v1.mapRequestFields(partnerNumber, accName, accHolder, bankRef, bankAcc, ctrlKey, bankKey, bankCtrlKey);

        AvafAddBankDetails_Resp_IB_v1 responseBean = (AvafAddBankDetails_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafAddBankDetails_Resp_IB_v1.class);
        return responseBean;
    }
}