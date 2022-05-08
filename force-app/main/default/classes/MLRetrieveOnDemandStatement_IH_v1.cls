/*
 * Integration Handler for retrieveOnDemandStatement Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-02
 * @W-
 */

public class MLRetrieveOnDemandStatement_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'MLRetrieveOnDemandStatement';

    public static MLRetrieveOnDemandStatement_Resp_IB_v1 onDemandStatementRequest(Integer numberOfMonths, Integer accountType, String accountNumber) {
        MLRetrieveOnDemandStatement_Req_IB_v1 requestBean = MLRetrieveOnDemandStatement_IU_v1.mapRequestFields(numberOfMonths, accountType, accountNumber);
        MLRetrieveOnDemandStatement_Resp_IB_v1 responseBean = (MLRetrieveOnDemandStatement_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            INTEGRATION_SERVICE_NAME,
            MLRetrieveOnDemandStatement_Resp_IB_v1.class
        );
        return responseBean;
    }
}