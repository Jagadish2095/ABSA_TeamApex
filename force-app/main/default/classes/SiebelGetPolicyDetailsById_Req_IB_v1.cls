/*
 * Request Integration Bean for SiebelGetPolicyDetailsById Service
 * @author Poulami Banerjee
 * @created 2021-16-04
 */
/**
 * @description SiebelGetPolicyDetailsById_Req_IB_v1 Description
 *
 */
public class SiebelGetPolicyDetailsById_Req_IB_v1 extends Base_IB {
	/**
	 * @description GetPoliciesByIDRequest Description
	 *
	 */
	public class GetPoliciesByIDRequest {
		public String idNumber;
		public String idType;
	}

	public Request Request;
	/**
	 * @description Request Description
	 *
	 */
	public class Request {
		public Header Header;
		public Message Message;
	}
	/**
	 * @description Message Description
	 *
	 */
	public class Message {
		public GetPoliciesByIDRequest GetPoliciesByIDRequest;
	}
	/**
	 * @description Header Description
	 *
	 */
	public class Header {
		public String Source;
		public String MessageId;
		public String TransactionId;
		public String ComponentName;
		public String Action;
		public String Version;
	}
	/**
	 * @description createDummyRequest description
	 *
	 * @return Return SiebelGetPolicyDetailsById_Req_IB_v1: Return description
	 */
	public static SiebelGetPolicyDetailsById_Req_IB_v1 createDummyRequest() {
		SiebelGetPolicyDetailsById_Req_IB_v1 requestBean = new SiebelGetPolicyDetailsById_Req_IB_v1();
		requestBean.Request = new SiebelGetPolicyDetailsById_Req_IB_v1.Request();
		requestBean.Request.Header = new SiebelGetPolicyDetailsById_Req_IB_v1.Header();
		requestBean.Request.Message = new SiebelGetPolicyDetailsById_Req_IB_v1.Message();
		requestBean.Request.Message.GetPoliciesByIDRequest = new SiebelGetPolicyDetailsById_Req_IB_v1.GetPoliciesByIDRequest();
		requestBean.Request.Header.Source = 'Salesforce';
		requestBean.Request.Header.MessageId = '4635-6457-5765-7689';
		requestBean.Request.Header.TransactionId = '45534';
		requestBean.Request.Header.ComponentName = 'Test';
		requestBean.Request.Header.Action = 'Query';
		requestBean.Request.Header.Version = '1.0';
		requestBean.Request.Message.GetPoliciesByIDRequest.idNumber = '9401060023083';
		requestBean.Request.Message.GetPoliciesByIDRequest.idType = 'SAIdentityDocument';

		return requestBean;
	}
}