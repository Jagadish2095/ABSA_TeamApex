/*** * @description Lightning Component Controller For Notify Banker Controller Class
 * @author  Muvhuso Nekhubvi : Absa
 * @version v1.0
 * @date   2020-06-22
 * @updated koketso Mpshane 2021-04-08
 * @updated Nagpalsing Girase 2021-07-09
 */
public class NotifyBankerController {
	/**
	 * @description getBankerName
	 * @param accountId
	 * @return String
	 */
	@AuraEnabled
	public static String getBankerName(String accountId) {
		if (String.isNotEmpty(accountId)) {
			return CustomerPortfolioController.getControlOfficers(accountId);
		}

		return null;
	}
	/**
	 * @description noEmail
	 * @param caseRecordId
	 */
	@AuraEnabled
	public static void noEmail(Id caseRecordId) {
		try {
			if (caseRecordId != null) {
				Case caseObj = new Case(Id = caseRecordId);
				caseObj.Status = 'Closed';
				update caseObj;
			}
		} catch (DmlException ex) {
			throw ex;
		}
	}
	/**
	 * @description updateCase
	 * @param caseRecordId
	 * @param productInterest
	 * @param notes
	 * @param notifyBanker
	 */
	@AuraEnabled
	public static void updateCase(Id caseRecordId, String productInterest, String notes, boolean notifyBanker) {
		try {
			if (caseRecordId != null) {
				Case caseObj = new Case(Id = caseRecordId);
				if (notifyBanker) {
					caseObj.Product_Interest__c = productInterest;
					caseObj.Interest_Details__c = notes;
				} else {
					caseObj.Product_Interest__c = productInterest;
					caseObj.Interest_Details__c = notes;
					caseObj.Status = 'Closed';
				}
				update caseObj;
			}
		} catch (DmlException ex) {
			throw ex;
		}
	}
	/**
	 * @description sendEmail
	 * @param emailAddress
	 * @param caseRecordId
	 * @param name
	 * @param templateName
	 * @param bankerEmail
	 * @param balance
	 * @param accountNumber
	 * @param flowplstCardNumbers
	 * @param jsonResponseString
	 * @param templateAttrVal
	 * @param emailBodyMapping
	 * @param taxPeriod
	 * @return String
	 */
	@AuraEnabled
	public static String sendEmail(
		String emailAddress,
		Id caseRecordId,
		String name,
		String templateName,
		String bankerEmail,
		String balance,
		String accountNumber,
		String flowplstCardNumbers,
		String jsonResponseString,
		String templateAttrVal,
		Map<String, String> emailBodyMapping,
		String taxPeriod
	) {
		String returnString = 'success';
		try {
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it

			if (emailBodyMapping != null) {
				sendEmailWithMappedValues(caseRecordId, targetObjectId, emailAddress, templateName, emailBodyMapping);
			} else if (templateName == 'Account_Balance_Enquiry') {
				sendBalanceEnquiryEmail(caseRecordId, targetObjectId, emailAddress, templateName, balance, accountNumber);
			} else if (templateName == 'StopCards') {
				return SendEmailForPaymentReq.sendEmailOnCaseClose(caseRecordId, emailAddress, templateName);
			} else if (templateName == 'StopReplaceCreditCard') {
				StopAndReplaceCreditCardController.sendEmailNotifications(caseRecordId, emailAddress, '', 'Email', flowplstCardNumbers);
				return returnString;
			} else if (templateName == 'Notify_Banker') {
				sendBankerEmail(caseRecordId, targetObjectId, bankerEmail, name, templateName);
			} else if (templateName == 'MinimumPaymentDue') {
				sendMinimumDueEmail(caseRecordId, targetObjectId, emailAddress, templateName, balance, accountNumber);
			} else if (templateName == 'Policy_Beneficiary_Maintenance') {
				sendPolicyBeneficiaryMaintenanceEmail(caseRecordId, targetObjectId, emailAddress, templateName, accountNumber);
			} else if (
				templateName == 'ABSAOnlineStatements' ||
				templateName == 'RateChangeLetter' ||
				templateName == 'Home_Loans_Tax_Certificate' ||
				templateName == 'Ford_Monthly_Statement_Template' ||
				templateName == 'AVAF_Monthly_Statement_Template'
			) {
				sendStatementEmail(caseRecordId, targetObjectId, emailAddress, templateName, accountNumber, jsonResponseString, templateAttrVal, taxPeriod);
			} else if (templateName == 'Signitaries') {
				getDocumentContentSendEmail(caseRecordId, targetObjectId, emailAddress, templateName);
			} else if (templateName == 'AccountConfirmation') {
				getDocumentContentSendEmail(caseRecordId, targetObjectId, emailAddress, templateName);
			} else if (templateName == 'Request_to_Cancel_Bond_Email') {
				sendBondCancellationEmail(caseRecordId, targetObjectId, emailAddress, templateName);
			} else {
				sendGenericEmail(caseRecordId, targetObjectId, emailAddress, templateName);
			}
		} catch (exception ex) {
			returnString = '' + ex.getMessage();
			throw ex;
		}

		try {
			if (caseRecordId != null && templateName != 'Notify_Banker') {
				Case caseObj = new Case(Id = caseRecordId);
				caseObj.Email__c = emailAddress;
				caseObj.Status = 'Closed';
				update caseObj;
			}
		} catch (DmlException ex) {
			throw ex;
		}

		return returnString;
	}
	/**
	 * @description sendGenericEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 */
	public static void sendGenericEmail(String caseRecordId, String contactId, String emailAddress, String templateName) {
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };
		String emailBody = email.getHtmlBody();

