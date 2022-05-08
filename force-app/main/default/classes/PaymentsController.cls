/**
 * @description Apex controller class for the Aura bundle Payments.
 * @author Simangaliso Mathenjwa
 * @since 2021-03-03
 * @updated 2022-03-14 Koketso Mpshane
 */
public class PaymentsController {
	/**
	 * @description Method to get Client accounts
	 * @param accountNo
	 * @return Client details as JSON String
	 */
	@AuraEnabled
	public static String getAccountDetailsByAccNo(String accountNo) {
		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToAccountNumber(
			StringConstants.SALESFORCE_STRING,
			accountNo 
		);

		if (response == null) {
			return 'Error: Blank response received from service.';
		}
		if (String.isNotBlank(response.nbsmsgo3?.msgEntry?.msgTxt)) {
			return 'Error: ' + response.nbsmsgo3.msgEntry.msgTxt;
		}
		if (response.statusCode != 200) {
			return 'Error: ' + response.message;
		}
		if (response.cip047o?.outputTable == null) {
			return 'Error: Unexpected response received. Service Response: ' + json.serialize(response);
		}

		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = response.cip047o.outputTable;
		return JSON.serialize(accTypes);
	}

	/**
	 * @description Method to get combi linked account List
	 * @param selectedCombi
	 * @return CClistAccsLinkedToCombiV1_Resp_IB_v1 bean
	 */
	@AuraEnabled
	public static CClistAccsLinkedToCombiV1_Resp_IB_v1 getAccountsLinkedToCombi(String selectedCombi) {
		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = CClistAccsLinkedToCombiV1_IH_v1.CCListAccsLinkedToCombi(selectedCombi);
		return responseBean;
	}

	/**
	 * @description Method to get Beneficiaries List
	 * @param selectedCombiAccountNumber
	 * @return MBlistInstructionsPerSrcAccV1_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MBlistInstPerSourceAccV1_Resp_IB_v1 getBeneficiaries(String selectedCombiAccountNumber) {
		return MBlistInstPerSourceAccV1_IH_v1.MBlistInstructionsPerSourceAccV1('', selectedCombiAccountNumber, 'VP');
	}

    /**
     * @description Call EBSBeneficiaries service to get Telephone Bannking Benificiary Details
	 * @param cifKey
	 * @param sourceAccount
	 * @return EBSBeneficiaries_Resp_IB_v1
	 */
	@AuraEnabled
	public static EBSBeneficiaries_Resp_IB_v1 getEBSBeneficiaryList(String cifKey, String sourceAccount) {
        EBSBeneficiaries_Resp_IB_v1 responseBean = EBSBeneficiaries_IH_v1.EBSBeneficiaries(cifKey, sourceAccount);
		return responseBean;
	}
    
