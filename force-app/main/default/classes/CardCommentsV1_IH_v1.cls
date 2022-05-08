public with sharing class CardCommentsV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'GB listComments V1';
 /**
* @description wrapper class CardCommentsV1Response
* @param dateFrom
* @return CardCommentsV1_Resp_IB_V1
*/
public static CardCommentsV1_Resp_IB_V1 GBListCommentsv1(String dateFrom) {
    CardCommentsV1_Req_IB_v1 requestBean = CardCommentsV1_IU_v1.mapRequestFields(dateFrom);
    CardCommentsV1_Resp_IB_V1 responseBean = (CardCommentsV1_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
        requestBean,
        INTEGRATION_SERVICE_NAME,
        CardCommentsV1_Resp_IB_V1.class
    );
    system.debug(responseBean);
    return responseBean;
}
 
}