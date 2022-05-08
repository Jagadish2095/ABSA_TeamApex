public class ROTAddExcludedAccounts_IH_v1 {
    //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'Add Excluded Accounts';
    
    public static ROTAddExcludedAccounts_Resp_IB_v1 addExcludedAccounts(ROTAddExcludedAccounts_Req_IB_v1 requestBean) {
        ROTAddExcludedAccounts_Resp_IB_v1 responseBean = (ROTAddExcludedAccounts_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTAddExcludedAccounts_Resp_IB_v1.class);
        return responseBean;
        
    }
   
}