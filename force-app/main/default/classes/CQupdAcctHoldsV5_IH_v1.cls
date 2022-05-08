/* * Response from CQupdAcctHoldsV5 Service
 * @author Satya Boyenepalli
 * @created 2020-12-08
 */
public class CQupdAcctHoldsV5_IH_v1 {
public static final String INTEGRATION_SERVICE_NAME = 'CQupdAcctHoldsV5';

    public static CQupdAcctHoldsV5_Resp_IB_v1 CQupdAcctHoldsV5(CQupdAcctHoldsV5_Req_IB_v1 requestBean) {
        CQupdAcctHoldsV5_Resp_IB_v1 responseBean = (CQupdAcctHoldsV5_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQupdAcctHoldsV5_Resp_IB_v1.class);
        return responseBean;
    }
}