/*
 * Integration Utility class for retrieveOnDemandStatement Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-02
 * @W-
 */

public class MLRetrieveOnDemandStatement_IU_v1 {
    public static MLRetrieveOnDemandStatement_Req_IB_v1 mapRequestFields(Integer numberOfMonths, Integer accountType, String accountNumber) {
        MLRetrieveOnDemandStatement_Req_IB_v1 requestBean = new MLRetrieveOnDemandStatement_Req_IB_v1();

        requestBean.numberOfMonths = numberOfMonths;
        requestBean.accountType = accountType;
        requestBean.accountNumber = accountNumber.replaceFirst('^0+', '');
        requestBean.businessUnit = 'ML';

        return requestBean;
    }
}