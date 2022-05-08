/*
 * Integration Handler for MpsCreateMerchantPlanv1 Service
 * @author Prashant Jain
 * @created 2020-06-08
 */

public class MpsCreateMerchantPlanv1_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'MPS Create Merchant Plan V1';

    public static MpsCreateMerchantPlanv1_Resp_IB_v1 MpsCreateMerchantPlanv1(MpsCreateMerchantPlanv1_Req_IB_v1 requestBean) {
        MpsCreateMerchantPlanv1_Resp_IB_v1 responseBean = (MpsCreateMerchantPlanv1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MpsCreateMerchantPlanv1_Resp_IB_v1.class);
        return responseBean;
    }
}