/**
 * @description Integration Handler for ContractPremiumSumAssured Service
 * @author Chandra Bhushan Singh
 * @created 2021-04-08
 */

public class ContractPremiumSumAssured_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Contract Premium Sum Assured';
	/**
	 * @description wrapper class ContractPremiumSumAssuredResponse
	 * @param pstrContractGID
	 * @param pstrLifeAssuredGid
	 * @param pintProductId
	 * @param pintCover
	 * @return ContractPremiumSumAssured_Resp_IB_v1
	 */
	public static ContractPremiumSumAssured_Resp_IB_v1 ContractPremiumSumAssured(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId, Integer pintCover) {
		ContractPremiumSumAssured_Req_IB_v1 requestBean = ContractPremiumSumAssured_IU_v1.mapRequestFields(pstrContractGID, pstrLifeAssuredGid, pintProductId, pintCover);
		ContractPremiumSumAssured_Resp_IB_v1 responseBean = (ContractPremiumSumAssured_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractPremiumSumAssured_Resp_IB_v1.class
		);

		return responseBean;
	}
}