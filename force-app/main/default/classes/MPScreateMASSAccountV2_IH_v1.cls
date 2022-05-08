/*
 * Integration Handler for MPScreateMASSAccountV2 Service
 * @author Prashant Jain
 * @created 2020-06-08
 */

public class MPScreateMASSAccountV2_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'MPS Create MASS Account V2';

    public static MPScreateMASSAccountV2_Resp_IB_v1 MPScreateMASSAccountV2(MPScreateMASSAccountV2_Req_IB_v1 requestBean) {
        MPScreateMASSAccountV2_Resp_IB_v1 responseBean = (MPScreateMASSAccountV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MPScreateMASSAccountV2_Resp_IB_v1.class);
        return responseBean;
    }
}