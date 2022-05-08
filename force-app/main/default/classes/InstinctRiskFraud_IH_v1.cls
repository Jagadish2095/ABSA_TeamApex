/*
 * Integration Handler for InstinctRiskFraud Service
 * @author Manoj Danthala
 * @created 2020-08-04
 */

public class InstinctRiskFraud_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Instinct Risk Fraud';
    
    public static InstinctRiskFraud_Res_IB_v1 InstinctRiskFraud(Opportunity opportunity){
        InstinctRiskFraud_Req_IB_v1 requestBean = InstinctRiskFraud_IU_v1.mapRequestFields(opportunity);
        System.debug('requestBean>>'+json.serialize(requestBean));
    	InstinctRiskFraud_Res_IB_v1 responseBean = (InstinctRiskFraud_Res_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, InstinctRiskFraud_Res_IB_v1.class);
        System.debug('responseBean>>'+responseBean);
        return responseBean;
    }
}