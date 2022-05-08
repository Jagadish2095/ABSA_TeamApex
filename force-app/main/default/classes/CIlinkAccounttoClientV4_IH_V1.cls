/*
 * Integration Handler class for CIlinkAccounttoClientV4 Service
 * @author Saurabh
 * @created 2020-06-03 
 */

public class CIlinkAccounttoClientV4_IH_V1 { 
    public static final String INTEGRATION_API_NAME = 'JitterbitDev';  //change this to string constant class once finalised
    public static final String INTEGRATION_SERVICE_NAME = 'CIlinkAccounttoClientv4';
    public static final String SERVICE_NAME = 'CIlinkAccounttoClientv4';
    public static final String METHOD_NAME = 'CIlinkAccounttoClientv4';

    public static CIlinkAccounttoClientV4_Resp_IB_V1 CIlinkAccounttoClientV4(CIlinkAccounttoClientV4_Req_IB_V1 requestBean) {
        CIlinkAccounttoClientV4_Resp_IB_V1 responseBean = (CIlinkAccounttoClientV4_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CIlinkAccounttoClientV4_Resp_IB_V1.class);
        return responseBean;
    }
}