/**
 * @description       : XDS 2.3 integration methods
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public class XDSQnAController23 {
    
    /**
	 * @description Call XDSGetQuestions_IH_v1 to get question
	 * @param accountId
	 * @return XDSGetQuetions_Resp_IB_v1 response
	 */
	@AuraEnabled
	public static String getQuesAndAnsList(Id accountId) {
		/**Call service to get Data **/

        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(accountId);
        Account client = new AccountsSelector().selectAllById(accountId);

		XDSGetQuetions_Resp_IB_v2 response;
		try {
            response = XDSGetQuestions_IH_v2.getXDSQuestions(client.PersonMobilePhone, client.ID_Number__pc, client.Passport_Number__pc);
	
            //Added by Sandile to update Account object 
            if(response.errorList != null && response.errorList.size() > 0){
                Account acc = new Account(Id = accountId);
				if (response.errorList[0].description == 'This Consumer has been blocked') {
                    acc.AuthMessage__c = 'BLOCKED';
                }else {
					acc.AuthMessage__c = response.errorList[0].description; // (By Hloni: Updated for XDS 2.3)
				}

				update acc;
            }

		} catch (Exception e) {
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			throw new AuraHandledException('Error:' + message);
		}
		return JSON.serialize(response);
	}

	/**
	 * @description This method takes answered question and send back to xds to verification
	 * @param requestBeanForVerificationString
	 * @return  result according to response from xds
	 */
	@AuraEnabled
	public static String verifyClient(String requestBeanForVerificationString) {
        XDSSubmitQuestions_Req_IB_v2 requestBean = (XDSSubmitQuestions_Req_IB_v2)JSON.deserialize(
			requestBeanForVerificationString,
			XDSSubmitQuestions_Req_IB_v2.class
		);

		XDSSubmitQuestions_Resp_IB_v2 response = XDSSubmitQuestions_IH_v2.xdsSubmitQuestions(requestBean);

		return JSON.serialize(response, true);

	}

	/**
	 * @description Method to get XDSVerificationResult
	 * @param requestBeanForVerificationString
	 * @param accountId
	 * @return XDSVerificationResult
	 */
	@AuraEnabled
	public static XDSVerificationResult verifyClientXDS(String requestBeanForVerificationString, Id accountId) {
		XDSGetQuetions_Resp_IB_v1 getQuestionResponseBean = (XDSGetQuetions_Resp_IB_v1) JSON.deserialize(
			requestBeanForVerificationString,
			XDSGetQuetions_Resp_IB_v1.class
		);
		XDSVerificationResult result = new XDSVerificationResult();
		if (getQuestionResponseBean != null) {
			XDSSubmitQuestions_Resp_IB_v1 responseFromXDSVerification = XDSSubmitQuestions_IH_v1.xdsSubmitQuestions(getQuestionResponseBean);

			if (responseFromXDSVerification != null) {
				result.authStatus = responseFromXDSVerification.authenticationStatus;
				result.message = responseFromXDSVerification.authenticationStatus;
				result.errorMessage = responseFromXDSVerification.errorMessage;
			}
			if (result.message == 'No message available') {
				Account acc = new Account(Id = accountId);
				acc.AuthMessage__c = 'UnableToXDS';
				update acc;
			}
			if (result.authStatus == 'Successful' || result.authStatus == 'Authenticated') {
				Account acc = new Account(Id = accountId);
				acc.AuthMessage__c = 'Successfully Authenticated';
				update acc;
			} else if (result.authStatus == 'Failed') {
				Account acc = new Account(Id = accountId);
				acc.AuthMessage__c = 'Failed Authentication';
				update acc;
			} else {
				Account acc = new Account(Id = accountId);
				acc.AuthMessage__c = 'UnableToXDS';
				update acc;
			}
		}

		return result;
	}

	/**
	 * @description XDS Verification Wrapper
	 */
	public class XDSVerificationResult {
		@AuraEnabled
		public String authStatus;
		@AuraEnabled
		public String message;
		@AuraEnabled
		public String errorMessage;
	}

	/**
	 * @description  Method to get XDSBypassResult
	 * @param caseRecId
	 * @param bypassChecked
	 * @return XDSBypassResult
	 */
	@AuraEnabled
	public static XDSBypassResult logXDSBypass(String caseRecId, Boolean bypassChecked) {
		XDSBypassResult result = new XDSBypassResult();
		String bypassed = UserInfo.getName() + ' (' + UserInfo.getUserName() + ')';

		Datetime now = Datetime.now();
		Integer offset = UserInfo.getTimezone().getOffset(now);
		Datetime local = now.addSeconds(offset / 1000);

		if (bypassChecked) {
			result.xdsBypassBy = bypassed;
			result.xdsBypassDate = local;
		}

		return result;
	}

	
	/** Hloni Matsoso: Added support for opportunity. W-14811
	 * @description  Method to get XDSBypassResult on an opportunity. 
	 * @param oppId
	 * @param bypassChecked
	 * @return XDSBypassResult
	 */
	@AuraEnabled
	public static XDSBypassResult logXDSBypassOnOppportunity(String oppId, Boolean bypassChecked) {
		XDSBypassResult result = new XDSBypassResult();
		String bypassed = UserInfo.getName() + ' (' + UserInfo.getUserName() + ')';

		Datetime now = Datetime.now();
		Integer offset = UserInfo.getTimezone().getOffset(now);
		Datetime local = now.addSeconds(offset / 1000);

		if (bypassChecked) {
			result.xdsBypassBy = bypassed;
			result.xdsBypassDate = local;
		}

		return result;
	}

	/**
	 * @description XDSBypassResult wrapper
	 */
	public class XDSBypassResult {
		@AuraEnabled
		public String xdsBypassBy;
		@AuraEnabled
		public DateTime xdsBypassDate;
	}

	/**
	 * @description Method to get power of Attorney detail
	 * @param accountnumber
	 * @return cigetgeneralpowerofattorneyv4_Resp_IB_v1
	 */
	@AuraEnabled
	public static cigetgeneralpowerofattorneyv4_Resp_IB_v1 getGeneralPA(String accountnumber) {
		cigetgeneralpowerofattorneyv4_Resp_IB_v1 responseBean = cigetgeneralpowerofattorneyv4_IH_v1.getcigetgeneralpowerofattorneyv4(accountnumber, true);

		if (responseBean.StatusCode == 200)
			responseBean.CIgetGeneralPowerOfAttorneyV4Response.cip081do.outputTable.idType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				StringConstants.CIF_STRING,
				StringConstants.FIELD_IDENTITY_TYPE_STRING,
				responseBean.CIgetGeneralPowerOfAttorneyV4Response.cip081do.outputTable.idType,
				StringConstants.OUTBOUND_RECORD_TYPE
			);

		return responseBean;
	}

	/**
	 * @description Method to get product list
	 * @param accountId
	 * @return List<ClientProductController.DisplayProducts>
	 */
	@AuraEnabled
	public static List<ClientProductController.DisplayProducts> getAccountProducts(string accountId) {
		return ClientProductController.getProductsList(accountId);
	}

	/**
	 * @description Method to get special poer of attorney
	 * @param accountnumber
	 * @return CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1
	 */
	@AuraEnabled
	public static CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 getSpecialPA(String accountnumber) {
		CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 responseBean = CIgetSpecialPowerOfAttorneyV4_IH_v1.getCIgetSpecialPowerOfAttorneyV4(accountnumber, true);
		if (responseBean.StatusCode == 200)
			responseBean.CIgetSpecialPowerOfAttorneyV4Response.cip080do.outputTable.idType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				StringConstants.CIF_STRING,
				StringConstants.FIELD_IDENTITY_TYPE_STRING,
				responseBean.CIgetSpecialPowerOfAttorneyV4Response.cip080do.outputTable.idType,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
		return responseBean;
	}

	/**
	 * @description Method to get current account name
	 * @param accountId
	 * @return accountId
	 */
	@AuraEnabled
	public static String getAccountName(string accountId) {
		Account currentAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId];
		return currentAccount.Name;
	}

	/**
	 * @description Method to get XDS question detail
	 * @param accountNumber
	 * @param surname
	 * @return XDSGetQuetions_Resp_IB_v1
	 */
	@AuraEnabled
	public static XDSGetQuetions_Resp_IB_v1 getQuestions(string accountNumber, String surname) {
		XDSGetQuetions_Req_IB_v1 reqBean = new XDSGetQuetions_Req_IB_v1();
		reqBean.idNumber = accountNumber;
		reqBean.surname = surname;
		XDSGetQuetions_Resp_IB_v1 responseBean;

		try {
			Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> responseBeanMap = XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
			responseBean = (new List<XDSGetQuetions_Resp_IB_v1>((responseBeanMap.keySet())))[0]; //response from service
			//insert logs
			if (responseBeanMap.get(responseBean) != null) {
				insert responseBeanMap.get(responseBean);
			}
		} catch (Exception e) {
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			throw new AuraHandledException('Error:' + message);
		}
		return responseBean;
	}

	/**
	 * @description Method to get Mndate detail
	 * @param accNr
	 * @return String
	 */
	@AuraEnabled
	public static String getMandate(String accNr) {
		List<Map<String, String>> mandateListMap = new List<Map<String, String>>();

		Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(
			accNr,
			'8198',
			'5'
		);

		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];

		if (responseBean != null) {
			if (responseBean.CIgetSigningInstructionsV4Response != null) {
				if (responseBean.CIgetSigningInstructionsV4Response.cip082do != null) {
					if (
						responseBean.CIgetSigningInstructionsV4Response.cip082do.outputTable != null &&
						responseBean.CIgetSigningInstructionsV4Response.cip082do.outputTable.size() > 0
					) {
						return JSON.serialize(responseBean.CIgetSigningInstructionsV4Response.cip082do.outputTable);
					}
				}
			}
		}
		return null;
	}

	/**
	 * @description Method added by Chandra to get Session Cache Value dated 18/03/2021
	 * @param cifCode
	 * @return ClientIDnVPollingApex.ClientIDnVSessionObject
	 */
	@AuraEnabled
	public static ClientIDnVPollingApex.ClientIDnVSessionObject getSessionCacheValues(String cifCode) {
		return ClientIDnVPollingApex.getSessionCacheValues(cifCode);
	}

	/**
	 * @description Method added by Chandra to set Session Cache Value dated 18/03/2021
	 * @param cifCode
	 */
	@AuraEnabled
	public static void setSessionCacheValues(String cifCode) {
		ClientIDnVPollingApex.ClientIDnVSessionObject clientIDnVSessionObj = new ClientIDnVPollingApex.ClientIDnVSessionObject();
		clientIDnVSessionObj.cifCode = cifCode;
		clientIDnVSessionObj.identified = true;
		clientIDnVSessionObj.verified = true;
		clientIDnVSessionObj.matched = true;
		clientIDnVSessionObj.authenticationType = new List<String>{ 'XDS' };
		Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', clientIDnVSessionObj);
	}
}