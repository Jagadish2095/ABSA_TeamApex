/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-30
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/**
  * @description IBupdIBLimitsV2
 */
public class IBupdIBLimitsV2_IH_v1 {

public static final String INTEGRATION_SERVICE_NAME = 'IBupdIBLimitsV2';

/**
 * @param requestBean
 * @description IBupdIBLimitsV2
 * @return IBupdIBLimitsV2_Resp_IB_v1
 * 
 */
    public static IBupdIBLimitsV2_Resp_IB_v1 IBupdIBLimitsV2(IBupdIBLimitsV2_Req_IB_v1 requestBean) {
        IBupdIBLimitsV2_Resp_IB_v1 responseBean = (IBupdIBLimitsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBupdIBLimitsV2_Resp_IB_v1.class);
        return responseBean;
    }
}