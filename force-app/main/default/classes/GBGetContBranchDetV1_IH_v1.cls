/*
 * Integration Handler for GBGetContBranchDetV1 Service
 * @author Saurabh Pandey
 * @created 2020-09-21
 */

public class GBGetContBranchDetV1_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'GBGetContBranchDetV1';

    public static GBGetContBranchDetV1_Resp_IB_v1 GBGetContBranchDetV1(String clientCode) {
        GBGetContBranchDetV1_Req_IB_v1 requestBean = GBGetContBranchDetV1_IU_v1.mapRequestFields(clientCode);
        GBGetContBranchDetV1_Resp_IB_v1 responseBean = (GBGetContBranchDetV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GBGetContBranchDetV1_Resp_IB_v1.class);
        return responseBean;
    }

    public static GBGetContBranchDetV1_Resp_IB_v1 GBGetContBranchDetV1(GBGetContBranchDetV1_Req_IB_v1 requestBean) {
        GBGetContBranchDetV1_Resp_IB_v1 responseBean = (GBGetContBranchDetV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GBGetContBranchDetV1_Resp_IB_v1.class);
        return responseBean;
    }
}