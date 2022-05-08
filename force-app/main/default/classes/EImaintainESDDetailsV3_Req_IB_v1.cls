/*
* Request Integration Bean for EImaintainESDDetailsV3 Service
* @author Muvhuso Nekhubvi
* @created 2020/04/07
*/

public class EImaintainESDDetailsV3_Req_IB_v1 extends Base_IB{
    
	public class Entry {
		public String wm;
		public String email;
	}

	public EImaintainESDDetailsV3 EImaintainESDDetailsV3;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class eip103i {
		public String request;
		public String ichannel;
		public String site;
		public String teller;
		public String acn;
		public String product;
		public String prodCode;
		public String eCount;
		public String marketerCodeInit;
		public String marketerCodeAmend;
		public List<Entry> entry;
		public String prefInd;
	}

	public class EImaintainESDDetailsV3 {
		public nbsapdpi nbsapdpi;
		public nbsmsgi nbsmsgi;
		public eip103i eip103i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static EImaintainESDDetailsV3_Req_IB_v1 createDummyRequest(){
        
        EImaintainESDDetailsV3_Req_IB_v1 requestBean = new EImaintainESDDetailsV3_Req_IB_v1();
        
        EImaintainESDDetailsV3_Req_IB_v1.EImaintainESDDetailsV3 eImaintainESDDetailsV3 = new EImaintainESDDetailsV3_Req_IB_v1.EImaintainESDDetailsV3();
        
        EImaintainESDDetailsV3_Req_IB_v1.Nbsapdpi nbsapdpi = new EImaintainESDDetailsV3_Req_IB_v1.Nbsapdpi();
        nbsapdpi.application = 'BDP';
        nbsapdpi.channel = 'BDP';
        nbsapdpi.trace = 'Y';
        
        EImaintainESDDetailsV3_Req_IB_v1.Nbsmsgi nbsmsgi = new EImaintainESDDetailsV3_Req_IB_v1.Nbsmsgi();
        EImaintainESDDetailsV3_Req_IB_v1.FinalMsgId finalMsgId = new EImaintainESDDetailsV3_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
        nbsmsgi.finalMsgId = finalMsgId;
        
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i eip103i = new EImaintainESDDetailsV3_Req_IB_v1.Eip103i();
        
        List<EImaintainESDDetailsV3_Req_IB_v1.Entry> entryList = new List<EImaintainESDDetailsV3_Req_IB_v1.Entry>();
        
        EImaintainESDDetailsV3_Req_IB_v1.Entry entry = new EImaintainESDDetailsV3_Req_IB_v1.Entry();
        entry.email = '';
        entry.wm = '';
        entryList.add(entry);
        
        eip103i.request = 'N';
        eip103i.ichannel = 'B';
        eip103i.site = '8913';
        eip103i.teller = '8913';
        eip103i.acn = '4051212002';
        eip103i.product = 'CQ';
        eip103i.prodCode = '0';
        eip103i.eCount = '0';
        eip103i.marketerCodeInit = '0';
        eip103i.marketerCodeAmend = '0';
        eip103i.entry = entryList;
        eip103i.prefInd = '';
        
        eImaintainESDDetailsV3.nbsapdpi = nbsapdpi;
        eImaintainESDDetailsV3.nbsmsgi = nbsmsgi;
        eImaintainESDDetailsV3.eip103i = eip103i;
        requestBean.EImaintainESDDetailsV3 = eImaintainESDDetailsV3;
        
        return requestBean; 
    }
}