public class ABFupdAccountStatusV1_IH_V1 {

    /*
* Integration Handler for ABFupdAccountStatusV1 Service 
* @author Gulafsha
* @created 2020-11-30
*/
    
    public static final String INTEGRATION_SERVICE_NAME = 'ABF Update Account Status';
    
    public static ABFupdAccountStatusV1_Resp_IB_V1 ABFupdAccountStatusV1(ABFupdAccountStatusV1_Req_IB_V1  requestBeanP){
    //ABFupdAccountStatusV1_Req_IB_V1  requestBeanP = ABFupdAccountStatusV1_Req_IB_V1.createDummyRequest();
    ABFupdAccountStatusV1_Resp_IB_V1 responseBean = (ABFupdAccountStatusV1_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, INTEGRATION_SERVICE_NAME, ABFupdAccountStatusV1_Resp_IB_V1.class);
    system.debug('responseBean'+responseBean);  
    system.debug('responseBean nbsapdpo'+responseBean.nbsapdpo);
    system.debug('responseBean nbsmsgo3'+responseBean.nbsmsgo3);
    system.debug('responseBean plpa03o'+responseBean.plpa03o);
    return responseBean;
 }

}