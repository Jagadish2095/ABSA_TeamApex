/**
 * @description       : Handler class for getProductExposure service
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/

public class GetProductExposureAggre_IH_v1 {
    public static final String INTEGRATION_API_NAME = 'Jitterbit2';
    public static final String INTEGRATION_SERVICE_NAME = 'Exposure';

    /**
    * @description :Method to get the response from the service
    * @author Gopi| 2021-06-11 
    * @param requestBean 
    * @return GetProductExposureAggre_Resp_IB_v1 
    **/
    public static GetProductExposureAggre_Resp_IB_v1 getProductExposure(GetProductExposureAggre_Req_IB_v1 requestBean) {
        GetProductExposureAggre_Resp_IB_v1 responseBean = (GetProductExposureAggre_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetProductExposureAggre_Resp_IB_v1.class);
        System.debug('responseBean :::: ' + JSON.serializePretty(responseBean));
        return responseBean;
    }
 }