    /**
	 * @description Method to initiate payment
	 * @param initiatePaymentParamsMap
	 * @return MBinitiatePaymentV12_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MBinitiatePaymentV12_Resp_IB_v1 initiatePayment_v12(Map<String, String> initiatePaymentParamsMap) {
        
        String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('EPS','Account Type',initiatePaymentParamsMap.get('trgAccType'),'Outbound');
		
        initiatePaymentParamsMap.put('trgAccType', trgAccTypeTrans); 
        
        MBinitiatePaymentV12_Resp_IB_v1 responseBean = MBinitiatePaymentV12_IH_V1.initiatePayment(initiatePaymentParamsMap);
        system.debug('responseBean***' + responseBean);
       
        return responseBean;
		
	}
    
    /**
	 * @description Method to initiate payment
	 * @param initiatePaymentParamsMap
	 * @return MBinitiatePaymentV12_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MBinitiatePaymentV12_Resp_IB_v1 payBeneficiary(Map<String, String> initiatePaymentParamsMap) {
        
        Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(initiatePaymentParamsMap.get('accountId'));
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
        
		String cifKey = accountList[0].CIF__c;
        initiatePaymentParamsMap.put('cifKey', cifKey);
        
        MBinitiatePaymentV12_Resp_IB_v1 responseBean = initiatePayment_v12(initiatePaymentParamsMap);
        system.debug('responseBean***' + responseBean);
		return responseBean;
	}

	/**
	 * @description Method to initiate payment
	 * @param payTime
	 * @param actDate
	 * @param amount
	 * @param srcAcc
	 * @param srcAccType
	 * @param srcStmtRef
	 * @param trgAcc
	 * @param trgClrCode
	 * @param trgAccType
	 * @param trgStmtRef
	 * @param paymIipInd
	 * @param instrRefName
	 * @param tieb
	 * @return MBinitiatePaymentV10_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MBinitiatePaymentV10_Resp_IB_v1 initiatePayment(
		String payTime,
		String actDate,
		String amount,
		String srcAcc,
		String srcAccType,
		String srcStmtRef,
		String trgAcc,
		String trgClrCode,
		String trgAccType,
		String trgStmtRef,
		String paymIipInd,
		String instrRefName,
        String tieb
	) {
        String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.EPS_STRING,
			'Account Type',
			trgAccType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		for (
			MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.callMBinitiatePayment(
					payTime,
					actDate,
					amount,
					srcAcc,
					srcAccType,
					srcStmtRef,
					trgAcc,
					trgClrCode,
					trgAccTypeTrans,
					trgStmtRef,
					paymIipInd,
					instrRefName,
                	tieb
				)
				.keyset()
		) {
			if (singleresponse != null) {
				if (singleresponse.statusCode == 200) {
					system.debug('response tt' + singleresponse);
					return singleresponse;
				}
			}
		}

		return null;
	}

	/**
	 * @description Method to initiate Future Payment
	 * @param srcAccountNumber
	 * @param srcAccountType
	 * @param amount
	 * @param trgAccNumberP
	 * @param trgBranchCodeP
	 * @param trgAccReferenceP
	 * @param trgAccTypeP
	 * @param futureDateP
	 * @param futureSourceRef
	 * @param accessAcc
	 * @return result string
	 */
	@AuraEnabled
	public static string initiateFuturePayment(
		String srcAccountNumber,
		String srcAccountType,
		String amount,
		String trgAccNumberP,
		String trgBranchCodeP,
		String trgAccReferenceP,
		String trgAccTypeP,
		String futureDateP,
		String futureSourceRef,
		String accessAcc
	) {
		string result;
		String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.EPS_STRING,
			'Account Type',
			trgAccTypeP,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String srcAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.EPS_STRING,
			'Account Type',
			srcAccountType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		CreateInstruction_Req_IB_v1 requestBean = new CreateInstruction_Req_IB_v1();
		requestBean.accessAcc = accessAcc;

		futureDatep = futureDatep.replace('-', '');
		System.debug('*********future Date******** ' + futureDatep);
		CreateInstruction_Req_IB_v1 reqBean = new CreateInstruction_Req_IB_v1();
		CreateInstruction_Resp_IB_v1 respBean = CreateInstruction_IH_v1.MBCreateInstructionFuture(
			srcAccountNumber,
			srcAccTypeTrans,
			amount,
			trgAccNumberP,
			trgBranchCodeP,
			trgAccReferenceP,
			trgAccTypeTrans,
			futureDatep,
			futureSourceRef,
			accessAcc
		);
		if (respBean.respDesc == 'SUCCESSFUL PROCESS') {
			result = 'SUCCESSFUL PROCESS';
		} else {
			result = respBean.respDesc;
		}
		return result;
	}

	/**
	 * @description
	 * @param clientAccountId
	 * @param srcAcc
	 * @return Intsruction List as JSON string
	 */
	@AuraEnabled
	public static String getIntsructionList(String clientAccountId, String srcAcc) {
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		String cifKey = accountList[0].CIF__c;

		if (clientAccountId != null) {
			Map<MBListsourceinstructionsv1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.mbListSourceInstructions(
				cifKey,
				srcAcc
			);
			MBListsourceinstructionsv1_Resp_IB_v1 responseBean = (new List<MBListsourceinstructionsv1_Resp_IB_v1>(responseMap.keySet()))[0];
			if (responseBean != null) {
				if (responseBean.statusCode == 200) {
					if (responseBean.MBlistSourceInstructionsV1Response != null) {
						if (responseBean.MBlistSourceInstructionsV1Response.mbn305o != null) {
							return JSON.serialize(responseBean.MBlistSourceInstructionsV1Response.mbn305o);
						}
					}
				}
			}
		}
		return null;
	}    

