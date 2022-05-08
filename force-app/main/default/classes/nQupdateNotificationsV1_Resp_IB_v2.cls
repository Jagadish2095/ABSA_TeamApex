/*
 * Response Bean for nQupdateNotificationsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */
public class nQupdateNotificationsV1_Resp_IB_v2 extends Base_IB{
    
	public Integer statusCode;
    public String message;
    public String status;
    
	public NQupdJVProdNotificationAcctSettingsV1Response NQupdJVProdNotificationAcctSettingsV1Response;
    
	public class NQupdJVProdNotificationAcctSettingsV1Response{
		public nbsapdpo nbsapdpo;
        public nbsmsgo nbsmsgo;
		public nqp204o nqp204o;
		
	}
	public class nqp204o{
		public String rc;
	}
	public class nbsmsgo{
		public String nbrUserMsgs;
		public String version;
		public String sysErrTxt;
        public String nbrUserErrs;
		public msgEntry msgEntry;
		
	}
	public class nbsapdpo{
		public String serviceVersion;
		public String reasonCode;
		public String returnCode;
	}
	public class msgEntry{
		public String msgClass;
		public String msgTxt;
		public String msgErrInd;
		public String msgCode;
	}
    
    public nQupdateNotificationsV1_Resp_IB_v2(){
        
    }
}