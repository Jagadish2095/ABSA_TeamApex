/**
 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CIdeleteFromFICALockoutV1_IH_v1 {
   
    public static final String INTEGRATION_SERVICE_NAME = 'CIdeleteFromFICALockoutV1';
    public static CIdeleteFromFICALockoutV1_Resp_IB_v1 deleteFromFicaLockout(CIdeleteFromFICALockoutV1_Req_IB_v1 requestBean){
        CIdeleteFromFICALockoutV1_Resp_IB_v1 responseBean = (CIdeleteFromFICALockoutV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CIdeleteFromFICALockoutV1_Resp_IB_v1.class);
        return responseBean;
    }
}