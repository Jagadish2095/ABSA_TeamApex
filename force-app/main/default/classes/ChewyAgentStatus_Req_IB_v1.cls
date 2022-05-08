/*
 * Request Integration Bean for ChewyAgentStatus Service
 * @author Saurabh Pandey
 * @created 29/07/2020
 * @updated: 09/03/2021
 */

public class ChewyAgentStatus_Req_IB_v1 extends Base_IB {
	public String userId;
	public String agentId;

	public static ChewyAgentStatus_Req_IB_v1 createDummyRequest() {
		ChewyAgentStatus_Req_IB_v1 requestBean = new ChewyAgentStatus_Req_IB_v1();
		requestBean.userId = 'abhm512';
		requestbean.agentId = '9021959';
		return requestBean;
	}
}