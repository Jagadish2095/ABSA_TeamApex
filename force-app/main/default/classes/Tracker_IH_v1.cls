/** @description Integration Handler Bean for Tracker_IH_v1 Service
* @author Satya Boyenepalli
* @created 28-07-2021
*/

public with sharing class  Tracker_IH_v1 {
public static final String INTEGRATION_SERVICE_NAME = 'Tracker';
    /**
* @description Tracker Absa Instant Life
* @return Tracker_Res_IB_v1
* @param requestBean
*/

    public static  Tracker_Res_IB_v1 AbsaInstantLifeTracker(Tracker_Req_IB_v1 requestBean){
       Tracker_Res_IB_v1 responseBean = (Tracker_Res_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  Tracker_Res_IB_v1.class);
       return responseBean;
    }
}