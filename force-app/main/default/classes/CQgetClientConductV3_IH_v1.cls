/**
 * Integration Handler for CQgetClientConductV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020-08-06
 */

public class CQgetClientConductV3_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CQ Get Client Conduct V3';

    public static CQgetClientConductV3_Resp_IB_v1 CQgetClientConductV3(String accountNbr, String branchCode, String branchSiteType, String tellerCode, String siteTypeAgency, String supervisorCode, String agencyCode, String corpCode) {
        CQgetClientConductV3_Req_IB_v1 requestBean = CQgetClientConductV3_IU_v1.mapRequestFields(accountNbr, branchCode, branchSiteType, tellerCode, siteTypeAgency, supervisorCode, agencyCode, corpCode);
        CQgetClientConductV3_Resp_IB_v1 responseBean = (CQgetClientConductV3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQgetClientConductV3_Resp_IB_v1.class);
        return responseBean;
    }
}