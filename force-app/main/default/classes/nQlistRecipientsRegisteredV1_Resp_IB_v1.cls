/*
* Response Integration Bean for NQlistRecipientsRegisteredForCustV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/

public class nQlistRecipientsRegisteredV1_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
	public class Dets {
		public String pnsRecipientId;
		public String recipNm;
		public String contactPref;
		public String lngPref;
        public String email;
		public String cellPhone;
	}

	public class Nqp904o {
		public String sbuCd;
		public Dets dets;
	}

	public class NQlistRecipientsRegisteredForCustV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Nqp904o nqp904o;
	}

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public NQlistRecipientsRegisteredForCustV1Response NQlistRecipientsRegisteredForCustV1Response;

	public class Nbsmsgo {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
    
    public nQlistRecipientsRegisteredV1_Resp_IB_v1(){}
}