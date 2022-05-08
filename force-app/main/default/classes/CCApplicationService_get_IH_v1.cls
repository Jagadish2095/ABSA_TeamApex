/*
 * CCApplicationService get
 * @author Aaron Castelyn: ABSA
 * @created 2021-03-25 
 */

public class CCApplicationService_get_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CCApplicationService get';

    public static CCApplicationService_get_Resp_IB_v1 GetApplicationInformation(CCApplicationService_get_Req_IB_v1 requestBean) {
        CCApplicationService_get_Resp_IB_v1 responseBean = (CCApplicationService_get_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_get_Resp_IB_v1.class);
        return responseBean;
    }
}