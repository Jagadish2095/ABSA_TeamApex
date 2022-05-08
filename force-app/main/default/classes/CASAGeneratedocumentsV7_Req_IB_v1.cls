/**
 * @description       : CASAGeneratedocumentsV7_Req
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CASAGeneratedocumentsV7_Req_IB_v1 extends Base_IB {
	public GetDocsRequest GetDocsRequest;

	/**
	* @description GetDocsRequest
	**/
	public class GetDocsRequest {
		public String RefNumber;
		public String SBU;
		public String OriginatingSystem;
		public String Branch;
		public String InitialAB;
		public String Additional_Docs;
	}

	/**
	* @description GetInstance
	* @return CASAGeneratedocumentsV7_Req_IB_v1
	**/
	public static CASAGeneratedocumentsV7_Req_IB_v1 GetInstance() {
		CASAGeneratedocumentsV7_Req_IB_v1 requestBean = new CASAGeneratedocumentsV7_Req_IB_v1();
		requestBean.GetDocsRequest = new CASAGeneratedocumentsV7_Req_IB_v1.GetDocsRequest();
		requestBean.GetDocsRequest.SBU = 'F';
		requestBean.GetDocsRequest.OriginatingSystem = 'BDP';
		requestBean.GetDocsRequest.Additional_Docs = '';
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c, AB_Number__c, Teller_Operator_Code__c FROM User WHERE Id = :usr];
		requestBean.GetDocsRequest.InitialAB = userInfo.AB_Number__c;
		requestBean.GetDocsRequest.Branch = userInfo.SiteCode__c;
		return requestBean;
	}
}