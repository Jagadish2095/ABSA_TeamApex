/*US:W-002572
*Description:Web Service Response class to get Client Holds From CIF For Client Hold Indicator
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-07-31
* @updated 2019-09-07
*/
public class GetClientHolds_Resp_IB_v1 extends Base_IB{
    public String status;
    public Integer statusCode;
    public String message;
    
   public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CImaintainHoldsV5Response CImaintainHoldsV5Response;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class Cip045o {
		public String rcode;
		public String omessage;
		public String nclta521;
		public String ttlea521;
		public String cinta521;
		public String surna521;
		public String idrq026d;
		public String dest026d;
		public String dsps026d;
		public String iest026d;
		public String cura026d;
		public String cphy026d;
		public String cemp026d;
		public String gadd026d;
		public String apdb026d;
		public String apdt026d;
		public String codb026d;
		public String codt026d;
		public String mcom026d;
		public String ocst026d;
		public String ibrAffected;
		public String inBusinessRescue;
		public String placedBy;
		public String dateBusRescueIss;
		public String clcdo;
		public String secia521;
		public String chnoa521;
		public String idCnt;
		public String forensicHoldOut;
		public String finCrimeHoldOut;
		public String clntAgrmntIssuedOut;
	}

	public class CImaintainHoldsV5Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cip045o cip045o;
	}
   public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	} 
}