/**
 * @description       :
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CASARiskProfileClientV7_Req_IB_v1 extends Base_IB {
	/**
	 * @description       : WQriskProfileClientV7Request Prop
	 **/
	public WQriskProfileClientV7Request WQriskProfileClientV7Request { get; set; }

	/**
	 * @description       : WQriskProfileClientV7Request
	 **/
	public class WQriskProfileClientV7Request {
		public String customerTypeCode;
		public String customerStatusCode;
		public String customerSourceUniqueId;
		public String companyForm;
		public String customerSourceRefID;
		public String primeBranchID;
		public String channel;
		public String sbu;
		public String originatingsystem;
		public String employmentStatus;
		public String occupation;
		public String userId;
		public List<AbsaSourceOfIncomeTable> absaSourceOfIncomeTable;
		public List<ProductCodeTable> productCodeTable;
		public List<SubProductCodeTable> subProductCodeTable;
	}
	/**
	 * @description       : AbsaSourceOfIncomeTable
	 **/
	public class AbsaSourceOfIncomeTable {
		public String absaSourceOfIncome;
	}

	/**
	 * @description       : SubProductCodeTable
	 **/
	public class SubProductCodeTable {
		public String subProductCode;
	}

	/**
	 * @description       : ProductCodeTable
	 **/
	public class ProductCodeTable {
		public String productCode;
	}

	/**
	 * @description       : setIntegrationTranslations
	 **/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('WQriskProfileClientV7Request.customerTypeCode', 'CIFCodesList;Ib Client Type');
		integrationTranslationsMap.put('WQriskProfileClientV7Request.employmentStatus', 'CIFCodesList;Emplstatus');
		integrationTranslationsMap.put('WQriskProfileClientV7Request.occupation', 'CIFCodesList;Occucode');
		integrationTranslationsMap.put('WQriskProfileClientV7Request.absaSourceOfIncomeTable.absaSourceOfIncome', 'CIFCodesList;Sofsoi');
	}

	/**
	 * @description       : GetInstance
	 * @return CASARiskProfileClientV7_Req_IB_v1
	 **/
	public static CASARiskProfileClientV7_Req_IB_v1 GetInstance() {
		CASARiskProfileClientV7_Req_IB_v1 requestBean = new CASARiskProfileClientV7_Req_IB_v1();
		requestBean.WQriskProfileClientV7Request = new CASARiskProfileClientV7_Req_IB_v1.WQriskProfileClientV7Request();
		requestBean.WQriskProfileClientV7Request.absaSourceOfIncomeTable = new List<CASARiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable>();
		requestBean.WQriskProfileClientV7Request.productCodeTable = new List<CASARiskProfileClientV7_Req_IB_v1.productCodeTable>();
		requestBean.WQriskProfileClientV7Request.SubProductCodeTable = new List<CASARiskProfileClientV7_Req_IB_v1.SubProductCodeTable>();

		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c, Teller_Operator_Code__c FROM User WHERE Id = :usr];
		requestBean.WQriskProfileClientV7Request.userId = userInfo.Teller_Operator_Code__c;
		requestBean.WQriskProfileClientV7Request.primeBranchID = userInfo.SiteCode__c;
		requestBean.WQriskProfileClientV7Request.channel = 'F2F1';
		requestBean.WQriskProfileClientV7Request.originatingsystem = 'BDP';
		requestBean.WQriskProfileClientV7Request.sbu = 'F';
		requestBean.WQriskProfileClientV7Request.customerStatusCode = '';
		return requestBean;
	}
}