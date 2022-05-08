/**
 * @description Response Integration Bean for ServiceProvidersDataEnquiry Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 22/04/2021
 */
public class ServiceProvidersDataEnquiry_Resp_IB_v1 extends Base_IB {
	public Integer statusCode;
	public String message;
	public String status;

	public List<Vouchers> vouchers;
	public String latestversion;
	/**
 	* @description Vouchers wrapper class
 	*/
	public class Vouchers {
		public String serviceProvider;
		public String SPID;
		public String dataSize;
		public String voiceValue;
		public String durantionValue;
		public String durantionUnit;
		public String currencyl;
		public Integer sequenceNumber;
		public String amount;
		public String ownAmount;
		public String voucherInstitutionCode;
		public String voucherDesc;
	}
	/**
 	* @description setIntegrationTranslations
 	*/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('vouchers.voucherInstitutionCode', 'TB Mobile Services;Voucher Institution Code');
	}
}