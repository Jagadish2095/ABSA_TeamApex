/**
 * @description Request Integration Bean for CopyOfNatis Request Service
 * @author Bhanumurty Rayala
 * @created 2021-03-03
 */

public class AVAFCopyOfNatis_Req_IB_v1 extends Base_IB {
	public String userIdNumber;
	public String userEmail;
	public String userName;
	public String accountNumber;
	public String userSurname;
	public String systemId;

	/**
	 * @description Method to create a dummy request.
	 * @return requestBean
	 */
	public static AVAFCopyOfNatis_Req_IB_v1 createDummyRequest() {
		AVAFCopyOfNatis_Req_IB_v1 requestBean = new AVAFCopyOfNatis_Req_IB_v1();
		requestBean.userIdNumber = '8309305930080';
		requestBean.userEmail = 'test@absa.africa';
		requestBean.userName = 'testName';
		requestBean.accountNumber = '00077075815';
		requestBean.userSurname = 'testSurname';
		requestBean.systemId = 'Salesforce';

		return requestBean;
	}
}