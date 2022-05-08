/**
* @description Request bean for BAPI_SF_IF42
* @author Bhanumurty Rayala
* @created 2021-06-08
*/
public class BAPI_SF_AccountFinInfo_Req_IB_v1 extends Base_IB{
    public BAPI_SF_IF42 BAPI_SF_IF42;
    /**
* @description Wrapper inner class for input variables
*/
    public class BAPI_SF_IF42{
        public String I_USER;
        public String I_ACCOUNT;
    }
    
    /**
	 * @description Method to create a request for test data
	 * @return BAPI_SF_AccountFinInfo_Req_IB_v1
	 */
	public static BAPI_SF_AccountFinInfo_Req_IB_v1 createDummyRequest() {
		BAPI_SF_AccountFinInfo_Req_IB_v1 requestBean = new BAPI_SF_AccountFinInfo_Req_IB_v1();
		requestBean.BAPI_SF_IF42 = new BAPI_SF_AccountFinInfo_Req_IB_v1.BAPI_SF_IF42();

		requestBean.BAPI_SF_IF42.I_ACCOUNT = '00073550470';
		requestBean.BAPI_SF_IF42.I_USER = 'ab0131R';

		return requestBean;
	}
}