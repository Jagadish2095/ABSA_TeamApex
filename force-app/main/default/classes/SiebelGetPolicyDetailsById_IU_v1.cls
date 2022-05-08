/*
 * Integration Utility class for SiebelGetPolicyDetailsById Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */
/**
 * @description SiebelGetPolicyDetailsById_IU_v1 Description
 *
 */
public class SiebelGetPolicyDetailsById_IU_v1 {
	/**
	 * @description mapRequestFields description
	 *
	 * @param IdType (String): IdType
	 * @param IdNumber (String): IdNumber
	 * @return Return SiebelGetPolicyDetailsById_Req_IB_v1: Return description
	 */
	public static SiebelGetPolicyDetailsById_Req_IB_v1 mapRequestFields(String IdType, String IdNumber) {
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
		requestBean.Request.Message.GetPoliciesByIDRequest.idNumber = IdNumber;
		requestBean.Request.Message.GetPoliciesByIDRequest.idType = IdType;

		return requestBean;
	}
}