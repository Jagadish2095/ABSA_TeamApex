/*
* Integration call from ImaintainESDDetailsV3 Service
* @author Khaliq Abdul
* @created 2020-11-25
*/
public class EImaintainESDDetailsV3_IH_v2 {
    
     public static final String INTEGRATION_SERVICE_NAME = 'EImaintainESDDetailsV3';

    public static EImaintainESDDetailsV3_Resp_IB_v1 EImaintainESDDetails(EImaintainESDDetailsV3_Req_IB_v1 requestBean) {
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (EImaintainESDDetailsV3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, EImaintainESDDetailsV3_Resp_IB_v1.class);
        return responseBean;
    }
}