/**
 * @description Integration Handler for ServiceCustomerEligibility Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 08/07/2021
 */
public class ServiceCustomerEligibility_IH_V1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Service Customer Eligibility v1';
	/**
	 * @description ServiceCustomerEligibilityV1 method
	 * @param SPID
	 * @param Phonenumber
	 * @param accType
	 * @param amount
	 * @param retrievalRefNumber
	 * @return ServiceCustomerEligibility_Resp_IB_V1
	 */
	public static ServiceCustomerEligibility_Resp_IB_V1 ServiceCustomerEligibilityV1(
		String SPID,
		String Phonenumber,
		String accType,
		String amount,
		String retrievalRefNumber
	) {
		ServiceCustomerEligibility_Req_IB_V1 requestBean = ServiceCustomerEligibility_IU_V1.mapRequestFields(
			SPID,
			Phonenumber,
			accType,
			amount,
			retrievalRefNumber
		);
		ServiceCustomerEligibility_Resp_IB_V1 responseBean = (ServiceCustomerEligibility_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			ServiceCustomerEligibility_Resp_IB_V1.class
		);

		return responseBean;
	}
}