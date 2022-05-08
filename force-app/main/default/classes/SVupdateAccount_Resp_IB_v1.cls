/** 
 *@description Integration Handler for CIgetClientDetailsByNameV2 Service
 * @author Edited by Prudence Shirindzi 
 * @created 2021-05-12
 */
public without sharing class SVupdateAccount_Resp_IB_v1 extends Base_IB {

	public NBSMSGO nBSMSGO;
	public NBSAPDPO nBSAPDPO;

	/** 
	 * @description NBSMSGO
	 */
	public without sharing class NBSMSGO {
		public NBSMSGO3 nBSMSGO3;
	}
	/** 
	 * @description NBSAPLO
	 */
	public without sharing class NBSAPLO {
		public String serviceVersion;
		public Integer returnCode;
		public Integer reasonCode;
	}

	/** 
	 * @description NBSAPDPO
	 */
	public without sharing class NBSAPDPO {
		public NBSAPLO nBSAPLO;
	}
	/** 
	 * @description MessageEntry
	 */
	public without sharing class MessageEntry {
		public String messageText;
		public String messageClass;
		public String messageErrorIndicator;
		public String messageCode;
	}
	/** 
	 * @description NBSMSGO3
	 */
	public without sharing class NBSMSGO3 {
		public String systemErrorText;
		public String messageVersion;
		public List<MessageEntry> messageEntry;
		public Integer numberUserErrors;
		public Integer numberUserMessages;
	}

	
	//public static SVupdateAccount_Resp parse(String json) {
	//	return (SVupdateAccount_Resp) System.JSON.deserialize(json, SVupdateAccount_Resp.class);
	//}
}