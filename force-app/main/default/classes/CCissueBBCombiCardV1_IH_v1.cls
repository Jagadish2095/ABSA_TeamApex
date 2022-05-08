/**
* Descripton: Apex/Integration Handler class for CCissueBBCombiCardV1 service
* Test Class Name: CCissueBBCombiCardV1_IH_v1_Test
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'ccissuebbcombicardv1';
    
    public static CCissueBBCombiCardV1_Resp_IB_v1 ccissueBBCombiCard(CCissueBBCombiCardV1_Req_IB_v1 requestBean){
        CCissueBBCombiCardV1_Resp_IB_v1 responseBean = (CCissueBBCombiCardV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCissueBBCombiCardV1_Resp_IB_v1.class);
        return responseBean;
    }

}