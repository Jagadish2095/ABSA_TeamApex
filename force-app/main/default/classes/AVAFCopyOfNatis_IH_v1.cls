/**
 * @description Integration Bean for CopyOfNatis Integration Handler Service
 * @author Bhanumurty Rayala
 * @created 2021-03-04
 */

public class AVAFCopyOfNatis_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'AVAFCopyOfNatis';
	/**
	 * @description Method to get Copy Natis response body
	 * @param userIdNumber String
	 * @param userEmail String
	 * @param userName String
	 * @param accountNumber String
	 * @param userSurname String
	 * @return AVAFCopyOfNatis_Resp_IB_v1 object
	 */
	public static AVAFCopyOfNatis_Resp_IB_v1 avafCopyOfNatis(String userIdNumber, String userEmail, String userName, String accountNumber, String userSurname) {
		AVAFCopyOfNatis_Req_IB_v1 requestBean = AVAFCopyOfNatis_IU_v1.mapRequestFields(userIdNumber, userEmail, userName, accountNumber, userSurname);
		AVAFCopyOfNatis_Resp_IB_v1 responseBean = (AVAFCopyOfNatis_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AVAFCopyOfNatis_Resp_IB_v1.class
		);
		return responseBean;
	}
}