/*
 * Request Integration Bean for HanisValidate Service
 * @author Prashant Jain
 * @created 2020-02-12
 */

public class HanisValidate_Req_IB_v1 extends Base_IB {

    public String requestDataObject;
	public String serviceID;
	
	public class RequestDataObjectBody {
		public String applicationID;
		public String applicationKey;
		public String serviceVersion;
		public String siteCode;
		public String userID;
		public String tellerID;
		public String clientID;
		public String getCert;
	}

    public static HanisValidate_Req_IB_v1 createDummyRequest() {
        HanisValidate_Req_IB_v1 requestBean = new HanisValidate_Req_IB_v1();

        requestBean.serviceID = 'NPR_VALIDATE';
		
		RequestDataObjectBody requestDataObjectBody = new RequestDataObjectBody();
		requestDataObjectBody.applicationID = 'A2KYCPOC';
		requestDataObjectBody.applicationKey = 'dd6f85dd-72cc-4e0b-94a1-82b48db93557';
		requestDataObjectBody.serviceVersion = '1.1';
		requestDataObjectBody.siteCode = 'testCode';
		requestDataObjectBody.userID = 'ABTest';
		requestDataObjectBody.tellerID = 'ABTest';
		requestDataObjectBody.clientID = '7707077777087';
		requestDataObjectBody.getCert = 'Y';
		
        requestBean.requestDataObject = JSON.serialize(requestDataObjectBody);

        return requestBean;
    }
}