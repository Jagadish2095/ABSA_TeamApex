/*
* Integration Handler for RulesEnginePOC Service
* @author Saurabh Pandey
* @created 2020-05-26
*/

public class RulesEngineService_IH_v1 {
 
    public static final String INTEGRATION_SERVICE_NAME = 'Rules_Engine_Service';
    
    public static RulesEngineService_Resp_IB_v1 RulesEngineService(RulesEngineService_Req_IB_v1 requestBean) {
        RulesEngineService_Resp_IB_v1 responseBean = (RulesEngineService_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, RulesEngineService_Resp_IB_v1.class);
        return responseBean; 
    }
}