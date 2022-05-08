/*
 * Integration Handler for LAUpdateBeneficiaryDetailsV2 Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-07-21
 * @W-006280,W-006906,W-006901,W-006929
 */
public class LAUpdateBeneficiaryDetailsV2_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'LAupdateBeneficiaryDetailsV2';

    public static LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 LAUpdateBeneficiaryDetailsV2(LAUpdateBeneficiaryDetailsV2_Req_IB_v1 requestBean) {
        LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 responseBean = (LAUpdateBeneficiaryDetailsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, LAUpdateBeneficiaryDetailsV2_Resp_IB_v1.class);
        return responseBean;
    }
}