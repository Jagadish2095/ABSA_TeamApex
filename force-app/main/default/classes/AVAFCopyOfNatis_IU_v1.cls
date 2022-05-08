/**
 * @description Integration Bean for CopyOfNatis Integration Utilities Service
 * @author Bhanumurty Rayala
 * @created 2021-03-04
 */

public class AVAFCopyOfNatis_IU_v1 {
	/**
	 * @description Method to get Copy Natis request bean
	 * @param userIdNumber String
	 * @param userEmail String
	 * @param userName String
	 * @param accountNumber String
	 * @param userSurname String
	 * @return AVAFCopyOfNatis_Req_IB_v1 object
	 */
	public static AVAFCopyOfNatis_Req_IB_v1 mapRequestFields(string userIdNumber, String userEmail, string userName, string accountNumber, string userSurname) {
		AVAFCopyOfNatis_Req_IB_v1 requestBean = new AVAFCopyOfNatis_Req_IB_v1();
		requestBean.userIdNumber = userIdNumber;
		requestBean.userEmail = userEmail;
		requestBean.userName = userName;
		requestBean.accountNumber = accountNumber;
		requestBean.userSurname = userSurname;
		requestBean.systemId = 'Salesforce';
		return requestBean;
	}
}