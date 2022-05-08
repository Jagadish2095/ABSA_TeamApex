/**
 * @description Integration Utility Bean for CIgetAcctLinkedToClientCode Service
 * @author Pitso Sekhu
 * @created 2019-03-01
 */
public class CIgetAcctLinkedToClientCode_IU_v1 {
	/**
	 * @description maps service callout request fields
	 * @param application
	 * @param clientcd
	 * @param accNo
	 * @return CIgetAcctLinkedToClientCode_Req_IB_v1
	 */
	public static CIgetAcctLinkedToClientCode_Req_IB_v1 mapRequestFields(String application, String clientcd, String accNo) {
		CIgetAcctLinkedToClientCode_Req_IB_v1 requestBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();

		requestBean.channel = StringConstants.SALESFORCE_STRING;
		requestBean.application = application;
		requestBean.trace = 'Y';
		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';
		requestBean.finalMsgClass = '';
		requestBean.finalMsgCode = '';
		requestBean.clientcd = clientcd;
		requestBean.accntnbr = accNo;
		requestBean.maxret = '0';
		requestBean.restart = '';
		requestBean.siteCode = '8196';
		return requestBean;
	}

	/**
	 * @description Creates a bean from the response
	 * @param responseP
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */
	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCode_Resp_IB_v1();
		String jsonString = responseP.getBody();
		String finalStringJson = jsonString;
		//this block added - as the response giving different formats for single product and multiple product
		if (jsonString.contains('"outputTable":{')) {
			String substring = jsonString.substringBetween('"outputTable":', '}') + '}';
			String substringReplacement = '[' + substring + ']';
			finalStringJson = jsonString.replace(substring, substringReplacement);
		}

		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBeanContent = (CIgetAcctLinkedToClientCode_Resp_IB_v1) responseBean.deserialize(
			finalStringJson,
			CIgetAcctLinkedToClientCode_Resp_IB_v1.class
		);

		responseBeanContent.status = responseP.getStatus();
		responseBeanContent.statusCode = responseP.getStatusCode();
		responseBeanContent.message = '';
		return responseBeanContent;
	}

	/**
	 * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
	 * @param statusCodeP
	 * @param statusP
	 * @param messageP
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */
	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCode_Resp_IB_v1();
		responseBean.status = statusP;
		responseBean.statusCode = statusCodeP;
		responseBean.message = messageP;
		return responseBean;
	}
}