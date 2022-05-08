/*
 * Request Integration Bean for CCApplicationService apply
 * @author Rajani Bommasani
 * @created 2020-10-07 
 */

public class CCApplicationService_apply_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'CCApplicationService apply';

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationService(CCApplicationService_apply_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServicePreScreen(CCApplicationService_PreScreen_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceClientUpdate(CCApplicationService_CltUpdate_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceFinalScoring(CCApplicationService_FnlScorng_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceComplete1(CCApplicationService_Complete1_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceComplete2(CCApplicationService_Complete2_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceQuoteAccept(CCApplicationService_QteAccept_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceInstantAccountOpening(CCApplicationService_InstAcc_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }

    public static CCApplicationService_apply_Resp_IB_v1 CCApplicationServiceInitiateDebiCheck(CCApplicationService_DebiCheck_Req_IB_v1 requestBean) {
        CCApplicationService_apply_Resp_IB_v1 responseBean = (CCApplicationService_apply_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CCApplicationService_apply_Resp_IB_v1.class);
        return responseBean;
    }
}