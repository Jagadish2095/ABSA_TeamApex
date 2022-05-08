/**
 * Integration Handler for GBgetCmsCreditGroupsDetV1 Service
 * @author Englarmerdge Mongwe
 * @created 2020-10-13
 */

public class GBgetCmsCreditGroupsDetV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'GB Get Cms Credit Groups Det V1';

    public static GBgetCmsCreditGroupsDetV1_Resp_IB_v1 gbGetCmsCreditGroupsDetV1(String clientCode) {
        GBgetCmsCreditGroupsDetV1_Req_IB_v1 requestBean = GBgetCmsCreditGroupsDetV1_IU_v1.mapRequestFields(clientCode);
        GBgetCmsCreditGroupsDetV1_Resp_IB_v1 responseBean = (GBgetCmsCreditGroupsDetV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GBgetCmsCreditGroupsDetV1_Resp_IB_v1.class);
        return responseBean;
    }
}