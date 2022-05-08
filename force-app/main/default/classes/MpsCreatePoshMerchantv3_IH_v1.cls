/*
 * Integration Handler for MpsCreatePoshMerchantv3 Service
 * @author Prashant Jain
 * @created 2020-06-08
 */

public class MpsCreatePoshMerchantv3_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'MPS Create Posh Merchant V3';

    public static MpsCreatePoshMerchantv3_Resp_IB_v1 MpsCreatePoshMerchantv3(MpsCreatePoshMerchantv3_Req_IB_v1 requestBean) {
        MpsCreatePoshMerchantv3_Resp_IB_v1 responseBean = (MpsCreatePoshMerchantv3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MpsCreatePoshMerchantv3_Resp_IB_v1.class);
        return responseBean;
    }
}