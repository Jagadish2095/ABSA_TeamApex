/**
 * @description       :
 * @author            : deepthi.narayanappa@absa.africa
 * @last modified on  : 2021-11-24
 * @last modified by  : deepthi.narayanappa@absa.africa
 **/
public class getDocumentsVA {
	/* Start Changes for Broker Notes*/
	/**
	 * @param caseId - The ID of the Case
	 * @param templateName - Email template name
	 * @description generateNewDocument
	 * @return Map<String,String>
	 */
	@AuraEnabled
	public static Map<String, String> generateNewDocument(Id caseId, String templateName) {
		Map<String, String> result = new Map<String, String>();
		try {
			CC_GenerateContentResponse response = new CC_GenerateContentResponse();
			Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);

			DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
			DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();

			Event event = new Event(call_start__c = System.DateTime.now());
			if (event != null)
				contextBuilder.add('Event', event);

			Case caseObj = new casesSelector().selectCaseFieldForBrokerNote(caseId);
			Case caseWithPolicy = new casesSelector().selectSelectedPolicyByCaseID(caseId);

			if (caseObj != null && String.isNotBlank(caseObj.CaseNumber))
				contextBuilder.add('Case', caseObj);

			User user = new UsersSelector().selectByAdviserCode(caseObj.Adviser_Code__c);

			List<String> policyIds = new List<String>();

			if (caseWithPolicy.SelectedPoliciesID__c.contains(';'))
				policyIds = caseWithPolicy.SelectedPoliciesID__c.split(';');
			else
				policyIds.add(caseWithPolicy.SelectedPoliciesID__c);

			List<Case_Support__c> caseSupportRecords = new CaseSupportSelector().showPoliciesWise(policyIds);
			/* New Changes */
			Map<String, List<Case_Support__c>> mpCaseSup = new Map<String, List<Case_Support__c>>();
			if (!Sys_Utilities_General.isListBlank(caseSupportRecords)) {
				for (Case_Support__c caseSupport : caseSupportRecords) {
					if (mpCaseSup.containsKey(caseSupport.Product_Provider__c.toUpperCase())) {
						mpCaseSup.get(caseSupport.Product_Provider__c.toUpperCase()).add(caseSupport);
					} else {
						mpCaseSup.put(caseSupport.Product_Provider__c.toUpperCase(), new List<Case_Support__c>{ caseSupport });
					}
				}
			}

			List<Document__c> docList = new List<Document__c>();
			/* New Changes */
			Account accountRecord = new AccountsSelector().selectAccountPhoneDetailsByID(caseObj.AccountId);

			if (mpCaseSup != null) {
				for (string key : mpCaseSup.keySet()) {
                    
					if (mpCaseSup.get(key) != null) {
						contextBuilder.add('Case_Support__c', mpCaseSup.get(key));
					}

					if (key.equalsIgnoreCase('SANLAM')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.Sanlam_Code__c);
						contextBuilder.add('PolicyProviderName', 'SANLAM');
					}

					if (key.equalsIgnoreCase('AIMS')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.AIMS_Code__c);
						contextBuilder.add('PolicyProviderName', 'AIMS');
					}

					if (key.equalsIgnoreCase('Liberty')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.Liberty_Code__c);
						contextBuilder.add('PolicyProviderName', 'LIBERTY');
					}
                    	if (key.equalsIgnoreCase('Liberty LIFE')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.Liberty_Code__c);
						contextBuilder.add('PolicyProviderName', 'LIBERTY_LIFE');
					}

					if (key.equalsIgnoreCase('Momentum')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.Momentum_Code__c);
						contextBuilder.add('PolicyProviderName', 'MOMENTUM');
					}

					if (key.equalsIgnoreCase('ABSA LIFE')) {
						contextBuilder.add('Name', user.FirstName + ' ' + user.LastName);
						contextBuilder.add('PolicyProviderCode', user.Advisor_Code__c);
						contextBuilder.add('PolicyProviderName', 'ABSA LIFE');
					}

					// end dirty fix
					//System.debug('>>>>Done with building data>>>');
					String req = contextBuilder.serialize(documentTemplate.XML__c);
					Map<String, String> params = setECMParam(accountRecord, documentTemplate);
					//System.debug('1>>>>');
					if (!test.isRunningTest()) {
						response = DocumentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
						/*  System.debug('2>>>>');
                        System.debug('serialise response ' + JSON.serialize(response));
                        System.debug('serialise response ' + response.contentStoreToken); */
					}

					Date dToday = Date.today();
					Document__c doc = new Document__c();
					doc.Name =
						documentTemplate.Name.toUpperCase() +
						'_' +
						userData().AB_Number__c +
						'_' +
						key +
						'_' +
						string.valueOf(dToday.year()) +
						'_' +
						string.valueOf(dToday.month()) +
						'_' +
						string.valueOf(dToday.day()).left(75) +
						'.pdf';
					doc.Type__c = documentTemplate.Document_Type__c;
					if (!test.isRunningTest())
						doc.Reference__c = response.contentStoreToken;
					else
						doc.Reference__c = '87654332HHAAKSHDH';

					doc.case__c = caseObj.Id;
					doc.IsActive__c = true;
					doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
					docList.add(doc);
				}
			}

			DocumentsSelector DocSelobj = new DocumentsSelector();
			list<Document__c> DocumentList = DocSelobj.getActiveDocumentBycaseId(CaseId);
			for (Document__c documen : DocumentList)
				documen.IsActive__c = false;

			update DocumentList;
			insert docList;

			// did we win? - I pressume a failure would result in the catch running - unless of course it is some unhandled error no being thrown
			result.put('success', 'true');
			result.put('message', 'Successfully generated');
		} catch (Exception ex) {
			result.put('success', 'false');
			result.put(
				'message',
				'Error generating document ' +
				ex.getMessage() +
				' at ' +
				ex.getLineNumber() +
				' getStackTraceString ' +
				ex.getStackTraceString()
			);
			/*system.debug(ex.getMessage());
			 system.debug(ex.getLineNumber());*/
		}
		return result;
	}

	/**
	 * @param caseId - The ID of the Case
	 * @description FetchDocumentId
	 * @return String
	 */
	@AuraEnabled
	public static String FetchDocumentId(Id caseId) {
		DocumentsSelector DocSelobj = new DocumentsSelector();
		return DocSelobj.selectDocumentBycaseId(caseId).id;
	}

	/**
	 * @param documentId - The ID of the Document
	 * @description getDocumentContent
	 * @return String
	 */
	@AuraEnabled
	public static String getDocumentContent(Id documentId) {
		List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);

		ECM_LoginResult_IB_V1 login = ECMLogin();
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);

		if (getResult != null && getResult.Content != null) {
			return getResult.Content.data;
		} else {
			return 'ECM returned no results.';
		}
	}
	/**
	 * @param caseId - The ID of the Case
	 * @description getVirtualAdviserDetails
	 * @return User
	 */
	public static user getVirtualAdviserDetails(String caseId) {
		CasesSelector cSelector = new CasesSelector();
		UsersSelector uSelector = new UsersSelector();
		case cObj = cSelector.selectCaseFieldForBrokerNote(caseId);
		String adviserCode = cObj.Adviser_Code__c;
		User uObj = uSelector.selectByAdviserCode(adviserCode);
		return uObj;
	}

	/**
	 * @param documentId - The ID of the Document
	 * @param caseID - The ID of the Case
	 * @description - SendBrokerNotes
	 * @return string
	 */
	@AuraEnabled
	public static string SendBrokerNotes(string documentId, string caseID) {
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

		list<Messaging.EmailFileAttachment> emailAttchmentLst = new List<Messaging.EmailFileAttachment>();
		Blob b;
		list<EmailTemplate> em = new List<EmailTemplate>();
		DocumentsSelector dSelect = new DocumentsSelector();
		list<document__c> doc = dSelect.getActiveDocumentBycaseId(CaseId);
		if (doc == null || doc.size() <= 0) {
			return 'Broker note not generated';
		}

		EmailTemplatesSelector EmailTempSelector = new EmailTemplatesSelector();
		em = EmailTempSelector.selectByName('BrokerNotePDF');

		CasesSelector cSelector = new CasesSelector();
		case caserec = cSelector.CaseDetailsByQuery(caseID);
		string[] lstDocId = documentId.split('\\$');
		set<string> DocIDE = new Set<string>();
		for (string str : lstDocId) {
			if (String.isNotBlank(str)) {
				DocIDE.add(str);
			}
		}

		/*system.debug('DocIDE--->' + DocIDE);
		 system.debug('DocIDE size--->' + DocIDE.size());*/
		list<Document__c> docContentList = new DocumentsSelector().getActiveDocumentBycaseId(CaseId);
		//system.debug('docContentList[0].size--->' + docContentList.size());
		ECM_LoginResult_IB_V1 login = getDocumentsVA.ECMLogin();
		ECM_GetResult_IB_V1 getResult;
		map<string, string> mapFileName = new Map<string, string>();
		mapFileName.put('AIMS', 'AIMS BROKER NOTE.pdf');
		mapFileName.put('SANLAM', 'SANLAM BROKER NOTE.pdf');
		mapFileName.put('LIBERTY LIFE', 'LIBERTY LIFE BROKER NOTE.pdf');
		mapFileName.put('MOMENTUM', 'MOMENTUM BROKER NOTE.pdf');
		mapFileName.put('ABSA LIFE', 'ABSA LIFE BROKER NOTE.pdf');

		map<string, list<string>> mapEmailToAdd = new Map<string, list<string>>();
		list<Policy_Provider_Email__mdt> lstPolicyProvMDT = [SELECT id, Policy_Provider_Email__c, Policy_Provider_Name__c FROM Policy_Provider_Email__mdt];
		for (Policy_Provider_Email__mdt PolMDT : lstPolicyProvMDT) {
			if (mapEmailToAdd.containsKey(PolMDT.Policy_Provider_Name__c)) {
				mapEmailToAdd.get(PolMDT.Policy_Provider_Name__c.toUpperCase()).add(PolMDT.Policy_Provider_Email__c);
			} else {
				mapEmailToAdd.put(PolMDT.Policy_Provider_Name__c.toUpperCase(), new List<string>{ PolMDT.Policy_Provider_Email__c });
			}
		}
		/*system.debug('mapEmailToAdd---->' + mapEmailToAdd);
		 system.debug('docContentList---->' + docContentList.size()); */
		OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :system.label.EmailAddLabel];

		List<String> sendTo = new List<String>();
		for (Document__c docRec : docContentList) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			sendTo.clear();
			emailAttchmentLst.clear();
			//system.debug('Split 252-->' + docRec.Name);
			if (!Test.isRunningTest()) {
				//system.debug('--' + login.token + '---' + docRec.Reference__c);
				getResult = ECM_IH_V1.getDocument(login.token, docRec.Reference__c);
				//system.debug('getResult---' + getResult);
			}
			if (!Test.isRunningTest())
				b = EncodingUtil.base64Decode(getResult.Content.data);
			else
				b = EncodingUtil.base64Decode('Testing');
			//system.debug('Split-->' + docRec.Name);
			//system.debug('Split-->' + docRec.Name.split('_')[2].toUpperCase().trim());
			if (mapFileName.containsKey(docRec.Name.split('_')[2].toUpperCase().trim())) {
				Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
				efa1.setFileName(mapFileName.get(docRec.Name.split('_')[2].trim()));
				efa1.setBody(b);
				emailAttchmentLst.add(efa1);
				//system.debug('Split-->' + docRec.Name.split('_')[2].toUpperCase().trim());
				if (!Test.isRunningTest())
					sendTo.addAll(mapEmailToAdd.get(docRec.Name.split('_')[2].toUpperCase().trim()));
				else {
					sendTo.addAll(new List<string>{ 'absa@absa.com' });
				}
			}
			//system.debug('sendTo--->' + sendTo);
			mail.setToAddresses(sendTo);
			mail.setTargetObjectId(caserec.Account.PersonContactId);
			mail.setWhatId(caserec.id);
			mail.setTreatTargetObjectAsRecipient(false);
			mail.setOrgWideEmailAddressId(owd.Id);
			mail.setSaveAsActivity(true);
			mail.setTemplateId(em.get(0).id);
			mail.setFileAttachments(emailAttchmentLst);
			mails.add(mail);
		}
		if (!Test.isRunningTest())
			Messaging.sendEmail(mails);
		return 'Success';
	}

	/**
	 * @description Used for Direct Delivery stream, SMS the client once verbal disclosures have been validated
	 * @param whoId Lead or contact
	 * @param whatId opportunity
	 * @param phoneNumberOverride if phone number needs to be overridden
	 * @param recipientNameOverride if the name needs to be overridden
	 * @param quickTextName name of quick text that needs to be sent out
	 * @param integrationService intergration service to be used
	 * @param saveAsActivity save as an activity true or false
	 */
	@AuraEnabled
	@Future(Callout=true)
	public static void dispatchSMS(
		Id whoId,
		Id whatId,
		String phoneNumberOverride,
		String recipientNameOverride,
		String quickTextName,
		String integrationService,
		boolean saveAsActivity
	) {
		sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
	}

	/**
	 * @description userData
	 * @return User
	 */
	@AuraEnabled
	public static User userData() {
		User use = [SELECT id, AB_Number__c FROM User WHERE id = :userinfo.getUserId()];
		return use;
	}

	/**
	 * @param caseId - The ID of the Case
	 * @description getCustomer
	 * @return case
	 */
	@AuraEnabled
	public static case getCustomer(Id caseId) {
		CasesSelector cSelector = new CasesSelector();
		case cse = cSelector.selectCaseFieldForBrokerNote(caseId); // [Select id, Customer_ID__c from case where id=:caseId];
		return cse;
	}

	/**
	 * @description ECMLogin
	 * @return ECM_LoginResult_IB_V1
	 */
	public static ECM_LoginResult_IB_V1 ECMLogin() {
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}
	/* End Changes for Broker Notes*/

	/**
	 * @author Thulani Maseko
	 * Generates a document for the input type and links it to the input opportunity
	 *
	 * @param acc
	 * @param template
	 * @description setECMParam
	 * @return Map<String, String>
	 */

	public static Map<String, String> setECMParam(Account acc, Document_Template__c template) {
		Map<String, String> fields = new Map<String, String>();

		fields.put('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
		fields.put('IdNr', acc.Registration_Number__c == null ? '0' : acc.Registration_Number__c);
		fields.put('AcctNr', acc.AccountNumber == null ? '0' : acc.AccountNumber);
		fields.put('Origin', 'Salesforce B2C');
		fields.put('BusinessUnit', 'RBB');

		if (!Test.isRunningTest()) {
			Map<String, String> credentials = ECM_IH_V1.getCredentials();
			fields.put('ECM_Account', credentials.get('username'));
			fields.put('ECM_Password', credentials.get('password'));
			fields.put('ECMItemType', template.ECM_Item_Type__c);
		}

		return fields;
	}

	/**
	 * @param whoId
	 * @param whatId
	 * @param phoneNumberOverride
	 * @param recipientNameOverride
	 * @param quickTextName
	 * @param integrationService
	 * @param saveAsActivity
	 * @description sendSMS
	 * @return String
	 */

	public static string sendSMS(
		Id whoId,
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
			phoneNumber = '+270' + phoneNumber;
		} else {
			phoneNumber = '+27' + phoneNumber;
		}
		//system.debug('phoneNumber---->' + phoneNumber);
		String recipientName = recipientNameOverride;
		//system.debug('recipientName---->' + recipientName);
		//system.debug('phoneNumberOverride--->' + phoneNumberOverride);

		//Verify User's mobile number format is compatible with iTouch format. Salesforce User's mobile number format is '+27 0600000000'
		if (phoneNumber.substring(0, 4) == '+27 ') {
			phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
		}

		//'+270600000000' format is not supported by iTouch, so remove 0
		if (phoneNumber.substring(0, 4) == '+270') {
			phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(4, 13);
		}
		//system.debug('phoneNumber---->' + phoneNumber);

		//Get plain text SMS body
		String mergedBody = getPlainTextSMSBody(whoId, whatId, quickTextName);

		//Send sms
		Integer statusCode;
		if (mergedBody != null) {
			SMSGateway_Resp_IB_v1 bean = dispatchSMS(phoneNumber, mergedBody, integrationService);
			statusCode = bean.statusCode;
			if (bean.statusCode == 200) {
				reference = bean.MessageReference;
			}
		}

		//Create SMS task. Only Contact (003) and Lead (00Q) can be whoId for a Task
		if (saveAsActivity && statusCode == 200) {
			Id taskWhoId = null;
			if (whoId != null) {
				if (String.valueOf(whoId).substring(0, 3) == '003' || String.valueOf(whoId).substring(0, 3) == '00Q') {
					taskWhoId = whoId;
				}
			}
			createTask(recipientName, phoneNumber, taskWhoId, whatId, UserInfo.getUserId(), mergedBody, reference);
		}

		return reference;
	}

	/**
	 * Does the Quick Text merge
	 * @description Quick Text Merge
	 * @param whoId - The ID of the Contact, Lead, or User the SMS is related to
	 * @param whatId - The ID of the object that the Task is related to, i.e. Opportunity, Case etc...
	 * @param quickTextName - Quick Text template name
	 * @return String
	 *
	 */
	public static String getPlainTextSMSBody(Id whoId, Id whatId, String quickTextName) {
		//An array of strings that are examined for merge field references. The corresponding data from the object referenced by the whoId or whatId replaces the merge field reference
		String mergedBody;
		try {
			CasesSelector cSelector = new CasesSelector();
			UsersSelector uSelector = new UsersSelector();
			case cObj = cSelector.selectCaseFieldForBrokerNote(whatId);
			String adviserCode = cObj.Adviser_Code__c;
			User uObj = uSelector.selectByAdviserCode(adviserCode);
			//system.debug('quickTextName--->' + quickTextName);
			String quickTextMessage = [SELECT Message FROM QuickText WHERE Name = :quickTextName].Message;
			quickTextMessage = quickTextMessage.replace('#', uObj.Name);
			List<Messaging.RenderEmailTemplateBodyResult> renderResults = Messaging.renderEmailTemplate(whoId, whatId, new List<String>{ quickTextMessage });
			mergedBody = renderResults[0].getMergedBody();
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
			//System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
		return mergedBody;
	}

	/**
	 * @param phoneNumber
	 * @param messageText
	 * @param integrationService
	 * @description dispatchSMS
	 * @return SMSGateway_Resp_IB_v1
	 */
	public static SMSGateway_Resp_IB_v1 dispatchSMS(String phoneNumber, String messageText, String integrationService) {
		SMSGateway_Resp_IB_v1 bean = SMSGateway_IH_v1.submit(phoneNumber, messageText, integrationService);
		return bean;
	}

	/**
	 * @param recipientName
	 * @param phoneNumber
	 * @param taskWhoId
	 * @param whatId
	 * @param ownerId
	 * @param messageText
	 * @param messageReference
	 * @description createTask
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
		tsk.Description = messageText;
		tsk.status = 'Completed';
		tsk.RecordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
		try {
			insert tsk;
		} catch (DmlException e) {
			throw new AuraHandledException(e.getMessage());
			//System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
	}

	/**
	 * @param caseID
	 * @description getContacts
	 * @return List<String>
	 */

	@AuraEnabled
	public static List<String> getContacts(String caseID) {
		List<String> contactNums = new List<String>();
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(CaseId);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		if (!String.isBlank(cases[0].Mobile__c)) {
			contactNums.add(cases[0].Mobile__c + '-Mob');
		}
		if (!String.isBlank(cases[0].Alternate_Phone1__c)) {
			contactNums.add(cases[0].Alternate_Phone1__c + '-Alt1');
		}
		if (!String.isBlank(cases[0].Alternate_Phone2__c)) {
			contactNums.add(cases[0].Alternate_Phone2__c + '-Alt2');
		}
		if (!String.isBlank(cases[0].Alternate_Phone3__c)) {
			contactNums.add(cases[0].Alternate_Phone3__c + '-Alt3');
		}
		if (!String.isBlank(cases[0].Alternate_Phone4__c)) {
			//System.debug('test123 alt4' + cases[0].Alternate_Phone4__c);
			contactNums.add(cases[0].Alternate_Phone4__c + '-Alt4');
		}
		if (!String.isBlank(cases[0].Alternate_Phone5__c)) {
			contactNums.add(cases[0].Alternate_Phone5__c + '-Alt5');
		}
		if (!String.isBlank(cases[0].Alternate_Phone6__c)) {
			contactNums.add(cases[0].Alternate_Phone6__c + '-Alt6');
		}
		if (!String.isBlank(cases[0].Alternate_Phone7__c)) {
			contactNums.add(cases[0].Alternate_Phone7__c + '-Alt7');
		}

		//System.debug('test123 list' + contactNums);
		return contactNums;
	}

	/**
	 * @param caseID
	 * @description getActiveNoteBrokerPDF
	 * @return List<document__c>
	 */
	@AuraEnabled
	public static List<document__c> getActiveNoteBrokerPDF(String caseID) {
		DocumentsSelector docObj = new DocumentsSelector();
		return docObj.getActiveDocumentBycaseId(caseID);
	}
}