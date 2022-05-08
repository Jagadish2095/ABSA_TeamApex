/*
 * Integration Handler for PowerCurveStatusUpdate Service
 * @author Saurabh Pandey
 * @created 2020-11-19
 */

public class PowerCurveStatusUpdate_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Power Curve Status Update';

    public static PowerCurveStatusUpdate_Resp_IB_v1 PowerCurveStatusUpdate(PowerCurveStatusUpdate_Req_IB_v1 requestBean) {
        PowerCurveStatusUpdate_Resp_IB_v1 responseBean = (PowerCurveStatusUpdate_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, PowerCurveStatusUpdate_Resp_IB_v1.class);
        return responseBean;
    }

}