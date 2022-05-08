public class ROTAddExcludedAccount_IH_v1 {
    //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'AddExcludedAccount';
    public static final String SERVICE_NAME = 'AddExcludedAccount';
 
    
    
    public static ROTAddExcludedAccount_Resp_IB_v1 AddExcludedAccount(ROTAddExcludedAccount_Req_IB_v1 requestBean) {
        ROTAddExcludedAccount_Resp_IB_v1 responseBean = (ROTAddExcludedAccount_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTAddExcludedAccount_Resp_IB_v1.class); 
        return responseBean;
    }
}