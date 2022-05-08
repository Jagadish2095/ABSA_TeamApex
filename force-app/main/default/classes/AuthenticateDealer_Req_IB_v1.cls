/**
 * @description Request Integration Bean for DealerVerification Service
 * @author manideep kenche
 * @created 2021-10-15
 * @work W-014039
 */
public class AuthenticateDealer_Req_IB_v1 extends Base_IB{
public BAPI_SF_DLR_DETAILS BAPI_SF_DLR_DETAILS;
    /*** 
     * @description BAPI_SF_DLR_DETAILS
*/
	public class BAPI_SF_DLR_DETAILS {
		public String I_DEALER ;
		public String I_USER ;	
	}
    /***
     *  @description create dummy request
* @return AuthenticateDealer_Req_IB_v1 bean object
*/
    public static AuthenticateDealer_Req_IB_v1 createDummyRequest() {
       AuthenticateDealer_Req_IB_v1 requestBean = new AuthenticateDealer_Req_IB_v1();
        BAPI_SF_DLR_DETAILS ac = new BAPI_SF_DLR_DETAILS();
        ac.I_DEALER='0000513119';
        ac.I_USER = 'ab0131R';
        requestBean.BAPI_SF_DLR_DETAILS = ac;
        return requestBean;
    }
}