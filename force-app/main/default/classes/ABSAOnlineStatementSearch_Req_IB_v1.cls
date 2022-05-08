/*
 * Request Integration Bean for ABSAOnlineStatementSearch Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

public class ABSAOnlineStatementSearch_Req_IB_v1 extends Base_IB {

    public String accountNumber;
    public Integer accountType;
    public String businessUnit;
    public String cifKey;
    public String statementDateRange;

    public static ABSAOnlineStatementSearch_Req_IB_v1 createDummyRequest() {
        ABSAOnlineStatementSearch_Req_IB_v1 requestBean = new ABSAOnlineStatementSearch_Req_IB_v1();

        requestBean.accountNumber = '4048144945';
        requestBean.accountType = 1;
        requestBean.businessUnit = 'RB';
        requestBean.cifKey = 'HIBBEJP001';
        requestBean.statementDateRange = '2019-07-01:2019-07-30';

        return requestBean;
    }
}