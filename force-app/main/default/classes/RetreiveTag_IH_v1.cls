/**
 * @description Integration Handler class for Retrieve Tags Service
 * @author Manideep kenche
 * @created 2021-08-18
 */
public class RetreiveTag_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Retrieve Tags';
/**
 * @description RetreiveTag
 * @param AGENCY_ID
 * @return RetreiveTag_Resp_IB_v1
 */
	public static RetreiveTag_Resp_IB_v1 RetreiveTag(string AGENCY_ID) {
		Map<String, string> storeheader = RetreiveTag_IU_v1.mapRequestFields(AGENCY_ID);

		RetreiveTag_Resp_IB_v1 responseBean = (RetreiveTag_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			null,
			storeheader,
			INTEGRATION_SERVICE_NAME,
			RetreiveTag_Resp_IB_v1.class
		);

		return responseBean;
	}
}