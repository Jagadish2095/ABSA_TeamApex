/**
 *@description Integration Handler for ContractAlterSumAssured Service
 * @author Chandra Bhushan Singh
 * @created 2021-04-08
 */

public class ContractAlterSumAssured_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Contract Alter Sum Assured';
	/**
	 * @description wrapper class ContractAlterSumAssuredResponse
	 * @param pstrContractGID
	 * @param pstrLifeAssuredGid
	 * @param pintProductId
	 * @param pintCover
	 * @return ContractAlterSumAssured_Resp_IB_v1
	 */
	public static ContractAlterSumAssured_Resp_IB_v1 ContractAlterSumAssured(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId, Integer pintCover) {
		ContractAlterSumAssured_Req_IB_v1 requestBean = ContractAlterSumAssured_IU_v1.mapRequestFields(pstrContractGID, pstrLifeAssuredGid, pintProductId, pintCover);
		ContractAlterSumAssured_Resp_IB_v1 responseBean = (ContractAlterSumAssured_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractAlterSumAssured_Resp_IB_v1.class
		);

		return responseBean;
	}
}