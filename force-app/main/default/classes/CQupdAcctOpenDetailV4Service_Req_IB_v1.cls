/*
 * Request Integration Bean for CQupdAcctOpenDetailV4Service Service
 * @author Willy Zuvana
 * @created 2021-04-06
 */
 
public class CQupdAcctOpenDetailV4Service_Req_IB_v1 Extends Base_IB {
    
	public class InputArea {
		public String accountNbr;
		public String openSite;
		public String controlSite;
		public String CIFkey;
		public String tellerNbr;
		public String controllerNbr;
		public String empleyeeNbr;
		public String workstationNbr;
		public String applicationNbr;
		public String openSiteType;
		public String clientName;
		public String accountName;
		public String acctOpenDate;
		public String acctOpenReason;
		public String managerNbr;
		public String riskType;
		public String lowRiskHoldAmount;
		public String acctStoppedInd;
		public String unilateralLimitInd;
		public String ACBUser;
		public String debitBackdateLimit;
		public String CreditBackdateLimit;
		public String corpSubProduct;
		public String businessAcct;
		public String trustS781Acct;
		public String lawSocietyRegion;
		public String studentNbr;
		public String fulTimeStudent;
		public String postGradStudent;
		public String studyCourse;
		public String normalDuration;
		public String currentAcademicYear;
		public String finalYear;
		public String studyInstitution;
		public String nbrYearsRepeated;
		public String extraFinanceReqrd;
		public String studiesCompleted;
		public String repayingInd;
		public String repaymentStartDate;
		public String mandateNbr;
		public String trustSweepingInd;
		public String shadowLimitInd;
	}

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CQT413I CQT413I;

	public class NBSMSGI {
		public NBSMSGI NBSMSGI;
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	public class CQT413I {
		public InputArea inputArea;
	}

	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}
	
	public static CQupdAcctOpenDetailV4Service_Req_IB_v1 createDummyRequest() {
        
        CQupdAcctOpenDetailV4Service_Req_IB_v1 requestBean = new CQupdAcctOpenDetailV4Service_Req_IB_v1();
		
        requestBean.NBSAPDPI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSAPDPI();
		requestBean.NBSAPDPI.NBSAPLI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSAPLI();
		
		requestBean.NBSMSGI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSMSGI();
		requestBean.NBSMSGI.NBSMSGI = new CQupdAcctOpenDetailV4Service_Req_IB_v1.NBSMSGI();
		
		requestBean.CQT413I = new CQupdAcctOpenDetailV4Service_Req_IB_v1.CQT413I();
		requestBean.CQT413I.inputArea = new CQupdAcctOpenDetailV4Service_Req_IB_v1.InputArea();
		
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'API';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';
		
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';		
		
		requestBean.CQT413I.inputArea.accountNbr = '4047098072';
        requestBean.CQT413I.inputArea.openSite = '8198';
        requestBean.CQT413I.inputArea.controlSite = '1';
        requestBean.CQT413I.inputArea.CIFkey = 'KGOSIWM001';
        requestBean.CQT413I.inputArea.tellerNbr = '11';
        requestBean.CQT413I.inputArea.controllerNbr = '111';
        requestBean.CQT413I.inputArea.empleyeeNbr = '5004450';
        requestBean.CQT413I.inputArea.workstationNbr = '99';
        requestBean.CQT413I.inputArea.applicationNbr = '0';
        requestBean.CQT413I.inputArea.openSiteType = '034';
        requestBean.CQT413I.inputArea.clientName = 'Aiden Walker';
        requestBean.CQT413I.inputArea.accountName = 'TESTING';
        requestBean.CQT413I.inputArea.acctOpenDate = '20201109';
        requestBean.CQT413I.inputArea.acctOpenReason = '1';
        requestBean.CQT413I.inputArea.managerNbr = '3';
        requestBean.CQT413I.inputArea.riskType = 'H';
        requestBean.CQT413I.inputArea.lowRiskHoldAmount = '0';
        requestBean.CQT413I.inputArea.acctStoppedInd = 'N';
        requestBean.CQT413I.inputArea.unilateralLimitInd = 'N';
        requestBean.CQT413I.inputArea.ACBUser = 'N';
        requestBean.CQT413I.inputArea.debitBackdateLimit = 'S';
        requestBean.CQT413I.inputArea.CreditBackdateLimit = 'S';
        requestBean.CQT413I.inputArea.corpSubProduct = '0';
        requestBean.CQT413I.inputArea.businessAcct = '0';
        requestBean.CQT413I.inputArea.trustS781Acct = '0';
        requestBean.CQT413I.inputArea.lawSocietyRegion = '';
        requestBean.CQT413I.inputArea.studentNbr = '';
        requestBean.CQT413I.inputArea.fulTimeStudent = '';
        requestBean.CQT413I.inputArea.postGradStudent = '';
        requestBean.CQT413I.inputArea.studyCourse = '';
        requestBean.CQT413I.inputArea.normalDuration = '0';
        requestBean.CQT413I.inputArea.currentAcademicYear = '0';
        requestBean.CQT413I.inputArea.finalYear = '';
        requestBean.CQT413I.inputArea.studyInstitution = '';
        requestBean.CQT413I.inputArea.nbrYearsRepeated = '0';
        requestBean.CQT413I.inputArea.extraFinanceReqrd = '';
        requestBean.CQT413I.inputArea.studiesCompleted = '';
        requestBean.CQT413I.inputArea.repayingInd = '';
        requestBean.CQT413I.inputArea.repaymentStartDate = '0';
        requestBean.CQT413I.inputArea.mandateNbr = '113';
        requestBean.CQT413I.inputArea.trustSweepingInd = '';
        requestBean.CQT413I.inputArea.shadowLimitInd = 'N';

        return requestBean;
    }
}