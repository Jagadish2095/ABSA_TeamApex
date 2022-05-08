/*
* Integration Handler Bean for CCUpdDailyTansactionLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-11-11
*/
public class CCUpdDailyTansactionLimitsV2_IH_v1 {

    
        public static final String INTEGRATION_SERVICE_NAME = 'CCUpdDailyTansactionLimitsV2';
        
        public static  CCUpdDailyTansactionLimitsV2_Resp_IB_v1 CCUpdDailyTansactionLimitsV2(CCUpdDailyTansactionLimitsV2_Req_IB_v1 requestBean){
            CCUpdDailyTansactionLimitsV2_Resp_IB_v1 responseBean = (CCUpdDailyTansactionLimitsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  CCUpdDailyTansactionLimitsV2_Resp_IB_v1.class);
            return responseBean;
        }
    }