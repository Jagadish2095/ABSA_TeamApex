/**
* Apex Integration Response Bean class for CCissueBBCombiCardV1 service
* @author  Mbuyiseni Mbhokane
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_Resp_IB_v1 extends Base_IB{
    
    public CCissueBBCombiCardV1Response CCissueBBCombiCardV1Response;
    
	public class Ccp868o {
		public String cardIssueInd;
		public String newCombiNbr;
		public Object cardFeeInd;
		public Object cardFeeType;
		public String cardFeeAmnt;
		public Object delvFeeInd;
		public String delvFeeAmnt;
	}

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class Nbsmsgo3 {
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class CCissueBBCombiCardV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Ccp868o ccp868o;
	}

	public static CCissueBBCombiCardV1_Resp_IB_v1 createDummyResponse(){
        CCissueBBCombiCardV1_Resp_IB_v1 responseBean = new CCissueBBCombiCardV1_Resp_IB_v1();
		responseBean.CCissueBBCombiCardV1Response = new CCissueBBCombiCardV1_Resp_IB_v1.CCissueBBCombiCardV1Response();
        responseBean.CCissueBBCombiCardV1Response.nbsapdpo = new CCissueBBCombiCardV1_Resp_IB_v1.Nbsapdpo();
        responseBean.CCissueBBCombiCardV1Response.nbsmsgo3 = new CCissueBBCombiCardV1_Resp_IB_v1.Nbsmsgo3();
        responseBean.CCissueBBCombiCardV1Response.ccp868o = new CCissueBBCombiCardV1_Resp_IB_v1.Ccp868o();
        CCissueBBCombiCardV1_Resp_IB_v1.MsgEntry msgEntryBean = new CCissueBBCombiCardV1_Resp_IB_v1.MsgEntry();
        
        responseBean.CCissueBBCombiCardV1Response.nbsapdpo.reasonCode = '0';
        responseBean.CCissueBBCombiCardV1Response.nbsapdpo.returnCode = '0';
        responseBean.CCissueBBCombiCardV1Response.nbsapdpo.serviceVersion = 'BUSO001';
        
        msgEntryBean.msgClass = 'CCS299';
        msgEntryBean.msgCode = '0014';
        msgEntryBean.msgErrInd = 'E';
        msgEntryBean.msgTxt = 'Brand 00231 does not exist on table';
        responseBean.CCissueBBCombiCardV1Response.nbsmsgo3.nbrUserMsgs = '1';
        responseBean.CCissueBBCombiCardV1Response.nbsmsgo3.nbrUserErrs = '1';
        responseBean.CCissueBBCombiCardV1Response.nbsmsgo3.msgEntry = msgEntryBean;

        responseBean.CCissueBBCombiCardV1Response.ccp868o.cardIssueInd = 'N';
        responseBean.CCissueBBCombiCardV1Response.ccp868o.newCombiNbr = '00000000000000000';
        responseBean.CCissueBBCombiCardV1Response.ccp868o.cardFeeInd = null;
        responseBean.CCissueBBCombiCardV1Response.ccp868o.cardFeeType = null;
        responseBean.CCissueBBCombiCardV1Response.ccp868o.cardFeeAmnt = '0';
        responseBean.CCissueBBCombiCardV1Response.ccp868o.delvFeeInd = null;
        responseBean.CCissueBBCombiCardV1Response.ccp868o.delvFeeAmnt = '0';
        
		return responseBean;
	}

}