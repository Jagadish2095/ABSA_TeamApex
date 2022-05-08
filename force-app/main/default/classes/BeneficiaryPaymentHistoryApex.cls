/**
 * @description Controller used by the BeneficiaryPaymentHistory lightning components
 *
 * @author  Danie Booysen
 * @version v1.0
 * @since   2021-03-25
 */
public class BeneficiaryPaymentHistoryApex {
	/**
	 *@description Method that gets the historical payments made to a selected beneficiary
	 *
	 * @param uniqueEft - the unique reference number of the selected beneficiary
	 * @return MBgetPaymentDetailV3_Resp_IB_v1 - the full response from the service
	 */
	@AuraEnabled
	public static MBgetPaymentDetailV3_Resp_IB_v1 BeneficiaryTransactionHistory(String uniqueEft) {
		return MBgetPaymentDetailV3_IH_v1.MBgetPaymentDetailV3(uniqueEft);
	}

	/**
	 * @author  Danie Booysen
	 * @description Method generates a full Proof of Payment document from ECM for Historical Proof of Payments of a Beneficiary
	 * @param beneficiaryPaymentList
	 * @param beneficiaryName
	 * @param beneficiaryAcc
	 * @param documentTemplateName
	 * @param accountId
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string getBenPaymentHistoryData(
		String beneficiaryPaymentList,
		String beneficiaryName,
		String beneficiaryAcc,
		String documentTemplateName,
		String accountId
	) {
		List<MBgetPaymentDetailV3_Resp_IB_v1.Payment> benPaymentList = (List<MBgetPaymentDetailV3_Resp_IB_v1.Payment>) JSON.deserialize(
			beneficiaryPaymentList,
			List<MBgetPaymentDetailV3_Resp_IB_v1.Payment>.class
		);
		if (benPaymentList == null && benPaymentList.size() == 0) {
			return 'Error: No Payments Available to Send Beneficiary Payment History: ' + beneficiaryPaymentList;
		}

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);
		//Add the client's ID number as the password required to open this document
		params.put('password', accountRecord.ID_Number__pc);

		//Map XML content
		contextBuilder.add('instrRefName', beneficiaryName);
		contextBuilder.add('trgAcc', beneficiaryAcc);
		contextBuilder.add('trgStmtRef', benPaymentList[0].trgStmtRef); //get the 1st(latest) payment from the list to display this data for
		contextBuilder.add('srcStmtRef', benPaymentList[0].srcStmtRef); //get the 1st(latest) payment from the list to display this data for
		String beneficiaryPaymentListXML = '';
		//Create and map a DebitInfo tag for each payment from the benPaymentList to represent each payment in the XML template
		for (MBgetPaymentDetailV3_Resp_IB_v1.Payment payment : benPaymentList) {
			String paymentTime = payment.paymTime;
			paymentTime = paymentTime.length() < 8 ? paymentTime.leftPad(8, '0') : paymentTime;
			paymentTime = paymentTime.left(2) + ':' + paymentTime.mid(2, 2) + ':' + paymentTime.mid(4, 2);
			String beneficiaryItem =
				'<DebitInfo>' +
				'<Date>' +
				payment.actDate +
				'</Date>' +
				'<Time>' +
				paymentTime +
				'</Time>' +
				'<DebitAccount>' +
				payment.srcAcc.replaceFirst('^0+', '') +
				'</DebitAccount>' +
				'<Amount>' +
				payment.amount +
				'</Amount>' +
				'<ImmediateInterbankPayment>' +
				payment.iipInd +
				'</ImmediateInterbankPayment>' +
				'</DebitInfo>';
			//Add each beneficiaryItem to the beneficiaryPaymentListXML variable
			beneficiaryPaymentListXML += beneficiaryItem;
		}
		//Manually replace the XML placeholder with the value of the beneficiaryPaymentList
		documentTemplate.XML__c = documentTemplate.XML__c.replace('{beneficiaryPaymentList}', beneficiaryPaymentListXML);

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
	public static string sendBeneficiaryPayments(String caseId, String emailAddress, String emailTemplateName, String pdfData, String docName) {
		return ProofOfPaymentSelController.sendEmailWithAttach(caseId, emailAddress, emailTemplateName, pdfData, docName);
	}
}