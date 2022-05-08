/**
 * @description Integration Utility class for crossBorderLetter Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-16
 * @W-006962
 */

public class AVAFCrossBorderLetter_IU_v1 {
	/**
	 * @description map the request for AVAFCrossBorderLetter
	 * @param accountNumber String
	 * @param userEmail String
	 * @param userIdNumber String
	 * @param userName String
	 * @param userSurname String
	 * @param driverName String
	 * @param driverIdNumber String
	 * @param periodStart String
	 * @param periodEnd String
	 * @return AVAFCrossBorderLetter_Req_IB_v1
	 */
	public static AVAFCrossBorderLetter_Req_IB_v1 mapRequestFields(
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
		AVAFCrossBorderLetter_Req_IB_v1 requestBean = new AVAFCrossBorderLetter_Req_IB_v1();

		requestBean.systemId = 'Salesforce';
		requestBean.accountNumber = accountNumber;
		requestBean.userEmail = userEmail;
		requestBean.userIdNumber = userIdNumber;
		requestBean.userName = userName;
		requestBean.userSurname = userSurname;
		requestBean.driverName = driverName;
		requestBean.driverIdNumber = driverIdNumber;
		requestBean.periodStart = periodStart;
		requestBean.periodEnd = periodEnd;
		//Query and map the user's AB Number
		User user = new UsersSelector().selectById(UserInfo.getUserId());
		requestBean.userId = user.AB_Number__c;

		return requestBean;
	}
}