/*
 * Integration Handler for CQcreateAndLinkAccountV9 Service
 * @author André Pietersen
 * @created 2020-10-30
 */

public class CQcreateAndLinkAccountV9_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CQcreateAndLinkAccountV9';

    public static CQcreateAndLinkAccountV9_Resp_IB_v1 createAndLinkAccount(CQcreateAndLinkAccountV9_Req_IB_v1 requestBean) {
        CQcreateAndLinkAccountV9_Resp_IB_v1 responseBean = (CQcreateAndLinkAccountV9_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQcreateAndLinkAccountV9_Resp_IB_v1.class);
        return responseBean;
    }
}