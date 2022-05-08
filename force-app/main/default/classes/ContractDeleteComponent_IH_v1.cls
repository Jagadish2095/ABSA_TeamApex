/**
 * @description Integration Handler for ContractDeleteComponent Service
 * @author Koketso Mpshane
 * @created 2021-06-29
 */
public class ContractDeleteComponent_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'Contract Delete Component';
	/**
	 * @description ContractDeleteComponent
	 * @param pstrContractGID
	 * @param pstrLifeAssuredGid
	 * @param pintProductId
	 * @return ContractDeleteComponent_Resp_IB_v1
	 */
	public static ContractDeleteComponent_Resp_IB_v1 ContractDeleteComponent(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId) {
		ContractDeleteComponent_Req_IB_v1 requestBean = ContractDeleteComponent_IU_v1.mapRequestFields(pstrContractGID, pstrLifeAssuredGid, pintProductId);
		ContractDeleteComponent_Resp_IB_v1 responseBean = (ContractDeleteComponent_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractDeleteComponent_Resp_IB_v1.class
		);

		return responseBean;
	}

}