/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-15
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-08-05   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class CIupdtAuthV20API_Req_IB_v1 extends Base_IB {
	//public CIupdAuthV20API CIupdAuthV20API;
	/**
	 * @description  NBSAPLI
	 */
	public class NBSAPLI {
		public string consumerChannel;
		public string providerApplication;
		public string trace;
	}
	/**
	 * @description  InputHeaders
	 */
	public class InputHeaders {
		public NBSAPLI NBSAPLI;
	}
	/**
	 * @description  InputMessage
	 */
	public class InputMessage {
		public string messageLanguage;
		public string messageTarget;
	}
	/**
	 * @description  InputMessageHeader
	 */
	public class InputMessageHeader {
		public InputMessage inputMessage;
	}
	/**
	 * @description  InputTableData
	 */
	public class InputTableData {
		public string updateOption;
		public string signatoryCifKey;
		public integer signatoryCasaNumber;
		public string compulsorySignatory;
		public integer designation;
	}
	/**
	 * @description  CIupdAuthV20RequestInputData
	 */
	public class CIupdAuthV20RequestInputData {
		public string primaryCifKey;
		public long accountNumber;
		public integer siteCode;
		public integer tellerNumber;
		public integer supervisorOverride;
		public string authType;
		public string numberOfSignatories;
		public string specialConditions;
		public List<InputTableData> inputTableData;
	}
	/**
	 * @description  CIupdAuthV20Request
	 */
	public class CIupdAuthV20Request {
		public CIupdAuthV20RequestInputData CIupdAuthV20RequestInputData;
	}

	/**
	 * @description  CIupdAuthV20API
	 */
//	public class CIupdAuthV20API {
		public InputHeaders inputHeaders;
		public InputMessageHeader inputMessageHeader;
		public CIupdAuthV20Request CIupdAuthV20Request;
//	}

	/**
	 * @description  createDummyRequest
	 * @return CIupdAuthV20API_Req_IB_v1
	 
	public static CIupdtAuthV20API_Req_IB_v1 createDummyRequest() {
		CIupdtAuthV20API_Req_IB_v1 requestBean = new CIupdtAuthV20API_Req_IB_v1();
		requestBean.CIupdAuthV20API = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20API();
		requestBean.CIupdAuthV20API.inputHeaders = new CIupdtAuthV20API_Req_IB_v1.InputHeaders();
		requestBean.CIupdAuthV20API.inputHeaders.NBSAPLI = new CIupdtAuthV20API_Req_IB_v1.NBSAPLI();
		requestBean.CIupdAuthV20API.inputMessageHeader = new CIupdtAuthV20API_Req_IB_v1.InputMessageHeader();
		requestBean.CIupdAuthV20API.CIupdAuthV20Request = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20Request();
		requestBean.CIupdAuthV20API.CIupdAuthV20Request.CIupdAuthV20RequestInputData = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20RequestInputData();
		requestBean.CIupdAuthV20API.CIupdAuthV20Request.CIupdAuthV20RequestInputData.inputTableData = new List<CIupdtAuthV20API_Req_IB_v1.InputTableData>();

		requestBean.CIupdAuthV20API.inputHeaders.NBSAPLI.consumerChannel = 'SALESFORCE';
		requestBean.CIupdAuthV20API.inputHeaders.NBSAPLI.providerApplication = 'SALESFORCE';
		requestBean.CIupdAuthV20API.inputHeaders.NBSAPLI.trace = 'N';

		requestBean.CIupdAuthV20API.inputMessageHeader.inputMessage.messageLanguage = 'E';
		requestBean.CIupdAuthV20API.inputMessageHeader.inputMessage.messageTarget = 'STD';
		CIupdtAuthV20API_Req_IB_v1.InputTableData inputData = new CIupdtAuthV20API_Req_IB_v1.InputTableData();
		inputData.compulsorySignatory = 'Y';
		inputData.designation = 21;
		inputData.signatoryCifKey = 'CIF201';
		inputData.updateOption = 'N';
		inputData.signatoryCasaNumber = 12345;
		return requestBean;
	}*/
}