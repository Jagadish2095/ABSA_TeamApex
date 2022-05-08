/**
 * @description Controller for the StopOrderMaintenance Lightning component
 * @author   Rudolf Niehaus
 * @since 2020-04-02
 */
public class StopOrderMaintenance {
	/**
	 * @description  Get logged in User Details for parameters on Services
	 * @return User
	 */
	@AuraEnabled
	public static User getLoggedInUserDetails() {
		User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());

		return loggedInUserInfo;
	}

	/**
	 * @description gets list of beneficiaries
	 * @param  accId
	 * @param  accNumber
	 * @param  userRecord
	 * @return List<Map<String, String>>
	 */
	@AuraEnabled
	public static Map<String, Map<String, String>> getBeneficiaryList(String accId, String accNumber, User userRecord) {
		Map<String, Map<String, String>> dataMap = new Map<String, Map<String, String>>();
		String cif = getCIF(accId);



		if (accNumber != null) {
			Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBListSourceInstructionsV1_IH_v1.MBListSourceInstructionsV1(
				cif,
				accNumber
			);

			MBListSourceInstructionsV1_Resp_IB_v1 responseBean = (new List<MBListSourceInstructionsV1_Resp_IB_v1>(responseMap.keySet()))[0];

			MBListSourceInstructionsV1_Resp_IB_v1.Mbn305o respData = responseBean.MBlistSourceInstructionsV1Response.mbn305o;

			for (MBListSourceInstructionsV1_Resp_IB_v1.Instruction ben : respData.instruction) {
				Map<String, String> details = new Map<String, String>();
				details.put('refName', ben.instrRefName);
				details.put('actionDate', ben.actDate);
				details.put('PayEndDate', ben.endDate);
				details.put('sourceRef', ben.srcStmtRef);
				details.put('amount', ben.amount);
				details.put('freq', translateFreqancy(ben.freq, 'in'));
				details.put('targetBank', ben.trgInstCode);
				details.put('targetBranch', ben.trgClrCode);
				details.put('targetAccount', ben.trgAcc.replaceFirst('^0+', ''));
				details.put('targetRef', ben.trgStmtRef);

				dataMap.put(ben.instrNo, details);
			}
		}

		return dataMap;
	}

	/**
	 * @description Get additional details for selected Branch
	 * @param  branchCode
	 * @return Lookup__c
	 */
	@AuraEnabled
	public static Lookup__c getSelectedBranchRecordDetails(String branchCode) {
		Set<String> branchCodeSet = new Set<String>();
		branchCodeSet.add(branchCode);
		List<Lookup__c> lookupList = new LookupsSelector().selectByBranchCode(branchCodeSet);

		if (lookupList != null && lookupList.size() > 0) {
			return lookupList[0];
		} else {
			return null;
		}
	}

	/**
	 * @description get bank by name
	 * @param bankName
	 * @return Lookup__c
	 */
	@AuraEnabled
	public static Lookup__c getBankIdByName(String bankName) {
		List<Lookup__c> lookupList = new LookupsSelector().selectByName(BankName);

		if (lookupList != null && lookupList.size() > 0) {
			return lookupList[0];
		} else {
			return null;
		}
	}

	/**
	 * @description update beneficiary details
	 * @param accId
	 * @param instrNo
	 * @param beneficiaryName
	 * @param trigDate
	 * @param endDate
	 * @param payDay
	 * @param freq
	 * @param amount
	 * @param srcAccNumber
	 * @param srcAccType
	 * @param srcBranchCode
	 * @param trgAccType
	 * @param trgAccNumber
	 * @param trgBranchCodeId
	 * @param srcRef
	 * @param trgRef
	 * @param userRecord
	 * @param updateType
	 * @return String
	 */
	@AuraEnabled
	public static string updateBeneficiary(
		String accId,
		String instrNo,
		String beneficiaryName,
		String trigDate,
		String endDate,
		String payDay,
		String freq,
		String amount,
		String srcAccNumber,
		String srcAccType,
		String srcBranchCode,
		String trgAccType,
		String trgAccNumber,
		String trgBranchCodeId,
		String srcRef,
		String trgRef,
		User userRecord,
		String updateType
	) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);

		try {
			if (accId != null) {
				String cif = getCIF(accId);

				//Universal ABSA branch code
				srcBranchCode = '632005';

				//Get Branch Code based on BrancCode Record Id
				String trgBranchCode = '0';
				Set<Id> branchCodeSet = new Set<Id>();
				branchCodeSet.add(trgBranchCodeId);
				List<Lookup__c> lookupList = new LookupsSelector().selectById(branchCodeSet);

				if (lookupList != null && lookupList.size() > 0) {
					trgBranchCode = lookupList[0].Branch_Code__c;
				}

				String siteCode = userRecord.SiteCode__c;
				String teller = userRecord.Teller_Operator_Code__c;

				freq = translateFreqancy(freq, 'out');
				trigDate = trigDate.remove('-');
				endDate = endDate.remove('-');

				if (cif != null) {
					if (updateType.equals('update')) {
						//Update Beneficiary Callout
						Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBSupdateInstructionV1_IH_v1.MBupdateInstructionV1(
							cif,
							instrNo,
							beneficiaryName,
							trigDate,
							endDate,
							payDay,
							freq,
							amount,
							srcAccNumber,
							srcAccType,
							srcBranchCode,
							srcRef,
							trgAccNumber,
							trgAccType,
							trgBranchCode,
							trgRef,
							siteCode,
							teller
						);
						// Get first key from the map
						MBSupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBSupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];

						MBSupdateInstructionV1_Resp_IB_v1.Mbp300o respData = responseBean.MBupdateInstructionV1Response.Mbp300o;

						if (respData != null) {
							if (respData.respCode == '0') {
								return respData.instrRefName + ' Successfully Updated';
							} else {
								ex.setMessage(respData.respDesc);
								throw ex;
							}
						} else {
							ex.setMessage('There was an error updating the Stop Order');
							throw ex;
						}
					} else if (updateType.equals('insert')) {
						//get first active comi card number for CIF
						String accessAcc = '';

						if (!Test.isRunningTest()) {
							accessAcc = getCombiCardNumber(cif);
						}

						CreateInstruction_Resp_IB_v2 accountValidationResponse = CreateInstruction_IH_v2.createInstruction(
							accessAcc,
							beneficiaryName,
							trigDate,
							endDate,
							payDay,
							freq,
							amount,
							srcAccNumber,
							srcAccType,
							srcBranchCode,
							srcRef,
							trgAccNumber,
							trgAccType,
							trgBranchCode,
							trgRef,
							siteCode,
							teller
						);

						if (accountValidationResponse.respDesc == 'SUCCESSFUL PROCESS') {
							return 'Successfully Added';
						} else {
							ex.setMessage('There was an error adding the new stop order ' + accountValidationResponse.respDesc);
							throw ex;
						}
					} else {
						ex.setMessage('Technical Error.. No update type implimented');
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
		} catch (Exception e) {
			System.debug('Update OR Insert Stop Order exception : ' + e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description Get first active combi card number
	 * @param cif
	 * @return String
	 */
	public static String getCombiCardNumber(String cif) {
		String combiCard = '';
		String errorMessage = '';

		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;

		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseBeanMap = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCodeWithOutInsertLog(
			StringConstants.SALESFORCE_STRING,
			cif
		);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = (new List<CIgetAcctLinkedToClientCode_Resp_IB_v1>((responseBeanMap.keySet())))[0];

		if (response.statusCode == 200) {
			CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;

			List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;

			accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();

			for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj : accTypes) {
				if (accWrObj.productType == 'CO' && accWrObj.status == 'ACTIVE') {
					combiCard = accWrObj.oaccntnbr;
					break;
				}
			}
		} else {
			errorMessage = 'CIF not found for the Account';
			throw new AuraHandledException('Error: ' + errorMessage);
		}

		return combiCard;
	}

	/**
	 * @description Remove a stop order for a selected account
	 * @param  accId
	 * @param  instrNo
	 * @param  userRecord
	 * @return String
	 */
	@AuraEnabled
	public static string removeBeneficiary(String accId, String instrNo, User userRecord) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);

		try {
			if (accId != null) {
				//Get CIF No based on Account Id
				String cif = getCIF(accId);
				String siteCode = userRecord.SiteCode__c;
				String teller = userRecord.Teller_Operator_Code__c;

				if (cif != null) {
					//Update Beneficiary Callout
					Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2ForStopOrder(
						cif,
						instrNo,
						siteCode,
						teller
					);
					// Get first key from the map
					MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];

					MBdeleteInstructionV2_Resp_IB_v1.Mbp306o respData = responseBean.MBdeleteInstructionV2Response.Mbp306o;

					if (respData != null) {
						//Beneficiary removed successfull
						if (respData.respCode == '0') {
							return respData.instrRefName + 'Successfully Removed';
						} else {
							//Beneficiary remove failed with error
							ex.setMessage(respData.respDesc);
							throw ex;
						}
					} else {
						//Reponse Bean is empty
						ex.setMessage('There was an error removing the Stop Order');
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
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description get frequency picklist values
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getFreqancy() {
		List<String> freqancyList = new List<String>{
			'DAILY',
			'MONTHLY',
			'MONTH END',
			'WEEKLY',
			'ANNUALLY',
			'2 MONTHLY',
			'2 WEEKLY',
			'QUARTERLY',
			'4 MONTHLY',
			'6 MONTHLY'
		};

		return freqancyList;
	}

	/**
	 * @description closes case in question
	 * @param caseRecordId
	 */
	@AuraEnabled
	public static void closeCaseAction(Id caseRecordId) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);

		try {
			if (caseRecordId != null) {
				Case caseObj = new Case(Id = caseRecordId);
				Date sla = Date.today().addDays(1);
				caseObj.External_SLA_End_Date__c = sla;
				caseObj.Status = 'Closed';
				update caseObj;
			}
		} catch (DmlException e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description gets users CIF
	 * @param accId
	 * @return String
	 */
	private static String getCIF(String accId) {
		Set<Id> ids = new Set<Id>();
		ids.add(accId);

		List<Account> acc = new AccountsSelector().selectById(ids);

		if (acc.size() > 0) {
			return acc[0].CIF__c;
		} else {
			return '';
		}
	}

	/**
	 * @description translates Frequency value
	 * @param inputVal
	 * @param inputOrder
	 * @return String
	 */
	public static String translateFreqancy(String inputVal, String inputOrder) {
		String outString = '';

		if (inputOrder.equals('in')) {
			switch on inputVal {
				when '1D' {
					outString = 'DAILY';
				}
				when '1M' {
					outString = 'MONTHLY';
				}
				when '1ME' {
					outString = 'MONTH END';
				}
				when '1W' {
					outString = 'WEEKLY';
				}
				when '1Y' {
					outString = 'ANNUALLY';
				}
				when '2M' {
					outString = '2 MONTHLY';
				}
				when '2W' {
					outString = '2 WEEKLY';
				}
				when '3M' {
					outString = 'QUARTERLY';
				}
				when '4M' {
					outString = '4 MONTHLY';
				}
				when '6M' {
					outString = '6 MONTHLY';
				}
				when else {
					outString = 'DAILY';
				}
			}
		} else if (inputOrder.equals('out')) {
			switch on inputVal {
				when 'DAILY' {
					outString = '1D';
				}
				when 'MONTHLY' {
					outString = '1M';
				}
				when 'MONTH END' {
					outString = '1ME';
				}
				when 'WEEKLY' {
					outString = '1W';
				}
				when 'ANNUALLY' {
					outString = '1Y';
				}
				when '2 MONTHLY' {
					outString = '2M';
				}
				when '2 WEEKLY' {
					outString = '2W';
				}
				when 'QUARTERLY' {
					outString = '3M';
				}
				when '4 MONTHLY' {
					outString = '4M';
				}
				when '6 MONTHLY' {
					outString = '6M';
				}
				when else {
					outString = '1D';
				}
			}
		}

		return outString;
	}

	/**
	 *  DO NOT REMOVE - WILL BE USED WHEN DOCFUSION IS READY *******
	 *
	@AuraEnabled
	public static String sendStopOrderHistory( String jsonStr, String emailAddress, Id caseRecordId ){

		String returnString = 'Email sent to the client';

		PageReference pdf = Page.StopOrderMaintenanceEmailPage;
		pdf.getParameters().put('vfParam' , jsonStr);

		Attachment attach = new Attachment();
		attach.contentType = 'application/pdf';
		attach.name = 'Stop_Order_History.pdf';

		if( String.isNotBlank(jsonStr) && !Test.isRunningTest()){

			attach.Body = pdf.getContentAsPdf();

		}else{
			attach.Body = blob.toPDF('There is no stop order history records for this account');
		}


		List<Attachment> attachmentList = new List<Attachment>();
		attachmentList.add(attach);

		try{

			Case currentCase = [SELECT Id, CaseNumber, AccountId, Account.Name FROM Case WHERE Id =: caseRecordId];

			String contactId = [Select PersonContactId From Account Where Id = :currentCase.AccountId].PersonContactId;

			if( String.isNotBlank(contactId) ){

				Contact con = [Select Email From Contact Where Id =:contactId];

				if(String.isBlank(con.email)){

					con.email = emailAddress;

					try{
						update con;
					}catch(DMLException ex){
						throw ex;
					}
				}

			}else{

				List<Contact> contList = [Select Id, Email From Contact Where Email = :emailAddress and AccountId = :currentCase.AccountId];

				if(contList.size() > 0){

					if(String.isBlank( contList[0].Email )){

						contList[0].Email = emailAddress;

						try{
							update contList[0];
						}catch(DmlException ex){
							throw ex;
						}
					}

					contactId = contList[0].Id;

				}else{

					String[] contNames = emailAddress.split('@');

					Contact newCon = new Contact();
					newCon.Email = emailAddress;
					newCon.LastName = contNames[0];
					newCon.AccountId = currentCase.AccountId;

					try{

						insert newCon;
						contactId = newCon.Id;

					}catch(DmlException ex){

						throw ex;
					}
				}

			}



			List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress,'Stop_Order_History');
			Messaging.SingleEmailMessage email = constructEmail.get(0);

			String htmlBody = email.getPlainTextBody();

			htmlBody = htmlBody.replace('{!Case.CaseNumber}', currentCase.CaseNumber).replace('{!Case.ClientName__c}', currentCase.Account.Name);
			email.setPlainTextBody(htmlBody);

			sendEmailwithPDFAttachments(email, emailAddress,email.getHTMLBody(),attachmentList);

		}catch(exception ex){
			system.debug(ex);
			system.debug(ex.getMessage());
			returnString = '' + ex.getMessage();
			throw ex;
		}

		//}

		return returnString;

	}

	private static void sendEmailwithPDFAttachments(Messaging.SingleEmailMessage constructEmail, String emailAddress, string emailBody, List<Attachment> attachmentList ){

		List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();

		for(Attachment attach: attachmentList ){

			Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
			efa.setFileName(attach.Name);
			efa.setBody(attach.Body);
			fileAttachments.add(efa);

		}

		constructEmail.setFileAttachments(fileAttachments);
		constructEmail.setSaveAsActivity(true);

		try{
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { constructEmail });
		}catch(exception e){
			apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
		}
	}
	**/
}