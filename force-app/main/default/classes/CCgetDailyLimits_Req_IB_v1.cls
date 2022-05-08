/*
 * Request Integration Bean for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

public class CCgetDailyLimits_Req_IB_v1 extends Base_IB {

    public String channel;
    public String application;
    public String trace;
    public String msgLanguage;
    public String msgTarget;
    public String combiNbr;

    public static CCgetDailyLimits_Req_IB_v1 createDummyRequest() {
        CCgetDailyLimits_Req_IB_v1 requestBean = new CCgetDailyLimits_Req_IB_v1();

        requestBean.channel = 'BDP';
        requestBean.application = 'BDP';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.combiNbr = '1';

        return requestBean;
    }
}