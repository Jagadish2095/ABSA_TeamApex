/*
 * Integration Handler for IBupdIBRegistrationDetailsV2 Service
 * @author Linda Motaung
 * @created 2020-10-15
 */
/**
 * @description IBupdIBRegistrationDetailsV2_IH_v1
 */
public class IBupdIBRegistrationDetailsV2_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'IBupdIBRegistrationDetailsV2';
 /**
	 * @description       : IBupdIBRegistrationDetailsV2_Resp_IB_v1
	 * @param requestBean
	 * @return IBupdIBRegistrationDetailsV2_Resp_IB_v1
	 **/
    public static IBupdIBRegistrationDetailsV2_Resp_IB_v1 IBupdIBRegistrationDetailsV2(IBupdIBRegistrationDetailsV2_Req_IB_v1 requestBean) {
        IBupdIBRegistrationDetailsV2_Resp_IB_v1 responseBean = (IBupdIBRegistrationDetailsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBupdIBRegistrationDetailsV2_Resp_IB_v1.class);
        return responseBean;
    }
     /**
	 * @description       : IBupdIBRegistrationDetailsV3
	 * @param requestBean
	 * @return IBupdIBRegistrationDetailsV2_Resp_IB_v2
	 **/
    public static IBupdIBRegistrationDetailsV2_Resp_IB_v2 IBupdIBRegistrationDetailsV3(IBupdIBRegistrationDetailsV2_Req_IB_v1 requestBean) {
        IBupdIBRegistrationDetailsV2_Resp_IB_v2 responseBean = (IBupdIBRegistrationDetailsV2_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBupdIBRegistrationDetailsV2_Resp_IB_v2.class);
        return responseBean;
    }
}