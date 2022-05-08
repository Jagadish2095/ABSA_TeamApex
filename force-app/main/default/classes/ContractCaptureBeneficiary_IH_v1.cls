/*
 * Integration Handler for contractCaptureBeneficiary Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2021-02-04
 * @W-007772,007778,007777,007783
 */
public class ContractCaptureBeneficiary_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'contractCaptureBeneficiary';

    public static ContractCaptureBeneficiary_Resp_IB_v1 contractCaptureBeneficiary(ContractCaptureBeneficiary_Req_IB_v1 requestBean) {
        ContractCaptureBeneficiary_Resp_IB_v1 responseBean = (ContractCaptureBeneficiary_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, ContractCaptureBeneficiary_Resp_IB_v1.class);
        return responseBean;
    }
}