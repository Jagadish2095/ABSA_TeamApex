/*
* Request Integration Bean for CClistNominatableAccountsV1 Service
* @author Satya Boyenepalli
* @created 2020-11-04
*/
public class CClistNominatableAccountsV1_Req_IB_v1 extends Base_IB {
    
    	public class CClistNominatableAccountsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ccp315i ccp315i;
	}

	public class Ccp315i {
		public String clientCode;
		public String inpAccntNbr;
		public String inpNxtAccnt;
		public String inpNbrAccnt;
	}

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

		public CClistNominatableAccountsV1 CClistNominatableAccountsV1;

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static CClistNominatableAccountsV1_Req_IB_v1 createDummyRequest(){
        CClistNominatableAccountsV1_Req_IB_v1 requestBean = new CClistNominatableAccountsV1_Req_IB_v1();
        CClistNominatableAccountsV1_Req_IB_v1.Nbsapdpi NbsapdpiBean = new  CClistNominatableAccountsV1_Req_IB_v1.Nbsapdpi();
        CClistNominatableAccountsV1_Req_IB_v1.Nbsmsgi NbsmsgiBean = new CClistNominatableAccountsV1_Req_IB_v1.Nbsmsgi();
        CClistNominatableAccountsV1_Req_IB_v1.Ccp315i Ccp315iBean = new  CClistNominatableAccountsV1_Req_IB_v1.Ccp315i();
        CClistNominatableAccountsV1_Req_IB_v1.CClistNominatableAccountsV1 CClistNominatableAccountsBean = new CClistNominatableAccountsV1_Req_IB_v1.CClistNominatableAccountsV1();
        NbsapdpiBean.channel = 'SF';
        NbsmsgiBean.msgLanguage = 'E';
        NbsmsgiBean.msgTarget = 'STD';
        CClistNominatableAccountsV1_Req_IB_v1.FinalMsgId fnlmsgid = new  CClistNominatableAccountsV1_Req_IB_v1.FinalMsgId();
        fnlmsgid.finalMsgClass='';
        fnlmsgid.finalMsgCode='';
        Ccp315iBean.clientCode =  'UOISUO 001';
        Ccp315iBean.inpAccntNbr='0';
        Ccp315iBean.inpNxtAccnt='0';
        Ccp315iBean.inpNbrAccnt='20';
        CClistNominatableAccountsBean.nbsapdpi=NbsapdpiBean;
        CClistNominatableAccountsBean.nbsmsgi=NbsmsgiBean;
        CClistNominatableAccountsBean.ccp315i=Ccp315iBean;
        requestBean.CClistNominatableAccountsV1=CClistNominatableAccountsBean;
        return requestBean;
    }   
}