/**
 * @description Integration Handler for ContractLapse Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractLapse_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Contract Lapse';
	/**
	 * @description ContractLapse method
	 * @param pstrContractGID
	 * @param p8dtMovementDate
	 * @param pintLapseReasonID
	 * @param pstrLapseReasonDesc
	 * @param lapseNote - not required, empty ('') string can be passed
	 * @return ContractLapse_Resp_IB_v1
	 */
	public static ContractLapse_Resp_IB_v1 ContractLapse(String pstrContractGID, String p8dtMovementDate, Integer pintLapseReasonID, String pstrLapseReasonDesc, String lapseNote) {
		ContractLapse_Req_IB_v1 requestBean = ContractLapse_IU_v1.mapRequestFields(pstrContractGID, p8dtMovementDate, pintLapseReasonID, pstrLapseReasonDesc, lapseNote);
		ContractLapse_Resp_IB_v1 responseBean = (ContractLapse_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractLapse_Resp_IB_v1.class
		);

		return responseBean;
	}

}