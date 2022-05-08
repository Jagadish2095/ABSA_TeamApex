/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountPreValidationRequest_Req_IB_v1 extends Base_IB {
	@AuraEnabled
	public String accountNumber;
	@AuraEnabled
	public String channel;
	@AuraEnabled
	public String language;

	/**
	 * @description createDummyRequest
	 * @return AccountPreValidationRequest_Req_IB_v1
	 * **/
	public static AccountPreValidationRequest_Req_IB_v1 createDummyRequest() {
		AccountPreValidationRequest_Req_IB_v1 requestBean = new AccountPreValidationRequest_Req_IB_v1();
		requestBean.accountNumber = '75678237';
		requestBean.channel = 'Salesforce';
		requestBean.language = 'en';

		return requestBean;
	}
}