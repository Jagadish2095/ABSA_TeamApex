/**
* Descripton: Apex/Integration Handler class for cclistprefproductsforclientv2 service
* Test Class Name: CClistPrefProductForClientV2_IH_v1_Test
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-30
*
**/
public class CClistPrefProductForClientV2_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'cclistprefproductsforclientv2';
    
    public static CClistPrefProductForClientV2_Resp_IB_v1 cclistprefproductsforclient(CClistPrefProductForClientV2_Req_IB_v1 requestBean){
        CClistPrefProductForClientV2_Resp_IB_v1 responseBean = (CClistPrefProductForClientV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CClistPrefProductForClientV2_Resp_IB_v1.class);
        return responseBean;
    }
}