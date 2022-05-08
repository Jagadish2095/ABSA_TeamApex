/**
 * @description Integration Handler for ServiceProvidersDataEnquiry Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 22/04/2021
 */
public class ServiceProvidersDataEnquiry_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Service Providers Data Enquiry';
    /**
	 * @description serviceProvidersDataEnquiry method
	 * @param customHeaders
	 * @return ServiceProvidersDataEnquiry_Resp_IB_v1
	 */
	public static ServiceProvidersDataEnquiry_Resp_IB_v1 serviceProvidersDataEnquiry(Map<String, String> customHeaders) {
		ServiceProvidersDataEnquiry_Resp_IB_v1 responseBean = (ServiceProvidersDataEnquiry_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			null,
			customHeaders,
			INTEGRATION_SERVICE_NAME,
			ServiceProvidersDataEnquiry_Resp_IB_v1.class
		);

		return responseBean;
	}
}