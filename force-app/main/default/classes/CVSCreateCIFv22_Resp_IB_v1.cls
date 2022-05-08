/*
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since   2020-09-18
*/

public class CVSCreateCIFv22_Resp_IB_v1 extends Base_IB {
	
	public Body body;
	public Integer statusCodeValue ;
	public String statusCode;
	public StatusMessage statusMessage;
	

	public class Nbsapdpo {
		public String serviceVersion;
		public Integer returnCode;
		public Integer reasonCode;
		public String version;
	}
	
	public class CIB003O {
		public CIcreateClientV22Response CIcreateClientV22Response;
	}

	public class Error 
	{
		public List<String> reason;
		public String field;
	}

	public class StatusMessage 
	{
		public List<Error> error;
	}
	
	public class NBSAPDPOClass {
		public Nbsapdpo nbsapdpo;
	}
	
	public class Nbsmsgo3 {
		public String sysErrTxt;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String version;
		public List<MsgEntry> msgEntry;

	}
	
	public class CIcreateClientV22Response {
		public String outputClientKey;

	}
	
	public class MsgEntry {
		public String msgClass;
		public String msgTxt;
		public String msgErrInd;
		public String msgCode;
	}
	
	public class NBSMSGO3Class {
		public Nbsmsgo3 nbsmsgo3;
	}
	
	public class Body {
		public CIB003O CIB003O;
		public NBSAPDPOClass NBSAPDPO;
		public NBSMSGO3Class NBSMSGO3;
}

public override void setFieldNameSubstitutions() {
	fieldNameSubstitutionMap = new Map<String, String>();
	fieldNameSubstitutionMap.put('"number":', '"z_number":');        
}

}