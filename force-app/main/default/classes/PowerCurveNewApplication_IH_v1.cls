/*
 * Integration Handler for PowerCurveNewApplication Service
 * @author Englarmerdge Mongwe
 * @created 2020-09-28
 */

public class PowerCurveNewApplication_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Power Curve New Application';

    public static PowerCurveNewApplication_Resp_IB_v1 PowerCurveNewApplication(PowerCurveNewApplication_Req_IB_v1 requestBean) {
        //PowerCurveUpdateApplication_Req_IB_v1 requestBean = PowerCurveUpdateApplication_IU_v1.mapRequestFields();
        PowerCurveNewApplication_Resp_IB_v1 responseBean = (PowerCurveNewApplication_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, PowerCurveNewApplication_Resp_IB_v1.class);
        return responseBean;
    }
}