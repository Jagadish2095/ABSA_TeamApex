/**
 * @description request bean ReIssueVoucher
 * @author Simangaliso Mathenjwa
 * @created 2021 11 16
 */
public class ReIssueVoucher_Req_IB_v1 extends Base_IB {

    public Header header;
	public String cifKey;
	public String idNumber;
	public String partnerId;
	public String offerId;
	public String offerTier;
	public String oldRewardPinVoucher;
	public String txnReference;
	public String challengeId;

    /**
	* @description Header class
	*/
	public class Header {
		public String applicationId;
	}

	/**
	* @description createDummyRequest 
    * @return requestBean
	*/
    public static ReIssueVoucher_Req_IB_v1 createDummyRequest() {
        ReIssueVoucher_Req_IB_v1 requestBean = new ReIssueVoucher_Req_IB_v1();
		requestBean.header = new ReIssueVoucher_Req_IB_v1.Header();
		Map<String, String> requestFieldsMap = new Map<String, String>();
		requestFieldsMap.put('txnReference', '344aecf2-95a0-48bc-9e32-504e6fc127ac');
		requestFieldsMap.put('cifKey', 'MADIDNJ001');
		requestFieldsMap.put('idNumber', '9101265784089');
		requestFieldsMap.put('partnerId', 'GI50');
		requestFieldsMap.put('offerTier', 'Bronze');
		requestFieldsMap.put('oldRewardPinVoucher', '****XCMHYADP');
		requestFieldsMap.put('challengeId', 'X.101');
		requestBean.header.applicationId = 'SALESFORCE';
		requestBean.txnReference = requestFieldsMap.get('txnReference');
		requestBean.cifKey = requestFieldsMap.get('cifKey');
		requestBean.idNumber = requestFieldsMap.get('idNumber');
		requestBean.partnerId = requestFieldsMap.get('partnerId');
		requestBean.offerId = requestFieldsMap.get('offerId');
		requestBean.offerTier = requestFieldsMap.get('offerTier');
		requestBean.oldRewardPinVoucher = requestFieldsMap.get('oldRewardPinVoucher');
		requestBean.challengeId = requestFieldsMap.get('challengeId');

		return requestBean;

    }
}