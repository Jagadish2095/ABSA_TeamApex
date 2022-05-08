/*
 * Request Integration Bean for CQupdAcctOpenDetailV4Service Service
 * @author Willy Zuvana
 * @created 2021-04-06
 */
 
public class CQupdAcctOpenDetailV4Service_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'CQupdAcctOpenDetailV4Service';

    public static CQupdAcctOpenDetailV4Service_Resp_IB_v1 CQupdAcctOpenDetailV4Service(CQupdAcctOpenDetailV4Service_Req_IB_v1 requestBean) {
        CQupdAcctOpenDetailV4Service_Resp_IB_v1 responseBean = (CQupdAcctOpenDetailV4Service_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQupdAcctOpenDetailV4Service_Resp_IB_v1.class);
        return responseBean;
    }
    }