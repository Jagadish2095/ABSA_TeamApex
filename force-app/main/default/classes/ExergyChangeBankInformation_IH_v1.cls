/*
 * Integration Handler for Exergy Contract Change Bank Information Service
 * @author Humbelani Denge
 * @created 2021-02-17
 */

public class ExergyChangeBankInformation_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Exergy Contract Change Bank Information';

	public static ExergyChangeBankInformation_Resp_IB_v1 ExergyChangeBankInformation(
		String policyNo,
		String accName,
		String accNo,
		Integer accTypeID,
		Integer bankBranchID,
		Integer bankID,
		Integer dayOfPayment,
		Integer sourceOfFunds
	) {
		ExergyChangeBankInformation_Req_IB_v1 requestBean = ExergyChangeBankInformation_IU_v1.mapRequestFields(
			policyNo,
			accName,
			accNo,
			accTypeID,
			bankBranchID,
			bankID,
			dayOfPayment,
			sourceOfFunds
		);
		ExergyChangeBankInformation_Resp_IB_v1 responseBean = (ExergyChangeBankInformation_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ExergyChangeBankInformation_Resp_IB_v1.class
		);

		return responseBean;
	}
}