/**
* Apex Integration Request Bean class for cclistprefproductsforclientv2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CClistPrefProductForClientV2_Req_IB_v2 extends Base_IB{

    public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}

	public class InputErrorMessage {
		public String errorMessageLanguage;
		public String errorMessageTarget;
	}

	public class InputCopybook {
		public String tellerCode;
		public String clientCode;
		public String accountNumber;
		public String cardType;
		public String functionIndicator;
	}

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CCS317I CCS317I;

	public class NBSMSGI {
		public InputErrorMessage inputErrorMessage;
	}

	public class CCS317I {
		public InputCopybook inputCopybook;
	}

	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}

	
	public static CClistPrefProductForClientV2_Req_IB_v2 createDummyRequest() {

        CClistPrefProductForClientV2_Req_IB_v2 requestBean = new CClistPrefProductForClientV2_Req_IB_v2();
		CClistPrefProductForClientV2_Req_IB_v2.NBSAPDPI nbsapdpiBean = new CClistPrefProductForClientV2_Req_IB_v2.NBSAPDPI();
		CClistPrefProductForClientV2_Req_IB_v2.NBSMSGI nbsmsgiBean = new CClistPrefProductForClientV2_Req_IB_v2.NBSMSGI();
		CClistPrefProductForClientV2_Req_IB_v2.CCS317I ccs317iBean = new CClistPrefProductForClientV2_Req_IB_v2.CCS317I();

		CClistPrefProductForClientV2_Req_IB_v2.InputHeaders inputHeaderBean = new CClistPrefProductForClientV2_Req_IB_v2.InputHeaders();
		CClistPrefProductForClientV2_Req_IB_v2.InputErrorMessage inputErrorMsgBean = new CClistPrefProductForClientV2_Req_IB_v2.InputErrorMessage();
		CClistPrefProductForClientV2_Req_IB_v2.InputCopybook inputCopyBookBean = new CClistPrefProductForClientV2_Req_IB_v2.InputCopybook();

		inputHeaderBean.applicationName = 'BDP';
		inputHeaderBean.channelName = 'BDP';
		inputHeaderBean.traceIndicator = 'Y';
		nbsapdpiBean.inputHeaders = inputHeaderBean;
		requestBean.NBSAPDPI = nbsapdpiBean;

		inputErrorMsgBean.errorMessageLanguage = 'E';
		inputErrorMsgBean.errorMessageTarget = 'STD';
		nbsmsgiBean.inputErrorMessage = inputErrorMsgBean;
		requestBean.NBSMSGI = nbsmsgiBean;

		inputCopyBookBean.accountNumber = '263404026';
		inputCopyBookBean.cardType = 'C';
		inputCopyBookBean.clientCode = 'kevivih';
		inputCopyBookBean.functionIndicator = 'N';
		inputCopyBookBean.tellerCode = '99998';
		ccs317iBean.inputCopybook = inputCopyBookBean;
		requestBean.CCS317I = ccs317iBean;
		
		return requestBean;
	}

}