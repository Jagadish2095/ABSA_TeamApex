/**
 * @description Class is created to send Not contactable sms and email to client.
 * CLient Review & Client Maturity
 * */
public class NewCaseCommunicationHandler {
	/**
	 * @description sendNoConnectSms will invoked by proess to sent no connect sms and email to client.
	 * @param CasesId - list of case ids.
	 * */
	@InvocableMethod
	public static void sendEmailSms(List<Id> CasesId) {
		handleEmailNotifications(CasesId);
		for (Id caseId : CasesId) {
			dispatchSMS(caseId);
		}
	}

	/**
	 * @description  dispatchSMS method is created to get and build SMS Body
	 * @param caseRecordID   current case id to send sms
	 **/
	@Future(Callout=true)
	public static void dispatchSMS(Id caseRecordID) {
		Set<String> idSet = new Set<String>();
		idSet.add(caseRecordID);
		List<Case> caseObjs = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		for (Case caseObj : caseObjs) {
			//String whoId=leadRecordID;
			String WhatId = caseRecordID;
			String quickTextName = 'VA_MVP3_InitialContactSMS';
			String IntegrationService = 'iTouch SMS Submit - VA';
			Boolean saveAsActivity = true;
			String recipientNameOverride = caseObj.Customer_Full_Name__c;
			String phoneNumberOverride = caseObj.Mobile__c;
			if (!Test.isRunningTest()) {
				String val = sendSMS(whatId, phoneNumberOverride, recipientNameOverride, quickTextName, IntegrationService, saveAsActivity);
				//system.debug('send sms return test uniq'+val);
			}
		}
	}

	/**
	 * @description  sendSMS method is created to call I-Tuch And send SMS
	 * @param whatId  related to id of case
	 * @param phoneNumberOverride    recipient phone number
	 * @param recipientNameOverride   recipient name of client
	 * @param quickTextName  quicktext massage of lead
	 * @param integrationService  integration service for sms
	 * @param saveAsActivity  Save as activity once sms is send
	 * @return string
	 **/
	public static string sendSMS(
		Id whatId,
		String phoneNumberOverride,
		String recipientNameOverride,
		String quickTextName,
		String integrationService,
		boolean saveAsActivity
	) {
		String reference = '';
		String phoneNumber = phoneNumberOverride.split('-')[0];
		if (phoneNumber.length() == 9) {
			phoneNumber = '+27' + phoneNumber;
		} else {
			phoneNumber = '+27' + phoneNumber;
		}
		//system.debug('phoneNumber---->'+phoneNumber);
		String recipientName = recipientNameOverride;
		//system.debug('recipientName---->'+recipientName);
		//system.debug('phoneNumberOverride--->'+phoneNumberOverride);

		//Verify User's mobile number format is compatible with iTouch format. Salesforce User's mobile number format is '+27 0600000000'
		if (phoneNumber.substring(0, 4) == '+27 ') {
			phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
		}

		//'+270600000000' format is not supported by iTouch, so remove 0
		if (phoneNumber.substring(0, 4) == '+270') {
			phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(4, 13);
		}
		//system.debug('quickTextName---->'+quickTextName);
		//Get plain text SMS body
		//String mergedBody = getPlainTextSMSBody(whoId, whatId, quickTextName,recipientName);
		String quickTextMessage = [SELECT Message FROM QuickText WHERE Name = :quickTextName].Message;
		quickTextMessage = quickTextMessage.replace('#', recipientName);
		//Send sms
		Integer statusCode;
		if (!Test.isRunningTest()) {
			SMSGateway_Resp_IB_v1 bean = dispatchSMS(phoneNumber, quickTextMessage, integrationService);
			statusCode = bean.statusCode;
			if (bean.statusCode == 200) {
				reference = bean.MessageReference;
			}
		} else {
			statusCode = 200;
		}
		//Create SMS task. Only Contact (003) and Lead (00Q) can be whoId for a Task
		if (saveAsActivity && statusCode == 200) {
			Id taskWhoId = null;

			createTask(recipientName, phoneNumber, taskWhoId, whatId, UserInfo.getUserId(), quickTextMessage, reference);
		}

		return reference;
	}

