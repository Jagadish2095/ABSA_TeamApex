/**
 *  * @description Integration Handler class for Payment Schedule Summaries Service
 * @author Manideep kenche
 * @created 2021-08-31
 */
public class PaymentScheduleSummaries_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Payment Schedule Summaries';
	/** 
* @description  GetPaymentScheduleSummaries
@param AGENCY_ID
@return PaymentScheduleSummaries_Resp_IB_v1
* @author Manideep kenche
* @created 2021-08-31
*/
	public static PaymentScheduleSummaries_Resp_IB_v1 GetPaymentScheduleSummaries(string AGENCY_ID) {
		Map<String, string> storeheader = PaymentScheduleSummaries_IU_v1.mapRequestFields(AGENCY_ID);

		PaymentScheduleSummaries_Resp_IB_v1 responseBean = (PaymentScheduleSummaries_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			null,
			storeheader,
			INTEGRATION_SERVICE_NAME,
			PaymentScheduleSummaries_Resp_IB_v1.class
		);

		return responseBean;
	}
}