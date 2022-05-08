/**
* @description Integration Handler class for DealerVerification Service
* @author Manideep kenche
* @created 2021-10-15
* @work W-014039
*/
public class AuthenticateDealer_IH_v1 {
 public static final String INTEGRATION_SERVICE_NAME = 'Dealer Verification';
    /*** 
* @description Fetch Dealer Info
* @param I_DEALER
* @param I_USER
* @return AuthenticateDealer_Resp_IB_v1
*/
    public static AuthenticateDealer_Resp_IB_v1 AuthenticateDealer(String I_DEALER,String I_USER) {
        AuthenticateDealer_Req_IB_v1 requestBean = AuthenticateDealer_IU_v1.mapRequestFields(I_DEALER,I_USER);
        AuthenticateDealer_Resp_IB_v1 responseBean = (AuthenticateDealer_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean,null,INTEGRATION_SERVICE_NAME, AuthenticateDealer_Resp_IB_v1.class);
        return responseBean;
    }
}