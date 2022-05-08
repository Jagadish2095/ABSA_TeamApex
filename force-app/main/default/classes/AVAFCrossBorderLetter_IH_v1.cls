/**
 * @description Integration Handler for crossBorderLetter Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-16
 * @W-006962
 */

public class AVAFCrossBorderLetter_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'AVAFCrossBorderLetter';

	/**
	 * @description Integration Handler for AVAFCrossBorderLetter service callout
	 * @param accountNumber String
	 * @param userEmail String
	 * @param userIdNumber String
	 * @param userName String
	 * @param userSurname String
	 * @param driverName String
	 * @param driverIdNumber String
	 * @param periodStart String
	 * @param periodEnd String
	 * @return AVAFCrossBorderLetter_Resp_IB_v1
	 */
	public static AVAFCrossBorderLetter_Resp_IB_v1 crossBorderLetterRequest(
		String accountNumber,
		String userEmail,
		String userIdNumber,
		String userName,
		String userSurname,
		String driverName,
		String driverIdNumber,
		String periodStart,
		String periodEnd
	) {
		AVAFCrossBorderLetter_Req_IB_v1 requestBean = AVAFCrossBorderLetter_IU_v1.mapRequestFields(
			accountNumber,
			userEmail,
			userIdNumber,
			userName,
			userSurname,
			driverName,
			driverIdNumber,
			periodStart,
			periodEnd
		);
		AVAFCrossBorderLetter_Resp_IB_v1 responseBean = (AVAFCrossBorderLetter_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AVAFCrossBorderLetter_Resp_IB_v1.class
		);
		return responseBean;
	}
}