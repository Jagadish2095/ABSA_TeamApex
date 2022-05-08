/*
 * Integration Req Bean for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh
 * @created 2020-04-07
 */
public class CqUpdAcctDomicileChangev2_Req_IB_v1 extends Base_IB {
    

	public class CQupdAcctDomicileChangeV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cqh538i cqh538i;
	}

	public CQupdAcctDomicileChangeV2 CQupdAcctDomicileChangeV2;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Cqh538i {
		public String accountNbr;
		public String newBranch;
		public String branchCode;
		public String agencyCode;
		public String agencySiteType;
		public String tellerCode;
		public String supervisorCode;
		public String corpCode;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    
    
    //Dummy Method for request
    public static CqUpdAcctDomicileChangev2_Req_IB_v1 createDummyRequest(){
           CqUpdAcctDomicileChangev2_Req_IB_v1 requestBean = new CqUpdAcctDomicileChangev2_Req_IB_v1();
           requestBean.CQupdAcctDomicileChangeV2 = new CqUpdAcctDomicileChangev2_Req_IB_v1.CQupdAcctDomicileChangeV2();
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi  = new CqUpdAcctDomicileChangev2_Req_IB_v1.Nbsapdpi();
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i  = new CqUpdAcctDomicileChangev2_Req_IB_v1.Cqh538i();
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi = new CqUpdAcctDomicileChangev2_Req_IB_v1.Nbsmsgi();
        
        
           //requestBean.CQupdAcctDomicileChangeV2.FinalMsgId.finalMsgClass = '';
           //requestBean.CQupdAcctDomicileChangeV2.FinalMsgId.finalMsgCode = ''; 
           
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.channel = 'BDP';
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.application = 'BDP';
           requestBean.CQupdAcctDomicileChangeV2.Nbsapdpi.trace = 'Y';
           
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.accountNbr = '4048078904';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.newBranch = '8198';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.branchCode = '8198';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.agencyCode = '034';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.agencySiteType = '034';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.tellerCode = '9999999';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.supervisorCode = '9999999';
           requestBean.CQupdAcctDomicileChangeV2.Cqh538i.corpCode = 'ABS';
           
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.msgLanguage = 'E';
           requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.msgTarget = 'STD';
           //requestBean.CQupdAcctDomicileChangeV2.Nbsmsgi.finalMsgId = FinalMsgIdRequest;  
           system.debug('CQupdAcctDomicileChangeV2 Request Bean: ' + requestBean);  
           return requestBean;
    }
    
}