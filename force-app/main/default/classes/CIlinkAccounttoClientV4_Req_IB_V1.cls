/*
* Request Integration Bean for CIlinkAccounttoClientV4 Service
* @author Saurabh
* @created 2020-06-03
*/

public class CIlinkAccounttoClientV4_Req_IB_V1 extends Base_IB {

	public class CIlinkAccountToClientV4 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cib015di cib015di;
	}

	public CIlinkAccountToClientV4 CIlinkAccountToClientV4;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Cib015di {
		public String clientCode;
		public String accountNo;
		public String dateAccOpen;
		public String siteAccOpen;
		public String tellerNo;
		public String product;
		public String casaRefNum;
		public String srcOfFnds1;
		public String srcOfFnds2;
		public String srcOfFnds3;
		public String srcOfFnds4;
		public String srcOfFnds5;
		public String sec129DeliveryAddr;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}


   public static CIlinkAccounttoClientV4_Req_IB_V1 createDummyRequest() {
       CIlinkAccounttoClientV4_Req_IB_V1 requestBean = new CIlinkAccounttoClientV4_Req_IB_V1();
       requestBean.CIlinkAccountToClientV4 = new CIlinkAccounttoClientV4_Req_IB_V1.CIlinkAccountToClientV4();
       requestBean.CIlinkAccountToClientV4.Nbsapdpi = new CIlinkAccounttoClientV4_Req_IB_V1.Nbsapdpi();
       requestBean.CIlinkAccountToClientV4.Nbsmsgi  = new CIlinkAccounttoClientV4_Req_IB_V1.Nbsmsgi();
       requestBean.CIlinkAccountToClientV4.Cib015di = new CIlinkAccounttoClientV4_Req_IB_V1.Cib015di();
       requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId = new CIlinkAccounttoClientV4_Req_IB_V1.FinalMsgId();
       
       requestBean.CIlinkAccountToClientV4.Nbsapdpi.application = 'BDP';
       requestBean.CIlinkAccountToClientV4.Nbsapdpi.channel = 'BDP';
       requestBean.CIlinkAccountToClientV4.Nbsapdpi.trace = 'Y';
       
       requestBean.CIlinkAccountToClientV4.Nbsmsgi.msgLanguage = 'E';
       requestBean.CIlinkAccountToClientV4.Nbsmsgi.msgTarget = 'STD';
       
       requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId.finalMsgClass = '';
       requestBean.CIlinkAccountToClientV4.Nbsmsgi.finalMsgId.finalMsgCode = '';
       
       requestBean.CIlinkAccountToClientV4.Cib015di.accountNo = '0';
       requestBean.CIlinkAccountToClientV4.Cib015di.casaRefNum = '123';
       requestBean.CIlinkAccountToClientV4.Cib015di.clientCode = 'CCC 531';
       requestBean.CIlinkAccountToClientV4.Cib015di.dateAccOpen = '20150401';
       requestBean.CIlinkAccountToClientV4.Cib015di.product = '09050';
       requestBean.CIlinkAccountToClientV4.Cib015di.sec129DeliveryAddr = '1';
       requestBean.CIlinkAccountToClientV4.Cib015di.siteAccOpen = '8198';
       requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds1 = '';
       requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds2 = '';
       requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds3 = '';
       requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds4 = '';
       requestBean.CIlinkAccountToClientV4.Cib015di.srcOfFnds5 = '';
       requestBean.CIlinkAccountToClientV4.Cib015di.tellerNo = '1469';
   return requestBean;   
   }
}