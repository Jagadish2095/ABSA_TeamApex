/*
 * Integration Utility class for ABSAOnlineStatementSearch Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementSearch_IU_v1 {

    /* Creates a request bean
     * @return: ABSAOnlineStatementSearch_Req_IB_v1 bean object
     */
    public static ABSAOnlineStatementSearch_Req_IB_v1 mapRequestFields(String accountNumber, Integer accountType, String cifKey, String statementDateRange) {
        ABSAOnlineStatementSearch_Req_IB_v1 requestBean = new ABSAOnlineStatementSearch_Req_IB_v1();

        requestBean.businessUnit = 'RB';

        requestBean.accountNumber = accountNumber;
        requestBean.accountType = accountType;
        requestBean.cifKey = cifKey;
        requestBean.statementDateRange = statementDateRange;

        return requestBean;
    }
}