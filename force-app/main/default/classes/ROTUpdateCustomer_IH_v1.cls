/**
* Class Name: ROTUpdateCustomer_IH_v1
* @author  	: Manish
**/
public class ROTUpdateCustomer_IH_v1 {

    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'UpdateCustomerV1';
	public static final String SERVICE_NAME = 'UpdateCustomerV1';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTUpdateCustomer_Resp_IB_v1 updateCustomer(ROTUpdateCustomer_Req_IB_v1 requestBean) {
       ROTUpdateCustomer_Resp_IB_v1 responseBean = (ROTUpdateCustomer_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTUpdateCustomer_Resp_IB_v1.class); 
       return responseBean;
    }
}