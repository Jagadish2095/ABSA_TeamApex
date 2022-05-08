/**
* 
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CClistPrefProductForClientV2_Resp_IB_v2 extends Base_IB{

    public CCS317O CCS317O;
	public NBSAPDPO NBSAPDPO;
	public NBSMSGO3 NBSMSGO3;

	public class ProductListTable {
		public String prodCode;
		public String prodBrand;
		public String accountNumber;
		public String prodType;
	}

	public class OutputCopybook {
		public List<ProductListTable> productListTable;
		public String cifRetrievedIndicator;
		public String sbuCode;
		public String numberProdReturned;
	}

	public class CCS317O {
		public OutputCopybook outputCopybook;
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

	public static CClistPrefProductForClientV2_Resp_IB_v2 createDummyResponse() {
        CClistPrefProductForClientV2_Resp_IB_v2 responseBean = new CClistPrefProductForClientV2_Resp_IB_v2();
        CClistPrefProductForClientV2_Resp_IB_v2.NBSAPDPO nbsapdpoBean = new CClistPrefProductForClientV2_Resp_IB_v2.NBSAPDPO();
        CClistPrefProductForClientV2_Resp_IB_v2.NBSMSGO3 nbsmsgo3Bean  = new CClistPrefProductForClientV2_Resp_IB_v2.NBSMSGO3();
		CClistPrefProductForClientV2_Resp_IB_v2.CCS317O ccs3170Bean  = new CClistPrefProductForClientV2_Resp_IB_v2.CCS317O();

		CClistPrefProductForClientV2_Resp_IB_v2.OutputHeader outputHeaderBean = new CClistPrefProductForClientV2_Resp_IB_v2.OutputHeader();
		CClistPrefProductForClientV2_Resp_IB_v2.OutputErrorMessage outputErrMsgBean = new CClistPrefProductForClientV2_Resp_IB_v2.OutputErrorMessage();
		CClistPrefProductForClientV2_Resp_IB_v2.ErrorMessageTable errMsgTableBean = new CClistPrefProductForClientV2_Resp_IB_v2.ErrorMessageTable();
		CClistPrefProductForClientV2_Resp_IB_v2.ProductListTable prodTableBean = new CClistPrefProductForClientV2_Resp_IB_v2.ProductListTable();
		CClistPrefProductForClientV2_Resp_IB_v2.OutputCopybook outputCopyBookBean = new CClistPrefProductForClientV2_Resp_IB_v2.OutputCopybook();
        List<CClistPrefProductForClientV2_Resp_IB_v2.ProductListTable> prodListTable = new List<CClistPrefProductForClientV2_Resp_IB_v2.ProductListTable>();
		List<CClistPrefProductForClientV2_Resp_IB_v2.ErrorMessageTable> errorMsgTable = new List<CClistPrefProductForClientV2_Resp_IB_v2.ErrorMessageTable>();
		
		outputHeaderBean.echoKey = '';
		outputHeaderBean.reasonCode = '0';
		outputHeaderBean.returnCode = '0';
		outputHeaderBean.serviceVersion = 'BUSO001';
		outputHeaderBean.version = 'APLO003';
		nbsapdpoBean.outputHeader = outputHeaderBean;
		responseBean.NBSAPDPO = nbsapdpoBean;

        errMsgTableBean.errorMessageClass = 'CCS299';
        errMsgTableBean.errorMessageCode = '0003';
        errMsgTableBean.errorMessageIndicator = 'E';
        errMsgTableBean.errorMessageText = 'Account number 0000009051341450 does not exist';
		errorMsgTable.add(errMsgTableBean);

        outputErrMsgBean.systemErrorText = '';
        outputErrMsgBean.numberUserErrors = '1';
        outputErrMsgBean.numberUserMessages = '1';
        outputErrMsgBean.errorMessageTable = errorMsgTable;
        outputErrMsgBean.version = '';
		nbsmsgo3Bean.outputErrorMessage = outputErrMsgBean;
		responseBean.NBSMSGO3 = nbsmsgo3Bean;

        prodTableBean.accountNumber = '0';
        prodTableBean.prodBrand = '';
        prodTableBean.prodCode = '0';
        prodTableBean.prodType = '';
		prodListTable.add(prodTableBean);

        outputCopyBookBean.cifRetrievedIndicator = '';
        outputCopyBookBean.numberProdReturned = '0';
        outputCopyBookBean.productListTable = prodListTable;
		outputCopyBookBean.sbuCode = '';
		ccs3170Bean.outputCopybook = outputCopyBookBean;
		responseBean.CCS317O = ccs3170Bean;

		return responseBean;
	}
}