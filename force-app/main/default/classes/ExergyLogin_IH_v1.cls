/*
 * Integration Handler for exergyLogin Service
 * @author chandra Bhushan Singh
 * @created 2021-02-04
 * @W-007772,007776,007778,007777,007783
 */

public class ExergyLogin_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'exergyLogin';

    public static ExergyLogin_Resp_IB_v1 exergyLogin(String sessionID) {
        ExergyLogin_Req_IB_v1 requestBean = ExergyLogin_IU_v1.mapRequestFields(sessionID);
        ExergyLogin_Resp_IB_v1 responseBean = (ExergyLogin_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, ExergyLogin_Resp_IB_v1.class);
        return responseBean;
    }
}