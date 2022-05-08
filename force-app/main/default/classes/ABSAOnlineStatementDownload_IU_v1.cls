/*
 * Integration Utility class for ABSAOnlineStatementDownload Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementDownload_IU_v1 {
    /* Creates a request bean
     * @return: ABSAOnlineStatementDownload_Req_IB_v1 bean object
     */
    public static ABSAOnlineStatementDownload_Req_IB_v1 mapRequestFields(String accountNumber, Integer accountType, String cifKey, String encoding, String listRef, String statementDate, String password) {
        ABSAOnlineStatementDownload_Req_IB_v1 requestBean = new ABSAOnlineStatementDownload_Req_IB_v1();

        requestBean.businessUnit = 'RB';
        requestBean.eStamp = 0; //1
        // requestBean.eStampRef = '2343387378323';

        requestBean.accountNumber = accountNumber;
        requestBean.accountType = accountType;
        requestBean.cifKey = cifKey;
        requestBean.encoding = encoding;
        requestBean.listRef = listRef;
        requestBean.statementDate = statementDate;
        requestBean.password = password;

        return requestBean;
    }
}