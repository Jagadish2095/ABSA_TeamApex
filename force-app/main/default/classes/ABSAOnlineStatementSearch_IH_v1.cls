/*
 * Integration Handler for ABSAOnlineStatementSearch Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementSearch_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'ABSA Online Statement Search';

    public static ABSAOnlineStatementSearch_Resp_IB_v1 ABSAOnlineStatementSearch(String accountNumber, Integer accountType, String cifKey, String statementDateRange) {
        ABSAOnlineStatementSearch_Req_IB_v1 requestBean = ABSAOnlineStatementSearch_IU_v1.mapRequestFields(accountNumber, accountType, cifKey, statementDateRange);
        ABSAOnlineStatementSearch_Resp_IB_v1 responseBean = (ABSAOnlineStatementSearch_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ABSAOnlineStatementSearch_Resp_IB_v1.class);
        return responseBean;
    }
}