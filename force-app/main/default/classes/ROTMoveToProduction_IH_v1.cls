public class ROTMoveToProduction_IH_v1 {

    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'MoveToProduction';
	public static final String SERVICE_NAME = 'MoveToProduction';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTMoveToProduction_Resp_IB_V1 moveToProduction(ROTMoveToProduction_Req_IB_V1 requestBean) {
       ROTMoveToProduction_Resp_IB_V1 responseBean = (ROTMoveToProduction_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTMoveToProduction_Resp_IB_V1.class); 
       return responseBean;
      // Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTMoveToProduction_Resp_IB_V1.class); 
      
    }
}