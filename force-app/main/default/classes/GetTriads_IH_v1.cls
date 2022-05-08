/*
* Integration Handler for Triad Service
* @author Almas Aleem:Absa 
* @created 2020-09-16
*/
public class GetTriads_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'GetTriads';
   
    public static GetTriads_Resp_IB_v1 GetTriads(String clientCode) {
          GetTriads_Req_IB_v1 requestBean = GetTriads_IU_v1.mapRequestFields(clientCode); //request mapping
        	system.debug('requestBean'+requestBean);
          GetTriads_Resp_IB_v1 responseBean = (GetTriads_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetTriads_Resp_IB_v1.class); //service callout
        return responseBean;
    }
 

}