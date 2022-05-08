/*
 * Response Bean for nQcreateNewOrAddRecipientV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */
public class nQcreateNewOrAddRecipientV2_Resp_IB_v2 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class Nqp906o {
		public String rcode;
		public String pnsRecipientIdO;
	}

	public NQcreateNewOrAddRecipientV2Response NQcreateNewOrAddRecipientV2Response;

	public class Nbsmsgo {
		public String version;
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

	public class NQcreateNewOrAddRecipientV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Nqp906o nqp906o;
	}
    public nQcreateNewOrAddRecipientV2_Resp_IB_v2(){

    }

}