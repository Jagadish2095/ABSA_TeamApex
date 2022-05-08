/*
* Request Integration Bean for NHupdatePauseCardV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHupdatePauseCardV1_Req_IB_v1 extends Base_IB {
    
	public NHupdatePauseCardV1 NHupdatePauseCardV1;

	public class NHupdatePauseCardV1 {
		public Nbsapdpi nbsapdpi;
		public Nhs141i nhs141i;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nhs141i {
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
		public String tellerCode;
		public String workStation;
		public String supervisor;
		public String branchCode;
		public String pauseHold;
		public String iatmHold;
		public String iposHold;
		public String latmHold;
		public String lposHold;
		public String cnpHold;
		public String digwHold;
		public String pauseDate;
	}
    
    public static nHupdatePauseCardV1_Req_IB_v1 createDummyRequest(){
        nHupdatePauseCardV1_Req_IB_v1 requestBean = new nHupdatePauseCardV1_Req_IB_v1();
		requestBean.NHupdatePauseCardV1 = new nHupdatePauseCardV1_Req_IB_v1.NHupdatePauseCardV1();
        
        requestBean.NHupdatePauseCardV1.nbsapdpi = new nHupdatePauseCardV1_Req_IB_v1.Nbsapdpi();
        requestBean.NHupdatePauseCardV1.nbsapdpi.application = 'BDP';
        requestBean.NHupdatePauseCardV1.nbsapdpi.channel = 'BDP';
        requestBean.NHupdatePauseCardV1.nbsapdpi.trace = 'Y';
        
        requestBean.NHupdatePauseCardV1.nhs141i = new nHupdatePauseCardV1_Req_IB_v1.Nhs141i();
        requestBean.NHupdatePauseCardV1.nhs141i.log = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.authenticate = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.accessNumber = '9050544469';
        requestBean.NHupdatePauseCardV1.nhs141i.user = '1';
        requestBean.NHupdatePauseCardV1.nhs141i.division = 'ABSA';
        requestBean.NHupdatePauseCardV1.nhs141i.device = 'W';
        requestBean.NHupdatePauseCardV1.nhs141i.origAddress = '0';
        requestBean.NHupdatePauseCardV1.nhs141i.language = 'E';
        requestBean.NHupdatePauseCardV1.nhs141i.action = 'READ';
        requestBean.NHupdatePauseCardV1.nhs141i.cardNbr =  '04483870000020440';
        requestBean.NHupdatePauseCardV1.nhs141i.tellerCode = '999999'; 
        requestBean.NHupdatePauseCardV1.nhs141i.workStation = '99';
        requestBean.NHupdatePauseCardV1.nhs141i.supervisor = '999999';
        requestBean.NHupdatePauseCardV1.nhs141i.branchCode = '8992';
        requestBean.NHupdatePauseCardV1.nhs141i.pauseHold = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.iatmHold = 'Y';
        requestBean.NHupdatePauseCardV1.nhs141i.iposHold = 'Y';
     	requestBean.NHupdatePauseCardV1.nhs141i.latmHold = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.iposHold = 'N';
     	requestBean.NHupdatePauseCardV1.nhs141i.cnpHold = 'N';
     	requestBean.NHupdatePauseCardV1.nhs141i.digwHold = 'N';
        requestBean.NHupdatePauseCardV1.nhs141i.pauseDate = '20200515';
     
        return requestBean;
    }
}