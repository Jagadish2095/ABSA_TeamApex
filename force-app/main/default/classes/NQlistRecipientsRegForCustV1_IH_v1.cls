/*
 * Integration from NQlistRecipientsRegForCustV1 Service
 * @author Khaliq Abdul
 * @created 2020-11-20
 */
public class NQlistRecipientsRegForCustV1_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'nqlistrecipientsregisteredforcustv1';

    public static NQlistRecipientsRegForCustV1_Resp_IB_v1 NQlistRecipientsRegForCustV1(NQlistRecipientsRegForCustV1_Req_IB_v1 requestBean) {
        NQlistRecipientsRegForCustV1_Resp_IB_v1 responseBean = (NQlistRecipientsRegForCustV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, NQlistRecipientsRegForCustV1_Resp_IB_v1.class);
        return responseBean;
    }
}