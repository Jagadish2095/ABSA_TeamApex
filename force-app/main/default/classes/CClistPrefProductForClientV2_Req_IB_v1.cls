/**
* Apex Integration Request Bean class for CClistPrefProductForClientV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-07-27
*
**/
public class CClistPrefProductForClientV2_Req_IB_v1 extends Base_IB{
    
    public class Ccp317i {
		public String tellerCode;
		public String clientCode;
		public String inpAccntNbr;
		public String cardType;
		public String functionInd;
	}

	public CClistPrefProductsForClientV2 CClistPrefProductsForClientV2;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String trace;
	}

	public class CClistPrefProductsForClientV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ccp317i ccp317i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	
	public static CClistPrefProductForClientV2_Req_IB_v1 createDummyRequest() {
        CClistPrefProductForClientV2_Req_IB_v1 requestBean = new CClistPrefProductForClientV2_Req_IB_v1();
        requestBean.CClistPrefProductsForClientV2 = new CClistPrefProductForClientV2_Req_IB_v1.CClistPrefProductsForClientV2();
       	requestBean.CClistPrefProductsForClientV2.nbsapdpi = new CClistPrefProductForClientV2_Req_IB_v1.Nbsapdpi();
        requestBean.CClistPrefProductsForClientV2.nbsmsgi = new CClistPrefProductForClientV2_Req_IB_v1.Nbsmsgi();
        requestBean.CClistPrefProductsForClientV2.ccp317i = new CClistPrefProductForClientV2_Req_IB_v1.Ccp317i();
        CClistPrefProductForClientV2_Req_IB_v1.FinalMsgId finalMsgIdBean = new CClistPrefProductForClientV2_Req_IB_v1.FinalMsgId();
        
 
		requestBean.CClistPrefProductsForClientV2.nbsapdpi.channel = '|';
        requestBean.CClistPrefProductsForClientV2.nbsapdpi.trace = 'Y';
        
        finalMsgIdBean.finalMsgClass = '';
        finalMsgIdBean.finalMsgCode = '';
        requestBean.CClistPrefProductsForClientV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CClistPrefProductsForClientV2.nbsmsgi.msgTarget = 'STD';
        requestBean.CClistPrefProductsForClientV2.nbsmsgi.finalMsgId = finalMsgIdBean;
        
        requestBean.CClistPrefProductsForClientV2.ccp317i.tellerCode = '2920';
        requestBean.CClistPrefProductsForClientV2.ccp317i.clientCode = 'WALINM 001';
        requestBean.CClistPrefProductsForClientV2.ccp317i.inpAccntNbr = '4048063812';
        requestBean.CClistPrefProductsForClientV2.ccp317i.cardType = 'C';
        requestBean.CClistPrefProductsForClientV2.ccp317i.functionInd = 'N';
        
		return requestBean;
	}

}