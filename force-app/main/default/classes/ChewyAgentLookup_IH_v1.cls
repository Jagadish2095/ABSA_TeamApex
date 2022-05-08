/**
 * @description Integration Handler to get CTI AgentId data from Chewy.
 * The Request will consist of User ABNumber information.
 * @author Saurabh Pandey
 * @updated Koketso Mpshane 09/11/2021
 */
public class ChewyAgentLookup_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Chewy Agent Lookup';
	/**
    * @description getAgentIdFromChewy
	* @param abNumber
	* @return ChewyAgentLookup_Resp_IB_v1
    */
	public static ChewyAgentLookup_Resp_IB_v1 getAgentIdFromChewy(String abNumber) {
		ChewyAgentLookup_Resp_IB_v1 responseBean = (ChewyAgentLookup_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			abNumber,
			INTEGRATION_SERVICE_NAME,
			ChewyAgentLookup_Resp_IB_v1.class
		);

		return responseBean;
	}
}