/*
 * Integration Handler for LAListPolicyDetailsByPolicyV7 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */

public class LAListPolicyDetailsByPolicyV7_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'LA List Policy Details By Policy V7';

    public static LAListPolicyDetailsByPolicyV7_Resp_IB_v1 LAListPolicyDetailsByPolicyV7(String policyNumber) {
        LAListPolicyDetailsByPolicyV7_Req_IB_v1 requestBean = LAListPolicyDetailsByPolicyV7_IU_v1.mapRequestFields(policyNumber);
        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = (LAListPolicyDetailsByPolicyV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, LAListPolicyDetailsByPolicyV7_Resp_IB_v1.class);

        return responseBean;
    }
}