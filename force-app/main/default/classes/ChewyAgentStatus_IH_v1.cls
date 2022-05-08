/**
 * @description Integration Handler for ChewyAgentStatus Service
 * @author Saurabh Pandey
 * @created 2020-07-29
 */

public class ChewyAgentStatus_IH_v1 {
    
    //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'Agent Status';
	public static final String SERVICE_NAME = 'AgentStatus';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    * @param requestBean 
    * @return ChewyAgentStatus_Resp_IB_v1 
    **/
    public static ChewyAgentStatus_Resp_IB_v1 ChewyAgentStatus(ChewyAgentStatus_Req_IB_v1 requestBean) {
        ChewyAgentStatus_Resp_IB_v1 responseBean = (ChewyAgentStatus_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ChewyAgentStatus_Resp_IB_v1.class);
        //Mapping the payload string to Object after 2nd deserialization
        if(responseBean.payload != null){
        	responseBean.PayloadObj = (ChewyAgentStatus_Resp_IB_v1.PayloadObj)responseBean.deserialize( responseBean.payload, ChewyAgentStatus_Resp_IB_v1.PayloadObj.class );
        //System.debug('ChewyAgentStatus Response Bean '+responseBean.serialize(responseBean));
		}
        
        
        return responseBean;
    }

}