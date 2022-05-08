/**
* @description Integration Utility class for DealerVerification Service
* @author manideep kenche
* @created 2021-10-15
* @work W-014039
*/
public class AuthenticateDealer_IU_v1 {
    /***
* @description mapping fields
* @param I_DEALER
* @param I_USER
* @return AuthenticateDealer_Req_IB_v1 bean object
*/
    public static AuthenticateDealer_Req_IB_v1 mapRequestFields(String I_DEALER,String I_USER) {
        AuthenticateDealer_Req_IB_v1 requestBean = new AuthenticateDealer_Req_IB_v1();
        requestBean.BAPI_SF_DLR_DETAILS =new AuthenticateDealer_Req_IB_v1.BAPI_SF_DLR_DETAILS();
        requestBean.BAPI_SF_DLR_DETAILS.I_DEALER=I_DEALER;
        requestBean.BAPI_SF_DLR_DETAILS.I_USER=I_USER;
        return requestBean;
    }
}