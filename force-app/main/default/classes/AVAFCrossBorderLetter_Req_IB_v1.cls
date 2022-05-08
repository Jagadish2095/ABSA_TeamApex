/**
 * @description Request Integration Bean for crossBorderLetter Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-13
 * @W-006962
 */

public class AVAFCrossBorderLetter_Req_IB_v1 extends Base_IB {
	public String systemId;
	public String accountNumber;
	public String userEmail;
	public String userIdNumber;
	public String userName;
	public String userSurname;
	public String driverName;
	public String driverIdNumber;
	public String periodStart;
	public String periodEnd;
	public String userId;

	/**
	 * @description Method that creates a dummy request for AVAFCrossBorderLetter
	 * @return AVAFCrossBorderLetter_Req_IB_v1
	 */
	public static AVAFCrossBorderLetter_Req_IB_v1 createDummyRequest() {
		AVAFCrossBorderLetter_Req_IB_v1 requestBean = new AVAFCrossBorderLetter_Req_IB_v1();

		requestBean.systemId = 'Salesforce';
		requestBean.accountNumber = '00073548581';
		requestBean.userEmail = 'test@absa.africa';
		requestBean.userIdNumber = '7910125061088';
		requestBean.userName = 'testName';
		requestBean.userSurname = 'testSurname';
		requestBean.driverName = 'test';
		requestBean.driverIdNumber = '201010676710';
		requestBean.periodStart = '20201106';
		requestBean.periodEnd = '20201114';
		requestBean.userId = 'ABNMBGE';

		return requestBean;
	}
}