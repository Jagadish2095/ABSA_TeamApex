/*
 * Integration Handler Class for bcmsgetdocumentsforcase
 * @author Haritha Police
 * @created 20-01-2021
 */

public class CAFGetCase_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'BcmsGetCase';

    public static CAFGetCase_Resp_IB_v1 bcmsgetcasev1data(string caseId) {
        CAFGetCase_Req_IB_v1 requestBean = CAFGetCase_IU_v1.mapReqfieldsForGetCase(caseId);
        CAFGetCase_Resp_IB_v1 responseBean = (CAFGetCase_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CAFGetCase_Resp_IB_v1.class);
        return responseBean;
    }
}