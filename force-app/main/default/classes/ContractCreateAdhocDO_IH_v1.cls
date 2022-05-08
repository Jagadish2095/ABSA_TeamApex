/*
 * Integration Handler for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-12
 */
public class ContractCreateAdhocDO_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Contract Create Adhoc DO';

	public static ContractCreateAdhocDO_Resp_IB_v1 contractCreateAdhocDO(
		String policyNumber,
		ContractCreateAdhocDO_Req_IB_v1.PobjBankContract bankContractObj,
		String collectionDate
	) {
		ContractCreateAdhocDO_Req_IB_v1 requestBean = ContractCreateAdhocDO_IU_v1.mapRequestFields(policyNumber, bankContractObj, collectionDate);
		ContractCreateAdhocDO_Resp_IB_v1 responseBean = (ContractCreateAdhocDO_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ContractCreateAdhocDO_Resp_IB_v1.class
		);

		return responseBean;
	}
}