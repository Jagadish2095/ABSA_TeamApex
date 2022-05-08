/**
* Apex Integration Response Bean class for CCIssueV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/

public class CCIssueV2_Resp_IB_v1 extends Base_IB{
    
    public class CCIssueV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Ccp311o ccp311o;
	}

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public CCIssueV2Response CCIssueV2Response;

	public class Nbsmsgo {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}

	public class Ccp311o {
		public String combiNbr;
		public String lvpNbr;
	}

	
	public static CCIssueV2_Resp_IB_v1 createDummyResponse() {
        CCIssueV2_Resp_IB_v1 responseBean = new CCIssueV2_Resp_IB_v1();
        responseBean.CCIssueV2Response = new CCIssueV2_Resp_IB_v1.CCIssueV2Response();
        responseBean.CCIssueV2Response.nbsapdpo = new CCIssueV2_Resp_IB_v1.Nbsapdpo();
        responseBean.CCIssueV2Response.nbsmsgo = new CCIssueV2_Resp_IB_v1.Nbsmsgo();
        responseBean.CCIssueV2Response.ccp311o = new CCIssueV2_Resp_IB_v1.Ccp311o();
        
        responseBean.CCIssueV2Response.nbsapdpo.reasonCode = '0';
        responseBean.CCIssueV2Response.nbsapdpo.returnCode = '0';
        responseBean.CCIssueV2Response.nbsapdpo.serviceVersion = 'BUSO001';
        
        responseBean.CCIssueV2Response.nbsmsgo.version = 'MSG3001';
        responseBean.CCIssueV2Response.nbsmsgo.nbrUserMsgs = '0';
        responseBean.CCIssueV2Response.nbsmsgo.nbrUserErrs = '0	';
        
        responseBean.CCIssueV2Response.ccp311o.combiNbr = '1558481213';
        responseBean.CCIssueV2Response.ccp311o.lvpNbr = '0';
        
		return responseBean;
	}

}