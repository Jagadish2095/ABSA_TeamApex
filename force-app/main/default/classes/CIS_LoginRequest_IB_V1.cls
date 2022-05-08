/**
 * @description       : Login Request class for CIS
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          	  Modification
 * 1.0   2021-05-24   Mohammed Junaid U   Initial Version
**/

public class CIS_LoginRequest_IB_V1 extends Base_IB{

    public LoginRequest LoginRequest;
	/**
	 * @description
	 */
	public class LoginRequest {

		public String DataStore;
	    public String UserName;
	    public String Password;
	}
	/**
	 * @description
	 */
    public CIS_LoginRequest_IB_V1(){}
}