		String subject = email.getSubject();
		emailMessage.setOrgWideEmailAddressId(owea.get(0).Id);
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setHtmlBody(emailBody);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description sendBalanceEnquiryEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 * @param balance
	 * @param accountNumber
	 */
	public static void sendBalanceEnquiryEmail(
		String caseRecordId,
		String contactId,
		String emailAddress,
		String templateName,
		String balance,
		String accountNumber
	) {
		//templateName = 'Account_Balance_Enquiry';
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };
		String htmlBody = email.getHtmlBody();
		htmlBody = htmlBody.replace('[accountNumber]', accountNumber).replace('[balanceDetails]', balance);
		String subject = email.getSubject();
		//String emailBody = email.getHtmlBody();
		emailMessage.setOrgWideEmailAddressId(owea.get(0).Id);
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setHtmlBody(htmlBody);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description sendBankerEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param name
	 * @param templateName
	 */
	public static void sendBankerEmail(String caseRecordId, String contactId, String emailAddress, String name, String templateName) {
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		String htmlBody = email.getHTMLBody();
		htmlBody = htmlBody.replace('[bankerName]', name);
		email.setHtmlBody(htmlBody);
		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };
		String emailBody = email.getHtmlBody();
		email.setOrgWideEmailAddressId(owea.get(0).Id);
		email.setToAddresses(to);
		email.setSubject('Relationship Banker Details');
		email.setHtmlBody(htmlBody);
		email.setSaveAsActivity(true);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description sendMinimumDueEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 * @param balance
	 * @param accountNumber
	 */
	public static void sendMinimumDueEmail(
		String caseRecordId,
		String contactId,
		String emailAddress,
		String templateName,
		String balance,
		String accountNumber
	) {
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };
		String htmlBody = email.getHtmlBody();
		htmlBody = htmlBody.replace('[accountNumber]', accountNumber).replace('[AmountDue]', balance);
		String subject = email.getSubject();

		email.setOrgWideEmailAddressId(owea.get(0).Id);
		email.setToAddresses(to);
		email.setSubject(subject);
		email.setHtmlBody(htmlBody);
		email.setSaveAsActivity(true);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description sendStatementEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 * @param accountNumber
	 * @param jsonString
	 * @param idRegistrationNumber
	 * @param taxPeriod
	 */
	public static void sendStatementEmail(
		String caseRecordId,
		String contactId,
		String emailAddress,
		String templateName,
		String accountNumber,
		String jsonString,
		String idRegistrationNumber,
		String taxPeriod
	) {
		accountNumber = accountNumber != '' ? '*********' + accountNumber.substring(accountNumber.length() - 4, accountNumber.length()) : '';
		idRegistrationNumber = idRegistrationNumber != ''
			? '*********' + idRegistrationNumber.substring(idRegistrationNumber.length() - 4, idRegistrationNumber.length())
			: '';
		taxPeriod = taxPeriod == null ? '' : taxPeriod;
		List<Attachment> attachmentList = getStatementToDownload(jsonString);
		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);
		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

