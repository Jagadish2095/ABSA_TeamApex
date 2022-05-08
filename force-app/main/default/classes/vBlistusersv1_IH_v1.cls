/*
 * Integration Handler class for vBlistusersv1 Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class vBlistusersv1_IH_v1 {
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'vblistusersv1';
	public static final String SERVICE_NAME = 'vBlistusersv1';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static vBlistusersv1_Resp_IB_v1 vBlistusersv1(String accNo,String userNo , String cifKey){
        vBlistusersv1_Req_IB_v1 requestBean = vBlistusersv1_IU_v1.mapRequestFields(accNo,userNo,cifKey);
        vBlistusersv1_Resp_IB_v1 responseBean = (vBlistusersv1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null,INTEGRATION_SERVICE_NAME, vBlistusersv1_Resp_IB_v1.class);
        return responseBean;
    }

}