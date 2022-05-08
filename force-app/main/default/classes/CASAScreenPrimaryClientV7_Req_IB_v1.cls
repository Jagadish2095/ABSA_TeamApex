/**
 * @description       : CASAScreenPrimaryClientV7
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
**/
public class CASAScreenPrimaryClientV7_Req_IB_v1 extends Base_IB {
	public String channel;
	public String application;
	public String trace;
	public String firstName;
	public String surnameComp;
	public String idType;
	public String idRegNo;
	public String clientTypeGrp;
	public String dob;
	public String nationality;
	public String town;
	public String territory;
	public String cntryOfRes;
	public String cntryOfBirth;
	public String registerCity;
	public String countryPassport;
	public String headofficeTown;
	public String headofficeCntry;
	public String headofficeOtherCntry1;
	public String headofficeOtherCntry2;
	public String headofficeOtherCntry3;
	public String headofficeOtherCntry4;
	public String headofficeOtherCntry5;
	public String sbu;
	public String originatingSys;
	public String branch;
	public String teller;

	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('idType', 'CIFCodesList;Idtype');
		integrationTranslationsMap.put('clientTypeGrp', 'CIFCodesList;Ib Client Type');
		integrationTranslationsMap.put('nationality', 'CIFCodesList;Nationality');
		integrationTranslationsMap.put('cntryOfRes', 'CIFCodesList;Casa Country');
		integrationTranslationsMap.put('cntryOfBirth', 'CIFCodesList;Casa Country');
	}

	/**
	* @description GetInstance
	* @author PaulJohn.duRand@absa.africa | 2021-08-16
	* @return CASAScreenPrimaryClientV7_Req_IB_v1
	**/
	public static CASAScreenPrimaryClientV7_Req_IB_v1 GetInstance() {
		CASAScreenPrimaryClientV7_Req_IB_v1 requestBean = new CASAScreenPrimaryClientV7_Req_IB_v1();
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c, Teller_Operator_Code__c FROM User WHERE Id = :usr];
		requestBean.teller = userInfo.Teller_Operator_Code__c;
		requestBean.branch = userInfo.SiteCode__c;
        requestBean.territory = '';
		requestBean.registerCity = '';
		requestBean.countryPassport = '';
		requestBean.headofficeTown = '';
		requestBean.headofficeCntry = '';
		requestBean.headofficeOtherCntry1 = '';
		requestBean.headofficeOtherCntry2 = '';
		requestBean.headofficeOtherCntry3 = '';
		requestBean.headofficeOtherCntry4 = '';
		requestBean.headofficeOtherCntry5 = '';
		requestBean.sbu = 'F';
		requestBean.originatingSys = 'BDP';
		return requestBean;
	}
}