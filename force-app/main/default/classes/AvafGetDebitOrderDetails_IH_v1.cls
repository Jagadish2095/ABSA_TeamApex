/*
 * Integration Handler class for AvafDebitOrderDetails Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetDebitOrderDetails_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'AVAF Get Debit Order Details';

    public static AvafGetDebitOrderDetails_Resp_IB_v1 AvafGetDebitOrderDetails (String avafAccNum){
        AvafGetDebitOrderDetails_Req_IB_v1 requestBean = AvafGetDebitOrderDetails_IU_v1.mapRequestFields(avafAccNum);

        AvafGetDebitOrderDetails_Resp_IB_v1 responseBean = (AvafGetDebitOrderDetails_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafGetDebitOrderDetails_Resp_IB_v1.class);
        return responseBean;
    }
}