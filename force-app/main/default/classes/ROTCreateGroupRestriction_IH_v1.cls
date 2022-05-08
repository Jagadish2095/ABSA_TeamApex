public class ROTCreateGroupRestriction_IH_v1 {
      //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'CreateGroupRestriction';
	public static final String SERVICE_NAME = 'CreateGroupRestriction';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTCreateGroupRestriction_Resp_IB_v1 CreateGroupRestriction(ROTCreateGroupRestriction_Req_IB_v1 requestBean) {
       ROTCreateGroupRestriction_Resp_IB_v1 responseBean = (ROTCreateGroupRestriction_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTCreateGroupRestriction_Resp_IB_v1.class); 
       return responseBean;
    }  
}