/*
 * Request Integration Bean for preValidationServiceRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @version v2.0
 * @created 2020-11-02
 */
public class AVAFPreValidationService_Req_IB_v1 extends Base_IB {
    public String channel;
    public Integer transactionCode;
    public Integer accountNumber;

    public static AVAFPreValidationService_Req_IB_v1 createDummyRequest() {
        AVAFPreValidationService_Req_IB_v1 requestBean = new AVAFPreValidationService_Req_IB_v1();
        requestBean.channel = 'Salesforce';
        requestBean.transactionCode = 0;
        requestBean.accountNumber = 75666239;
        return requestBean;
    }
}