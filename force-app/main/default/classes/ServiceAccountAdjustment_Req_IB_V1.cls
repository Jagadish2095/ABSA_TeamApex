/**
 * @description Request Integration Bean for ServiceAccountAdjustment Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 30/04/2021
 */
public class ServiceAccountAdjustment_Req_IB_V1 extends Base_IB {
	public String SPID;
	public String Phonenumber;
	public String AcctTyp;
	public String AccNumber;
	public String Amount;
	public String CurrencyCode;
	public String RetrievalReferenceNumber;
	public String TermID;
	public String CardAccptrID;
	public String CardAccptrNameLocation;
	/**
	 * @description createDummyRequest for test class method
	 * @return ServiceAccountAdjustment_Req_IB_V1
	 */
	public static ServiceAccountAdjustment_Req_IB_V1 createDummyRequest() {
		ServiceAccountAdjustment_Req_IB_V1 requestBean = new ServiceAccountAdjustment_Req_IB_V1();
		requestBean.SPID = '8805';
		requestBean.Phonenumber = '0746004196';
		requestBean.AcctTyp = '20';
		requestBean.AccNumber = '0000000004048195352';
		requestBean.Amount = '20.00';
		requestBean.CurrencyCode = '710';
		requestBean.RetrievalReferenceNumber = 'SALESF0000013';
		requestBean.TermID = 'S11600';
		requestBean.CardAccptrID = '0634824';
		requestBean.CardAccptrNameLocation = 'SHERRY  001ABSA INTERNET/MOB RECHARGE ZA';

		return requestBean;
	}
	/**
 	* @description setIntegrationTranslations
 	*/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('AcctTyp', 'TB Mobile Services;Account Type');
	}
}