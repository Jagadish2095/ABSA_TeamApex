/*
* Integration Handler for PowerCurveUpdateApplication Service
* @author Saurabh Pandey
* @created 2020-11-17
*/
public class PowerCurveUpdateApplication_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Power Curve Update Application';
    
    public static PowerCurveUpdateApplication_Resp_IB_v1 PowerCurveUpdateApplication(PowerCurveUpdateApplication_Req_IB_v1 requestBean) {
        PowerCurveUpdateApplication_Resp_IB_v1 responseBean = (PowerCurveUpdateApplication_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, PowerCurveUpdateApplication_Resp_IB_v1.class);
        return responseBean; 
    }
}