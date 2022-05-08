/*
 * Integration Utility class for Exergy Contract Change Bank Information Service
 * @author Humbelani Denge
 * @created 2021-02-17
 */
public class ExergyChangeBankInformation_IU_v1 {
	public static ExergyChangeBankInformation_Req_IB_v1 mapRequestFields(
		String policyNo,
		String accName,
		String accNo,
		Integer accTypeID,
		Integer bankBranchCode,
		Integer bankID,
		Integer dayOfPayment,
		Integer sourceOfFunds
	) {
		ExergyChangeBankInformation_Req_IB_v1 requestBean = new ExergyChangeBankInformation_Req_IB_v1();
		requestBean.Contract_ChangeBankInformation = new ExergyChangeBankInformation_Req_IB_v1.Contract_ChangeBankInformation();

		requestBean.Contract_ChangeBankInformation.pstrSessionGID = ExergyLoginController.getSessionId();
		requestBean.Contract_ChangeBankInformation.pstrPolicyNumber = policyNo.replaceFirst('^0+', '');
		requestBean.Contract_ChangeBankInformation.pobjBankContract = new ExergyChangeBankInformation_Req_IB_v1.PobjBankContract();
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountName = accName;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountNo = accNo;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountTypeID = accTypeID;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.BankBranchID = bankBranchCode;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.BankID = bankID;

		requestBean.Contract_ChangeBankInformation.pintDayofPayment = dayOfPayment;
		requestBean.Contract_ChangeBankInformation.pintSourceofFundsID = sourceOfFunds;

		return requestBean;
	}
}