/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountRestructureRequest_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Account Restructure Request';

	/**
	 * @description
	 * @author Mradul Maheshwari | 08-19-2021
	 * @param  accountNumber
	 * @param  advanceAmount
	 * @param  restructureOption
	 * @param  email
	 * @param  consent
	 * @param  newInstallment
	 * @param  newCalculatedInstallmentsNo
	 * @param  newTerm
	 * @param  newContractEndDate
	 * @param  newResidualAmount
	 * @return AccountRestructureRequest_Resp_IB_v1
	 **/
	public static AccountRestructureRequest_Resp_IB_v1 accountRestructureRequest(
		String accountNumber,
		String advanceAmount,
		String restructureOption,
		String email,
		String consent,
		String newInstallment,
		String newCalculatedInstallmentsNo,
		String newTerm,
		String newContractEndDate,
		String newResidualAmount
	) {
		AccountRestructureRequest_Req_IB_v1 requestBean = AccountRestructureRequest_IU_v1.mapRequestFields(
			accountNumber,
			advanceAmount,
			restructureOption,
			email,
			consent,
			newInstallment,
			newCalculatedInstallmentsNo,
			newTerm,
			newContractEndDate,
			newResidualAmount
		);
		AccountRestructureRequest_Resp_IB_v1 responseBean = (AccountRestructureRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AccountRestructureRequest_Resp_IB_v1.class
		);

		return responseBean;
	}
}