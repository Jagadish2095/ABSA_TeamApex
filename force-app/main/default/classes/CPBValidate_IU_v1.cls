/**
 * @description Integration Utility Bean for CPBValidate Service
 * @author Prashant Jain
 * @created 2020-02-06
 * @updated Kabelo Aphane 22 June 2021
 * @updated Humbelani Denge 2021/10/04
 */
public class CPBValidate_IU_v1 {
	/**
	 * @description method for mapping request fields
	 * @param idNumber
	 * @param surname
	 * @return CPBValidate_Req_IB_v1
	 */
	public static CPBValidate_Req_IB_v1 mapRequestFields(String idNumber, String surname) {
		CPBValidate_Req_IB_v1 requestBean = new CPBValidate_Req_IB_v1();

		requestBean.serviceID = 'CPB_VALIDATE';
		User currentuser = new UsersSelector().selectById(UserInfo.getUserId());
		List<Site__c> sitesList = new SitesSelector().selectBySiteCode(currentuser.SiteCode__c);

		requestBean.requestDataObject = new CPBValidate_Req_IB_v1.requestDataObject();
		requestBean.requestDataObject.applicationID = Label.CPBValidateAppID;
		requestBean.requestDataObject.applicationKey = Label.CPBValidateAppKey;
		requestBean.requestDataObject.serviceVersion = '1.1';
		if (!Test.isRunningTest()) {
			if (String.isNotBlank(currentuser.SiteCode__c)) {
				requestBean.requestDataObject.siteCode = currentuser.SiteCode__c;
			}

			if (String.isNotBlank(currentuser.Teller_Operator_Code__c)) {
				requestBean.requestDataObject.tellerID = currentuser.Teller_Operator_Code__c;
			}

			requestBean.requestDataObject.userID = currentuser.AB_Number__c;

			if (sitesList.size() > 0) {
				requestBean.requestDataObject.siteName = sitesList.get(0).Name;
			}
		} else {
			requestBean.requestDataObject.siteCode = 'Test Site';
			requestBean.requestDataObject.userID = 'AbTest';
			requestBean.requestDataObject.tellerID = 'Test Teller ID';
			requestBean.requestDataObject.siteName = 'Test Site Name';
		}

		requestBean.requestDataObject.idNumber = idNumber;
		requestBean.requestDataObject.surname = surname;
		return requestBean;
	}

	/**
	 * @description Creates a bean from the response
	 * @param responseP
	 * @return CPBValidate_Resp_IB_v1 bean object
	 */
	public static CPBValidate_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
		CPBValidate_Resp_IB_v1 responseBeanContent;

		try {
			CPBValidate_Resp_IB_v1 responseBean = new CPBValidate_Resp_IB_v1();
			responseBeanContent = (CPBValidate_Resp_IB_v1) responseBean.deserialize(responseP.getBody(), CPBValidate_Resp_IB_v1.class);

			responseBeanContent.status = responseP.getStatus();
			responseBeanContent.statusCode = responseP.getStatusCode();
		} catch (Exception e) {
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
		}

		return responseBeanContent;
	}

	/**
	 * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
	 * @param statusCodeP
	 * @param statusP
	 * @param messageP
	 * @return CPBValidate_Resp_IB_v1
	 * */
	public static CPBValidate_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
		CPBValidate_Resp_IB_v1 responseBean = new CPBValidate_Resp_IB_v1();
		responseBean.status = statusP;
		responseBean.statusCode = statusCodeP;
		responseBean.message = messageP;

		return responseBean;
	}
}