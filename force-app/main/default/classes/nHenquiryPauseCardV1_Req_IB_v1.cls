/*
* Request Integration Bean for NHenquiryPauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHenquiryPauseCardV1_Req_IB_v1 extends Base_IB {
	
    public class NHenquiryPauseCardV1 {
		public Nbsapdpi nbsapdpi;
		public Nhs142i nhs142i;
	}

	public NHenquiryPauseCardV1 NHenquiryPauseCardV1;

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nhs142i {
		public String log;
		public String authenticate;
		public String accessNumber;
		public String user;
		public String division;
		public String device;
		public String origAddress;
		public String language;
		public String action;
		public String cardNbr;
	}
    
    public static nHenquiryPauseCardV1_Req_IB_v1 createDummyRequest(){
        nHenquiryPauseCardV1_Req_IB_v1 requestBean = new nHenquiryPauseCardV1_Req_IB_v1();
        requestBean.NHenquiryPauseCardV1 = new nHenquiryPauseCardV1_Req_IB_v1.NHenquiryPauseCardV1();
        requestBean.NHenquiryPauseCardV1.nbsapdpi = new nHenquiryPauseCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.NHenquiryPauseCardV1.nbsapdpi.application = 'BDP';
        requestBean.NHenquiryPauseCardV1.nbsapdpi.channel = 'BDP';
        requestBean.NHenquiryPauseCardV1.nbsapdpi.trace = 'Y';
        
        requestBean.NHenquiryPauseCardV1.nhs142i = new nHenquiryPauseCardV1_Req_IB_v1.Nhs142i();
        requestBean.NHenquiryPauseCardV1.nhs142i.log = 'N';
        requestBean.NHenquiryPauseCardV1.nhs142i.authenticate = 'N';
        requestBean.NHenquiryPauseCardV1.nhs142i.accessNumber = '9050544469';
        requestBean.NHenquiryPauseCardV1.nhs142i.user = '1';
        requestBean.NHenquiryPauseCardV1.nhs142i.division = 'ABSA';
        requestBean.NHenquiryPauseCardV1.nhs142i.device = 'W';
        requestBean.NHenquiryPauseCardV1.nhs142i.origAddress = '0';
        requestBean.NHenquiryPauseCardV1.nhs142i.language = 'E';
        requestBean.NHenquiryPauseCardV1.nhs142i.action = 'READ';
        requestBean.NHenquiryPauseCardV1.nhs142i.cardNbr = '04483870000020440';
        
        return requestBean;
    }
}