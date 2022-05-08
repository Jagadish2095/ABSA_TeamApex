/**
* Descripton: Apex/Integration Handler class for ccissuev2 service
* Test Class Name: CCIssueV2_IH_v1_Test
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CCIssueV2_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'ccissuev2';
    
    public static CCIssueV2_Resp_IB_v1 ccissue(CCIssueV2_Req_IB_v1 requestBean){
        CCIssueV2_Resp_IB_v1 responseBean = (CCIssueV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCIssueV2_Resp_IB_v1.class);
        return responseBean;
    }
    
}