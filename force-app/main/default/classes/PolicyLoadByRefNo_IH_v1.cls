/**
 * @description Integration Handler for policyLoadByRefNo Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2021-02-04
 * @W-007776
 */
public class PolicyLoadByRefNo_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'policyLoadByRefNo';
    
    /**
     * @description method to call the policyLoadByRefNo method
     * @param policyNumber
     * @return responseBean
     */
    public static PolicyLoadByRefNo_Resp_IB_v1 policyLoadByRefNo(String policyNumber) {
        PolicyLoadByRefNo_Req_IB_v1 requestBean = PolicyLoadByRefNo_IU_v1.mapRequestFields(policyNumber);
        PolicyLoadByRefNo_Resp_IB_v1 responseBean = (PolicyLoadByRefNo_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, PolicyLoadByRefNo_Resp_IB_v1.class);
        return responseBean;
    }
}