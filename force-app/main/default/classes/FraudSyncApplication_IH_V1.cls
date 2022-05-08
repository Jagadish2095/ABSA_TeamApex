/*
 * Integration Handler for FraudSyncApplication Service
 * @author André Pietersen
 * @created 2020-11-04
 */
public class FraudSyncApplication_IH_V1 {
    public static final String INTEGRATION_SERVICE_NAME = 'FraudSyncApplication';

    public static FraudSyncApplication_Resp_IB_V1 syncFraudApplication(FraudSyncApplication_Req_IB_V1 requestBean) {
        FraudSyncApplication_Resp_IB_V1 responseBean = (FraudSyncApplication_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, FraudSyncApplication_Resp_IB_V1.class);
        return responseBean;
    }
}