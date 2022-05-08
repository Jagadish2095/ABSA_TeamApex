/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class AccountPreValidationRequest_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Account Pre Validation Request';

	/**
	 * @description accountPreValidationRequest
	 * @param accountNumber
	 * @return AccountPreValidationRequest_Resp_IB_v1
	 **/
	public static AccountPreValidationRequest_Resp_IB_v1 accountPreValidationRequest(String accountNumber) {
		AccountPreValidationRequest_Req_IB_v1 requestBean = AccountPreValidationRequest_IU_v1.mapRequestFields(accountNumber);
		AccountPreValidationRequest_Resp_IB_v1 responseBean = (AccountPreValidationRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AccountPreValidationRequest_Resp_IB_v1.class
		);

		return responseBean;
	}
}