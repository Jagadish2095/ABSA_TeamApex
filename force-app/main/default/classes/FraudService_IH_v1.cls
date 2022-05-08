/**
* @description       :
* Test Integration Handler for FraudService_IH_v1 Service
* @author Nkaiseng Malete
* @created 2021-09-17
*/
public without sharing class FraudService_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'FraudServiceV2';
    /**
	 * @description FraudService
	 * @return FraudService_Resp_IB_v1
	 * @param requestBean
	 */
    public static FraudService_Resp_IB_v1 FraudService(FraudService_Req_IB_v1 requestBean) {
        FraudService_Resp_IB_v1 responseBean = (FraudService_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, FraudService_Resp_IB_v1.class);
        return responseBean;

    }
}