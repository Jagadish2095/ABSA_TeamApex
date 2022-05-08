/*
 * Integration Handler class for getTbUserBasicLimits Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class getTbUserBasicLimits_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'getTbUserBasicLimits';
	public static final String SERVICE_NAME = 'getTbUserBasicLimits';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static getTbUserBasicLimits_Resp_IB_v1 getTbUserBasicLimits(String  customerCifKeyP,String userNumberP){
        getTbUserBasicLimits_Req_IB_v1 requestBean = getTbUserBasicLimits_IU_v1.mapRequestFields(customerCifKeyP,userNumberP);
        getTbUserBasicLimits_Resp_IB_v1 responseBean = (getTbUserBasicLimits_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, getTbUserBasicLimits_Resp_IB_v1.class);
        return responseBean;
    }
        
    
}