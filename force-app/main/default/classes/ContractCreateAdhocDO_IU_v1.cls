/*
 * Integration Utility for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-12
 */
public class ContractCreateAdhocDO_IU_v1 {
	public static ContractCreateAdhocDO_Req_IB_v1 mapRequestFields(
		String policyNumber,
		ContractCreateAdhocDO_Req_IB_v1.PobjBankContract bankContractObj,
		String collectionDate
	) {
		ContractCreateAdhocDO_Req_IB_v1 requestBean = new ContractCreateAdhocDO_Req_IB_v1();
		requestBean.Contract_CreateAdhocDO = new ContractCreateAdhocDO_Req_IB_v1.Contract_CreateAdhocDO();

		requestBean.Contract_CreateAdhocDO.pstrSessionGID = ExergyLoginController.getSessionId();
		requestBean.Contract_CreateAdhocDO.pstrPolicyNumber = policyNumber.replaceFirst('^0+', '');
		requestBean.Contract_CreateAdhocDO.pobjBankContract = bankContractObj;
		requestBean.Contract_CreateAdhocDO.p8dtCollectionDate = collectionDate;

		requestBean.Contract_CreateAdhocDO.pstrSourceName = 'Salesforce';


		return requestBean;
	}
}