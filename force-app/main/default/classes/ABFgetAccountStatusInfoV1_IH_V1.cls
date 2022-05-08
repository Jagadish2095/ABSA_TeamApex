public class ABFgetAccountStatusInfoV1_IH_V1 {

    public static final String INTEGRATION_SERVICE_NAME = 'ABF Get Account Status Info V1';
    	
    public static ABFgetAccountStatusInfoV1_Resp_IB_V1 ABFgetAccountStatusInfoV1(ABFgetAccountStatusInfoV1_Req_IB_V1 requestBeanp){
        //ABFgetAccountStatusInfoV1_Req_IB_V1 requestBeanp = ABFgetAccountStatusInfoV1_Req_IB_V1.createDummyRequest();
        ABFgetAccountStatusInfoV1_Resp_IB_V1 responseBean = (ABFgetAccountStatusInfoV1_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, INTEGRATION_SERVICE_NAME, ABFgetAccountStatusInfoV1_Resp_IB_V1.class);
        system.debug('%%%responseBean'+responseBean);  
        system.debug(responseBean.nbsapdpo);
        system.debug(responseBean.nbsmsgo);
        system.debug(responseBean.plpa18o);
        return responseBean;
 
    }
}