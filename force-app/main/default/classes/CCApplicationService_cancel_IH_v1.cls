/*
 * Integration Handler Bean for CCApplicationService cancel
 * @author Prudence Shirindzi
 * @created 2020-10-20
 */
public class CCApplicationService_cancel_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'CCApplicationService cancel';
    
    public static  CCApplicationService_cancel_Resp_IB_v1 CCApplicationServiceCancel(CCApplicationService_cancel_Req_IB_v1 requestBean){
        CCApplicationService_cancel_Resp_IB_v1 responseBean = ( CCApplicationService_cancel_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  CCApplicationService_cancel_Resp_IB_v1.class);
        return responseBean;
    }

}