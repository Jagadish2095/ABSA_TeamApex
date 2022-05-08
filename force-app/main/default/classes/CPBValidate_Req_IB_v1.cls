/**
 * @description Request Integration Bean for CPBValidate Service
 * @author Prashant Jain
 * @created 2020-02-06
 * @updated 2021/10/13
 * @updatedby Humbelani Denge
 */
public class CPBValidate_Req_IB_v1 extends Base_IB {
	public RequestDataObject requestDataObject;
	public String serviceID;
	/**
	 * @description RequestDataObject
	 */
	public class RequestDataObject {
		public String applicationID;
		public String tellerID;
		public String siteName;
		public String siteCode;
		public String userID;
		public String idNumber;
		public String surname;
		public String applicationKey;
		public String serviceVersion;
	}

	/**
	 * @description createDummyRequest
	 * @return CPBValidate_Req_IB_v1
	 */
	public static CPBValidate_Req_IB_v1 createDummyRequest() {
		CPBValidate_Req_IB_v1 requestBean = new CPBValidate_Req_IB_v1();

		requestBean.serviceID = 'CPB_VALIDATE';

		requestBean.requestDataObject = new RequestDataObject();
		requestBean.requestDataObject.applicationID = 'A2KYCPOC';
		requestBean.requestDataObject.applicationKey = 'dd6f85dd-72cc-4e0b-94a1-82b48db93557';
		requestBean.requestDataObject.serviceVersion = '1.1';
		requestBean.requestDataObject.siteCode = 'testCode';
		requestBean.requestDataObject.userID = 'ABTest';
		requestBean.requestDataObject.idNumber = '7707077777087';
		requestBean.requestDataObject.surname = 'Burger';
		requestBean.requestDataObject.tellerID = 'Test TellerID';
		requestBean.requestDataObject.siteName = 'Test SiteName';

		return requestBean;
	}
}