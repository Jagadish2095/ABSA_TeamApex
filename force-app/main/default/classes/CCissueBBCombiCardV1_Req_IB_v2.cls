/**
* Apex Integration Request Bean class for CCissueBBCombiCardV1 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CCissueBBCombiCardV1_Req_IB_v2 extends Base_IB{

    public class CCS868I {
		public InputCopybook inputCopybook;
	}

	public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}

	public class InputErrorMessage {
		public String errorMessageLanguage;
		public String errorMessgeTarget;
	}

	public class InputCopybook {
		public String tellerCode;
		public String workStation;
		public String supervisor;
		public String branchCode;
		public String consumerID;
		public String clientCode;
		public String accountNumber;
		public String productCode;
		public String brandNumber;
		public String issueBranch;
		public String sbuCode;
		public String secClientCode;
		public String persIndicator;
		public String nameIndicator;
		public String persName;
		public String nomCheq;
		public String nomSavs;
		public String deliveryMethod;
		public String deliveryBranch;
		public String blindIndicator;
	}

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CCS868I CCS868I;

	public class NBSMSGI {
		public InputErrorMessage inputErrorMessage;
	}

	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}

	
	public static CCissueBBCombiCardV1_Req_IB_v2 createDummyRequest() {

		CCissueBBCombiCardV1_Req_IB_v2 requestBean = new CCissueBBCombiCardV1_Req_IB_v2();
		CCissueBBCombiCardV1_Req_IB_v2.NBSAPDPI nbsapdpiBean = new CCissueBBCombiCardV1_Req_IB_v2.NBSAPDPI();
		CCissueBBCombiCardV1_Req_IB_v2.NBSMSGI nbsmsgiBean = new CCissueBBCombiCardV1_Req_IB_v2.NBSMSGI();
		CCissueBBCombiCardV1_Req_IB_v2.CCS868I ccs868iBean = new CCissueBBCombiCardV1_Req_IB_v2.CCS868I();

		CCissueBBCombiCardV1_Req_IB_v2.InputHeaders inputHeaderBean = new CCissueBBCombiCardV1_Req_IB_v2.InputHeaders();
		CCissueBBCombiCardV1_Req_IB_v2.InputErrorMessage inputErrorMsgBean = new CCissueBBCombiCardV1_Req_IB_v2.InputErrorMessage();
		CCissueBBCombiCardV1_Req_IB_v2.InputCopybook inputCopyBookBean = new CCissueBBCombiCardV1_Req_IB_v2.InputCopybook();

		inputHeaderBean.applicationName = 'BDP';
		inputHeaderBean.channelName = 'BDP';
		inputHeaderBean.traceIndicator = 'Y';
		nbsapdpiBean.inputHeaders = inputHeaderBean;
		requestBean.NBSAPDPI = nbsapdpiBean;
		System.debug('inputHeaderBean: '+ inputHeaderBean);
		System.debug('requestBean : '+ requestBean);

		inputErrorMsgBean.errorMessageLanguage = 'E';
		inputErrorMsgBean.errorMessgeTarget = 'STD';
		nbsmsgiBean.inputErrorMessage = inputErrorMsgBean;
		requestBean.NBSMSGI = nbsmsgiBean;
		
        inputCopyBookBean.tellerCode = '99997';
        inputCopyBookBean.workStation = 'du';
        inputCopyBookBean.supervisor = '999997';
        inputCopyBookBean.branchCode = '999998';
        inputCopyBookBean.consumerID = '4980202755063808';
        inputCopyBookBean.clientCode = 'leaboege';
        inputCopyBookBean.accountNumber = '898631881';
        inputCopyBookBean.productCode = '99997';
        inputCopyBookBean.brandNumber = '26495';
        inputCopyBookBean.issueBranch = '999997';
        inputCopyBookBean.sbuCode = 'g';
        inputCopyBookBean.secClientCode = '6011437624128292';
        inputCopyBookBean.persIndicator = 'm';
        inputCopyBookBean.nameIndicator = 'Luella Ward';
        inputCopyBookBean.persName = 'May Garcia';
        inputCopyBookBean.nomCheq = '2572864634';
        inputCopyBookBean.nomSavs = '205130988';
        inputCopyBookBean.deliveryMethod = 'b';
        inputCopyBookBean.deliveryBranch = '999998';
        inputCopyBookBean.blindIndicator = 'i';
		ccs868iBean.inputCopybook = inputCopyBookBean;
		requestBean.CCS868I = ccs868iBean;

		return requestBean;
	}
}