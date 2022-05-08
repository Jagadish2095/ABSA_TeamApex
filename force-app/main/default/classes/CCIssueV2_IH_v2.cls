public class CCIssueV2_IH_v2 {

    public static final String INTEGRATION_SERVICE_NAME = 'CCissueV2';
    
    public static CCIssueV2_Resp_IB_v2 ccissue(CCIssueV2_Req_IB_v2 requestBean){
        CCIssueV2_Resp_IB_v2 responseBean = (CCIssueV2_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCIssueV2_Resp_IB_v2.class);
        return responseBean;
    }
}