		string[] to = new List<string>{ emailAddress };
		String htmlBody = email.getHtmlBody();
		//Added by chandra dated 29/01/2021 to pass values in email template
		htmlBody = htmlBody.replace('[accountNumber]', accountNumber)
			.replace('[idRegistrationNumber]', idRegistrationNumber)
			.replace('[taxYear]', String.valueof(taxPeriod));
		String subject = email.getSubject();
		emailMessage.setOrgWideEmailAddressId(getOrgWideEmailAddressId(caseRecordId));
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setHtmlBody(htmlBody);

		List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();

		for (Attachment attach : attachmentList) {
			Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
			efa.setFileName(attach.Name); //iterate and add all attachments here this is for Poc
			efa.setBody(attach.Body);
			fileAttachments.add(efa);
		}

		emailMessage.setFileAttachments(fileAttachments);
		emailMessage.setSaveAsActivity(true);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description getStatementToDownload
	 * @param jsonString
	 * @return List<Attachment>
	 */
	public static List<Attachment> getStatementToDownload(String jsonString) {
		List<ABSAOnlineStatementDownload_Resp_IB_v1> repponseWrapperList = (List<ABSAOnlineStatementDownload_Resp_IB_v1>) JSON.deserialize(
			jsonString,
			List<ABSAOnlineStatementDownload_Resp_IB_v1>.class
		);

		List<Attachment> attachmentList = new List<Attachment>();
		for (ABSAOnlineStatementDownload_Resp_IB_v1 response : repponseWrapperList) {
			Attachment attach = new Attachment();
			attach.contentType = 'application/pdf';
			attach.name = response.timestamp + '.pdf';
			if (!Test.isRunningTest())
				attach.body = EncodingUtil.base64Decode(response.doc);
			else
				attach.body = blob.valueOf('this is for test');
			attachmentList.add(attach);
		}

		return attachmentList;
	}
	/**
	 * @description emailActivities
	 * @param emailObject
	 * @param caseRecordId
	 */
	public static void emailActivities(Messaging.SingleEmailMessage emailObject, String caseRecordId) {
		try {
			EmailMessage email = new EmailMessage();
			email.FromAddress = getServiceGroupResponseEmail(caseRecordId);
			email.Subject = emailObject.getSubject();
			email.HtmlBody = emailObject.getHtmlBody();
			email.ParentId = caseRecordId;
			email.ToAddress = String.join(emailObject.getToAddresses(), ',');
			insert email;
		} catch (DmlException ex) {
			throw ex;
		}
	}
	/**
	 * @author Muvhuso
	 * @description Method that downloads  a document and send it to a client
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 */
	public static void getDocumentContentSendEmail(Id caseRecordId, String contactId, String emailAddress, String templateName) {
		Document__c doc;
		ECM_GetResult_IB_V1 getResult;
		if (!Test.isRunningTest()) {
			String token = ECMLogin();
			doc = new DocumentsSelector().selectByCaseId(caseRecordId);
			getResult = ECM_IH_V1.getDocument(token, doc.Reference__c);
		}
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);
		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

		string[] to = new List<string>{ emailAddress };
		String htmlBody = email.getHtmlBody();
		String subject = email.getSubject();
		emailMessage.setOrgWideEmailAddressId(owea.get(0).Id);
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setHtmlBody(htmlBody);

		Blob faqBlob;
		List<Messaging.Emailfileattachment> fileAttachments;
		Messaging.Emailfileattachment efa;
		if (!Test.isRunningTest()) {
			List<String> attName = doc.Reference__c.split(' ');

			Attachment attach = new Attachment();

			attach.contentType = 'application/pdf';
			attach.name = attName[7] + '.pdf';

			fileAttachments = new List<Messaging.Emailfileattachment>();
			efa = new Messaging.Emailfileattachment();
			efa.setFileName(attach.Name);

			faqBlob = EncodingUtil.base64Decode(getResult.Content.data);

			efa.setBody(faqBlob);

			fileAttachments.add(efa);

			emailMessage.setFileAttachments(fileAttachments);
		} else {
			faqBlob = blob.valueOf('Test Result Body');
		}

