/*
 * Integration Request Bean for CQGetPaymentDue Service
 * @author Haritha Police
 * @created 2019-09-14
 */

public class CQgetPaymentDue_Req_IB_V1 extends Base_IB {
		public String channel;
        public String application;
        public String trace;
        public String msgLanguage;
        public String msgTarget;
        public String accountNbr;
        public string agencyCode;
 		public string siteCode;
  		public string tellerCode;
  		public string controllerCode;
    
  public static CQgetPaymentDue_Req_IB_V1 createDummyRequest() {
    CQgetPaymentDue_Req_IB_V1 requestBean = new CQgetPaymentDue_Req_IB_V1();

        requestBean.channel = 'BDP';
        requestBean.application = 'BDP';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.accountNbr = '4046048717';
        requestBean.agencyCode = '034';
 		requestBean.siteCode = '034';
  		requestBean.tellerCode = '1234';
  		requestBean.controllerCode = '1';
      	 return requestBean;
	}
}