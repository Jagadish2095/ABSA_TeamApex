/**
 * @description Request Integration Bean for MBlistInstructionsPerSourceAccV1 Service
 * @author Chandra Bhushan
 * @created 2020-03-12
 */

public class MBlistInstPerSourceAccV1_Req_IB_v1 extends Base_IB {
	/**
	 * @description InputHeaders class
	 */
	public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}

	/**
	 * @description InputErrorMessage class
	 */
	public class InputErrorMessage {
		public String errorMessageLanguage;
		public String errorMessageTarget;
	}

	/**
	 * @description InputCopybook class
	 */
	public class InputCopybook {
		public String channel;
		public Integer maxRetrieve;
		public String processIndicator;
		public String origType;
		public String origStatus;
		public Integer altTieb;
		public String cifKey;
		public Double tieb;
		public String instrType;
		public Integer instrNumber;
		public Integer multiNumber;
		public String instrStatus;
		public String sourceAccount;
	}

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public MBS326I MBS326I;

	/**
	 * @description MBS326I class
	 */
	public class MBS326I {
		public InputCopybook inputCopybook;
	}

	/**
	 * @description NBSMSGI class
	 */
	public class NBSMSGI {
		public InputErrorMessage inputErrorMessage;
	}

	/**
	 * @description NBSAPDPI class
	 */
	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}

	/**
	 * @description createDummyRequest method to create dummy request
	 * @return MBlistInstPerSourceAccV1_Req_IB_v1
	 */
	public static MBlistInstPerSourceAccV1_Req_IB_v1 createDummyRequest() {
		MBlistInstPerSourceAccV1_Req_IB_v1 requestBean = new MBlistInstPerSourceAccV1_Req_IB_v1();
		requestBean.NBSAPDPI = new MBlistInstPerSourceAccV1_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new MBlistInstPerSourceAccV1_Req_IB_v1.NBSMSGI();
		requestBean.MBS326I = new MBlistInstPerSourceAccV1_Req_IB_v1.MBS326I();
		requestBean.NBSAPDPI.InputHeaders = new MBlistInstPerSourceAccV1_Req_IB_v1.InputHeaders();
		requestBean.NBSMSGI.InputErrorMessage = new MBlistInstPerSourceAccV1_Req_IB_v1.InputErrorMessage();
		requestBean.MBS326I.InputCopybook = new MBlistInstPerSourceAccV1_Req_IB_v1.InputCopybook();
		requestBean.NBSAPDPI.InputHeaders.channelName = 'SALESFOR';
		requestBean.NBSAPDPI.InputHeaders.applicationName = 'SALESFOR';
		requestBean.NBSAPDPI.InputHeaders.traceIndicator = 'Y';
		requestBean.NBSMSGI.InputErrorMessage.errorMessageLanguage = 'E';
		requestBean.NBSMSGI.InputErrorMessage.errorMessageTarget = 'STD';
		requestBean.MBS326I.InputCopybook.channel = 'SALESFOR';
		requestBean.MBS326I.InputCopybook.maxRetrieve = 50;
		requestBean.MBS326I.InputCopybook.processIndicator = '';
		requestBean.MBS326I.InputCopybook.origType = '';
		requestBean.MBS326I.InputCopybook.origStatus = '';
		requestBean.MBS326I.InputCopybook.altTieb = 0;
		requestBean.MBS326I.InputCopybook.cifKey = 'PIERIDO001';
		requestBean.MBS326I.InputCopybook.tieb = 0;
		requestBean.MBS326I.InputCopybook.instrType = 'VP';
		requestBean.MBS326I.InputCopybook.instrNumber = 0;
		requestBean.MBS326I.InputCopybook.multiNumber = 0;
		requestBean.MBS326I.InputCopybook.instrStatus = 'CURRENT';
		requestBean.MBS326I.InputCopybook.sourceAccount = '04451450000062516';

		return requestBean;
	}
}