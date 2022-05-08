/**
* Class Name: ROTExpireSchemeNodes_IH_v1
* @author  	: Manish
* @since   	: 2021-1-19
**/
public class ROTExpireSchemeNodes_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'ExpireSchemeNodes';
	public static final String SERVICE_NAME = 'ExpireSchemeNodes';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTExpireSchemeNodes_Resp_IB_v1 getExpireSchemeNodes(ROTExpireSchemeNodes_Req_IB_v1 requestBean) {
       ROTExpireSchemeNodes_Resp_IB_v1 responseBean = (ROTExpireSchemeNodes_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTExpireSchemeNodes_Resp_IB_v1.class); 
       return responseBean;
    }
}