/**
* @description Test Integration Handler for GBlistCommentsV1 Service
* @author Jagadish Thummala
* @created 3/17/2022

*/
public class GBlistCommentsV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'GBlistCommentsV1';
 /**
* @description wrapper class GBlistCommentsV1Response
* @param dateFrom
* @return GBlistCommentsV1_Resp_IB_V1
*/
public static GBlistCommentsV1_Resp_IB_V1 GBListCommentsv1(String dateFrom, string clientCode, string inputBranch) {
    GBlistCommentsV1_Req_IB_v1 requestBean = GBlistCommentsV1_IU_v1.mapRequestFields(dateFrom,clientCode,inputBranch);
   GBlistCommentsV1_Resp_IB_V1 responseBean = (GBlistCommentsV1_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
        requestBean,
        INTEGRATION_SERVICE_NAME,
        GBlistCommentsV1_Resp_IB_V1.class
    );
    system.debug('comments'+responseBean);
    return responseBean;
}
 
}