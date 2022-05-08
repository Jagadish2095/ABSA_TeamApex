/**
* 
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CClistPrefProductForClientV2_IH_v2 {

    public static final String INTEGRATION_SERVICE_NAME = 'CClistPrefProductsForClientV2';
    
    public static CClistPrefProductForClientV2_Resp_IB_v2 cclistprefproductsforclient(CClistPrefProductForClientV2_Req_IB_v2 requestBean){

        CClistPrefProductForClientV2_Resp_IB_v2 responseBean = (CClistPrefProductForClientV2_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CClistPrefProductForClientV2_Resp_IB_v2.class);
        return responseBean;
    }
}