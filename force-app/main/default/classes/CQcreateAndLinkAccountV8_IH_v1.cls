/*
 * Integration Handler for CQcreateAndLinkAccountV8 Service
 * @author Tracy de Bruin
 * @created 2020-11-03
 */

public class CQcreateAndLinkAccountV8_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CQ Create And Link Account V8';

    public static CQcreateAndLinkAccountV8_Resp_IB_v1 CQcreateAndLinkAccountV8(CQcreateAndLinkAccountV8_Req_IB_v1 requestBean) {
        CQcreateAndLinkAccountV8_Resp_IB_v1 responseBean = (CQcreateAndLinkAccountV8_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQcreateAndLinkAccountV8_Resp_IB_v1.class);
        return responseBean;
    }
}