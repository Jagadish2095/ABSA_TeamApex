public class ROTUpdateExcludedAccount_IH_V1 {

    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'UpdateExcludedAccount';
	public static final String SERVICE_NAME = 'UpdateExcludedAccount';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTUpdateExcludedAccount_Resp_IB_V1 updateExcludedAccount(ROTUpdateExcludedAccount_Req_IB_V1 requestBean) {
       ROTUpdateExcludedAccount_Resp_IB_V1 responseBean = (ROTUpdateExcludedAccount_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTUpdateExcludedAccount_Resp_IB_V1.class); 
       return responseBean;
    }
}