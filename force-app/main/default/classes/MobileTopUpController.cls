/**
 * @description Controller class for Mobile Top Up
 * @author  Koketso Mpshane
 * @date    22/04/2021
 */
public class MobileTopUpController {
	/**
	 * @description Method to get Service Providers Data
	 * @return String
	 */
	@AuraEnabled
	public static String getServiceProvidersData() {
		Map<String, List<Object>> serviceProvidersDataMap = new Map<String, List<Object>>();
		Map<String, String> customHeaders = new Map<String, String>();
		String currentVersion = Label.ServiceProvidersDataEnquiryVersion;

		customHeaders.put('currentversion', currentVersion);

		ServiceProvidersDataEnquiry_Resp_IB_v1 responseBean = ServiceProvidersDataEnquiry_IH_v1.serviceProvidersDataEnquiry(customHeaders);

		//check if response is null
		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (responseBean?.vouchers.size() > 0) {
			for (ServiceProvidersDataEnquiry_Resp_IB_v1.vouchers obj : responseBean.vouchers) {
				if (serviceProvidersDataMap.containsKey(obj.serviceProvider)) {
					serviceProvidersDataMap.get(obj.serviceProvider).add(obj);
				} else {
					serviceProvidersDataMap.put(obj.serviceProvider, new List<Object>{ obj });
				}
			}
		}

		return JSON.serialize(serviceProvidersDataMap);
	}

	/**
	 * @description Method to process mobile top up transaction
	 * @param mobileTopUpParamsMap
	 * @return String
	 */
	@AuraEnabled
	public static String processMobileTopUp(Map<String, String> mobileTopUpParamsMap) {
		String spid = mobileTopUpParamsMap.get('spid');
		String phoneNumber = mobileTopUpParamsMap.get('phoneNumber');
		String accType = mobileTopUpParamsMap.get('accType');
		String accNumber = mobileTopUpParamsMap.get('accNumber');
		String amount = mobileTopUpParamsMap.get('amount');
		String retrievalRefNumber = mobileTopUpParamsMap.get('retrievalRefNumber');

		User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

		ServiceAccountAdjustment_Resp_IB_v1 accountAdjustmentResponse;

		ServiceCustomerEligibility_Resp_IB_v1 customerEligibilityResponse = ServiceCustomerEligibility_IH_V1.ServiceCustomerEligibilityV1(
			spid,
			phoneNumber,
			'00',
			amount,
			retrievalRefNumber
		);

		//check if response is null
		if (customerEligibilityResponse == null) {
			return 'Error: Blank response received from ServiceCustomerEligibility service;';
		}
		//check the response statusCode
		if (customerEligibilityResponse.statusCode != 200) {
			return 'Error: ServiceCustomerEligibility service returned ' + customerEligibilityResponse.message;
		}
		//check if the response is not successful
		if (customerEligibilityResponse.ActionCode != '000') {
			String errorDescription = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				'TB Mobile Services',
				'Action Code',
				String.valueOf(customerEligibilityResponse.ActionCode),
				StringConstants.INBOUND_RECORD_TYPE
			);
			return 'Error: ServiceCustomerEligibility returned Error Code (' + customerEligibilityResponse.ActionCode + ') ' + errorDescription;
		} else {
			accountAdjustmentResponse = ServiceAccountAdjustment_IH_V1.ServiceAccountAdjustmentV1(
				spid,
				phonenumber,
				accType,
				accNumber,
				amount,
				retrievalRefNumber
			);
			//check if response is null
			if (accountAdjustmentResponse == null) {
				return 'Error: Blank response received from ServiceAccountAdjustment service;';
			}
			//check the response statusCode
			if (accountAdjustmentResponse.statusCode != 200) {
				return 'Error: ServiceAccountAdjustment service returned ' + accountAdjustmentResponse.message;
			}
			//check if the response is not successful
			if (accountAdjustmentResponse.ActionCode != '000') {
				String errorDescription = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
					'TB Mobile Services',
					'Action Code',
					String.valueOf(accountAdjustmentResponse.ActionCode),
					StringConstants.INBOUND_RECORD_TYPE
				);
				return 'Error: ServiceAccountAdjustment returned Error Code (' + accountAdjustmentResponse.ActionCode + ') ' + errorDescription;
			}
		}

		return JSON.serialize(accountAdjustmentResponse);
	}

	/**
	 * @description Method to get mobile beneficiaries
	 * @param cifKey
	 * @return String
	 */
	@AuraEnabled
	public static String getMobileBeneficiaries(String cifKey) {
		getMobileBeneficiaries_Resp_IB_v1 responseBean = getMobileBeneficiaries_IH_v1.getMobileBeneficiaries(cifKey);
		//check if response is null
		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		for (getMobileBeneficiaries_Resp_IB_v1.mobileNumberList obj : responseBean.mobileNumberList) {
			obj.cellProvider = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				'TB Mobile Services',
				'Service Provider',
				obj.cellProvider,
				StringConstants.INBOUND_RECORD_TYPE
			);
		}
		return JSON.serialize(responseBean.mobileNumberList);
	}

	/**
	 * @description Method to add mobile beneficiaries
	 * @param cifKey
	 * @param ivrPaymentNo
	 * @param cellProvider
	 * @param cellNo
	 * @param description
	 * @return String
	 */
	@AuraEnabled
	public static String addMobileBeneficiaries(String cifKey, String ivrPaymentNo, String cellProvider, String cellNo, String description) {
		String translatedProvider = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'TB Mobile Services',
			'Service Provider',
			cellProvider,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		addTBMobileBeneficiaries_Resp_IB_v1 responseBean = addTBMobileBeneficiaries_IH_v1.addTBMobileBeneficiaries(
			cifKey,
			cellNo,
			ivrPaymentNo,
			description,
			translatedProvider
		);
		//check if response is null
		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}
		//check the response error
		if (responseBean.error || responseBean.addMobileBeneficiariesResp == null) {
			return 'Error: ' + JSON.serialize(responseBean.errorList);
		}

		return responseBean.addMobileBeneficiariesResp?.saveMessage;
	}
}