/*
 * Request Integration Bean for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-12
 */
public class ContractCreateAdhocDO_Req_IB_v1 extends Base_IB {
	public Contract_CreateAdhocDO Contract_CreateAdhocDO;

	public class Contract_CreateAdhocDO {
		public String pstrSessionGID;
		public String pstrPolicyNumber;
		public PobjBankContract pobjBankContract;
		public String p8dtCollectionDate;
		public String pstrSourceName;
	}

	public class PobjBankContract {

		public String AccountName;
		public String AccountNo;
		public Integer AccountTypeID;
		public Integer BankBranchID;
		public Integer BankID;

	}

	public static ContractCreateAdhocDO_Req_IB_v1 createDummyRequest() {
		ContractCreateAdhocDO_Req_IB_v1 requestBean = new ContractCreateAdhocDO_Req_IB_v1();
		requestBean.Contract_CreateAdhocDO = new ContractCreateAdhocDO_Req_IB_v1.Contract_CreateAdhocDO();

		requestBean.Contract_CreateAdhocDO.pstrSessionGID = '18adf2f0-7366-4b50-807f-be93cfa21b95';
		requestBean.Contract_CreateAdhocDO.pstrPolicyNumber = '6635633325';
		requestBean.Contract_CreateAdhocDO.p8dtCollectionDate = '20201124';
		requestBean.Contract_CreateAdhocDO.pstrSourceName = 'abc';

		requestBean.Contract_CreateAdhocDO.pobjBankContract = new ContractCreateAdhocDO_Req_IB_v1.PobjBankContract();
		requestBean.Contract_CreateAdhocDO.pobjBankContract.AccountName = 'TEST';
		requestBean.Contract_CreateAdhocDO.pobjBankContract.AccountNo = '75000000491';
		requestBean.Contract_CreateAdhocDO.pobjBankContract.AccountTypeID = 1;
		requestBean.Contract_CreateAdhocDO.pobjBankContract.BankBranchID = 4258;
		requestBean.Contract_CreateAdhocDO.pobjBankContract.BankID = 15;

		return requestBean;
	}

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('Contract_CreateAdhocDO.pobjBankContract.AccountTypeID', 'Exergy;Account Type');
		integrationTranslationsMap.put('Contract_CreateAdhocDO.pobjBankContract.BankBranchID', 'Exergy;Branch ID');
		integrationTranslationsMap.put('Contract_CreateAdhocDO.pobjBankContract.BankID', 'Exergy;Bank Name');
	}
}