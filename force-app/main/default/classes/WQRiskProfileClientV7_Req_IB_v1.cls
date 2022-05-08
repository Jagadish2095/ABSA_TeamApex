/**
 * @description       :
 
 * @last modified on  : 2021-10-04
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class WQRiskProfileClientV7_Req_IB_v1 extends Base_IB {
	/**
	 * @description       : AbsaSourceOfIncomeTable
	 *
	 **/
	public class AbsaSourceOfIncomeTable {
		public String absaSourceOfIncome;
	}

	public WQriskProfileClientV7Request WQriskProfileClientV7Request;
	/**
	 * @description       : WQriskProfileClientV7Request
	 *
	 **/
	public class WQriskProfileClientV7Request {
		public String userId;
		public List<SubProductCodeTable> subProductCodeTable;
		public String sbu;
		public List<ProductCodeTable> productCodeTable;
		public String primeBranchID;
		public String originatingsystem;
		public String occupation;
		public String IncorporationCountryCode;
		public String employmentStatus;
		public String customerTypeCode;
		public String customerStatusCode;
		public String customerSourceUniqueId;
		public String customerSourceRefID;
		public String companyForm;
		public String cifkey;
		public String channel;
		public String businessSegment1;
		public List<AbsaSourceOfIncomeTable> absaSourceOfIncomeTable;
		public List<AbsaCountryOfOperationTable> absaCountryOfOperationTable;
		public List<AbsaCountryTradedWithTable> absaCountryTradedWithTable;
	}
	/**
	 * @description       : SubProductCodeTable
	 *
	 **/
	public class SubProductCodeTable {
		public String subProductCode;
	}
	/**
	 * @description       : AbsaCountryOfOperationTable
	 *
	 **/
	public class AbsaCountryOfOperationTable {
		public String absaCountryOfOperation;
	}
	/**
	 * @description       : ProductCodeTable
	 *
	 **/
	public class ProductCodeTable {
		public String productCode;
	}
	/**
	 * @description       : AbsaCountriesTradedWithTable
	 *
	 **/
	public class AbsaCountryTradedWithTable  {
		public String absaCountriesTradedWith;
	}

	/**
	 * @description       : GetInstance
	 * @return WQRiskProfileClientV7_Req_IB_v1
	 **/
	public static WQRiskProfileClientV7_Req_IB_v1 GetInstance() {
		WQRiskProfileClientV7_Req_IB_v1 requestBean = new WQRiskProfileClientV7_Req_IB_v1();
		requestBean.WQriskProfileClientV7Request = new WQRiskProfileClientV7_Req_IB_v1.WQriskProfileClientV7Request();
		requestBean.WQriskProfileClientV7Request.absaSourceOfIncomeTable = new List<WQRiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable>();
		requestBean.WQriskProfileClientV7Request.productCodeTable = new List<WQRiskProfileClientV7_Req_IB_v1.productCodeTable>();
		requestBean.WQriskProfileClientV7Request.SubProductCodeTable = new List<WQRiskProfileClientV7_Req_IB_v1.SubProductCodeTable>();
		requestBean.WQriskProfileClientV7Request.absaCountryOfOperationTable = new List<WQRiskProfileClientV7_Req_IB_v1.AbsaCountryOfOperationTable>();
		requestBean.WQriskProfileClientV7Request.absaCountryTradedWithTable = new List<WQRiskProfileClientV7_Req_IB_v1.AbsaCountryTradedWithTable >();

		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c, Teller_Operator_Code__c FROM User WHERE Id = :usr];
		requestBean.WQriskProfileClientV7Request.userId = userInfo.Teller_Operator_Code__c;
		requestBean.WQriskProfileClientV7Request.primeBranchID = userInfo.SiteCode__c;
		requestBean.WQriskProfileClientV7Request.channel = 'F2F1';
		requestBean.WQriskProfileClientV7Request.originatingsystem = 'BDP';
		requestBean.WQriskProfileClientV7Request.sbu = '102';
		requestBean.WQriskProfileClientV7Request.customerStatusCode = '';
		return requestBean;
	}
}