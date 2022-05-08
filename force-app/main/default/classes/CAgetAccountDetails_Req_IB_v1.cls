/*
 * Request Integration Bean for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

public class CAgetAccountDetails_Req_IB_v1 extends Base_IB {

    public String channel;
    public String application;
    public String trace;
    public String msgLanguage;
    public String msgTarget;
    public String accountNumber;

    public static CAgetAccountDetails_Req_IB_v1 createDummyRequest() {
        CAgetAccountDetails_Req_IB_v1 requestBean = new CAgetAccountDetails_Req_IB_v1();

        requestBean.channel = 'BDP';
        requestBean.application = 'BDP';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.accountNumber = '05544351000291012';

        return requestBean;
    }
}