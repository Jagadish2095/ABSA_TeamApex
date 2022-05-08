/**
 * Integration Handler for CQgetOverdraftDetailsV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-07-28
 */

public class CQgetOverdraftDetailsV4_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CQ Get Overdraft Details V4';

    public static CQgetOverdraftDetailsV4_Resp_IB_v1 CQgetOverdraftDetailsV4(String accountNbr, String processingSite,String processingSiteType, String tellerNbr, String agencyCode, String agencyType, String controllerNbr, String corpCode) {
        CQgetOverdraftDetailsV4_Req_IB_v1 requestBean = CQgetOverdraftDetailsV4_IU_v1.mapRequestFields(accountNbr, processingSite, processingSiteType, tellerNbr, agencyCode, agencyType, controllerNbr, corpCode);
        CQgetOverdraftDetailsV4_Resp_IB_v1 responseBean = (CQgetOverdraftDetailsV4_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQgetOverdraftDetailsV4_Resp_IB_v1.class);
        return responseBean;
    }
}