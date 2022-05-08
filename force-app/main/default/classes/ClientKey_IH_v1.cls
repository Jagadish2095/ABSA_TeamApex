/**
* @description Service for ClientKey for package linking
* @author Satya Boyenepalli
* @created 2021-02-25
*/
/**
 * @description  ClientKey  Service
 */
public class ClientKey_IH_v1 {
     public static final String INTEGRATION_SERVICE_NAME = 'clientKey';
    	/**
 * @description GetLinkProductsByClientKey method
 * @param  requestBean
 * @return ClientKey_Resp_IB_v1
 */
     public static ClientKey_Resp_IB_v1 GetLinkProductsByClientKey(ClientKey_Req_IB_v1 requestBean) {
       ClientKey_Resp_IB_v1 responseBean = (ClientKey_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ClientKey_Resp_IB_v1.class);
      return responseBean;
    }

}