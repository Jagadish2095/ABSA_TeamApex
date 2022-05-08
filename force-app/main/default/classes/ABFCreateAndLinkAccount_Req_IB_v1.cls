/*
* Integration Request Bean for create and Link Account
* @author Almas Aleem:Absa  
* @created 2020-12-07
*/
public class ABFCreateAndLinkAccount_Req_IB_v1 extends Base_IB{
	public Nbsapdpi nbsapdpi;
	public Nbsmsgi nbsmsgi;
	public Plpa00i plpa00i;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Plpa00i {
		public String clientCode;
		public String corpCode;
		public String productCode;
		public String applicationNbr;
		public String branchCode;
		public String siteTypeAgency;
		public String agencyCode;
		public String tellerCode;
		public String workstationNbr;
		public String supervisorCode;
		public String marketersCode;
		public String branchSiteType;
		public String sourceOfFunds1;
		public String sourceOfFunds2;
		public String sourceOfFunds3;
		public String sourceOfFunds4;
		public String sourceOfFunds5;
		public String eddRiskHoldInd;
		public String accOrigChannel;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
public static ABFCreateAndLinkAccount_Req_IB_v1 createDummyRequest() {
	
    ABFCreateAndLinkAccount_Req_IB_v1 requestBean = new ABFCreateAndLinkAccount_Req_IB_v1();
    requestBean.nbsapdpi = new ABFCreateAndLinkAccount_Req_IB_v1.Nbsapdpi();
    requestBean.nbsapdpi.application='DP';
    requestBean.nbsapdpi.channel ='DP';
    requestBean.nbsapdpi.trace ='N';
    
    requestBean.nbsmsgi = new ABFCreateAndLinkAccount_Req_IB_v1.Nbsmsgi();
    requestBean.nbsmsgi.msgLanguage ='E';
    requestBean.nbsmsgi.msgTarget='STD';
    requestBean.nbsmsgi.finalMsgId = new ABFCreateAndLinkAccount_Req_IB_v1.FinalMsgId();
    requestBean.nbsmsgi.finalMsgId.finalMsgClass ='';
    requestBean.nbsmsgi.finalMsgId.finalMsgCode='';
    
    requestBean.plpa00i = new ABFCreateAndLinkAccount_Req_IB_v1.Plpa00i();
    requestBean.plpa00i.clientCode = 'WCC    451';
    requestBean.plpa00i.corpCode = 'ABS';
    requestBean.plpa00i.productCode = '5016';
    requestBean.plpa00i.applicationNbr = '0';
    requestBean.plpa00i.branchCode = '6522';
    requestBean.plpa00i.siteTypeAgency = '034';
    requestBean.plpa00i.agencyCode = '08198';
    requestBean.plpa00i.tellerCode = '001560';
    requestBean.plpa00i.workstationNbr = '0';
    requestBean.plpa00i.supervisorCode = '001560';
    requestBean.plpa00i.marketersCode = '0';
    requestBean.plpa00i.branchSiteType = '034';
    requestBean.plpa00i.sourceOfFunds1 = '0';
    requestBean.plpa00i.sourceOfFunds2 = '';
    requestBean.plpa00i.sourceOfFunds3 = '';
    requestBean.plpa00i.sourceOfFunds4 = '';
    requestBean.plpa00i.sourceOfFunds5 = '';
    requestBean.plpa00i.eddRiskHoldInd = '';
    requestBean.plpa00i.accOrigChannel = '';

    return requestBean;
  }
}