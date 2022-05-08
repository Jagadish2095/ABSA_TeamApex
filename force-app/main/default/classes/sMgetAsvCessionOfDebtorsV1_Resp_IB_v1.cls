/**
 * @description       : 
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfDebtorsV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;
/** @description : Wrapper class */
	public class SMgetASVCessionOfDebtorsV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Smp170eo smp170eo;
	}
/** @description : Wrapper class */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}
/** @description : Wrapper class */
	public class Table {
		public String seqnoOut;
		public String anldteOut;
		public String cesdteOut;
		public String cgicinOut;
		public String clcd;
		public String num0Out;
		public String num30Out;
		public String num60Out;
		public String num90Out;
		public String num120Out;
		public String numtotOut;
		public String amt0Out;
		public String amt30Out;
		public String amt60Out;
		public String amt90Out;
		public String amt120Out;
		public String amttotOut;
		public String specifOut;
		public String refaccOut;
		public String statusOut;
		public String keynumOut;
		public String eotdteOut;
		public String amtcedOut;
		public String nomvalOut;
		public String secvalOut;
		public String asvamtOut;
		public String msvamtOut;
        public String ApplicationId;
        
	}

	public SMgetASVCessionOfDebtorsV1Response SMgetASVCessionOfDebtorsV1Response;
/** @description : Wrapper class */
	public class Nbsmsgo3 {
		public String version;
		public Object sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}
/** @description : Wrapper class */
	public class MsgEntry {
		public Object msgClass;
		public Object msgCode;
		public Object msgErrInd;
		public Object msgTxt;
	}
/** @description : Wrapper class */
	public class Smp170eo {
		public String clcdOut;
		public String nomvalTotOut;
		public String secvalTotOut;
		public String asvamtTotOut;
		public String msvamtTotOut;
		public String successInd;
		public List<Table> table;
	}}