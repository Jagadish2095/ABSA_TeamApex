/**
 * @description Integration Utility class for Payment Schedule Summaries Service
 * @author Manideep kenche
 * @created 2021-08-31
 */
public class PaymentScheduleSummaries_IU_v1 {
	/**
	 * @description mapRequestFields
	 *@param AGENCY_ID
	 * @return Map<String, String>
	 */
	public static Map<String, String> mapRequestFields(String AGENCY_ID) {
		Map<String, String> customHeaders = new Map<String, String>{ 'AGENCY_ID' => AGENCY_ID };
		return customHeaders;
	}
}