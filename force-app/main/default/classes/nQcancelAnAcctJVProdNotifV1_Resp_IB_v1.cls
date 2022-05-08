/*
 * Response Bean for NQcancelAnAcctJVProdNotificationV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */
public class nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 extends Base_IB{
    
    public Integer statusCode;
    public String message;
    public String status;
    
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public NQcancelAnAcctJVProdNotificationV1Response NQcancelAnAcctJVProdNotificationV1Response;

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class NQcancelAnAcctJVProdNotificationV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Nqp207o nqp207o;
	}

	public class Nqp207o {
		public String rc;
		public String pnsRecipientId;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
    public nQcancelAnAcctJVProdNotifV1_Resp_IB_v1(){
        
    }
}