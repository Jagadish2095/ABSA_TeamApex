/**
 * @description Controller used by the ProofOfPaymentSelection lightning components
 *
 * @author  Danie Booysen
 * @version v1.0
 * @since   2021-02-10
 */
public class ProofOfPaymentSelController {
	/**
	 * @author  Danie Booysen
	 * @description Method generates the Proof of Payment documents(s) from ECM
	 * @param MBinitiatePaymentResp
	 * @param uiInputProofOfPayment
	 * @param documentTemplateName
	 * @param accountId
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string generateProofOfPayment(String MBinitiatePaymentResp, String uiInputProofOfPayment, String documentTemplateName, String accountId) {
		UiInputFields UiInputFieldsObj = (UiInputFields) JSON.deserialize(uiInputProofOfPayment, UiInputFields.class);
		MBinitiatePaymentV10_Resp_IB_v1 MBinitiatePaymentV10RespBean = (MBinitiatePaymentV10_Resp_IB_v1) JSON.deserialize(
			MBinitiatePaymentResp,
			MBinitiatePaymentV10_Resp_IB_v1.class
		);
		if (MBinitiatePaymentV10RespBean?.MBinitiatePaymentV10Response?.nbsmsgo3?.nbrUserErrs != '0') {
			return 'Error: getting response from MBinitiatePaymentV10 service. Error Message: ' +
				MBinitiatePaymentV10RespBean?.MBinitiatePaymentV10Response?.nbsmsgo3?.msgEntry?.msgTxt;
		}

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

		//Format Date and Time values to the structure accepted by ECM
		String initiatePaymentDate = MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.todaysDate;
		String transactionDate = initiatePaymentDate.left(4) + '-' + initiatePaymentDate.mid(4, 2) + '-' + initiatePaymentDate.right(2);
		String initatePaymentTime = MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.timeNow;
		initatePaymentTime = initatePaymentTime.length() < 8 ? initatePaymentTime.leftPad(8, '0') : initatePaymentTime;
		String transactionTime = initatePaymentTime.left(2) + ':' + initatePaymentTime.mid(2, 2) + ':' + initatePaymentTime.mid(4, 2);
		//Map to XML document template
		if (documentTemplateName == System.Label.Proof_of_Payment_Beneficiary) {
			contextBuilder.add('RecipientName', UiInputFieldsObj.RecipientName);
			contextBuilder.add('AccountMobile', accountRecord.PersonMobilePhone);
		}
		contextBuilder.add('AccountName', accountRecord.Name);
		contextBuilder.add('YourReferenceName', UiInputFieldsObj.YourReference);
		contextBuilder.add('uniqueEft', MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.uniqueEft);
		contextBuilder.add('todaysDate', transactionDate);
		contextBuilder.add('timeNow', transactionTime);
		contextBuilder.add('trgInstCode', MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.trgInstCode);
		contextBuilder.add('trgAcc', MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.trgAcc.replaceFirst('^0+', ''));
		contextBuilder.add('Amount', UiInputFieldsObj.Amount);
		contextBuilder.add('ImmediatePayment', UiInputFieldsObj.ImmediatePayment);
		contextBuilder.add('RecipientReference', UiInputFieldsObj.RecipientRef);
		contextBuilder.add('trgClrCode', MBinitiatePaymentV10RespBean.MBinitiatePaymentV10Response.mbn301o.trgClrCode);

		//Generate document
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

		return getResult.Content.data;
	}

	/**
	 * @author  Danie Booysen
	 * @description Method generates the Proof of Payment documents(s) from ECM for Historical Proof of Payment for a Once Off Payment
	 * @param selectedPaymentString
	 * @param documentTemplateName
	 * @param accountId
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string generateHistoricalOOP(String selectedPaymentString, String documentTemplateName, String accountId) {
		MBlistInstPerSourceAccV1_Resp_IB_v1.InstructionTable selectedPaymentObj = (MBlistInstPerSourceAccV1_Resp_IB_v1.InstructionTable) JSON.deserialize(
			selectedPaymentString,
			MBlistInstPerSourceAccV1_Resp_IB_v1.InstructionTable.class
		);
		if (selectedPaymentObj == null) {
			return 'Error: No Once Off Payment Selected: ' + selectedPaymentString;
		}

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

		//Format Date and Time values to the structure accepted by ECM
		String initiatePaymentDate = selectedPaymentObj.actDate;
		String transactionDate = initiatePaymentDate.left(4) + '-' + initiatePaymentDate.mid(4, 2) + '-' + initiatePaymentDate.right(2);
		String transactionTime = '12:00:00';//Time defaulted for once off payments because paymentTime is not returned for historical once off payments
		//Map to XML document template
		if (documentTemplateName == System.Label.Proof_of_Payment_Beneficiary) {
			contextBuilder.add('RecipientName', selectedPaymentObj.instrRefName != null ? selectedPaymentObj.instrRefName : '');
			contextBuilder.add('AccountMobile', accountRecord.PersonMobilePhone);
		}
		contextBuilder.add('AccountName', accountRecord.Name);
		contextBuilder.add('YourReferenceName', selectedPaymentObj.sourceStatementRef);
		contextBuilder.add('uniqueEft', selectedPaymentObj.uniqueEFT);
		contextBuilder.add('todaysDate', transactionDate);
		contextBuilder.add('timeNow', transactionTime);
		contextBuilder.add('trgInstCode', selectedPaymentObj.targetInstCode);
		contextBuilder.add('trgAcc', selectedPaymentObj.targetAccount.replaceFirst('^0+', ''));
		contextBuilder.add('Amount', selectedPaymentObj.amount);
		contextBuilder.add('ImmediatePayment', selectedPaymentObj.iipAllowIndicator);
		contextBuilder.add('RecipientReference', selectedPaymentObj.targetStatementRef);
		contextBuilder.add('trgClrCode', selectedPaymentObj.targetClrCode);

		//Generate document
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

		return getResult.Content.data;
	}

	/**
	 * @author  Danie Booysen
	 * @description Method generates the Proof of Payment documents(s) from ECM for Historical Proof of Payment of a Beneficiary
	 * @param selectedPaymentString
	 * @param recipientName
	 * @param uniqueEft
	 * @param documentTemplateName
	 * @param accountId
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string generateHistoricalBenPayment(String selectedPaymentString, String recipientName, String uniqueEft, String documentTemplateName, String accountId) {
		MBgetPaymentDetailV3_Resp_IB_v1.Payment selectedPaymentObj = (MBgetPaymentDetailV3_Resp_IB_v1.Payment) JSON.deserialize(
			selectedPaymentString,
			MBgetPaymentDetailV3_Resp_IB_v1.Payment.class
		);
		if (selectedPaymentObj == null) {
			return 'Error: No Beneficiary Payment Selected: ' + selectedPaymentString;
		}

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);

		//Format Date and Time values to the structure accepted by ECM
		String initiatePaymentDate = selectedPaymentObj.actDate;
		String transactionDate = initiatePaymentDate.left(4) + '-' + initiatePaymentDate.mid(4, 2) + '-' + initiatePaymentDate.right(2);
		String initatePaymentTime = selectedPaymentObj.paymTime;
		initatePaymentTime = initatePaymentTime.length() < 8 ? initatePaymentTime.leftPad(8, '0') : initatePaymentTime;
		String transactionTime = initatePaymentTime.left(2) + ':' + initatePaymentTime.mid(2, 2) + ':' + initatePaymentTime.mid(4, 2);
		//Map to XML document template
		if (documentTemplateName == System.Label.Proof_of_Payment_Beneficiary) {
			contextBuilder.add('RecipientName', recipientName);//passed in from cmp separately, not part of selectedPaymentObj
			contextBuilder.add('AccountMobile', accountRecord.PersonMobilePhone);
		}
		contextBuilder.add('AccountName', accountRecord.Name);
		contextBuilder.add('YourReferenceName', selectedPaymentObj.srcStmtRef);
		contextBuilder.add('uniqueEft', uniqueEft);//passed in from cmp separately, not part of selectedPaymentObj
		contextBuilder.add('todaysDate', transactionDate);
		contextBuilder.add('timeNow', transactionTime);
		contextBuilder.add('trgInstCode', selectedPaymentObj.trgInstCode);
		contextBuilder.add('trgAcc', selectedPaymentObj.trgAcc.replaceFirst('^0+', ''));
		contextBuilder.add('Amount', selectedPaymentObj.amount);
		contextBuilder.add('ImmediatePayment', selectedPaymentObj.iipInd);
		contextBuilder.add('RecipientReference', selectedPaymentObj.trgStmtRef);
		contextBuilder.add('trgClrCode', selectedPaymentObj.trgClrCode);

		//Generate document
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
	public static String sendEmailWithAttach(String caseId, String emailAddress, String emailTemplateName, String pdfData, String docName) {
		OrgWideEmailAddress orgWideAddress = CloseCase.getOrgWideEmailAddress(caseId, null);
		if (orgWideAddress != null) {
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress, emailTemplateName);

			if (constructEmail != null && constructEmail.size() > 0) {
				Messaging.SingleEmailMessage email = constructEmail[0];
				string[] toAddress = new List<string>{ emailAddress };
				String emailBody = email.getHtmlBody();
				String subject = email.getSubject();

				Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
				emailMessage.setOrgWideEmailAddressId(orgWideAddress.Id);
				emailMessage.setToAddresses(toAddress);
				emailMessage.setSubject(subject);
				emailMessage.setHtmlBody(emailBody);
				emailMessage.saveAsActivity = false;

				//Add attachment
				List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
				Messaging.EmailFileAttachment emailFileAttach = new Messaging.EmailFileAttachment();
				emailFileAttach.setFileName(docName + '.pdf');
				emailFileAttach.setBody(EncodingUtil.base64Decode(pdfData));
				fileAttachments.add(emailFileAttach);
				emailMessage.setFileAttachments(fileAttachments);

				//Send Email
				Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });

				//Attach Email to Case
				EmailMessage emailMsg = new EmailMessage();
				emailMsg.FromAddress = orgWideAddress.Address;
				emailMsg.Subject = subject;
				emailMsg.HtmlBody = emailBody;
				emailMsg.ParentId = caseId;
				insert emailMsg;

				return 'Email sent Successfully';
			} else {
				//Error - unable to construct Email
				return 'Error: Unable to construct email. EmailHandler.ComposeEmail(' +
					caseId +
					' ' +
					targetObjectId +
					' ' +
					emailAddress +
					' ' +
					emailTemplateName +
					')';
			}
		} else {
			//Error - No OrgWideEmailAddress found
			return 'Error: Unable to find a matching Org Wide Email Address from the Email Address specified on the Service_Group__c of this Case. ';
		}
	}

	/**
	 * @description Custom type for UI Input fields passed from the Payment Request component
	 */
	public class UiInputFields {
		public String YourReference;
		public Decimal Amount;
		public Boolean ImmediatePayment;
		public String RecipientRef;
		public String RecipientName;
	}
}