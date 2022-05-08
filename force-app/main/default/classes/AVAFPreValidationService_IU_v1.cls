/*
 * Integration Utility class for preValidationServiceRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @version v2.0
 * @created 2020-11-03
 */

public class AVAFPreValidationService_IU_v1 {
    public static AVAFPreValidationService_Req_IB_v1 mapRequestFields(Integer accountNumber) {
        AVAFPreValidationService_Req_IB_v1 requestBean = new AVAFPreValidationService_Req_IB_v1();
        requestBean.channel = 'Salesforce';
        requestBean.transactionCode = 0;
        requestBean.accountNumber = accountNumber;
        return requestBean;
    }
}