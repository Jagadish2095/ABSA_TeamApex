/**
 *@description Response Integration Bean for CAactionQuotationV6 IH
 * @author Jabulani Mashia
 * @created 2021-09-06
 **/
public with sharing class CAactionQuotationV6_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CAactionQuotationV6';
/**
 *@description caActionQuotation
 * @param requestBean
 * @return CAactionQuotationV6_Resp_IB_v1
**/
    public static CAactionQuotationV6_Resp_IB_v1 caActionQuotation(CAactionQuotationV6_Req_IB_v1 requestBean) {
        CAactionQuotationV6_Resp_IB_v1 responseBean = (CAactionQuotationV6_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            null,
            INTEGRATION_SERVICE_NAME,
            CAactionQuotationV6_Resp_IB_v1.class
            );
        return responseBean;
    }
}