/**
 * @description Integration Handler for CClistAccsLinkedToCombiV1 Service
 * @author Humbelani Denge
 * @created 2021-02-12
 */
public class CClistAccsLinkedToCombiV1_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CC list Accs Linked To Combi Card';
	/**
	 * @description handler method to trigger service callout
	 * @param combiNumber
	 * @return CClistAccsLinkedToCombiV1_Resp_IB_v1
	 */
	public static CClistAccsLinkedToCombiV1_Resp_IB_v1 CCListAccsLinkedToCombi(String combiNumber) {
		CClistAccsLinkedToCombiV1_Req_IB_v1 requestBean = CClistAccsLinkedToCombiV1_IU_v1.mapRequestFields(combiNumber);
		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = (CClistAccsLinkedToCombiV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			CClistAccsLinkedToCombiV1_Resp_IB_v1.class
		);

		return responseBean;
	}
}