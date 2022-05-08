/**
 * Integration Handler for BusinessTrace Service
 * @author Englarmerdge Mongwe
 * @created 2021-01-08
 */
public class BusinessTrace_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Business Trace';

    public static BusinessTrace_Resp_IB_v1 BusinessTrace(String businessName, String searchWord1, String searchWord2, String searchWord3) {
        BusinessTrace_Req_IB_v1 requestBean = BusinessTrace_IU_v1.mapRequestFields(businessName, searchWord1, searchWord2, searchWord3);
        BusinessTrace_Resp_IB_v1 responseBean = (BusinessTrace_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, BusinessTrace_Resp_IB_v1.class);
        return responseBean;
    }
}