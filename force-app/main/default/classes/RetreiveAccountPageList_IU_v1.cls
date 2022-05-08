/**
 * @description Integration Utility class for Retreive Account PageList Service
 * @author Manideep kenche
 * @created 2021-08-20
 */
public class RetreiveAccountPageList_IU_v1 {
	/**
	 * @description mapRequestFields
	 * @param AGENCY_ID
	 * @return Map<String, String>
	 */
	public static Map<String, String> mapRequestFields(String AGENCY_ID) {
		Map<String, String> customHeaders = new Map<String, String>{ 'AGENCY_ID' => AGENCY_ID, 'PAGE_NAME' => 'GENERAL' };
		return customHeaders;
	}
}