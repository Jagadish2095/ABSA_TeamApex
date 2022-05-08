/*
 * Request Integration Bean for ABSAOnlineStatementDownload Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementDownload_Req_IB_v1 extends Base_IB {
    public String accountNumber;
    public Integer accountType;
    public String businessUnit;
    public String cifKey;
    public Integer eStamp;
    public String eStampRef;
    public String encoding;
    public String listRef;
    public String statementDate;
    public String password;

    public static ABSAOnlineStatementDownload_Req_IB_v1 createDummyRequest() {
        ABSAOnlineStatementDownload_Req_IB_v1 requestBean = new ABSAOnlineStatementDownload_Req_IB_v1();

        requestBean.accountNumber = '4048144945';
        requestBean.accountType = 1;
        requestBean.businessUnit = 'RB';
        requestBean.cifKey = 'HIBBEJP001';
        requestBean.eStamp = 0; //1
        // requestBean.eStampRef = '2343387378323';
        requestBean.encoding = 'PDF';
        requestBean.listRef = '0a0433f5-c94b-44f9-9bed-2ed8371d6da2';
        requestBean.statementDate = '20190728';
        requestBean.password = 'my-password';
        return requestBean;
    }
}