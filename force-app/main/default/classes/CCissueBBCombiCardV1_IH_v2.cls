/**
* 
* 
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_IH_v2 {

    public static final String COMBICARD_SERVICE_NAME = 'ccissuebbcombicardv1';

    public static CCissueBBCombiCardV1_Resp_IB_v2 issueCombiCard(CCissueBBCombiCardV1_Req_IB_v2 requestBean) {
        CCissueBBCombiCardV1_Resp_IB_v2 responseBean = (CCissueBBCombiCardV1_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, COMBICARD_SERVICE_NAME, CCissueBBCombiCardV1_Resp_IB_v2.class);
        return responseBean;
    }
}