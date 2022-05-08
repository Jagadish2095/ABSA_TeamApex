/*
 * Request Integration Bean for Exergy Contract Change Bank Information Service
 * @author Humbelani Denge
 * @created 2021-02-17
 */
public class ExergyChangeBankInformation_Req_IB_v1 extends BASE_IB {
	public class PobjBankContract {
		public String AccountName;
		public String AccountNo;
		public Integer AccountTypeID;
		public Integer BankBranchID;
		public Integer BankID;
	}

	public class Contract_ChangeBankInformation {
		public String pstrSessionGID;
		public String pstrPolicyNumber;
		public PobjBankContract pobjBankContract;
		public Integer pintDayofPayment;
		public Integer pintSourceofFundsID;
	}

	public Contract_ChangeBankInformation Contract_ChangeBankInformation;

	public static ExergyChangeBankInformation_Req_IB_v1 createDummyRequest() {
		ExergyChangeBankInformation_Req_IB_v1 requestBean = new ExergyChangeBankInformation_Req_IB_v1();
		requestBean.Contract_ChangeBankInformation = new ExergyChangeBankInformation_Req_IB_v1.Contract_ChangeBankInformation();

		requestBean.Contract_ChangeBankInformation.pstrSessionGID = '18adf2f0-7366-4b50-807f-be93cfa21b95';
		requestBean.Contract_ChangeBankInformation.pstrPolicyNumber = '6635635173';
		requestBean.Contract_ChangeBankInformation.pobjBankContract = new ExergyChangeBankInformation_Req_IB_v1.PobjBankContract();
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountName = 'TEST';
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountNo = '75000000491';
		requestBean.Contract_ChangeBankInformation.pobjBankContract.AccountTypeID = 1;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.BankBranchID = 4258;
		requestBean.Contract_ChangeBankInformation.pobjBankContract.BankID = 15;

		requestBean.Contract_ChangeBankInformation.pintDayofPayment = 10;
		requestBean.Contract_ChangeBankInformation.pintSourceofFundsID = 1358;

		return requestBean;
	}

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('Contract_ChangeBankInformation.pobjBankContract.AccountTypeID', 'Exergy;Account Type');
		integrationTranslationsMap.put('Contract_ChangeBankInformation.pobjBankContract.BankBranchID', 'Exergy;Branch ID');
		integrationTranslationsMap.put('Contract_ChangeBankInformation.pobjBankContract.BankID', 'Exergy;Bank Name');
	}
}