	/**
	 * @description  dispatchSMS method is created to call I-Tuch ,send SMS and read responce
	 * @param phoneNumber   phone number of client
	 * @param messageText   quick text message for sms
	 * @param integrationService   service for sms
	 * @return responce
	 **/
	public static SMSGateway_Resp_IB_v1 dispatchSMS(String phoneNumber, String messageText, String integrationService) {
		SMSGateway_Resp_IB_v1 bean = SMSGateway_IH_v1.submit(phoneNumber, messageText, integrationService);
		return bean;
	}

	/**
	 * @description  createTask method is created to create task once sms is sent
	 * @param recipientName name of client
	 * @param phoneNumber  phone number of client
	 * @param taskWhoId   name id of lead
	 * @param whatId    related to id of lead
	 * @param ownerId   owner of lead
	 * @param messageText   massage of sms
	 * @param messageReference   massage reference
	 */
	@TestVisible
	private static void createTask(String recipientName, String phoneNumber, Id taskWhoId, Id whatId, Id ownerId, String messageText, String messageReference) {
		Task tsk = new Task();
		tsk.Subject = recipientName + ' ' + phoneNumber;
		tsk.Message_Reference__c = messageReference;
		tsk.WhatId = whatId;
		if (taskWhoId != null) {
			tsk.WhoId = taskWhoId;
		}
		tsk.OwnerId = ownerId;
		tsk.ActivityDate = date.today();
		tsk.Description = messageText;
		tsk.status = 'Completed';
		tsk.RecordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
		try {
			insert tsk;
		} catch (DmlException e) {
			//System.debug('An unexpected error has occurred: ' + e.getMessage());
			String msg = e.getMessage();
		}
	}

	/**
	 * @description  handleEmailNotifications method is created to sent no connect email to client.
	 * @param CasesId name of cliet
	 */
	public static void handleEmailNotifications(List<Id> CasesId) {
		try {
			List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
			String defaulttargetObjectId = null;
			if (mdt.size() > 0) {
				defaulttargetObjectId = mdt[0].Value__c;
			}
			Set<Id> casesIdSet = new Set<Id>();
			casesIdSet.addAll(CasesId);
			List<Case> cases = new CasesSelector().selectById(casesIdSet);
			List<EmailTemplate> emailTemps = [
				SELECT Id, DeveloperName
				FROM EmailTemplate
				WHERE DeveloperName = 'Client_Review_Notify_Customer_on_Case_Creation'
			];
			List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
			OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :System.Label.VAFromEmailAddress];
			for (Case data : cases) {
				//System.debug('Name'+ data.Customer_Full_Name__c +'Email'+ data.Email__c);
				if (string.isNotEmpty(data.Customer_Full_Name__c) && string.isNotEmpty(data.Email__c)) {
					String emailTemplateName = '';
					Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
					string replyToMail = system.Label.ReplyToEmail;
					if (emailTemps <> null && emailTemps.size() > 0) {
						//System.debug('inside Send Email');
						emailOut.setOrgWideEmailAddressId(owd.Id);
						emailOut.setReplyTo(replyToMail);
						emailOut.setTargetObjectId(defaulttargetObjectId);
						emailOut.setTreatTargetObjectAsRecipient(false);
						emailOut.setToAddresses(new List<String>{ data.Email__c });
						emailOut.setSaveAsActivity(true);
						emailOut.setWhatId(data.Id);
						emailOut.setTemplateId(emailTemps[0].Id);
						emailsOutList.add(emailOut);
					}
				}
			}
			if (!emailsOutList.isEmpty()) {
				if (!Test.isRunningTest()) {
					Messaging.sendEmail(emailsOutList);
				}
			}
		} catch (Exception e) {
			String msg = e.getMessage();
			//system.debug('Exception while sending email----' + e);
		}
	}
}