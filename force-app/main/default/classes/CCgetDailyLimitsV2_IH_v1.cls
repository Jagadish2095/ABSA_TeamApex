/*
* Integration Handler Bean for CCgetDailyLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-10-15
*/
public class CCgetDailyLimitsV2_IH_v1 {

    
        public static final String INTEGRATION_SERVICE_NAME = 'CCgetDailyLimitsV2';
        
        public static  CCgetDailyLimitsV2_Resp_IB_v1 CCgetDailyLimitsV2(CCgetDailyLimitsV2_Req_IB_v1 requestBean){
            CCgetDailyLimitsV2_Resp_IB_v1 responseBean = (CCgetDailyLimitsV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  CCgetDailyLimitsV2_Resp_IB_v1.class);
            return responseBean;
        }
    }