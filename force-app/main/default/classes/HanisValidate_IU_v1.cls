/*
 * Integration Utility Bean for HanisValidate Service
 * @author Prashant Jain
 * @created 2020-02-12
 */
public class HanisValidate_IU_v1{
	public static HanisValidate_Req_IB_v1 mapRequestFields(String clientID){
		HanisValidate_Req_IB_v1 requestBean = new HanisValidate_Req_IB_v1();

		requestBean.serviceID = 'NPR_VALIDATE';
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

		HanisValidate_Req_IB_v1.RequestDataObjectBody requestDataObjectBody = new HanisValidate_Req_IB_v1.RequestDataObjectBody();
		requestDataObjectBody.applicationID = Label.CPBValidateAppID;
		requestDataObjectBody.applicationKey = Label.CPBValidateAppKey;
		requestDataObjectBody.serviceVersion = '1.1';
		requestDataObjectBody.siteCode = currentUser.SiteCode__c;
		requestDataObjectBody.userID = currentUser.AB_Number__c;
		requestDataObjectBody.tellerID = currentUser.Teller_Operator_Code__c;
		requestDataObjectBody.getCert = 'Y';

		requestDataObjectBody.clientID = clientID;

		requestBean.requestDataObject = JSON.serialize(requestDataObjectBody);

		System.debug('HanisValidate Request Bean: ' + requestBean);
		return requestBean;
	}

	/* Creates a bean from the response
	 * @param: HTTP Response
	 * @return: HanisValidate_Resp_IB_v1 bean object
	 */
	public static HanisValidate_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
		HanisValidate_Resp_IB_v1 responseBeanContent;

		try{
			HanisValidate_Resp_IB_v1 responseBean = new HanisValidate_Resp_IB_v1();
			responseBeanContent = (HanisValidate_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), HanisValidate_Resp_IB_v1.class);

			responseBeanContent.status = responseP.getStatus();
			responseBeanContent.statusCode = responseP.getStatusCode();
			//responseBeanContent.message = '';
		} catch (Exception e){
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage()+'. ' + e.getStackTraceString();
			responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
			System.debug(message);
		}

		System.debug('HanisValidate Response bean: ' + responseBeanContent);
		return responseBeanContent;
	}

	/* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
	 * @param: Status Code
	 * @param: Status
	 * @param: message
	 * @return: HanisValidate_Resp_IB_v1 bean object
	 * */
	public static HanisValidate_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
		HanisValidate_Resp_IB_v1 responseBean = new HanisValidate_Resp_IB_v1();
		responseBean.status = statusP;
		responseBean.statusCode = statusCodeP;
		responseBean.message = messageP;

		System.debug('HanisValidate Failed Response bean: ' + responseBean);
		return responseBean;
	}
}