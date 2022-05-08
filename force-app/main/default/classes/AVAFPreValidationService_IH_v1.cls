/*
 * Integration Utility class for preValidationServiceRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @version v2.0
 * @created 2020-11-03
 */
public class AVAFPreValidationService_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AVAFPreValidationService';

    public static AVAFPreValidationService_Resp_IB_v1 preValidationService(Integer accountNumber) {
        AVAFPreValidationService_Req_IB_v1 requestBean = AVAFPreValidationService_IU_v1.mapRequestFields(accountNumber);
        AVAFPreValidationService_Resp_IB_v1 responseBean = (AVAFPreValidationService_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AVAFPreValidationService_Resp_IB_v1.class);
        return responseBean;
    }
}