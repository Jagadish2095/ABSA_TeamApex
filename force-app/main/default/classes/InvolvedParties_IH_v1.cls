/**
 * @description Integration Handler for InvolvedParties Service
 * @author Humbelani Denge
 * @created 2021-06-16
 */
public class InvolvedParties_IH_v1 {
	public static String INTEGRATION_SERVICE_NAME;
	/**
	 * @description involvedPartiesFlagging method
	 * @param flags
	 * @param method
	 * @param cifKey
	 * @return InvolvedParties_Resp_IB_v1
	 */
	public static InvolvedParties_Resp_IB_v1 involvedPartiesFlagging(Map<String, String> flags, String method, String cifKey) {
		INTEGRATION_SERVICE_NAME = method.equalsIgnoreCase('create') ? 'Involved Parties Create' : 'Involved Parties Update';
		InvolvedParties_Req_IB_v1 requestBean = InvolvedParties_IU_IB.mapRequestFields(flags, method, cifKey);
		Map<String, String> customHeaders = new Map<String, String>{
			'involved-party-id' => cifKey,
			'involved-party-id-type' => 'CIF',
			'involved-party-version' => '8',
			'application-key' => 'DSR',
			'Calling-user' => 'FICRem_User'
		};

		InvolvedParties_Resp_IB_v1 responseBean = (InvolvedParties_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			customHeaders,
			INTEGRATION_SERVICE_NAME,
			InvolvedParties_Resp_IB_v1.class
		);

		return responseBean;
	}
}