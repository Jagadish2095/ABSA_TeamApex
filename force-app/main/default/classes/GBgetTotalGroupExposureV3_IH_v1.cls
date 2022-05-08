/**
 * Integration Handler for for GBgetTotalGroupExposureV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020/12/29
 */
public class GBgetTotalGroupExposureV3_IH_v1 {
    public static final String INTEGRATION_API_NAME = 'Jitterbit2';
    public static final String INTEGRATION_SERVICE_NAME = 'GB Get Total Group Exposure V3';

    public static GBgetTotalGroupExposureV3_Resp_IB_v1 GBgetTotalGroupExposureV3(String clientCode) {
        GBgetTotalGroupExposureV3_Req_IB_v1 requestBean = GBgetTotalGroupExposureV3_IU_v1.mapRequestFields(clientCode);
        GBgetTotalGroupExposureV3_Resp_IB_v1 responseBean = (GBgetTotalGroupExposureV3_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GBgetTotalGroupExposureV3_Resp_IB_v1.class);
        System.debug('responseBean::: ' + JSON.serializePretty(responseBean));
        return responseBean;
    }
}