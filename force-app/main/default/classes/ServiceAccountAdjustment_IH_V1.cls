/**
 * @description Integration Handler for ServiceAccountAdjustment Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 08/07/2021
 */
public class ServiceAccountAdjustment_IH_V1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Service Account Adjustment v1';
    /**
	 * @description ServiceAccountAdjustmentV1 method
     * @param SPID
     * @param Phonenumber
     * @param accType
     * @param accNumber
     * @param amount
     * @param retrievalRefNumber
	 * @return ServiceAccountAdjustment_Resp_IB_V1
	 */
	public static ServiceAccountAdjustment_Resp_IB_V1 ServiceAccountAdjustmentV1(
		String SPID,
		String Phonenumber,
		String accType,
		String accNumber,
		String amount,
		String retrievalRefNumber
	) {
		ServiceAccountAdjustment_Req_IB_V1 requestBean = ServiceAccountAdjustment_IU_V1.mapRequestFields(
			SPID,
			Phonenumber,
			accType,
			accNumber,
			amount,
			retrievalRefNumber
		);
		ServiceAccountAdjustment_Resp_IB_V1 responseBean = (ServiceAccountAdjustment_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null, 
			INTEGRATION_SERVICE_NAME,
			ServiceAccountAdjustment_Resp_IB_V1.class
		);

		return responseBean;
	}
}