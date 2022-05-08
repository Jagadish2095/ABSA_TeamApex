/*
* Integration Handler Bean for CCIssueCombiCardV2 Service
 * @author André Pietersen
 * @created 2020-11-15
*/
public class CCIssueCombiCardV1_IH_v2 {

    
        public static final String INTEGRATION_SERVICE_NAME = 'CCissue Combi CardV1';
        
        public static  CCIssueCombiCardV1_Resp_IB_v1 CCIssueCombiCardV1(CCissueCombiCardV1_Req_IB_v1 requestBean){
            CCIssueCombiCardV1_Resp_IB_v1 responseBean = (CCIssueCombiCardV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  CCIssueCombiCardV1_Resp_IB_v1.class);
            return responseBean;
        }
    }