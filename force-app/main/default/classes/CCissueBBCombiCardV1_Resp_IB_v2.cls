/**
* Apex Integration Response Bean class for CCissueBBCombiCardV1 service
* @author  Mbuyiseni Mbhokane
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_Resp_IB_v2 extends Base_IB{

    public NBSAPDPO NBSAPDPO;
	public CCS868O CCS868O;
	public NBSMSGO3 NBSMSGO3;

	public class OutputCopybook {
		public String deliveryFeeAmount;
		public String newCombiNumber;
		public String deliveryFeeType;
		public String cardFeeType;
		public String cardFeeAmount;
		public String cardIssueIndicator;
		public String deliveryFeeIndicator;
		public String cardFeeIndicator;
	}

	public class NBSAPDPO {
		public OutputHeader outputHeader;
	}

	public class CCS868O {
		public OutputCopybook outputCopybook;
	}

	public class ErrorMessageTable {
		public String errorMessageCode;
		public String errorMessageIndicator;
		public String errorMessageText;
		public String errorMessageClass;
	}

	public class OutputHeader {
		public String serviceVersion;
		public String returnCode;
		public String echoKey;
		public String reasonCode;
		public String version;
	}

	public class NBSMSGO3 {
		public OutputErrorMessage outputErrorMessage;
	}

	public class OutputErrorMessage {
		public String systemErrorText;
		public String version;
		public String numberUserErrors;
		public List<ErrorMessageTable> errorMessageTable;
		public String numberUserMessages;
	}

	
	public static CCissueBBCombiCardV1_Resp_IB_v2 createDummyResponse() {
		CCissueBBCombiCardV1_Resp_IB_v2 responseBean = new CCissueBBCombiCardV1_Resp_IB_v2();
		
        CCissueBBCombiCardV1_Resp_IB_v2.NBSAPDPO nbsapdpoBean = new CCissueBBCombiCardV1_Resp_IB_v2.NBSAPDPO();
        CCissueBBCombiCardV1_Resp_IB_v2.NBSMSGO3 nbsmsgo3Bean = new CCissueBBCombiCardV1_Resp_IB_v2.NBSMSGO3();
		CCissueBBCombiCardV1_Resp_IB_v2.CCS868O ccs8680Bean = new CCissueBBCombiCardV1_Resp_IB_v2.CCS868O();

		CCissueBBCombiCardV1_Resp_IB_v2.OutputHeader outputHeaderBean  = new CCissueBBCombiCardV1_Resp_IB_v2.OutputHeader();
		CCissueBBCombiCardV1_Resp_IB_v2.OutputErrorMessage outputErrMsgBean = new CCissueBBCombiCardV1_Resp_IB_v2.OutputErrorMessage();
		CCissueBBCombiCardV1_Resp_IB_v2.OutputCopybook outputCopyBookBean = new CCissueBBCombiCardV1_Resp_IB_v2.OutputCopybook();
		CCissueBBCombiCardV1_Resp_IB_v2.ErrorMessageTable errMsgTableBean = new CCissueBBCombiCardV1_Resp_IB_v2.ErrorMessageTable();
		List<CCissueBBCombiCardV1_Resp_IB_v2.ErrorMessageTable> errorMsgTableList = new List<CCissueBBCombiCardV1_Resp_IB_v2.ErrorMessageTable>();
		
		outputHeaderBean.echoKey = '';
		outputHeaderBean.reasonCode = '0';
		outputHeaderBean.returnCode = '0';
		outputHeaderBean.serviceVersion = 'BUSO001';
		outputHeaderBean.version = '';
		nbsapdpoBean.outputHeader = outputHeaderBean;
		responseBean.NBSAPDPO = nbsapdpoBean;

		errMsgTableBean.errorMessageClass = 'CCS299';
		errMsgTableBean.errorMessageCode = '0015';
		errMsgTableBean.errorMessageIndicator = 'E';
		errMsgTableBean.errorMessageText = 'Brand 01565 blocked for Issuing';
		errorMsgTableList.add(errMsgTableBean);

		outputErrMsgBean.errorMessageTable = errorMsgTableList;
		outputErrMsgBean.numberUserErrors = '1';
		outputErrMsgBean.numberUserMessages = '1';
		outputErrMsgBean.systemErrorText = '';
		outputErrMsgBean.version = '';
		nbsmsgo3Bean.outputErrorMessage = outputErrMsgBean;
		responseBean.NBSMSGO3 = nbsmsgo3Bean;

        outputCopyBookBean.deliveryFeeAmount = '0.00';
        outputCopyBookBean.newCombiNumber = '0';
        outputCopyBookBean.deliveryFeeType = '';
        outputCopyBookBean.cardFeeType = '';
        outputCopyBookBean.cardFeeAmount = '0.00';
        outputCopyBookBean.cardIssueIndicator = 'N';
        outputCopyBookBean.deliveryFeeIndicator = '';
		outputCopyBookBean.cardIssueIndicator = '';
		ccs8680Bean.outputCopybook = outputCopyBookBean;
		responseBean.CCS868O = ccs8680Bean;
		
		return responseBean;
	}
}