	/**
	 * @description Method to pay beneficiary
	 * @param clientAccountId
	 * @param paymTime
	 * @param accessAcc
	 * @param instrRefName
	 * @param actDate
	 * @param amount
	 * @param instrNo
	 * @param srcAcc
	 * @param srcAccType
	 * @param srcStmtRef
	 * @param trgAcc
	 * @param trgClrCode
	 * @param trgAccType
	 * @param trgStmtRef
	 * @param paymIipInd
	 * @param tieb
	 * @return MBinitiatePaymentV10_Resp_IB_v1 object
	 */
	@AuraEnabled
	public static MBinitiatePaymentV10_Resp_IB_v1 payBeneficiary_v10(
		String clientAccountId,
		String paymTime,
		String accessAcc,
		String instrRefName,
		String actDate,
		String amount,
		String instrNo,
		String srcAcc,
		String srcAccType,
		String srcStmtRef,
		String trgAcc,
		String trgClrCode,
		String trgAccType,
		String trgStmtRef,
		String paymIipInd,
        String tieb
	) {
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		String cifKey = accountList[0].CIF__c;

		String trgAccTypeTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.EPS_STRING,
			'Account Type',
			trgAccType,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		for (
			MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.payBeneficiary(
					paymTime,
					accessAcc,
					cifKey,
					instrRefName,
					actDate,
					amount,
					instrNo,
					srcAcc,
					srcAccType,
					srcStmtRef,
					trgAcc,
					trgClrCode,
					trgAccTypeTrans,
					trgStmtRef,
					paymIipInd,
                	tieb
				)
				.keyset()
		) {
			if (singleresponse != null) {
				if (singleresponse.statusCode == 200) {
					return singleresponse;
				}
			}
		}

		return null;
	}

	/**
	 * @description Method to complete Beneficiary Payment
	 * @param uniqueEft
	 * @param paymNo
	 * @return result string
	 */
	@AuraEnabled
	public static String completeBeneficiaryPayment(String uniqueEft, String paymNo) {
		String result;

		if (uniqueEft != null && paymNo != null) {
			MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.payBeneficiary(uniqueEft, paymNo);
			MBcomplEpSpaymentV4_Resp_IB_v1.MBcomplEpSpaymentV4Response outputBean = singleresponse.MBcomplEpSpaymentV4Response;

			if (outputBean != null) {
				MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o output = outputBean.mbp302o;
				if (singleresponse.statusCode == 200) {
					if (output.respDesc == 'SUCCESSFUL PROCESS') {
						result = output.respDesc;
					} else {
						result = output.respDesc;
					}
				}
			}
		}
		return result;
	}

	/**
	 * @description Method to get daily limits
	 * @param selectedCombiNumber
	 * @return daily limits as JSON string
	 */
	@AuraEnabled
	public static String getDailyLimits(String selectedCombiNumber) {
		Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CCgetDailyLimits_IH_v1.CCgetDailyLimits(selectedCombiNumber);
		CCgetDailyLimits_Resp_IB_v1 responseBean = (new List<CCgetDailyLimits_Resp_IB_v1>(responseMap.keySet()))[0];
		if (responseBean.statusCode == 200) {
			CCgetDailyLimits_Resp_IB_v1.CCgetDailyLimitsV2Response wrapper = responseBean.CCgetDailyLimitsV2Response;
			CCgetDailyLimits_Resp_IB_v1.ccp312o cls_CCp312o = wrapper?.ccp312o;
			return JSON.serialize(cls_CCp312o);
		}
		return null;
	}

	/**
	 * @description Method to complete Payment
	 * @param uniqueEft
	 * @return result string
	 */
	@AuraEnabled
	public static String completePayment(String uniqueEft) {
		String result;

		// if(uniqueEft != null){
		MBcomplEpSpaymentV4_Resp_IB_v1 singleresponse = MBcomplEpSpaymentV4_IH_v1.mBcomplEpSpaymentV4(uniqueEft);
		MBcomplEpSpaymentV4_Resp_IB_v1.MBcomplEpSpaymentV4Response outputBean = singleresponse.MBcomplEpSpaymentV4Response;

		if (outputBean != null) {
			MBcomplEpSpaymentV4_Resp_IB_v1.mbp302o output = outputBean.mbp302o;
			if (singleresponse.statusCode == 200) {
				if (output.respDesc == 'SUCCESSFUL PROCESS') {
					result = output.respDesc;
				} else {
					result = output.respDesc;
				}
			}
		}
		// }
		return result;
	}

