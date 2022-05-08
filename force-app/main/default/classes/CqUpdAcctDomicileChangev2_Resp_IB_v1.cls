/*
 * Integration Response Bean for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh Pandey
 * @created 2020-04-07
 */

public class CqUpdAcctDomicileChangev2_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public CQupdAcctDomicileChangeV2Response CQupdAcctDomicileChangeV2Response;

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class Cqh538o {
		public String accountNbrOut;
		public String clientName;
		public String oldDomcNum;
		public String oldDomcDiv;
		public String newDomcNum;
		public String newDomcDiv;
		public String oldCntrlNum;
		public String oldCntrlDiv;
		public String newCntrlNum;
		public String newCntrlDiv;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class CQupdAcctDomicileChangeV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Cqh538o cqh538o;
	}
    
    public CqUpdAcctDomicileChangev2_Resp_IB_v1 dummyResponse(){
        CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = new CqUpdAcctDomicileChangev2_Resp_IB_v1();
        responseBean.CQupdAcctDomicileChangeV2Response = new CqUpdAcctDomicileChangev2_Resp_IB_v1.CQupdAcctDomicileChangeV2Response();
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsapdpo  = new CqUpdAcctDomicileChangev2_Resp_IB_v1.Nbsapdpo();
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo  = new CqUpdAcctDomicileChangev2_Resp_IB_v1.Nbsmsgo();
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o  = new CqUpdAcctDomicileChangev2_Resp_IB_v1.Cqh538o();
        //responseBean.CQupdAcctDomicileChangeV2Response.MsgEntry  = new CqUpdAcctDomicileChangev2_Resp_IB_v1.MsgEntry();
        
        responseBean.status = 'Success';
        responseBean.statusCode = 200;
        responseBean.message = '';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsapdpo.reasonCode = '0';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsapdpo.returnCode = '0';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsapdpo.serviceVersion = 'BUSO001' ;
        
        //NbsmsgoResponse.msgEntry = MsgEntryResponse ;
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.version = 'MSG3001';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.sysErrTxt = '';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.nbrUserMsgs = '1';
        responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.nbrUserErrs = '0';
        
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.accountNbrOut = '4048078904';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.clientName = 'ME POOPEDI';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.newCntrlDiv = 'ABS';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.newCntrlNum = '8198';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.newDomcDiv = 'ABS';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.newDomcNum = '8198';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.oldCntrlDiv = 'ABS';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.oldCntrlNum = '5920';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.oldDomcDiv = 'ABS';
        responseBean.CQupdAcctDomicileChangeV2Response.Cqh538o.oldDomcNum = '5920';
        
        //MsgEntryResponse.msgClass = 'CQSMGC01';
        //MsgEntryResponse.msgCode = '0884';
        //MsgEntryResponse.msgErrInd = 'I';
        //MsgEntryResponse.msgTxt = 'Account domicile changed-New chq book not ordered.';
        
           return responseBean;
    }
}