/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountRestructureRequest_IU_v1 {
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
	 * @return AccountRestructureRequest_Req_IB_v1
	 **/
	public static AccountRestructureRequest_Req_IB_v1 mapRequestFields(
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
		AccountRestructureRequest_Req_IB_v1 requestBean = new AccountRestructureRequest_Req_IB_v1();
		requestBean.systemId = 'Salesforce';
		requestBean.accountNumber = accountNumber;
		requestBean.advanceAmount = advanceAmount;
		requestBean.restructureOption = restructureOption;
		requestBean.email = email;
		requestBean.consent = consent;
		requestBean.newInstallment = newInstallment;
		requestBean.newCalculatedInstallmentsNo = newCalculatedInstallmentsNo;
		requestBean.newTerm = newTerm;
		requestBean.newContractEndDate = newContractEndDate;
		requestBean.newResidualAmount = newResidualAmount;

		return requestBean;
	}
}