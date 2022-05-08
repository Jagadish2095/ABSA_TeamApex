/*
 * Integration Handler  Bean for bcmscreatecase
 * @author Sandile Mathe
 * @created 12-01-2021
 */

public class CAFCreateCase_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'bcmscreatecase';

    public static CAFCreateCase_Resp_IB_v1 createCaseInBCMS(String xmlData) {
        CAFCreateCase_Req_IB_v1 requestBean = CAFCreateCase_IU_v1.mapRequestFields(xmlData);
        CAFCreateCase_Resp_IB_v1 responseBean = (CAFCreateCase_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CAFCreateCase_Resp_IB_v1.class);
        return responseBean;
    }
}