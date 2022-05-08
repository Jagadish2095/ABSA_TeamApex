/**
 * Integration response class for cqupdautooverdraftloadv2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class Cqupdautooverdraftloadv2_Resp_IB_v1 extends Base_IB { 
	public NBSAPDPO NBSAPDPO;
	public CQS573O CQS573O;
	public NBSMSGO3 NBSMSGO3;

	public class OutputHeaders {
		public String serviceVersion;
		public Integer returnCode;
		public String echoKey;
		public Integer reasonCode;
		public String version;
	}

	public class OutputArea {
		public Integer outputReturnCode;
		public String outputErrorDescription;
	}

	public class ErrorMessagesOutput {
		public String systemErrorText;
		public List<MessageEntryTable> messageEntryTable;
		public String versionNumber;
		public Integer numberUserErrors;
		public Integer numberUserMessages;
	}

	public class NBSAPDPO {
		public OutputHeaders outputHeaders;
	}

	public class CQS573O {
		public OutputArea outputArea;
	}

	public class MessageEntryTable {
		public String messageClass;
		public String messageErrorIndicator;
		public String messageCode;
		public String errorMessageText;
	}

	public class NBSMSGO3 {
		public ErrorMessagesOutput errorMessagesOutput;
	}
}