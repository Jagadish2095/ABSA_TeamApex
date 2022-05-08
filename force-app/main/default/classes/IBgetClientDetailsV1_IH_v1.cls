/*
 * Response from IBgetClientDetailsV1 Service
 * @author Khaliq Abdul
 * @created 2020-09-22
 */
public class IBgetClientDetailsV1_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'IBgetClientDetailsV1';

    public static IBgetClientDetailsV1_Resp_IB_v1 IBgetClientDetails(IBgetClientDetailsV1_Req_IB_v1 requestBean) {
        IBgetClientDetailsV1_Resp_IB_v1 responseBean = (IBgetClientDetailsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBgetClientDetailsV1_Resp_IB_v1.class);
        return responseBean;
    }
}