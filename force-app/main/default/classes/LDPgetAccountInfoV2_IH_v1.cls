/**
 * @description Integration handler class for LDPgetAccountInfoV2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class LDPgetAccountInfoV2_IH_v1{
	public static final String INTEGRATION_SERVICE_NAME = 'LDPgetAccountInfoV2';
/**
 * @description executeService description
 *
 * @param requestBean (LDPgetAccountInfoV2_Req_IB_v1): requestBean
 * @return LDPgetAccountInfoV2_Resp_IB_v1: Return description
 */
    public static LDPgetAccountInfoV2_Resp_IB_v1 executeService(LDPgetAccountInfoV2_Req_IB_v1 requestBean){
		LDPgetAccountInfoV2_Resp_IB_v1 responseBean = (LDPgetAccountInfoV2_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, LDPgetAccountInfoV2_Resp_IB_v1.class);

		return responseBean;
	}
}