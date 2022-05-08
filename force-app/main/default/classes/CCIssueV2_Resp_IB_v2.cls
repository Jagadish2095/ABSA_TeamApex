/**
* Apex Integration Response Bean class for CCIssueV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CCIssueV2_Resp_IB_v2 extends Base_IB{

    public class CCS311O {
		public OutputCopybook outputCopybook;
	}

	public CCS311O CCS311O;
	public NBSAPDPO NBSAPDPO;
	public NBSMSGO3 NBSMSGO3;

	public class OutputCopybook {
		public String combiNumber;
		public String prtPassNumber;
		public String lvpNumber;
	}

	public class NBSAPDPO {
		public OutputHeader outputHeader;
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
	
	public static CCIssueV2_Resp_IB_v2 createDummyResponse() {
		CCIssueV2_Resp_IB_v2 responseBean = new CCIssueV2_Resp_IB_v2();
		CCIssueV2_Resp_IB_v2.NBSAPDPO nbsapdpoBean = new CCIssueV2_Resp_IB_v2.NBSAPDPO();
		CCIssueV2_Resp_IB_v2.NBSMSGO3 nbsmsgo3Bean = new CCIssueV2_Resp_IB_v2.NBSMSGO3();
		CCIssueV2_Resp_IB_v2.CCS311O ccs3110Bean = new CCIssueV2_Resp_IB_v2.CCS311O();

		CCIssueV2_Resp_IB_v2.OutputHeader outputHeaderBean = new CCIssueV2_Resp_IB_v2.OutputHeader();
		outputHeaderBean.echoKey = '';
		outputHeaderBean.reasonCode = '0';
		outputHeaderBean.returnCode = '0';
		outputHeaderBean.serviceVersion = 'BUSO001';
		outputHeaderBean.version = '';
		nbsapdpoBean.outputHeader = outputHeaderBean;
		responseBean.NBSAPDPO = nbsapdpoBean;

		CCIssueV2_Resp_IB_v2.OutputErrorMessage outputErrorMsg = new CCIssueV2_Resp_IB_v2.OutputErrorMessage();
		CCIssueV2_Resp_IB_v2.ErrorMessageTable errorMsgTableBean = new CCIssueV2_Resp_IB_v2.ErrorMessageTable();
		List<CCIssueV2_Resp_IB_v2.ErrorMessageTable> errorMsgTableList = new List<CCIssueV2_Resp_IB_v2.ErrorMessageTable>();

		errorMsgTableBean.errorMessageClass = 'CCS299';
		errorMsgTableBean.errorMessageCode = '0053';
		errorMsgTableBean.errorMessageIndicator = 'E';
		errorMsgTableBean.errorMessageText = 'Card Required s invalid, must be \"Y\" or \"N\"';
		errorMsgTableList.add(errorMsgTableBean);

		outputErrorMsg.errorMessageTable = errorMsgTableList;
		outputErrorMsg.numberUserErrors = '1';
		outputErrorMsg.numberUserMessages = '1';
		outputErrorMsg.systemErrorText = '';
		outputErrorMsg.version = '';
		nbsmsgo3Bean.outputErrorMessage = outputErrorMsg;
		responseBean.NBSMSGO3 = nbsmsgo3Bean;

		CCIssueV2_Resp_IB_v2.OutputCopybook outputCopyBookBean = new CCIssueV2_Resp_IB_v2.OutputCopybook();
		outputCopyBookBean.combiNumber = '';
		outputCopyBookBean.lvpNumber = '';
		outputCopyBookBean.prtPassNumber = '';
		ccs3110Bean.outputCopybook = outputCopyBookBean;
		responseBean.CCS311O = ccs3110Bean;

		return responseBean;
	}
}