		emailMessage.setSaveAsActivity(true);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @description ECMLogin
	 * @return String
	 */
	public static String ECMLogin() {
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login.Token;
	}
	/**
	 * @author Chandra
	 * @description sendPolicyBeneficiaryMaintenanceEmail
	 * @param caseRecordId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 * @param accountNumber
	 */
	public static void sendPolicyBeneficiaryMaintenanceEmail(
		String caseRecordId,
		String contactId,
		String emailAddress,
		String templateName,
		String accountNumber
	) {
		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };
		String htmlBody = email.getHtmlBody();
		htmlBody = htmlBody.replace('[PolicyNo]', accountNumber);
		String subject = email.getSubject();
		emailMessage.setOrgWideEmailAddressId(getOrgWideEmailAddressId(caseRecordId));
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setHtmlBody(htmlBody);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
	/**
	 * @author Srikanth N: 20201027
	 * @description getOrgWideEmailAddressId
	 * @param caseId
	 * @return Id
	 */
	public static Id getOrgWideEmailAddressId(String caseId) {
		String emailAddress = getServiceGroupResponseEmail(caseId);
		List<OrgWideEmailAddress> oweaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :emailAddress LIMIT 1];
		if (oweaList?.size() > 0) {
			return oweaList[0].Id;
		}

		return null;
	}
	/**
	 * @author Srikanth N: 20201027
	 * @description getServiceGroupResponseEmail
	 * @param caseId
	 * @return String
	 */
	public static String getServiceGroupResponseEmail(String caseId) {
		List<Case> caseList = [SELECT Id, sd_Service_Group_Id__c FROM Case WHERE Id = :caseId LIMIT 1];
		if (caseList?.size() > 0) {
			List<Service_Group__c> serviceGroupList = [
				SELECT Id, Response_Email_Address__c
				FROM Service_Group__c
				WHERE Id = :caseList[0].sd_Service_Group_Id__c
			];
			if (serviceGroupList?.size() > 0) {
				return serviceGroupList[0].Response_Email_Address__c;
			}
		}

		return null;
	}
	/**
	 * @author Koketso Mpshane
	 * @description notify customer by sms
	 * @param caseId
	 * @param phoneNumber
	 * @param messageText
	 * @param serviceAccount integration service account
	 * @return String
	 */
	@AuraEnabled
	public static String notifyClientBySMS(String caseId, String phoneNumber, String messageText, String serviceAccount) {
		SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit(phoneNumber, messageText, serviceAccount);

		if (responseBean == null) {
			return 'Error: Blank response received from service;';
		}

		if (responseBean.statusCode != 200) {
			return 'Error: ' + responseBean.message;
		}

		if (caseId != null) {
			Case caseRecord = new Case(Id = caseId);
			caseRecord.Status = 'Closed';
			update caseRecord;
		}

		return JSON.serialize(responseBean);
	}

	/**
	 * @description sendBondCancellationEmail
	 * @param caseId
	 * @param targetObjectId
	 * @param emailAddress
	 * @param templateName
	 */
	public static void sendBondCancellationEmail(Id caseId, Id targetObjectId, String emailAddress, String templateName) {
		Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :templateName].Id;
		Case caseRec = [SELECT Id, Account.PersonContactId FROM Case WHERE Id = :caseId];
		Messaging.SingleEmailMessage emailMessage = new messaging.SingleEmailMessage();
		emailMessage.setTemplateId(templateId);
		emailMessage.setTargetObjectId(targetObjectId);
		emailMessage.setWhatId(caseId);
		emailMessage.setToAddresses(new List<String>{ emailAddress });
		emailMessage.setOrgWideEmailAddressId(getOrgWideEmailAddressId(caseId));
		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseId);
		} catch (exception e) {
			throw e;
		}
	}

	/**
	 * @description Send Email With Mapped Values - Koketso Mpshane 25062021
	 * @param caseRecordId
	 * @param targetObjectId
	 * @param emailAddress
	 * @param templateName
	 * @param emailBodyMapping
	 */
	@AuraEnabled
	public static void sendEmailWithMappedValues(
		Id caseRecordId,
		Id targetObjectId,
		String emailAddress,
		String templateName,
		Map<String, String> emailBodyMapping
	) {
		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, targetObjectId, emailAddress, templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		string[] to = new List<string>{ emailAddress };

		String subject = email.getSubject();
		emailMessage.setToAddresses(to);
		emailMessage.setSubject(subject);
		emailMessage.setOrgWideEmailAddressId(getOrgWideEmailAddressId(caseRecordId));

		String emailBody = email.getHtmlBody();

		for (String bodyString : emailBodyMapping.keySet()) {
			emailBody = emailBody.replace(bodyString, emailBodyMapping.get(bodyString));
		}

		emailMessage.setHtmlBody(emailBody);

		try {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });
			emailActivities(emailMessage, caseRecordId);
		} catch (exception e) {
			throw e;
		}
	}
}