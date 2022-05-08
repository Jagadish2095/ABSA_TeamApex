public class ROTUpdateGroupRestriction_IH_v1 {
	  //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'UpdateGroupRestriction';
	public static final String SERVICE_NAME = 'UpdateGroupRestriction';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTUpdateGroupRestriction_IB_Resp_v1 UpdateGroupRestriction(ROTUpdateGroupRestriction_IB_Req_v1 requestBean) {
       ROTUpdateGroupRestriction_IB_Resp_v1 responseBean = (ROTUpdateGroupRestriction_IB_Resp_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTUpdateGroupRestriction_IB_Resp_v1.class); 
       return responseBean;
    }  
}