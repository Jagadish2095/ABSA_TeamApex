/**
 * @description Integration Handler for MLgetPayoffDetailsV1 Service
 * @author Jason Quevauvilliers
 * @created 2020-10-20
 * Edited by Simangaliso: 27 Aug 2021
 */
public class MLgetPayoffDetailsV1_IH_v1 extends Base_IB {
    public static final String INTEGRATION_SERVICE_NAME = 'ML Get Payoff Details V1';

    /**
     * @description method for handle method for making the call-out to MLgetPayoffDetailsV1
     * @param mortgageLoanNo
     * @param payAllAcc
     * @param effectiveDate
     * @param includeCommit
     * @return MLgetPayoffDetailsV1_Resp_IB_v1
     */
    public static MLgetPayoffDetailsV1_Resp_IB_v1 MLgetPayoffDetailsV1(String mortgageLoanNo, String payAllAcc, String effectiveDate, String includeCommit) {
        MLgetPayoffDetailsV1_Req_IB_v1 requestBean = MLgetPayoffDetailsV1_IU_v1.mapRequestFields(mortgageLoanNo, payAllAcc, effectiveDate, includeCommit);
        MLgetPayoffDetailsV1_Resp_IB_v1 responseBean = (MLgetPayoffDetailsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MLgetPayoffDetailsV1_Resp_IB_v1.class);

        return responseBean;
    }
}