/*
* Integration Response Bean for create and Link Account
* @author Almas Aleem:Absa  
* @created 2020-12-07
*/
public class ABFCreateAndLinkAccount_Resp_IB_v1 extends Base_IB{
    
public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public Nbsapdpo nbsapdpo;
	public Nbsmsgo3 nbsmsgo3;
	public Plpa00o plpa00o;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}

	public class Plpa00o {
		public String accountNumber;
		public String eddRiskHoldInd;
		public String accOrigChannel;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

}