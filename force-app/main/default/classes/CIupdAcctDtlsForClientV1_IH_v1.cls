/*
 * Integration Handler for CIupdAcctDtlsForClientV1 Service
 * @author Rudolf Niehaus
 * @created 2020-10-03
 */

public class CIupdAcctDtlsForClientV1_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'CIupdAcctDtlsForClientV1';

    public static CIupdAcctDtlsForClientV1_Resp_IB_v1 CIupdAcctDtlsForClientV1(CIupdAcctDtlsForClientV1_Req_IB_v1 requestBean) {
        CIupdAcctDtlsForClientV1_Resp_IB_v1 responseBean = (CIupdAcctDtlsForClientV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CIupdAcctDtlsForClientV1_Resp_IB_v1.class);
        return responseBean;
    }
}