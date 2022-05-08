/**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 */
public class CAFUpdateCase_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'bcmssavecase';
/**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 * @param xmlData
 * @param businessOriginatorRef
 * @return
 */
    public static CAFUpdateCase_Resp_IB_v1 updateCaseInBCMS(String xmlData, String businessOriginatorRef) {
        CAFUpdateCase_Req_IB_v1 requestBean = CAFUpdateCase_IU_v1.mapRequestFields(xmlData,businessOriginatorRef);
        system.debug ('BCMS update case request: ' + requestBean);
        CAFUpdateCase_Resp_IB_v1 responseBean = (CAFUpdateCase_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CAFUpdateCase_Resp_IB_v1.class);
        system.debug ('BCMS update case response : ' + responseBean);
        return responseBean;
    }
}