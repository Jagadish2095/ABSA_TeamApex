/*
 * Request Integration Bean for retrieveOnDemandStatement Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-02
 * @W-
 */

public class MLRetrieveOnDemandStatement_Req_IB_v1 extends Base_IB {
    public Integer numberOfMonths;
    public Integer accountType;
    public String accountNumber;
    public String businessUnit;

    public static MLRetrieveOnDemandStatement_Req_IB_v1 createDummyRequest() {
        MLRetrieveOnDemandStatement_Req_IB_v1 requestBean = new MLRetrieveOnDemandStatement_Req_IB_v1();

        requestBean.numberOfMonths = 23;
        requestBean.accountType = 3;
        requestBean.accountNumber = '8057676092';
        requestBean.businessUnit = 'ML';

        return requestBean;
    }
}