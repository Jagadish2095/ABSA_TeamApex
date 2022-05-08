/*
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since   2020-09-18
*/

public class CVSUpdateCIFv22_Resp_IB_v1 extends Base_IB 
{
 
	public Body body;
	public String statusCode;
	public Integer statusCodeValue;
    public StatusMessage statusMessage;
	
	public class Error 
	{
		public List<String> reason;
		public String field;
	}

	public class StatusMessage 
	{
		public List<Error> error;
	}

	public class Nbsaplo {
		public String serviceVersion;
		public Integer returnCode;
		public Integer reasonCode;
		public String version;

	}
	
	public class NBSAPDPO {
		public Nbsaplo nbsaplo;
	}
	
	public class Nbsmsgo3 {
		public String sysErrTxt;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String version;
		public List<MsgEntry> msgEntry;
	}
	
	public class MsgEntry {
		public String msgClass;
		public String msgTxt;
		public String msgErrInd;
		public String msgCode;
	}
	
	public class NBSMSGO3_z {
		public Nbsmsgo3 nbsmsgo3;
	}
	
	public class CIupdateClientDetailsV22Response {
		public Integer returnCode;

	}
	
	public class CIB004O {
		public CIupdateClientDetailsV22Response CIupdateClientDetailsV22Response;

	}
	
	public class Body {
		public NBSAPDPO NBSAPDPO;
		public NBSMSGO3_z NBSMSGO3;
		public CIB004O CIB004O;

	}
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
	
}