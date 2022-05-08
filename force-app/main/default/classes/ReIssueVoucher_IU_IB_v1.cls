/**
 * @description Integration Utility bean ReIssueVoucher
 * @author Simangaliso Mathenjwa
 * @created 2021 11 16
 */
public class ReIssueVoucher_IU_IB_v1 extends Base_IB {
	/**
	 * @description method to create request and return response
	 * @param requestFieldsMap
	 * @return ReIssueVoucher_Req_IB_v1
	 */
	public static ReIssueVoucher_Req_IB_v1 mapRequestFields(Map<String, String> requestFieldsMap) {
		ReIssueVoucher_Req_IB_v1 requestBean = new ReIssueVoucher_Req_IB_v1();
		requestBean.header = new ReIssueVoucher_Req_IB_v1.Header();
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