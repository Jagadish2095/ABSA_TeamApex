/**
 * @description       :
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-06
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CASARiskProfileClientV7_Resp_IB_v1 extends Base_IB {
	/**
	 *@description       : WQriskProfileClientV7Response Prop
	 **/
	public WQriskProfileClientV7Response WQriskProfileClientV7Response { get; set; }

	/**
	 *@description       : WQriskProfileClientV7Response
	 **/
	public class WQriskProfileClientV7Response {
		public String msgNo;
		public String msg;
		public String riskRating;
	}

	/**
	 *@description       :setIntegrationTranslations
	 **/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('WQriskProfileClientV7Response.riskRating', 'eCasa;Risk Rating');
	}
}