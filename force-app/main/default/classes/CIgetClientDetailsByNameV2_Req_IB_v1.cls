/*
* Request Integration Bean for CIgetClientDetailsByNameV2 Service
* @author Rudolf Niehaus
* @created 2020-04-07
*/

public class CIgetClientDetailsByNameV2_Req_IB_v1 extends Base_IB {

	public CIgetClientDetailsByNameV2 CIgetClientDetailsByNameV2;

	public class CIgetClientDetailsByNameV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cip602i cip602i;
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

	public class Cip602i {
		public String cifSurname;
		public String cifInitials;
		public String clntGroup;
		public String clntGender;
		public String clntBirthDate;
		public String maxRecsToRtrv;
		public String startAfterSearchPos;
		public String siteCode;
		public String clntTitle;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	public static CIgetClientDetailsByNameV2_Req_IB_v1 createDummyRequest() {
        
        CIgetClientDetailsByNameV2_Req_IB_v1 requestBean = new CIgetClientDetailsByNameV2_Req_IB_v1();
        requestBean.CIgetClientDetailsByNameV2 = new CIgetClientDetailsByNameV2_Req_IB_v1.CIgetClientDetailsByNameV2();
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi = new CIgetClientDetailsByNameV2_Req_IB_v1.Nbsapdpi();
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi = new CIgetClientDetailsByNameV2_Req_IB_v1.Nbsmsgi();
        requestBean.CIgetClientDetailsByNameV2.cip602i = new CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i();
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId = new CIgetClientDetailsByNameV2_Req_IB_v1.FinalMsgId();
        
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.channel = 'BDP';
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.application = 'BDP';
        requestBean.CIgetClientDetailsByNameV2.nbsapdpi.trace = 'Y';

        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.msgLanguage = 'E';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.msgTarget = 'STD';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIgetClientDetailsByNameV2.nbsmsgi.finalMsgId.finalMsgCode = '';
        
     
		requestBean.CIgetClientDetailsByNameV2.cip602i.cifSurname = 'OOSTHUIZEN';
		requestBean.CIgetClientDetailsByNameV2.cip602i.cifInitials = '';
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntGroup = '';
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntGender = '';
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntBirthDate = '';
        requestBean.CIgetClientDetailsByNameV2.cip602i.maxRecsToRtrv = '15';
		requestBean.CIgetClientDetailsByNameV2.cip602i.startAfterSearchPos = '';
		requestBean.CIgetClientDetailsByNameV2.cip602i.siteCode = '8089';
		requestBean.CIgetClientDetailsByNameV2.cip602i.clntTitle = '';
        
        return requestBean;
    }
}