/*
* Integration Handler for IBgetRegistrationDetailsV1 Service
* @author Srinivas
* @created 2020-10-07
*/
public class IBgetRegistrationDetailsV1_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'IBgetRegistrationDetailsV1';
    
    public static IBgetRegistrationDetailsV1_Resp_v1 IBgetRegistrationDetailsV1(IBgetRegistrationDetailsV1_Req_v1 requestBean) {
        IBgetRegistrationDetailsV1_Resp_v1 responseBean = (IBgetRegistrationDetailsV1_Resp_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBgetRegistrationDetailsV1_Resp_v1.class);
        return responseBean;
        
    }
    
}