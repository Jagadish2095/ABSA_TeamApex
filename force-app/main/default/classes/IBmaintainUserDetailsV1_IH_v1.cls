/**
 * @description       : IBmaintainUserDetailsV1_IH_v1
 * @author            : Willy Zuvana
 * @last modified on  : 2021-07-21
 * @last modified by  : Willy zuvana
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-07-21   Willy Zuvana   Initial Version
**/
public class IBmaintainUserDetailsV1_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'IBmaintainUserDetailsV1';

    /**
    * @description IBmaintainUserDetailsV1
    * @author Willy zuvana | 2021-07-21
    * @param requestBean
    * @return IBmaintainUserDetailsV1_Resp_IB_v1
    **/
    public static IBmaintainUserDetailsV1_Resp_IB_v1 IBmaintainUserDetailsV1(IBmaintainUserDetailsV1_Req_IB_v1 requestBean) {
        IBmaintainUserDetailsV1_Resp_IB_v1 responseBean = (IBmaintainUserDetailsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBmaintainUserDetailsV1_Resp_IB_v1.class);
        return responseBean;
    }
}