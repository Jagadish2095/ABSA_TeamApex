/**
 * @description Controller for Beneficiary Maintenance Lightning component
 * @author Rudolf Niehaus
 * @Updated 2020-03-21
 */
public class BeneficiaryMaintenance {
	/**
	 * @description getAccountDetails method to get Account detail
	 * @param clientAccountId
	 * @return String
	 */
	@AuraEnabled
	public static String getAccountDetails(String clientAccountId) {
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

		if (accountList?.size() != 1) {
			return 'Error: Account not found with Id: ' + clientAccountId;
		}

		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(
			StringConstants.SALESFORCE_STRING,
			accountList[0].CIF__c
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
	 * @description getLoggedInUserDetails method to get loggedInUserDetails
	 * @return User
	 */
	@AuraEnabled
	public static User getLoggedInUserDetails() {
		User loggedInUserInfo = new UsersSelector().selectById(UserInfo.getUserId());

		return loggedInUserInfo;
	}

	/**
	 * @description Call MBlistInstPerSourceAccV1_IH_v1 to get Telephone Bannking Benificiary Details
	 * @param cifKey
	 * @param sourceAccount
	 * @param instrType
	 * @return MBlistInstPerSourceAccV1_Resp_IB_v1 response
	 */
	@AuraEnabled
	public static Map<String, List<Object>> getBeneficiaryListMap(String cifKey, String sourceAccount, String instrType) {
		Map<String, List<Object>> dataMap = new Map<String, List<Object>>();
		MBlistInstPerSourceAccV1_Resp_IB_v1 responseBean = MBlistInstPerSourceAccV1_IH_v1.MBlistInstructionsPerSourceAccV1(cifKey, sourceAccount, instrType);

		if (responseBean?.MBS326O?.outputCopybook?.instructionTable != null) {
			for (MBlistInstPerSourceAccV1_Resp_IB_v1.instructionTable instruction : responseBean.MBS326O.outputCopybook.instructionTable) {
				List<String> benDetails = new List<String>();

				benDetails.add(instruction.ivrNominate != null ? instruction.ivrNominate : '');
				benDetails.add(instruction.instrRefName != null ? instruction.instrRefName : '');
				benDetails.add(instruction.targetInstCode != null ? instruction.targetInstCode : '');
				benDetails.add(instruction.targetAccount != null ? instruction.targetAccount : '');
				benDetails.add(instruction.sourceStatementRef != null ? instruction.sourceStatementRef : '');
				benDetails.add(instruction.targetStatementRef != null ? instruction.targetStatementRef : '');
				benDetails.add(instruction.tieb != null ? instruction.tieb : '');

				dataMap.put(instruction.instrNumber, benDetails);
				
			}
			dataMap.put('instructionTable', responseBean.MBS326O.outputCopybook.instructionTable); //DBOOYSEN 14/04/2021. W-008297
		} else if (responseBean?.NBSMSGO3?.outputErrorMessage?.numberUserErrors > 0) {
			dataMap.put('Exception', new List<string>{ 'Error: ' + responseBean.NBSMSGO3.outputErrorMessage.numberUserMessages });
		} else {
			dataMap.put('Exception', new List<string>{ 'Error: Unexpected response received. Response body: ' + JSON.serialize(responseBean) });
		}

		return dataMap;
	}
    /**
     * @description Call EBSBeneficiaries service to get Telephone Bannking Benificiary Details
	 * @param cifKey
	 * @param sourceAccount
	 * @return Map<String, List<String>>
	 */
	@AuraEnabled
	public static Map<String, List<Object>> getEBSBeneficiaries(String cifKey, String sourceAccount) {

        Map<String, List<Object>> dataMap = new Map<String, List<Object>>();
        EBSBeneficiaries_Resp_IB_v1 responseBean = EBSBeneficiaries_IH_v1.EBSBeneficiaries(cifKey, sourceAccount);

		//check if response is null
		if (responseBean == null) {
            dataMap.put('Exception', new List<string>{ 'Error: Blank response received from service;'});
		}
		//check the response statusCode
		if (responseBean.statusCode != 200) {
            dataMap.put('Exception', new List<string>{ 'Error: ' + responseBean.message});
		}
		//check the response has error
		if (responseBean.error == true) {
            dataMap.put('Exception', new List<string>{ 'Error: ' + JSON.serialize(responseBean.errorList)});
		}

		if (responseBean?.ebsBeneficiariesResponse?.MBS326O?.outputCopybook?.instructionTable.size() > 0) {
            for (EBSBeneficiaries_Resp_IB_v1.instructionTable instruction : responseBean.ebsBeneficiariesResponse.MBS326O.outputCopybook.instructionTable) {
				List<String> benDetails = new List<String>();

				benDetails.add(instruction.ivrNominate != null ? instruction.ivrNominate : '');
				benDetails.add(instruction.sourceStatementRef != null ? instruction.sourceStatementRef : '');
				benDetails.add(instruction.targetInstCode != null ? instruction.targetInstCode : '');
				benDetails.add(instruction.targetAccount != null ? extractAccountNumber(instruction.targetAccount) : ''); // W-016885 Removed leading zeros. Hloni Matsoso
				benDetails.add(instruction.sourceStatementRef != null ? instruction.sourceStatementRef : '');
				benDetails.add(instruction.targetStatementRef != null ? instruction.targetStatementRef : '');

				benDetails.add(instruction.tieb != null ? instruction.tieb : '');

				dataMap.put(instruction.instrNumber, benDetails);
			}
			dataMap.put('instructionTable', responseBean.ebsBeneficiariesResponse.MBS326O.outputCopybook.instructionTable); //DBOOYSEN 14/04/2021. W-008297
		}

		return dataMap;
	}

	/**
    * @description Extract account number from string with leading zeros
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-12-09
    * @param accountString
    * @return String
    **/
    public static String extractAccountNumber(String accountString){
        String result;
        Integer position = 0;
        String character = '';

        do{
            if(position < accountString.length()){
                character = accountString.substring(position, position + 1);
                if(character != '0'){
                    break;
                }
            }
            position = position + 1;
        }while(position < accountString.length());

        result = accountString.substring(position);
        return result;
    }

	/**
	 * @description getSelectedBranchRecordDetails method to get additional details for selected Branch
	 * @param branchCode
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
	 * @description getBankIdByName method to get additional details for selected Branch
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
	 * @description updateBeneficiary method to update beneficiary data
	 * @param accId
	 * @param instrNo
	 * @param beneficiaryName
	 * @param srcAccNumber
	 * @param srcAccType
	 * @param srcBranchCode
	 * @param trgAccType
	 * @param trgAccNumber
	 * @param trgBranchCodeId
	 * @param srcRef
	 * @param trgRef
	 * @param userRecord
	 * @param tieb
	 * @return String
	 */
	@AuraEnabled
	public static String updateBeneficiary(
		String accId,
		String instrNo,
		String beneficiaryName,
		String srcAccNumber,
		String srcAccType,
		String srcBranchCode,
		String trgAccType,
		String trgAccNumber,
		String trgBranchCodeId,
		String srcRef,
		String trgRef,
		User userRecord,
		String tieb
	) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);

		if (accId != null) {
			//Get CIF No based on Account Id
			String cif = getCIF(accId);

			//TdB - To be removed
			srcBranchCode = '632005';

			//Get Branch Code based on BranchCode Record Id
			String trgBranchCode = '0';
			Set<Id> branchCodeSet = new Set<Id>();
			branchCodeSet.add(trgBranchCodeId);
			List<Lookup__c> lookupList = new LookupsSelector().selectById(branchCodeSet);

			if (lookupList != null && lookupList.size() > 0) {
				trgBranchCode = lookupList[0].Branch_Code__c;
			}

			String siteCode = userRecord.SiteCode__c;
			String teller = userRecord.Teller_Operator_Code__c;

			if (cif != null) {
				//Update Beneficiary Callout
				Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.MBupdateInstructionV1(
					cif,
					instrNo,
					beneficiaryName,
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
					tieb
				);
				// Get first key from the map
				MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];

				MBupdateInstructionV1_Resp_IB_v1.Mbp300o respData = responseBean.MBupdateInstructionV1Response.Mbp300o;

				if (respData != null) {
					//Beneficiary update successfull
					if (respData.respCode == '0') {
						return respData.instrRefName + ' Successfully Updated';
					} else {
						//Beneficiary update failed with error
						ex.setMessage(respData.respDesc);
						throw ex;
					}
				} else {
					//Reponse Bean is empty
					ex.setMessage('There was an error updating the Beneficiary');
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
	 * @description getAccountDetails method to update an IVR beneficiary
	 * @param accId
	 * @param instrNo
	 * @param beneficiaryName
	 * @param srcAccNumber
	 * @param srcAccType
	 * @param trgAccType
	 * @param trgAccNumber
	 * @param trgBranchCodeId
	 * @param srcRef
	 * @param trgRef
	 * @param ivrCustNo
	 * @param tieb
	 * @return String
	 */
	@AuraEnabled
	public static String updateIVRBeneficiary(
		String accId,
		String instrNo,
		String beneficiaryName,
		String srcAccNumber,
		String srcAccType,
		String trgAccType,
		String trgAccNumber,
		String trgBranchCodeId,
		String srcRef,
		String trgRef,
		String ivrCustNo,
		String tieb
	) {
		String cif = getCIF(accId);

		String trgBranchCode = trgBranchCodeId;
		if (trgBranchCodeId.length() > 6) {
			Set<Id> branchCodeSet = new Set<Id>();
			branchCodeSet.add(trgBranchCodeId);
			List<Lookup__c> lookupList = new LookupsSelector().selectById(branchCodeSet);

			if (lookupList != null && lookupList.size() > 0) {
				trgBranchCode = lookupList[0].Branch_Code__c;
			}
		}
		Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.updateIVRbeneficiary(
			beneficiaryName,
			trgAccNumber,
			trgAccType,
			trgBranchCode,
			ivrCustNo,
			cif,
			srcAccNumber,
			tieb,
			instrNo,
			srcAccType,
			srcRef,
			trgRef
		);

		MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}

		if (responseBean?.MBupdateInstructionV1Response?.mbp300o?.respCode != '0') {
			return 'Error: ' + responseBean.MBupdateInstructionV1Response.mbp300o.respDesc;
		}

		MBupdateInstructionV1_Resp_IB_v1.MBupdateInstructionV1Response cls_retrieveTransactionInqWrapper = responseBean.MBupdateInstructionV1Response;
		MBupdateInstructionV1_Resp_IB_v1.Mbp300o Mbp300o = cls_retrieveTransactionInqWrapper.mbp300o;

		return JSON.serialize(Mbp300o);
	}

	/**
	 * @description removeBeneficiary method to delete beneficiary data
	 * @param accId
	 * @param instrNo
	 * @param userRecord
	 * @return String
	 */
	@AuraEnabled
	public static string removeBeneficiary(String accId, String instrNo, User userRecord, String tieb) {
		String errorMsg = 'Exception';
		AuraHandledException ex = new AuraHandledException(errorMsg);

		try {
			if (accId != null) {
				//Get CIF No based on Account Id
				String cif = getCIF(accId);
				String siteCode = userRecord.SiteCode__c;
				String teller = userRecord.Teller_Operator_Code__c;

				// System.debug('teller : ' + teller);
				// System.debug('userRecord : ' + userRecord);

				if (cif != null) {
					//Update Beneficiary Callout
					Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionV2(
						cif,
						instrNo,
						siteCode,
						teller,
						tieb
					);
					// Get first key from the map
					MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];

					MBdeleteInstructionV2_Resp_IB_v1.Mbp306o respData = responseBean.MBdeleteInstructionV2Response.Mbp306o;

					if (respData != null) {
						//Beneficiary removed successfull
						if (respData.respCode == '0') {
							return respData.instrRefName + ' Successfully Removed';
						} else {
							//Beneficiary remove failed with error
							ex.setMessage(respData.respDesc);
							throw ex;
						}
					} else {
						//Reponse Bean is empty
						ex.setMessage('There was an error removing the Beneficiary');
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
	 * @description addBeneficiaryRecord method to get CreateInstruction_Resp_IB_v1 response
	 * @param selectedAccount
	 * @param sourceAccType
	 * @param beneficiaryName
	 * @param accountType
	 * @param branchCodeId
	 * @param accountNumber
	 * @param sourceRef
	 * @param targetRef
	 * @param userRecord
	 * @return String
	 */
	@AuraEnabled
	public static String addBeneficiaryRecord(
		String selectedAccount,
		String sourceAccType,
		String beneficiaryName,
		String accountType,
		String branchCodeId,
		String accountNumber,
		String sourceRef,
		String targetRef,
		User userRecord
	) {
		CreateInstruction_Resp_IB_v1 response;

		try {
			//Get Branch Code based on BrancCode Record Id
			Set<Id> branchCodeSet = new Set<Id>();
			branchCodeSet.add(branchCodeId);
			List<Lookup__c> lookupList = new LookupsSelector().selectById(branchCodeSet);

			String branchCode;
			if (lookupList != null && lookupList.size() > 0) {
				branchCode = lookupList[0].Branch_Code__c;
			}

			response = CreateInstruction_IH_v1.MBcreateInstruction(
				accountType,
				beneficiaryName,
				accountNumber,
				branchCode,
				selectedAccount,
				sourceAccType,
				selectedAccount,
				sourceRef,
				targetRef
			);

			if (response.statusCode != 200) {
				return 'Error: ' + response.message;
			}

			if (response == null) {
				return 'Error: Blank response received from service;';
			}

			if (response.respCode != '0') {
				return 'Error: ' + response.respDesc;
			}
		} catch (Exception e) {
			return 'Error: ' + e.getMessage();
		}

		return JSON.serialize(response);
	}

	/**
	 * @description getCIF method to get CIF detail
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
	 * @author  Danie Booysen
	 * @description Method generates the list of beneficiaries document from ECM for Beneficiary Maintenance
	 * @param beneficiaryListString
	 * @param documentTemplateName
	 * @param accountId
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string getBeneficiaryData(String beneficiaryListString, String documentTemplateName, String accountId) {
		List<MBlistInstPerSourceAccV1_Resp_IB_v1.instructionTable> beneficiaryList = (List<MBlistInstPerSourceAccV1_Resp_IB_v1.instructionTable>) JSON.deserialize(
			beneficiaryListString,
			List<MBlistInstPerSourceAccV1_Resp_IB_v1.instructionTable>.class
		);
		if (beneficiaryList == null && beneficiaryList.size() == 0) {
			return 'Error: No Payments Available to Send Beneficiary Payment History: ' + beneficiaryListString;
		}

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);
		//Add the client's ID number as the password required to open this document
		params.put('password', accountRecord.ID_Number__pc);

		//Map XML content
		//Create and map a BeneficiaryList tag for each payment from the beneficiaryList to represent each beneficiary in the XML template
		String beneficiaryListXML = '';
		for (MBlistInstPerSourceAccV1_Resp_IB_v1.instructionTable beneficiary : beneficiaryList) {
			String beneficiaryItem =
				'<BeneficiaryList>' +
				'<IVRnumber>' +
				beneficiary.ivrNominate +
				'</IVRnumber>' +
				'<BeneficiaryName>' +
				beneficiary.instrRefName +
				'</BeneficiaryName>' +
				'<Reference>' +
				beneficiary.sourceStatementRef +
				'</Reference>' +
				'<Amount>' +
				beneficiary.amount +
				'</Amount>' +
				'<Bank>' +
				beneficiary.targetInstCode +
				'</Bank>' +
				'</BeneficiaryList>';
			//Add each beneficiaryItem to the beneficiaryListXML variable
			beneficiaryListXML += beneficiaryItem;
		}
		//Manually replace the XML placeholder with the value of the beneficiaryList
		documentTemplate.XML__c = documentTemplate.XML__c.replace('{beneficiaryList}', beneficiaryListXML);

		//Generate document
		//contextBuilder sent in as a required param to generateDocument method but not used for this document generation
		CC_GenerateContentResponse generateDocumentResponse = new DocumentTemplateProcessor().generateDocument(contextBuilder, documentTemplate, params);
		if (String.isBlank(generateDocumentResponse?.contentStoreToken)) {
			return 'Error: Document generation using DocumentTemplateProcessor service failed. Response: ' + JSON.serialize(generateDocumentResponse);
		}

		//Retrieve generated document
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, generateDocumentResponse.contentStoreToken);

		if (String.isBlank(getResult?.Content?.data)) {
			return 'Error: Document download using ECM_IH_V1 service failed. Response: ' + JSON.serialize(getResult);
		}
		System.debug('getResult.Content.data: ' + getResult.Content.data);
		return getResult.Content.data;
	}

	/**
	 * @author  Danie Booysen
	 * @description Method sends an email with an attachment
	 * @param caseId
	 * @param emailAddress
	 * @param emailTemplateName
	 * @param pdfData
	 * @param docName
	 * @return String: Email message status
	 */
	@AuraEnabled
	public static string sendBeneficiaryList(String caseId, String emailAddress, String emailTemplateName, String pdfData, String docName) {
		return ProofOfPaymentSelController.sendEmailWithAttach(caseId, emailAddress, emailTemplateName, pdfData, docName);
	}
}