	/**
	 * @description update selected instructions for future payment
	 * @param clientAccountId
	 * @param instrNo
	 * @param amount
	 * @param instrRefName
	 * @param srcAccNumber
	 * @param srcAccType
	 * @param srcBranchCode
	 * @param srcRef
	 * @param trgAccNumber
	 * @param trgAccType
	 * @param trgBranchCode
	 * @param trgRef
	 * @param actDate
	 * @return result string
	 */
	@AuraEnabled
	public static string updateFuturePayment(
		String clientAccountId,
		String instrNo,
		String amount,
		String instrRefName,
		String srcAccNumber,
		String srcAccType,
		String srcBranchCode,
		String srcRef,
		String trgAccNumber,
		String trgAccType,
		String trgBranchCode,
		String trgRef,
		String actDate
	) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		String cifKey = accountList[0].CIF__c;

		User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
		String siteCode = currentUser.SiteCode__c;
		String teller = currentUser.Teller_Operator_Code__c;
		String actDateP = actDate.replace('-', '');

		if (clientAccountId != null) {
			if (cifKey != null) {
				//Update Callout
				Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.updateInstruction(
					cifKey,
					instrNo,
					amount,
					instrRefName,
					srcAccNumber,
					srcAccType,
					srcBranchCode,
					srcRef,
					trgAccNumber,
					trgAccType,
					trgBranchCode,
					trgRef,
					siteCode,
					teller,
					actDateP
				);
				MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
				MBupdateInstructionV1_Resp_IB_v1.Mbp300o respData = responseBean.MBupdateInstructionV1Response.Mbp300o;

				//if(responseBean != null ){
				if (respData != null) {
					// update successfull
					if (respData.respCode == '0') {
						return respData.respDesc + '  UPDATED';
					} else {
						// update failed with error
						ex.setMessage(respData.respDesc);
						throw ex;
					}
				} else {
					ex.setMessage('There was an error updating the record');
					throw ex;
				}
			} else {
				ex.setMessage('There was an error retrieving the Client CIF Number');
				throw ex;
			}
		} else {
			ex.setMessage('There was an error retrieving the Client record');
			throw ex;
		}
	}

	/**
	 * @description Call MBgetPaymentDetailV3_Resp_IB_v1 to get last two payments mad to a beneficiary
	 * @param uniqueEFT
	 * @return MBgetPaymentDetailV3_Resp_IB_v1
	 */
	@AuraEnabled
	public static MBgetPaymentDetailV3_Resp_IB_v1 getLastTwoTransactions(String uniqueEFT) {
		MBgetPaymentDetailV3_Resp_IB_v1 responseBean = MBgetPaymentDetailV3_IH_v1.MBgetPaymentDetailV3(uniqueEFT);

		return responseBean;
	}

	/**
	 * @description Method to remove payment
	 * @param clientAccountId
	 * @param instrNo
	 * @return result string
	 **/
	@AuraEnabled
	public static string removePayment(String clientAccountId, String instrNo) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		String cifKey = accountList[0].CIF__c;

		User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
		String siteCode = currentUser.SiteCode__c;
		String teller = currentUser.Teller_Operator_Code__c;

		if (clientAccountId != null) {
			if (cifKey != null) {
				//Update  Callout
				Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2Forpayment(
					cifKey,
					instrNo,
					siteCode,
					teller
				);

				// Get first key from the map
				MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];

				MBdeleteInstructionV2_Resp_IB_v1.Mbp306o respData = responseBean.MBdeleteInstructionV2Response.Mbp306o;

				if (respData != null) {
					// removed successfull
					if (respData.respCode == '0') {
						return respData.respDesc + ' REMOVED';
					} else {
						//remove failed with error
						ex.setMessage(respData.respDesc);
						throw ex;
					}
				} else {
					//Reponse Bean is empty
					ex.setMessage('There was an error removing the record');
					throw ex;
				}
			} else {
				ex.setMessage('There was an error retrieving the Client CIF Number');
				throw ex;
			}
		} else {
			ex.setMessage('There was an error retrieving the Client record');
			throw ex;
		}
	}
}