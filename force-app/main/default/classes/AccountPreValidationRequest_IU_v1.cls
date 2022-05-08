/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountPreValidationRequest_IU_v1 {
	/**
	 * @description getCIFValue
	 * @param accountNumber
	 * @return AccountPreValidationRequest_Req_IB_v1
	 * **/
	public static AccountPreValidationRequest_Req_IB_v1 mapRequestFields(String accountNumber) {
		AccountPreValidationRequest_Req_IB_v1 requestBean = new AccountPreValidationRequest_Req_IB_v1();
		requestBean.accountNumber = accountNumber;
		requestBean.channel = 'Salesforce';
		requestBean.language = 'en';

		return requestBean;
	}
}