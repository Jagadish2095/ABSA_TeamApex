/**
 * @description Integration Handler for ContractCancel Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractCancel_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Contract Cancel';
	/**
	 * @description ContractCancel method 
	 * @param pstrContractGID
	 * @param pintDecisionReason
	 * @param pstrDecisionNote
	 * @param pstrCancelRequestDate
	 * @param pstrDecisionReason
	 * @return ContractCancel_Req_IB_v1
	 */
	public static ContractCancel_Resp_IB_v1 ContractCancel(String pstrContractGID, Integer pintDecisionReason, String pstrDecisionNote, String pstrCancelRequestDate, String pstrDecisionReason) {
		ContractCancel_Req_IB_v1 requestBean = ContractCancel_IU_v1.mapRequestFields(pstrContractGID, pintDecisionReason, pstrDecisionNote, pstrCancelRequestDate, pstrDecisionReason);
		ContractCancel_Resp_IB_v1 responseBean = (ContractCancel_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractCancel_Resp_IB_v1.class
		);

		return responseBean;
	}

}