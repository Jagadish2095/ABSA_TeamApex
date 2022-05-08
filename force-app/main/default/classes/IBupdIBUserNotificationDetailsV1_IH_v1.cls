/*
 * Integration Handler for IBupdIBUserNotificationDetailsV1 Service
 * @author Angelina Myshkovets
 * @created 2020-10-15
 */
/**
 * @description  IBupdIBUserNotificationDetailsV1_IH_v1
 */
public with sharing class IBupdIBUserNotificationDetailsV1_IH_v1 {
/**
 * @description  IBupdIBUserNotificationDetailsV1_IH_v1
 */
    public static final String INTEGRATION_SERVICE_NAME = 'IBupdIBUserNotificationDetailsV1';
/**
 * @description  IBupdIBUserNotificationDetailsV1_Resp_IB
 * @return  IBupdIBUserNotificationDetailsV1_Resp_IB
 * @param   requestBean
 */
    public static IBupdIBUserNotificationDetailsV1_Resp_IB IBupdIBUserNotificationDetailsV1(IBupdIBUserNotificationDetailsV1_Req_IB requestBean) {
        IBupdIBUserNotificationDetailsV1_Resp_IB responseBean = (IBupdIBUserNotificationDetailsV1_Resp_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, IBupdIBUserNotificationDetailsV1_Resp_IB.class);
        return responseBean;
    }
}