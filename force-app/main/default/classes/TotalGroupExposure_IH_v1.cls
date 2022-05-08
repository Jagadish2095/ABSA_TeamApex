/**
 * @description       : Handler class for TotalGroupExposure service
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/


public class TotalGroupExposure_IH_v1 {
    public static final String INTEGRATION_API_NAME = 'Jitterbit2';
    public static final String INTEGRATION_SERVICE_NAME = 'Total Group';
    public static final String METHOD_NAME = 'Total Group';

    /**
    * @description :Method to get the response bean
    * @author Thabo Senkomane | 2021-06-11 
    * @param requestBean 
    * @return TotalGroupExposure_Resp_IB_v1 
    **/
    public static TotalGroupExposure_Resp_IB_v1 GetTotalGroup(TotalGroupExposure_Req_IB_v1 requestBean) {
        TotalGroupExposure_Resp_IB_v1 responseBean = (TotalGroupExposure_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, TotalGroupExposure_Resp_IB_v1.class);
        System.debug('responseBean::: ' + JSON.serializePretty(responseBean));
        return responseBean;
    }
}