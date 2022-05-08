/**
 * @description       : Integration Handler for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
 **/

public class ChequeServicesOrchestration_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Cheque Services Orchestration';

	/**
	 * @description call Orchestration Service
	 * @author Englarmerdge Mongwe | 2021-06-11
	 * @param clientCd
	 * @param productFamilies
	 * @param accountNumber
	 * @param siteCode
	 * @param maxRet
	 * @return ChequeServicesOrchestration_Resp_IB_v1
	 **/
	public static ChequeServicesOrchestration_Resp_IB_v1 chequeServicesOrchestration(
		String clientCd,
		String productFamilies,
		String accountNumber,
		String siteCode,
		String maxRet
	) {
		ChequeServicesOrchestration_Req_IB_v1 requestBean = ChequeServicesOrchestration_IU_v1.mapRequestFields(
			clientCd,
			productFamilies,
			accountNumber,
			siteCode,
			maxRet
		);
		ChequeServicesOrchestration_Resp_IB_v1 responseBean = (ChequeServicesOrchestration_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			ChequeServicesOrchestration_Resp_IB_v1.class
		);
		return responseBean;
	}
}