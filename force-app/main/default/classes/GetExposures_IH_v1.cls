/**
 * @description       : Handler class for GetExposures service
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-10   Himani Joshi   Initial Version
**/

public class GetExposures_IH_v1 {
    public static final String INTEGRATION_API_NAME = 'Jitterbit2';
    public static final String INTEGRATION_SERVICE_NAME = 'Get Exposures';
    public static final String METHOD_NAME = 'GetExposures';

    /**
    * @description : Method to get response
    * @author Himani Joshi | 2021-06-10 
    * @param clientCode 
    * @return GetExposures_Resp_IB_v1 
    **/
    public static GetExposures_Resp_IB_v1 GetExposures(String clientCode) {
        GetExposures_Req_IB_v1 requestBean = GetExposures_IU_v1.mapRequestFields(clientCode); //request mapping
        GetExposures_Resp_IB_v1 responseBean = (GetExposures_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetExposures_Resp_IB_v1.class);
        return responseBean;
    }
}