/*
 * Integration Handler for ABSAOnlineStatementDownload Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementDownload_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'ABSA Online Statement Download';

    public static ABSAOnlineStatementDownload_Resp_IB_v1 ABSAOnlineStatementDownload(String accountNumber, Integer accountType, String cifKey, String encoding, String listRef, String statementDate, String password) {
        ABSAOnlineStatementDownload_Req_IB_v1 requestBean = ABSAOnlineStatementDownload_IU_v1.mapRequestFields(accountNumber, accountType, cifKey, encoding, listRef, statementDate, password);
        ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = (ABSAOnlineStatementDownload_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ABSAOnlineStatementDownload_Resp_IB_v1.class);
        return responseBean;
    }
}