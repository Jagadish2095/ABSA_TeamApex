/*
* Request Integration Bean for IBgetClientDetails Service
* @author Khaliq Abdul
* @created 2020-10-30
*/
public class CAactionQuotationV4_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'CAactionQuotationV4';

    public static CAactionQuotationV4_Resp_IB_v1 CAactionQuotation(CAactionQuotationV4_Req_IB_v1 requestBean) {
        CAactionQuotationV4_Resp_IB_v1 responseBean = (CAactionQuotationV4_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CAactionQuotationV4_Resp_IB_v1.class);
        return responseBean;
    }
}