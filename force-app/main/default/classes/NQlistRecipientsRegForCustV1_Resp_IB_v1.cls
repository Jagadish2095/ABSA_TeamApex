/*
* Response Integration Bean for NQlistRecipientsRegForCustV1 Service
* @author Khaliq Abdul
* @created 2020-11-20
*/
public class NQlistRecipientsRegForCustV1_Resp_IB_v1 extends Base_IB {
    
   
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

	
}