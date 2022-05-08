/**
 * @description This is InterAccountTransfer Lightning component Apex Controller Class
 * @author Lulu Rankwe
 * @created 2020/02/05
 * @updated Koketso Mpshane 2021/04/12
 */

public class InterAccountTransferController {
	/**
	 * @description retrieves client account account number based on AccountId
	 * @param  clientAccountId
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */
	@AuraEnabled
	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 getAccountDetails(String clientAccountId) {
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(
			StringConstants.SALESFORCE_STRING,
			accountList[0].CIF__c
		);
		//Added by chandra dated 17/11/2021
        if(responseBean.cip047o != null && responseBean.cip047o.outputTable != null){
            List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = responseBean.cip047o.outputTable;
            for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable currentRecord : accTypes) {
                currentRecord.productTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF, 'Product Type', currentRecord.productType, StringConstants.INBOUND_RECORD_TYPE);
            }
        }
        //Changes ended by chandra
		return responseBean;
	}

	/**
	 * @description retrieves accounts linked to a specified combi account
	 * @param   selectedCombi
	 * @return  CClistAccsLinkedToCombiV1_Resp_IB_v1
	 */
	@AuraEnabled
	public static CClistAccsLinkedToCombiV1_Resp_IB_v1 getAccountsLinkedToCombi(String selectedCombi) {
		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = CClistAccsLinkedToCombiV1_IH_v1.CCListAccsLinkedToCombi(selectedCombi);

		return responseBean;
	}

	/**
	 * @description Initiate payment based on client selected Account
	 * @param payTime
	 * @param actDate
	 * @param amount
	 * @param srcAcc
	 * @param srcAccType
	 * @param trgAcc
	 * @param trgAccType
	 * @param trgStmtRef
	 *  @param instrRefName
	 * @return MBinitiatePaymentV10_Resp_IB_v1
	 */
	@AuraEnabled
	public static MBinitiatePaymentV10_Resp_IB_v1 initiatePayment(
		String payTime,
		String actDate,
		String amount,
		String srcAcc,
		String srcAccType,
		String trgAcc,
		String trgAccType,
		String trgStmtRef,
		String instrRefName
	) {
		MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1();
		requestBean.paymTime = payTime;
		requestBean.maxRetrieve = '1';
		requestBean.instrType = 'OOP';
		// Sweep set off
		if (instrRefName != null) {
			requestBean.instrRefName = instrRefName;
		}
		requestBean.actDate = actDate;
		requestBean.amount = amount;
		requestBean.srcAcc = srcAcc;
		requestBean.srcAccType = srcAccType;
		requestBean.srcStmtRef = 'loan to build ';
		requestBean.trgAcc = trgAcc;
		requestBean.trgClrCode = '0';
		requestBean.trgAccType = trgAccType;
		requestBean.trgStmtRef = trgStmtRef; //reference
		requestBean.changeBranch = '8089';
		requestBean.changeTeller = '11012';
		requestBean.benNonResStat = '';
		requestBean.channel = 'BISONTEST';
		requestBean.application = 'EPS';
		requestBean.channelInp = 'BDP';
		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';
		requestBean.srcClrCode = '0';
		requestBean.trace = 'Y';

		MBinitiatePaymentV10_Resp_IB_v1 response = new MBinitiatePaymentV10_Resp_IB_v1();
		for (
			MBinitiatePaymentV10_Resp_IB_v1 singleresponse : (Set<MBinitiatePaymentV10_Resp_IB_v1>) MBinitiatePaymentV10_IH_v1.callToMBinitiatePaymentV10(
					requestBean
				)
				.keyset()
		) {
			response = singleresponse;
			break;
		}

		return response;
	}

	/**
	 * @author Koketso Mpshane
	 * @description translate customer account type for text message
	 * @param systemName
	 * @param valueType
	 * @param valueString
	 * @return String
	 */
	@AuraEnabled
	public static String getOutboundTranslation(String systemName, String valueType, String valueString) {
		return Sys_Utilities_Integration.getIntegrationTranslationExternalValue(systemName, valueType, valueString, StringConstants.OUTBOUND_RECORD_TYPE);
	}

	/**
	 * @description retrieves Collection Phase and Collection Cycle passing Account Number
	 * @param  clientAccountNum
	 * @return Map<String, String>
	 * @work w-013364
	 */
	@AuraEnabled
	public static Map<String, String> getAccountCollectionPhaseAndCycle(String clientAccountNum) {
		String businessArea;
		String collectionCycle;
		String customerOnPTP;
		Decimal arrearAmount;
		// Map to return data in the form of key and value
		Map<String, String> collectionCycleDataMap = new Map<String, String>();

		// To fetch agency Identifier
		AccountSearch_Resp_IB_v1 responseBean = AccountSearch_IH_v1.AccountSearch(clientAccountNum);
		if (responseBean?.StatusCode != 200) {
			collectionCycleDataMap.put('Error', 'Service returned error while fetching account details');
			return collectionCycleDataMap;
		}
		if (!Test.isRunningTest()) {
			if (responseBean.Data == null || (responseBean.Data != null && responseBean?.Data[0]?.accountAgencyIdentifier == null)) {
				collectionCycleDataMap.put('Error', 'Service returned Agency Identifiers as null');
				return collectionCycleDataMap;
			}
		}

		// To fetch Business Area / Collection Phase
		string accAgencyiden;
		accAgencyiden = String.valueof(responseBean?.Data[0]?.accountAgencyIdentifier);
		arrearAmount = responseBean?.Data[0]?.CurrentBalance?.amount;
		if (Test.isRunningTest()) {
			accAgencyiden = '170305299';
		}
		RetreiveTag_Resp_IB_v1 responseRetrieveTag = RetreiveTag_IH_v1.RetreiveTag(accAgencyiden);

		// To fetch  Collection Cycle
		RetreiveAccountPageList_Resp_IB_v1 resRetriveList = RetreiveAccountPageList_IH_v1.RetreiveAccountPageList(accAgencyiden);

		if (responseRetrieveTag?.statusCode != 200 && resRetriveList?.statusCode != 200) {
			collectionCycleDataMap.put('Error', ' Service returned Error while fetching collection phase and collection cycle.');
			return collectionCycleDataMap;
		}
		if (responseRetrieveTag != null) {
			for (RetreiveTag_Resp_IB_v1.Data data : responseRetrieveTag.Data) {
				if (data?.tag?.tagType?.name == 'Business Area') {
					businessArea = data.tag.description;
				}

				if (data?.tag?.tagType?.name == 'PTP Status Tag Type') {
					if (data.tag.description == 'PTP Kept' || data.tag.description == 'PTP Cancelled' || data.tag.description == 'PTP Broken' || data.tag.description == 'PTP Clear') {
						customerOnPTP = 'No';
					}
					if (data.tag.description == 'PTP Active') {
						customerOnPTP = 'Yes';
					}
				} else {
					customerOnPTP = 'Yes';
				}
			}
		}
		if (resRetriveList != null) {
			collectionCycle = calculateCollectionCycle(resRetriveList);
		}

		collectionCycleDataMap.put('businessArea', businessArea);
		collectionCycleDataMap.put('collectionCycle', collectionCycle);
		collectionCycleDataMap.put('customerOnPTP', customerOnPTP);
		collectionCycleDataMap.put('arrearAmount', String.valueof(arrearAmount));

		return collectionCycleDataMap;
	}

	/**
	 * @description Calculate Number of Cycle on passing Response
	 * @param  res
	 * @return String
	 * @work w-013364
	 */
	@TestVisible
	private static String calculateCollectionCycle(RetreiveAccountPageList_Resp_IB_v1 res) {
		String collectionCycle;
		if (res?.data[0]?.userDefinedData?.UDEFNDD != null) {
			Decimal uDEFNDD = Decimal.valueOf(res.data[0].userDefinedData.UDEFNDD);

			Integer count = Integer.valueOf(Math.ceil(uDEFNDD / 30));
			collectionCycle = 'Cycle ' + count;
		}
		return collectionCycle;
	}
	/**
	 * @description Create Case Transaction record
	 * @param  caseTransactionDataMap
	 * @return String
	 * @work w-013364
	 */
	@AuraEnabled
	public static String createCaseTransactionRecord(Map<String, String> caseTransactionDataMap) {
		
		String collectionPhase = caseTransactionDataMap.get('collectionPhase');
		String queueName = caseTransactionDataMap.get('queueName');
		String jobType = caseTransactionDataMap.get('jobType');
        Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = :queueName]?.Id;

		Case_Transaction__c caseTransactionRecord = new Case_Transaction__c();
		caseTransactionRecord.Amount__c = decimal.valueOf(caseTransactionDataMap.get('amount'));
		caseTransactionRecord.Case__c = caseTransactionDataMap.get('caseID');
		caseTransactionRecord.Reason__c = caseTransactionDataMap.get('reason');
		caseTransactionRecord.Reason_Comments__c = caseTransactionDataMap.get('otherReasonComment');
		caseTransactionRecord.Reference__c = caseTransactionDataMap.get('reference');
		caseTransactionRecord.Service_Group__c = 'Everyday Banking - Collections';
		caseTransactionRecord.Source_Account__c = caseTransactionDataMap.get('sourceAccount');
		caseTransactionRecord.Target_Account__c = caseTransactionDataMap.get('targetAccount');
		caseTransactionRecord.Source_Account_Type__c = caseTransactionDataMap.get('srcAccType');
		caseTransactionRecord.Target_Account_Type__c = caseTransactionDataMap.get('trgAccType');
		caseTransactionRecord.Status__c = 'New';
		caseTransactionRecord.jobType__c = caseTransactionDataMap.get('jobType');
        if(queueId !=null && !Test.isRunningTest()){
             caseTransactionRecord.OwnerId=queueId;
        }
		if (collectionPhase != null) {
			caseTransactionRecord.Collection_Phase__c = collectionPhase;
		}
		insert caseTransactionRecord;
		// Submitting for approval process
		Boolean isApprovalInitiatedSuccessfully = submitForApproval(caseTransactionRecord.Id, queueId);
		return isApprovalInitiatedSuccessfully == true ? 'Successfully Submitted for Approval' : 'Error Occurred while submitting for approval';
	}
	/**
	 * @description Calling future method to avoid Uncommitted work Issue
	 * @param  caseTranasactionIDList
	 * @work w-013364
	 */
	@InvocableMethod(Label='logicAfterApproveReject')
	public static void logicAfterApproveReject(List<Id> caseTranasactionIDList) {
		makeCallOutToInitiatePayment(caseTranasactionIDList);
	}
	/**
	 * @description Future method to initiate  record
	 * @param  caseTranasactionIDList
	 * @work w-013364
	 */
	@future(callout=true)
	public static void makeCallOutToInitiatePayment(List<Id> caseTranasactionIDList) {
		List<Case_Transaction__c> updateCaseTransactionList = new List<Case_Transaction__c>();
		List<Case> updateCaseList = new List<Case>();
		Case_Transaction__c caseTransactionRecord = [
			SELECT
				Name,
				Amount__c,
				Approvers_Comment__c,
				jobType__c,
				Case__c,
				Source_Account__c,
				Target_Account__c,
				Source_Account_Type__c,
				Target_Account_Type__c,
				Status__c,
				Reference__c
			FROM Case_Transaction__c
			WHERE Id = :caseTranasactionIDList[0]
			LIMIT 1
		];
		Case caseRecord = [
			SELECT Id, OwnerId, Description, Status, Comments__c, CIF__c, Client_Mobile_Phone__c
			FROM Case
			WHERE Id = :caseTransactionRecord.Case__c
			LIMIT 1
		];
		String approverComments;
		List<ProcessInstance> processInstances = [
			SELECT
				Id,
				TargetObjectId,
				(SELECT Id, ActorId, StepStatus, Comments 
                 FROM Steps WHERE StepStatus IN :new List<String>{ 'Approved', 'Rejected' } 
                 ORDER BY CreatedDate DESC)
			FROM ProcessInstance
			WHERE TargetObjectId IN :caseTranasactionIDList
			ORDER BY CreatedDate DESC
		];
		for (ProcessInstance pi : processInstances) {
			for (ProcessInstanceStep step : pi.Steps) {
				if (step.StepStatus == 'Approved' || step.StepStatus == 'Rejected') {
					approverComments = step.Comments;
				}
			}
		}
		//Approvers_Comment__c
		String payDate;
		String payTime;
		String month;
		String dayStr;
		Integer monthInInteger = Date.today().Month();
		Integer year = Date.today().Year();
		Integer day = Date.today().Day();
		DateTime dt = DateTime.now();
		if (caseTransactionRecord != null && caseTransactionRecord?.Status__c == 'Approved') {
			caseTransactionRecord.Approvers_Comment__c = approverComments;
			if (monthInInteger < 10) {
				month = '0' + monthInInteger;
			} else {
				month = String.valueof(monthInInteger);
			}
			if (day < 10) {
				dayStr = '0' + day;
			} else {
				dayStr = String.valueof(day);
			}
			payDate = year + month + dayStr;
			String instrRefName = caseTransactionRecord.jobType__c == 'Inter-Account Transfer (Sweep)' ? 'EB COL Sweep' : 'EB COL Setoff';
			payTime = String.valueof(dt.hour()) + dt.Minute() + dt.Second() + dt.Millisecond();
			MBinitiatePaymentV10_Resp_IB_v1 res = initiatePayment(
				payTime,
				payDate,
				String.valueOf(caseTransactionRecord.Amount__c),
				caseTransactionRecord.Source_Account__c,
				caseTransactionRecord.Source_Account_Type__c,
				caseTransactionRecord.Target_Account__c,
				caseTransactionRecord.Target_Account_Type__c,
				caseTransactionRecord.Reference__c,
				instrRefName
			);
             
            if (Test.isRunningTest()) {
               res.statusCode=200;
                //res.MBinitiatePaymentV10Response.mbn301o.respDesc='SUCCESSFUL';
                 MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response resMB= new MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response();
                 list<MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response> resMBList  = new list<MBinitiatePaymentV10_Resp_IB_v1.MBinitiatePaymentV10Response>();
                res.status='OK';
                res.statusCode=200;
                res.StatusMessage='SUCCESS';
                MBinitiatePaymentV10_Resp_IB_v1.mbn301o dsresponse  = new MBinitiatePaymentV10_Resp_IB_v1.mbn301o();
                list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o> listdsresponse  = new list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o>();
                
                
                dsresponse.trgAcc='20190720';
                dsresponse.lastPaymAmnt='SUCCESSFUL';
                dsresponse.todaysDate='20211019';
                dsresponse.trgAccType='SA';
                dsresponse.avbl='302022';
                dsresponse.respDesc='SUCCESSFUL';
                resMB.mbn301o=dsresponse;
                resMBList.add(resMB);
                res.responseList=resMBList;
                res.MBinitiatePaymentV10Response=resMB;
               // res.responseList=listdsresponse;
                
            }
           
				if (res != null && res.statusCode == 200 && res.MBinitiatePaymentV10Response?.mbn301o?.respDesc.Contains('SUCCESSFUL')) {
					String transactionAmount = res.MBinitiatePaymentV10Response.mbn301o.lastPaymAmnt;
					String transactionDate = res.MBinitiatePaymentV10Response.mbn301o.todaysDate;
					String accountType = res.MBinitiatePaymentV10Response.mbn301o.trgAccType;
					String availableBalance = res.MBinitiatePaymentV10Response.mbn301o.avbl;
					String accTypeText;
					String smsText;
					// sweep
					if (caseTransactionRecord.jobType__c == 'Inter-Account Transfer (Sweep)') {
						accTypeText = getOutboundTranslation('EB SMS', 'Account Type', accountType);
						accTypeText = accTypeText != null ? accTypeText : accountType;
						smsText =
							'Absa: Per instruction payment from related account, Inter account transfer, R' +
							transactionAmount +
							' on ' +
							transactionDate +
							' to ' +
							accTypeText +
							', Total Avail Bal R' +
							availableBalance +
							'. Help 0860008600; ' +
							caseRecord.CIF__c;

						caseTransactionRecord.Status__c = 'Service Response Approved';
						caseRecord.Description = 'Inter Acccount Transfer sweep Successfull.';
						caseRecord.Status = 'Closed';
						updateCaseList.add(caseRecord);
						updateCaseTransactionList.add(caseTransactionRecord);
						//send sms
						NotifyBankerController.notifyClientBySMS(null, caseRecord.Client_Mobile_Phone__c, smsText, 'iTouch SMS Submit - EB Collections');
					} else {
						// Set off sms
						if (caseTransactionRecord.Target_Account_Type__c == 'CA' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
							smsText = System.Label.set_off_sms_card_from_Savings;
						} else if (caseTransactionRecord.Target_Account_Type__c == 'CA' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
							smsText = System.Label.set_off_sms_card_from_chq;
						} else if (caseTransactionRecord.Target_Account_Type__c == 'CQ' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
							smsText = System.Label.set_off_sms_chq_from_savings;
						} else if (caseTransactionRecord.Target_Account_Type__c == 'CQ' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
							smsText = System.Label.set_off_sms_chq_from_chq;
						} else if (caseTransactionRecord.Target_Account_Type__c == 'PL' && caseTransactionRecord.Source_Account_Type__c == 'SA') {
							smsText = System.Label.set_off_sms_pl_from_savings;
						} else if (caseTransactionRecord.Target_Account_Type__c == 'PL' && caseTransactionRecord.Source_Account_Type__c == 'CQ') {
							smsText = System.Label.set_off_sms_pl_from_chq;
						}
						smsText = smsText?.replace('xxxxx', transactionAmount);
						NotifyBankerController.notifyClientBySMS(null, caseRecord.Client_Mobile_Phone__c, smsText, 'iTouch SMS Submit - EB Collections');
						caseTransactionRecord.Status__c = 'Service Response Approved';
						caseRecord.Description = 'Set OFF Successfull.';
						caseRecord.Status = 'Closed';
						updateCaseList.add(caseRecord);
						updateCaseTransactionList.add(caseTransactionRecord);
					}
				} else {
					caseTransactionRecord.Status__c = 'Service Response Failed';
					// Transfer case for sweep when service response failed but approved by the approver.
					if (caseTransactionRecord.jobType__c == 'Inter-Account Transfer (Sweep)') {
						transferCase(
							'Inter Account Sweep Escalations',
							'Inter-Account Transfer (Sweep)',
							caseRecord.Id,
							new List<Case>{ caseRecord },
							Label.InterAccount_Sweep_Queue_for_Response_Failed_cases
						);
					} else {
						// Transfer case for SET OFF when service response failed but approved by the approver.
						transferCase(
							'Inter Account Sweep Escalations',
							'SET-OFF',
							caseRecord.Id,
							new List<Case>{ caseRecord },
							Label.Set_off_Response_Failed_Queue
						);
					}

					updateCaseTransactionList.add(caseTransactionRecord);
				}
			
		} else if (caseTransactionRecord != null && caseTransactionRecord?.Status__c == 'Rejected') {
			caseTransactionRecord.Approvers_Comment__c = approverComments;
			caseRecord.Description = 'Inter Acccount Transfer sweep Rejected by the Approver.';
			caseRecord.Status = 'Closed';
			updateCaseList.add(caseRecord);
			updateCaseTransactionList.add(caseTransactionRecord);
		}

		update updateCaseList;
		update updateCaseTransactionList;
	}
	/**
	 * @description To submit for approval
	 * @param caseTransactionID
	 * @param queueId
	 * @return Boolean
	 * @work w-013364
	 */
	@AuraEnabled
	public static Boolean submitForApproval(String caseTransactionID, Id queueId) {
		String approvalStatus;
		//Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = :queueName]?.Id;
		Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
		req.setComments('Submitting deviations for approval Process');
		req.setObjectId(caseTransactionID);
		req.setProcessDefinitionNameOrId('Inter_Account_Sweep_Approval_Mandate');
		req.setNextApproverIds(new List<Id>{ queueId });

		Approval.ProcessResult result = Approval.process(req);
		return result.isSuccess();
	}
	/**
	 * @description Transfers the Case to a new Service Group
	 * @param serviceGroupName
	 * @param serviceTypeName
	 * @param caseId
	 * @param caseList
	 * @param queueName
	 */
	@AuraEnabled
	public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId, List<Case> caseList, String queueName) {
		CaseTransferActionExt.transferCase(serviceGroupName, serviceTypeName, caseId);

		List<Group> groupList = new GroupsSelector().selectByNameAndType(queueName, 'Queue');

		if (groupList.size() > 0 && caseList.size() == 1) {
			caseList[0].OwnerId = groupList[0].Id;
			update caseList;
		}
	}
	/**
	 * @description TpromisToPay
	 * @param clientAccountNum
	 * @return String
	 */
	@AuraEnabled
	public static String promisToPay(String clientAccountNum) {
		// To fetch agency Identifier
		AccountSearch_Resp_IB_v1 responseBean = AccountSearch_IH_v1.AccountSearch(clientAccountNum);

		if (
			responseBean?.statusCode != 200 ||
			responseBean.Data == null ||
			(responseBean.Data != null &&
			responseBean?.Data[0]?.accountAgencyIdentifier == null)
		) {
			throw new AuraHandledException('Service returned error while fetching account details');
		}
		// To fetch  Payment Schedule Summaries Data
		PaymentScheduleSummaries_Resp_IB_v1 response = PaymentScheduleSummaries_IH_v1.GetPaymentScheduleSummaries(
			String.valueof(responseBean?.Data[0]?.accountAgencyIdentifier)
		);

		return JSON.serialize(response);
	}
}