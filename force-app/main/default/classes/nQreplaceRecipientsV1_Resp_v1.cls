/*
* Response Integration Bean for NQreplaceRecipientsAcrossAllAcntsV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQreplaceRecipientsV1_Resp_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public NQreplaceRecipientsAcrossAllAcntsV1Response NQreplaceRecipientsAcrossAllAcntsV1Response;

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class Nqp096o {
		public String rc;
	}

	public class NQreplaceRecipientsAcrossAllAcntsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Nqp096o nqp096o;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
    public nQreplaceRecipientsV1_Resp_v1(){}
}