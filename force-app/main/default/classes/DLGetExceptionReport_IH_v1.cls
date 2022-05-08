/**
 * @description Integration Handler for DLGetExceptionReport Service
 * @author Jason Quevauvilliers
 * @created 2021-03-29
 */
public class DLGetExceptionReport_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'DL Get Exception Report For Customer';
	/**
	 * @description Calls DLGetExceptionReport Service
	 * @param cifCode
	 * @return DLGetExceptionReport_Resp_IB_v1
	 */
	public static DLGetExceptionReport_Resp_IB_v1 getExceptionReport(String cifCode) {
		DLGetExceptionReport_Req_IB_v1 requestBean = DLGetExceptionReport_IU_v1.mapRequestFields(cifCode);
		DLGetExceptionReport_Resp_IB_v1 responseBean = (DLGetExceptionReport_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			DLGetExceptionReport_Resp_IB_v1.class
		);
		return responseBean;
	}
}