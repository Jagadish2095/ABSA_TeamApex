/**  * @description Controller for Documents Share Lightning component
 * @author Vladimir Panajic
 * @created 2019-05-20
 */
public class DocumentsShareControllerESign{
	static Map<String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a list of all documents for an Opportunity
	 *
	 * @param opportunityId
	 * @return List<Document__c>
	 */
	@AuraEnabled
	public static List<Document__c> getDocumentsData(Id opportunityId){
		if (!Test.isRunningTest()){
			ImpressionsController.updateImpressionRequests(opportunityId);
		}

		List<Document__c> documents = new DocumentsSelector().getDocuments(opportunityId, 'Opportunity', 100);
		return documents;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a list of all document audits (email and download) for an Opportunity
	 *
	 * @param opportunityId
	 * @return List<Document_Audit__c>
	 */
	@AuraEnabled
	public static List<Document_Audit__c> getDocumentAudit(Id opportunityId){
		List<Document_Audit__c> documentAudits = new DocumentAuditsSelector().selectDocumentsShare(opportunityId);
		return documentAudits;
	}

	/**
	 * @author Danie Booysen
	 * @description Method that gets a list of all document audits (email) for an Opportunity
	 *
	 * @param opportunityId
	 * @return  List<Document_Audit__c>
	 */
	@AuraEnabled
	public static List<Document_Audit__c> getDocAuditHistoryEmail(Id opportunityId){
		List<Document_Audit__c> documentAudits = new DocumentAuditsSelector().selectDocumentsShareByEmail(opportunityId);
		return documentAudits;
	}

	/**
	 * @author Jason Quevauvilliers
	 * @description Method that gets a list of all Tasks (email) for an Opportunity
	 *
	 * @param opportunityId
	 * @return List<Task>
	 */
	@AuraEnabled
	public static List<Task> getDocumentAuditEmail(Id opportunityId){
		return [SELECT Id, Subject, Document_Sharing_Email__c, Document_Sharing_Method__c, CreatedDate
		        FROM Task
		        WHERE WhatId = :opportunityId
		        ORDER BY CREATEDDATE DESC];
	}

	/**
	 * @author Jason Quevauvilliers
	 * @description Method that gets a list of all Tasks (email) for an Opportunity
	 *
	 * @param activityId
	 * @return List<Email_Document__c>
	 */
	@AuraEnabled
	public static List<Email_Document__c> getEmailDocuments(Id activityId){
		return [SELECT Id, Name, Document__c, Email_Message__c, Email_Message_Name__c, Activity__c, CreatedDate
		        FROM Email_Document__c
		        WHERE Activity__c = :activityId
		        ORDER BY CREATEDDATE DESC];
	}

	/**
	 * @author Jason Quevauvilliers
	 * @description Method that gets the Opportunity related to the task
	 *
	 * @param taskIdP
	 * @return Id
	 */
	@AuraEnabled
	public static Id getOpportunityIdFromTask(Id taskIdP){
		return [SELECT WhatId
		        FROM Task
		        WHERE Id = :taskIdP].WhatId;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a list of all Impression requests for an Opportunity
	 *
	 * @param opportunityId
	 * @return List<ImpressionRequest__c>
	 */
	@AuraEnabled
	public static List<ImpressionRequest__c> fetchImpressionRequest(Id opportunityId){
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectRequestsByOpptyId(opportunityId);
		return impressionRequests;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that creates a documents share audit record
	 *
	 * @param opportunityId
	 * @param documentId
	 * @param sharingMethod
	 * @param clientEmail
	 */
	@AuraEnabled
	public static void createDocumentSharingAudit(Id opportunityId, Id documentId, String sharingMethod, String clientEmail){
		Document_Audit__c documentAudit = new Document_Audit__c(Document__c = documentId, Opportunity__c = opportunityId, Document_Sharing_Method__c = sharingMethod, Document_Sharing_Email__c = clientEmail);
			insert documentAudit;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that downloads a document to the desktop
	 *
	 * @param opportunityId
	 * @param documentId
	 * @param sharingMethod
	 * @param clientEmail
	 * @return ECM_GetResult_IB_V1.Content.data
	 */
	@AuraEnabled
	public static String getDocumentContent(Id opportunityId, Id documentId, String sharingMethod, String clientEmail){
		Document__c doc = new DocumentsSelector().selectById(documentId);
		ECM_LoginResult_IB_V1 login = ECMLogin();
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c);
		createDocumentSharingAudit(opportunityId, documentId, sharingMethod, clientEmail);
		if (Test.isRunningTest()){
			return 'getResult.Content.data';
		}
		return getResult.Content.data;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that logs to ECM
	 * @return ECM_LoginResult_IB_V1
	 */
	public static ECM_LoginResult_IB_V1 ECMLogin(){
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that does the component refresh on demand
	 */
	@AuraEnabled
	public static void dummyRefresh(){
		//this is a dummy refresh
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets the name of the adviser (loged in user) for the documents share declaration
	 *
	 * @return Name
	 */
	@AuraEnabled
	public static String fetchAdviserName(){
		return UserInfo.getName();
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets the name of the Opportunity Owner for the documents share declaration
	 * @param oppId
	 * @return Name
	 */
	@AuraEnabled
	public static String fetchOppOwnerName(Id oppId){
		List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(oppId);
		return new UsersSelector().selectById(opportunityList[0].OwnerId).Name;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a content of a list of documents
	 *
	 * @param idListJSON
	 * @return docs
	 */
	public static List<List<string>> getDocumentsContent(String idListJSON){
		List<List<string>> docs = new List<List<string>>();
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECMLogin();

		Type idArrType = Type.forName('List<string>');
		List<string> wrapperList = (List<string>)JSON.deserialize(idListJSON, idArrType);
		for (String documentId : wrapperList){
			Document__c doc = new DocumentsSelector().selectById(documentId);
			ECM_GetResult_IB_V1 getResult;
			if (!Test.isRunningTest()){
				getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c);
			} else{
				getResult = ECM_GetResult_IB_V1.getExample();
			}
			if (getResult.Content != null){
				docs.add(new List<string>{documentId, doc.Name, getResult.Content.data});
			}
		}
		return docs;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that sends a document sharing email with attachment(s)
	 *
	 * @param opportunityId
	 * @param clientEmail
	 * @param idListJSON
	 */
	@AuraEnabled
	public static void sendDocumentSharingEmail(String opportunityId, String clientEmail, String idListJSON){
		List<List<string>> docs = getDocumentsContent(idListJSON);
		List<EmailMessage> emailMessageList = new List<EmailMessage>();

		// There is a bug, we are not supposed create an Application record, not sure why this code is here
		// I am skipping it for Opportunities of type Merchant Onboarding
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
		// so I am checking to see if the record type is not Merchant_Onboarding - dunno again why this code is here - Tinashe - 2020-07-31
		if (!opportunities.isEmpty() && opportunities.size() > 0 && opportunities != null && opportunities.get(0).RecordType.DeveloperName != 'Merchant_Onboarding'){
			List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
			if (!applicationList.isEmpty() && applicationList.size() > 0 && applicationList != null){
				applicationList.get(0).Preferred_Email__c = clientEmail;
					update applicationList.get(0);
			} else{
				Application__c application = new Application__c(RecordTypeId = applicationRecordTypeMap.get(opportunities.get(0).RecordType.DeveloperName).getRecordTypeId(),Opportunity__c = opportunityId,Preferred_Email__c = clientEmail);
					insert application;

			}
		}

		//Lerato Matenzhe - W-005375 - Merchant_Email Template for Merchant Agreement
		String templateName = StringConstants.WIMI_DOCUMENTS_SHARE_EMAIL;
			if (opportunities.get(0).RecordType.DeveloperName == 'Merchant_Onboarding'){
				templateName = 'Email_Template_for_Application_PDFs';
			}

		List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
		List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
		Id templateId;
		List<EmailTemplate> emailTemplatesList = new EmailTemplatesSelector().selectByDeveloperName(templateName);
		if (!emailTemplatesList.isEmpty()){
			templateId = emailTemplatesList.get(0).Id;
		}
		msg.setTemplateId(templateId);
		msg.setWhatId(opportunityId);
		List<Contact> acrConList = new AccountContactRelationSelector().selectContactListByAccId(opportunities.get(0).AccountId);
		if (!acrConList.isEmpty() && acrConList.size() > 0 && acrConList != null){
			msg.setTargetObjectId(acrConList.get(0).Id);
		} else{
			msg.setTargetObjectId(accounts.get(0).PersonContactId);
		}
		msg.setToAddresses(new List<String>{clientEmail});
		if (test.isRunningTest()){
			msg.plainTextBody = 'Please find attached the document.';
		}
		lstMsgs.add(msg);
		Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
		List<Messaging.Emailfileattachment> attList = new List<Messaging.Emailfileattachment>();
		for (Messaging.SingleEmailMessage email : lstMsgs){
			//Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
			//List<Messaging.Emailfileattachment> attList = new List<Messaging.Emailfileattachment>();
			for (Integer i = 0; i < docs.size(); i++){
				Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();
				for (Integer j = 0; j < docs[i].size(); j++){
					if (j == 1){
						att.setFileName(docs[i][j]);
					} else if (j == 2){
						Blob faqBlob;
						faqBlob = EncodingUtil.base64Decode(docs[i][j]);
						att.setBody(faqBlob);
						attList.add(att);
					}
				}
			}

			emailToSend.setFileAttachments(attList);
			//Needed for the setSaveAsActivity = true. Send the emails in a transaction, then roll it back
			Savepoint sp = Database.setSavepoint();
			Messaging.sendEmail(lstMsgs);
			Database.rollback(sp);
			emailToSend.setToAddresses(email.getToAddresses());
			emailToSend.setPlainTextBody(email.getPlainTextBody());
			emailToSend.setHTMLBody(email.getHTMLBody());
			emailToSend.setSubject(email.getSubject());
			emailToSend.setSaveAsActivity(false);
			emailToSend.setWhatId(opportunityId);
			lstMsgsToSend.add(emailToSend);

			//Create EmailMessage Object and map fields
			EmailMessage emailMessage = new EmailMessage();
			emailMessage.TextBody = email.getPlainTextBody();
			emailMessage.htmlBody = email.getHTMLBody();
			emailMessage.Subject = email.getSubject();
			emailMessage.FromName = UserInfo.getName();
			emailMessage.FromAddress = UserInfo.getUserEmail();
			emailMessage.ValidatedFromAddress = UserInfo.getUserEmail();
			emailMessage.ToAddress = clientEmail;
			emailMessage.RelatedToId = opportunityId;
			emailMessage.status = '3';
			emailMessage.MessageDate = System.now();
			emailMessage.IsClientManaged = false;
			emailMessage.IsTracked = false;
			emailMessage.IsBounced = false;
			emailMessage.Is_Auto_Response__c = false;
			emailMessage.Incoming = false;
			emailMessageList.add(emailMessage);
		}
		//Send Email
		Messaging.sendEmail(lstMsgsToSend);

			insert emailMessageList;

		//Get Id Set from EmailMessages
		Set<Id> messageIdSet = new Set<Id>();
		for (EmailMessage eMessage : emailMessageList){
			messageIdSet.add(eMessage.Id);
		}
		//Requery EmailMessages to get ActivityId
		List<EmailMessage> newEmailMessageList = [SELECT Id, ActivityId, Subject
		                                          FROM EmailMessage
		                                          WHERE Id IN :messageIdSet];
		//Query Task Based off of ActivityId
		List<Task> taskList = [SELECT Id, Subject, Document_Sharing_Method__c, Document_Sharing_Email__c, Engagement_Reason__c
		                       FROM Task
		                       WHERE Id = :newEmailMessageList[0].ActivityId];
		//Map Task Fields
		taskList[0].Document_Sharing_Method__c = 'Email';
		taskList[0].Document_Sharing_Email__c = clientEmail;
		taskList[0].Engagement_Reason__c = 'Sale / Potential Sale';

		List<Email_Document__c> emailDocumentList = new List<Email_Document__c>();
		//Map Email_Document__c for each Document for each Email
		for (EmailMessage eMessage : newEmailMessageList){

			for (Integer i = 0; i < docs.size(); i++){

				Email_Document__c emailDocument = new Email_Document__c(Email_Message__c = eMessage.Id, Email_Message_Name__c = eMessage.Subject, Activity__c = eMessage.ActivityId);
				for (Integer j = 0; j < docs[i].size(); j++){
					if (j == 0){
						emailDocument.Document__c = docs[i][j];
					}
					if (j == 1){
						emailDocument.Name = docs[i][j];
					}
				}
				emailDocumentList.add(emailDocument);
			}
		}

		try{
			update taskList;
		} catch (Exception ex){
			//throw all other exception message
			throw new AuraHandledException(ex.getMessage());
		}
		try{
			insert emailDocumentList;
		} catch (Exception ex){
			//throw all other exception message
			throw new AuraHandledException(ex.getMessage());
		}
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a list of all signatories for a document
	 *
	 * @param documentId
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getSignatoriesData(Id documentId){
		Document__c doc = new DocumentsSelector().selectById(documentId);
		String documentType = doc.Type__c;
		String documentName = doc.Name;
		Id opportunityId = doc.Opportunity__c;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		string oppRecordTypeName = opportunities.get(0).RecordType.Name;
		List<Digital_Signature_Admin__c> admin = new DigitalSignatureAdminsSelector().selectDigitalSignatureAdminByType(documentType);
		Id adminId; // validation added in case Admin not setup
		//  W-004546 - Tinashe Shoko
		if (!admin.isEmpty() && admin.size() > 0 && admin != null){
			adminId = admin.get(0).Id;
		} else{
			return null;
		}
		List<Digital_Signature_Signatory__c> signatories = new DigitalSignatorySignatoriesSelector().selectSignatoryByRecordType(adminId,oppRecordTypeName);
		//W-13685 : Anka Ganta : added else conditon - START
		Map<String, Object> signatoryRoleMap = new Map<String, Object>();
		if (signatories.isEmpty() || signatories.size() <= 0 || signatories == null){
			// validation added in case Admin not setup
			//W-004546 - Tinashe Shoko
			return null;
		} else{
			Map<Id,List<Digital_Signatory_Role__c>> idRoleMap =  new Map<Id,List<Digital_Signatory_Role__c>>();
            Set<Id> sigIds = new Set<Id>();
            for(Digital_Signature_Signatory__c sig : signatories){
                sigIds.add(sig.Id);
            }
            List<Digital_Signatory_Role__c> signRoles = [Select id, Name, Client_Type__c, Roles__c, Designation__c, Digital_Signature_Signatory__c
				                                              from Digital_Signatory_Role__c
				                                              where Digital_Signature_Signatory__c IN : sigIds];
            for(Digital_Signatory_Role__c sign: signRoles){
                if(sign.Roles__c != null){
                   if(!idRoleMap.containsKey(sign.Digital_Signature_Signatory__c)) {
                    	idRoleMap.put(sign.Digital_Signature_Signatory__c, new List<Digital_Signatory_Role__c>{sign});
                    } else {
                        idRoleMap.get(sign.Digital_Signature_Signatory__c).add(sign);
                    } 
                }
            }
			for (Digital_Signature_Signatory__c sig : signatories){
                if(idRoleMap.containsKey(sig.Id)){
				for (Digital_Signatory_Role__c signroleRec : idRoleMap.get(sig.Id)){
					if (signroleRec.Roles__c != null){
						for (String role : signroleRec.Roles__c.split(';')){
							signatoryRoleMap.put((signroleRec.Client_Type__c + role).toUpperCase(), signroleRec);
						}
					}
					if (signroleRec.Designation__c != null){
						for (String designation : signroleRec.Designation__c.split(';')){
							signatoryRoleMap.put((signroleRec.Client_Type__c + designation).toUpperCase(), signroleRec);
						}
					}
				}
            }
			}
		}
		//W-13685 - END
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		for (Integer i = 0; i < signatories.size(); i++){
			Map<String, String> mapObj = new Map<String, String>();
			if (signatories[i].Signatory_Type__c == 'Parent Owner'){
				User adviser = new UsersSelector().selectById(opportunities.get(0).OwnerId);
				mapObj.put('Id', adviser.Id);
				mapObj.put('Title', 'Advisor.');
				mapObj.put('Last_Name', adviser.LastName);
				String phoneNumber = adviser.MobilePhone;
				//Verify User's mobile number format is compatible with Impression format. Salesforce User's mobile number format is '+27 0600000000', so remove space and 0
				if (phoneNumber != null && phoneNumber != '' && phoneNumber.startsWith('+27')){
					if (phoneNumber.substring(0, 4) == '+27 '){
						phoneNumber = phoneNumber.substring(0, 3)+phoneNumber.substring(5, 14);
					}
				}
				mapObj.put('Mobile_Phone', phoneNumber);
				mapObj.put('Email', adviser.Email);
				mapObj.put('Order', String.valueOf(signatories[i].Order__c));
				mapObj.put('Role', 'Adviser');
				mapObj.put('Method', signatories[i].Preferred_Method__c);
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Parent Customer'){
				Account client = new AccountsSelector().selectById(opportunities.get(0).AccountId);
				List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.PersonContactId, 1);
				mapObj.put('Id', client.PersonContactId);
				if (client.Salutation != null){
					mapObj.put('Title', client.Salutation);
				} else{
					mapObj.put('Title', '');
				}
				mapObj.put('Last_Name', client.LastName);
				//Mobile Phone, Email and Method
				String mobile;
				if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList.size() > 0 && signatoryPartyOveridesList != null){
					if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
						if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
							mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
						}
						mapObj.put('Mobile_Phone', mobile);
					} else{
						if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null){
							mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
							mapObj.put('Mobile_Phone', mobile);
						}
					}

					if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
						mapObj.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
					} else{
						mapObj.put('Email', client.PersonEmail);
					}

					if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
						mapObj.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
					} else{
						mapObj.put('Method', signatories[i].Preferred_Method__c);
					}
				} else{
					if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null){
						mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
						mapObj.put('Mobile_Phone', mobile);
					} else{
						mapObj.put('Mobile_Phone', '');
					}
					if (client.PersonEmail != ''){
						mapObj.put('Email', client.PersonEmail);
					} else{
						mapObj.put('Email', '');
					}
					mapObj.put('Method', signatories[i].Preferred_Method__c);
				}
				mapObj.put('Order', String.valueOf(signatories[i].Order__c));
				mapObj.put('Role', 'Client');
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Authorised Signatory'){
				//String roles = '\'Individual with Authority to Act\'';
				List<OpportunityLineItem> oppLineList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunities.get(0).Id, 1);
				if (oppLineList != null && !oppLineList.isEmpty() && oppLineList.size() > 0){
					// check if there are contacts found
					List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectRelationById(oppLineList[0].Contact_Person__c);
					List<merchantOnboardingAuthSignatoryCtrl.contactPerson> cpList = new List<merchantOnboardingAuthSignatoryCtrl.contactPerson>();
					// changes made here to cater for person account if there is not ACR record
					if (acrList != null && !acrList.isEmpty() && acrList.size() > 0){
						for (AccountContactRelation acr : acrList){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = acr.Id;
							cp.salutation = acr.Contact.Salutation;
							cp.initials = acr.Contact.Initials__c;
							cp.lastName = acr.Contact.LastName;
							cp.mobilePhone = acr.Contact.MobilePhone;
							cp.email = acr.Contact.Email;
							cp.roles = acr.Roles;
							cpList.add(cp);
						}
					} else{
						Account ac = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
						if (ac != null){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = ac.Id;
							cp.salutation = ac.PersonTitle;
							cp.initials = ac.Initials__pc;
							cp.lastName = ac.LastName;
							cp.mobilePhone = ac.PersonMobilePhone;
							cp.email = ac.PersonEmail;
							cp.roles = 'Individual with Authority to Act';
							cpList.add(cp);
						}
					}

					for (merchantOnboardingAuthSignatoryCtrl.contactPerson client : cpList){
						Map<String, String> mapObjAuthSig = new Map<String, String>();
						List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
						mapObjAuthSig.put('Id', client.id);
						if (client.salutation != null){
							mapObjAuthSig.put('Title', client.salutation);
						} else{
							mapObjAuthSig.put('Title', '');
						}
						mapObjAuthSig.put('Last_Name', client.lastname);
						//Mobile Phone, Email and Method
						String mobile;
						if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
							if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
								if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
									mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
								}
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								if (client.mobilePhone != '' && client.mobilePhone != null){
									mobile = '+27' + client.mobilePhone.substring(1, 10);
									mapObjAuthSig.put('Mobile_Phone', mobile);
								}
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
								mapObjAuthSig.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
							} else{
								mapObjAuthSig.put('Email', client.email);
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
								mapObjAuthSig.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
							} else{
								mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
							}
						} else{
							if (client.mobilePhone != '' && client.mobilePhone != null){
								mobile = '+27' + client.mobilePhone.substring(1, 10);
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								mapObjAuthSig.put('Mobile_Phone', '');
							}
							if (client.email != ''){
								mapObjAuthSig.put('Email', client.email);
							} else{
								mapObjAuthSig.put('Email', '');
							}
							mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
						}
						mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
						mapObjAuthSig.put('Role', 'Client'); // this allows us to Overide e.g. the mobile number
						mapObjAuthSig.put('Document_Name', documentName);
						mapObjAuthSig.put('Document_Type', documentType);
						listTotal.add(mapObjAuthSig);
					}
					// } // ends here - marker
				}
			}
			//W-012954 - added else if for related party added : Anka Ganta
			else if (signatories[i].Signatory_Type__c == 'Related Party Signatory'){
				//W-13540 : START : Anka Ganta : pull main account holder
				Boolean isSoleTrader = false;
				Boolean isIndividual = false;
				String ClientType;
				Account ac = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
				if (ac.Client_Type__c == 'Sole Trader'){
					isSoleTrader = true;
					isIndividual = false;
					ClientType = ac.Client_Type__c;
				} else if (ac.Client_Type__c == 'Private Individual' || ac.Client_Type__c == 'Individual - Minor' || ac.Client_Type__c == 'Individual'){
					isSoleTrader = false;
					isIndividual = true;
					ClientType = ac.Client_Type__c;
				} else{
					isSoleTrader = false;
					isIndividual = false;
					ClientType = ac.Client_Type__c;
				}
				// W-13540 - END

				List<OpportunityLineItem> oppLineList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunities.get(0).Id, 1);
				if (oppLineList != null && !oppLineList.isEmpty() && oppLineList.size() > 0){
					// check if there are contacts found
					// below line chnaged to search by and get details of identified Contact Person W-004546 - Tinashe Shoko

					List<AccountContactRelation> acrRecs = new AccountContactRelationSelector().selectRelationByAccountId(opportunities.get(0).AccountId);
					//W-13685 : START : rules to pull signatories based on digital admin setup of Signatory Roles
					List<Id> acrIdsList = new List<Id>();
					for (AccountContactRelation acrRec : acrRecs){
						if (acrRec.Roles != null){
							for (String role : acrRec.Roles.split(';')){
								if (signatoryRoleMap.containsKey((clientType + role).toUpperCase())){
									acrIdsList.add(acrRec.Id);
								}
							}
						}
						if (acrRec.Designation__c != null){
							for (String designation : acrRec.Designation__c.split(';')){
								if (signatoryRoleMap.containsKey((clientType + designation).toUpperCase())){
									acrIdsList.add(acrRec.Id);
								}
							}
						}
					}

					Set<Id> acrSetIds = new Set<Id>();
					acrSetIds.addAll(acrIdsList);

					List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectById(acrSetIds);

					List<merchantOnboardingAuthSignatoryCtrl.contactPerson> cpList = new List<merchantOnboardingAuthSignatoryCtrl.contactPerson>();
					// changes made here to cater for person account if there is not ACR record
					if (acrList != null && !acrList.isEmpty() && acrList.size() > 0 && (!isSoleTrader && !isIndividual)){
						for (AccountContactRelation acr : acrList){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = acr.Id;
							cp.salutation = acr.Contact.Salutation;
							cp.initials = acr.Contact.Initials__c;
							cp.lastName = acr.Contact.LastName;
							cp.mobilePhone = acr.Contact.MobilePhone;
							cp.email = acr.Contact.Email;
							cp.roles = acr.Roles;
							cp.designation = acr.Designation__c;
							cpList.add(cp);
						}
					} else if (acrList != null && !acrList.isEmpty() && acrList.size() > 0 && (isSoleTrader || isIndividual)){
						//W-13540

						Boolean isManagerDesignation = false;
						Boolean isAuthtoActRole = false;
						Boolean isOperatorRole = false;
						for (AccountContactRelation acr : acrList){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = acr.Id;
							cp.salutation = acr.Contact.Salutation;
							cp.initials = acr.Contact.Initials__c;
							cp.lastName = acr.Contact.LastName;
							cp.mobilePhone = acr.Contact.MobilePhone;
							cp.email = acr.Contact.Email;
							cp.roles = acr.Roles;
							// W-13540
							if (acr.Roles != null)
								if (acr.Roles.contains('Individual with Authority to Act')){
									isAuthtoActRole = true;
							}
							if (acr.Roles.contains('Operators on primary accounts ( Internet Main Users, Signatories, Card Users)')){
								isOperatorRole = true;
							}
							if (acr.Designation__c != null)
								if (acr.Designation__c == 'Manager'){
									isManagerDesignation = true;
							}
							if (isSoleTrader && (isAuthtoActRole || isManagerDesignation)){
								cpList.add(cp);
							} else if (isIndividual && (isOperatorRole)){
								cpList.add(cp);
							}
						}
						if (ac != null){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = ac.Id;
							cp.salutation = ac.PersonTitle;
							cp.initials = ac.Initials__pc;
							cp.lastName = ac.LastName;
							cp.mobilePhone = ac.PersonMobilePhone;
							cp.email = ac.PersonEmail;
							cp.roles = 'Individual with Authority to Act';
							cpList.add(cp);
						}

					} else{
						if (ac != null){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = ac.Id;
							cp.salutation = ac.PersonTitle;
							cp.initials = ac.Initials__pc;
							cp.lastName = ac.LastName;
							cp.mobilePhone = ac.PersonMobilePhone;
							cp.email = ac.PersonEmail;
							cp.roles = 'Individual with Authority to Act';
							cpList.add(cp);
						}
					}
					for (merchantOnboardingAuthSignatoryCtrl.contactPerson client : cpList){
						Map<String, String> mapObjAuthSig = new Map<String, String>();
						List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
						mapObjAuthSig.put('Id', client.id);
						if (client.salutation != null){
							mapObjAuthSig.put('Title', client.salutation);
						} else{
							mapObjAuthSig.put('Title', '');
						}
						mapObjAuthSig.put('Last_Name', client.lastname);
						//Mobile Phone, Email and Method
						String mobile;
						if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
							if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
								if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
									mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
								}
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								if (client.mobilePhone != '' && client.mobilePhone != null){
									mobile = '+27' + client.mobilePhone.substring(1, 10);
									mapObjAuthSig.put('Mobile_Phone', mobile);
								}
							}
							if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
								mapObjAuthSig.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
							} else{
								mapObjAuthSig.put('Email', client.email);
							}
							if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
								mapObjAuthSig.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
							} else{
								mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Order__c != '' && signatoryPartyOveridesList.get(0).Preferred_Order__c != null){
								mapObjAuthSig.put('Order', signatoryPartyOveridesList.get(0).Preferred_Order__c);
							} else{
								mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
							}
						} else{
							if (client.mobilePhone != '' && client.mobilePhone != null){
								mobile = '+27' + client.mobilePhone.substring(1, 10);
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								mapObjAuthSig.put('Mobile_Phone', '');
							}
							if (client.email != ''){
								mapObjAuthSig.put('Email', client.email);
							} else{
								mapObjAuthSig.put('Email', '');
							}
							mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
						}
						//W-12954
						//mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
						mapObjAuthSig.put('Role', 'Client'); // this allows us to Overide e.g. the mobile number
						mapObjAuthSig.put('Document_Name', documentName);
						mapObjAuthSig.put('Document_Type', documentType);
						listTotal.add(mapObjAuthSig);
					}
					// } // ends here - marker
				}

			}
		}
		return listTotal;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that calls Impression for document digital signature
	 *
	 * @param documentId
	 * @param signatories
	 * @return String
	 */
	@AuraEnabled
	public static String sendForImpressionSignature(Id documentId, String signatories){
		List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(signatories);
		List<Impressions_Model.Signatory> signatoriesList = new List<Impressions_Model.Signatory>();
		List<Impressions_Model.SignatoryWrapper> wrappers = new List<Impressions_Model.SignatoryWrapper>();
		if (!signatoryList.isEmpty()){
			Integer ii = 0;
			for (JSON2ApexSignatories signatoryParty : signatoryList){
				Impressions_Model.Signatory signatory = new Impressions_Model.Signatory();
				Impressions_Model.SignatoryWrapper wrapper = new Impressions_Model.SignatoryWrapper();
				signatory.title = signatoryList.get(ii).Title;
				signatory.surname = signatoryList.get(ii).Last_Name;
				signatory.email = signatoryList.get(ii).Email;
				signatory.mobile = signatoryList.get(ii).Mobile_Phone;
				Impressions_Model.CustomSignatoryOptions custom = new Impressions_Model.CustomSignatoryOptions();
				//custom.challenge =  'I, Adolf van Niekerk, test test test test test test tes agree on @ease Life insurance quotation:\nPremium R500 per month.\n1. Accept\n9. Decline';
				//custom.challenge =  'I, #{fullname}, agree on @ease Life insurance quotation. \n1. Accept\n9. Decline'.replace('#{fullname}', signatory.surname);
				custom.challenge = 'Absa Onboarding: You are responding to a Customer Onboarding Application. \n Please select \n1-Accept\n9-Reject';
				signatory.custom = custom;
				signatoriesList.add(signatory);
				wrapper.title = signatory.title;
				wrapper.surname = signatory.surname;
				wrapper.mobile = signatory.mobile;
				wrapper.email = signatory.email;
				wrapper.method = signatoryParty.Method;
				if (signatoryParty != null && signatoryParty.Order != null){
					wrapper.order = Integer.valueOf(signatoryParty.Order);//W-12954
				} else{
					wrapper.order = 0;
				}

				wrapper.index = ii + 1;
				wrapper.signatory = signatory;
				wrappers.add(wrapper);
				ii += 1;
			}
		}
		if (test.isRunningTest())
			return 'test done';
		String document = DocumentController.getDocumentContent(documentId);
		String wid = ImpressionsController.sendForSigning(wrappers, document, documentId);
		return wid;
	}

	/**
	 * @description requestSignatureFromUser description
	 *
	 * @param workflowId (String): workflowId
	 */
	public static void requestSignatureFromUser(String workflowId){
		if (workflowId != ''){
			String results = track(workflowId);
			Impressions_Model.WorkflowAuditOutput wfo = (Impressions_Model.WorkflowAuditOutput)JSON.deserializeStrict(results, Impressions_Model.class);
			if (wfo != null && wfo.items.size() > 0){
				signNow(wfo.items[0].SignatureRequestID);
			}
		}
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets all of the clients emails for sharing
	 *
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getAllClientEmails(Id opportunityId){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
		List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
		List<String> emails = new List<String>();
		List<Application__c> applications = new ApplicationsSelector().selectByOpportunityId(opportunityId);
		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (applications.get(0).Preferred_Email__c != null && applications.get(0).Preferred_Email__c != ''){
				emails.add(applications.get(0).Preferred_Email__c);
			}
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).PersonEmail != null && applications.get(0).Preferred_Email__c != accounts.get(0).PersonEmail){
				emails.add(accounts.get(0).PersonEmail);
			}
		} else{
			if (accounts.get(0).PersonEmail != null){
				emails.add(accounts.get(0).PersonEmail);
			}
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Alternative_Email__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email__c){
				emails.add(accounts.get(0).Alternative_Email__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email__c);
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Alternative_Email_1__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_1__c){
				emails.add(accounts.get(0).Alternative_Email_1__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_1__c);
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Alternative_Email_2__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_2__c){
				emails.add(accounts.get(0).Alternative_Email_2__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_2__c);
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Alternative_Email_3__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_3__c){
				emails.add(accounts.get(0).Alternative_Email_3__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_3__c);
		}

		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Alternative_Email_4__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_4__c){
				emails.add(accounts.get(0).Alternative_Email_4__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_4__c);
		}
		// bug raised in UAT - solution is to read also email from Active Email field
		if (!applications.isEmpty() && applications != null && applications.size() > 0){
			if (accounts.get(0).Active_Email__c != null && applications.get(0).Preferred_Email__c != accounts.get(0).Active_Email__c){
				emails.add(accounts.get(0).Active_Email__c);
			}
		} else{
			emails.add(accounts.get(0).Active_Email__c);
		}
		// end bugfix for UAT

		return emails;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets all of the clients emails for the digital signature
	 *
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getAllClientEmailsSignature(Id opportunityId){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
		List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
		List<String> emails = new List<String>();
		List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, accounts.get(0).PersonContactId, 1);
		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
				emails.add(signatoryPartyOveridesList.get(0).Preferred_Email__c);
			}
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).PersonEmail != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).PersonEmail){
				emails.add(accounts.get(0).PersonEmail);
			}
		} else{
			if (accounts.get(0).PersonEmail != null){
				emails.add(accounts.get(0).PersonEmail);
			}
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).Alternative_Email__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email__c){
				emails.add(accounts.get(0).Alternative_Email__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email__c);
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).Alternative_Email_1__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_1__c){
				emails.add(accounts.get(0).Alternative_Email_1__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_1__c);
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).Alternative_Email_2__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_2__c){
				emails.add(accounts.get(0).Alternative_Email_2__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_2__c);
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).Alternative_Email_3__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_3__c){
				emails.add(accounts.get(0).Alternative_Email_3__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_3__c);
		}

		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (accounts.get(0).Alternative_Email_4__c != null && signatoryPartyOveridesList.get(0).Preferred_Email__c != accounts.get(0).Alternative_Email_4__c){
				emails.add(accounts.get(0).Alternative_Email_4__c);
			}
		} else{
			emails.add(accounts.get(0).Alternative_Email_4__c);
		}

		return emails;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets all of the clients mobile numbers
	 *
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getMobile(Id opportunityId){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
		List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
		Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
		List<String> mobile = new List<String>();
		List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, accounts.get(0).PersonContactId, 1);
		if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
			if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
				mobile.add(signatoryPartyOveridesList.get(0).Preferred_Mobile__c);
			}
		}
		if (account.PersonMobilePhone != null){
			mobile.add(account.PersonMobilePhone);
		}
		return mobile;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Gets the LOVs for Digital Signatory input field
	 *
	 * @param fld
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getDigitalSignatorySelectOptions(string fld){
		List<String> allOpts = new list<String>();
		Digital_Signature_Signatory__c dss = new Digital_Signature_Signatory__c();
		Schema.sObjectType objType = dss.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : values){
			allOpts.add(a.getValue());
		}
		allOpts.sort();
		return allOpts;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets an updated list of all signatory items for a document
	 *
	 * @param opportunityId
	 * @param documentId
	 * @param signatoryId
	 * @param signatoriesInput
	 * @param method
	 * @param mobile
	 * @param email
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getUpdatedSignatoriesData(Id opportunityId, Id documentId, Id signatoryId, String signatoriesInput, String method, String mobile, String email){
		//Overide method, mobile, email for a signatory party
		if (email != '' || mobile != '' || method != ''){
			List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, signatoryId, 1);
			if (signatoryPartyOveridesList.isEmpty() || signatoryPartyOveridesList == null || signatoryPartyOveridesList.size() < 1){
				Signatory_Party_Overide__c signatoryPartyOveride = new Signatory_Party_Overide__c();
				signatoryPartyOveride.Opportunity__c = opportunityId;
				signatoryPartyOveride.Signatory_Party__c = signatoryId;
				if (email != ''){
					signatoryPartyOveride.Preferred_Email__c = email;
				}
				if (mobile != ''){
					signatoryPartyOveride.Preferred_Mobile__c = mobile;
				}
				if (method != ''){
					signatoryPartyOveride.Preferred_Method__c = method;
				}
					insert signatoryPartyOveride;

			} else{
				if (email != ''){
					signatoryPartyOveridesList.get(0).Preferred_Email__c = email;
				}
				if (mobile != ''){
					signatoryPartyOveridesList.get(0).Preferred_Mobile__c = mobile;
				}
				if (method != ''){
					signatoryPartyOveridesList.get(0).Preferred_Method__c = method;
				}
					update signatoryPartyOveridesList.get(0);

			}
		}

		Document__c doc = new DocumentsSelector().selectById(documentId);
		String documentType = doc.Type__c;
		String documentName = doc.Name;
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(signatoriesInput);
		if (!signatoryList.isEmpty() && signatoryList != null && signatoryList.size() > 0){
			Integer ii = 0;
			for (JSON2ApexSignatories signatoryParty : signatoryList){
				Map<String, String> mapObj = new Map<String, String>();
				mapObj.put('Id', signatoryList.get(ii).Id);
				mapObj.put('Title', signatoryList.get(ii).Title);
				mapObj.put('Last_Name', signatoryList.get(ii).Last_Name);
				if (signatoryId == signatoryList.get(ii).Id && mobile != signatoryList.get(ii).Mobile_Phone && mobile != ''){
					//Verify mobile number format is compatible with Impression format.
					if (mobile.length() == 10){
						mobile = '+27' + mobile.substring(1, 10);
						mapObj.put('Mobile_Phone', mobile);
					}
				} else{
					mapObj.put('Mobile_Phone', signatoryList.get(ii).Mobile_Phone);
				}

				if (signatoryId == signatoryList.get(ii).Id && email != signatoryList.get(ii).Email && email != ''){
					mapObj.put('Email', email);
				} else{
					mapObj.put('Email', signatoryList.get(ii).Email);
				}
				mapObj.put('Order', signatoryList.get(ii).Order);
				mapObj.put('Role', signatoryList.get(ii).Role);
				if (signatoryId == signatoryList.get(ii).Id && method != signatoryList.get(ii).Method && method != ''){
					mapObj.put('Method', method);
				} else{
					mapObj.put('Method', signatoryList.get(ii).Method);
				}
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
				ii += 1;
			}
		}
		return listTotal;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that indicates if the document is restricted for digital signature (either In Progress, Signed or not eligible)
	 *
	 * @param opportunityId
	 * @param documentId
	 * @return boolean
	 */
	@AuraEnabled
	public static boolean documentRestricted(Id opportunityId, Id documentId){
		boolean restricted = false;
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'In Progress');
		if (!impressionRequests.isEmpty() && impressionRequests != null && impressionRequests.size() > 0){
			restricted = true;
		}
		List<ImpressionRequest__c> impressionRequests2 = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'Signed');
		if (!impressionRequests2.isEmpty() && impressionRequests2 != null && impressionRequests2.size() > 0){
			restricted = true;
		}
		Document__c doc = new DocumentsSelector().selectById(documentId);
		if (doc.Document_Status__c == 'Signed Manually' || doc.Document_Status__c == 'Signed Digitally'){
			restricted = true;
		}
		return restricted;
	}

	/**
	 * @description Method that checks if the casa screening has been done on init
	 *
	 * @param oppId - opportunity Id
	 * @return String - casa status i.e. valid, invalid etc.
	 */
	@AuraEnabled
	public static String checkCASAValidity(Id oppId){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

		return opportunities.get(0).CASA_Status__c;
		//return 'Valid';
	}

	/**
	 * @description getUserRole description
	 *
	 * @param oppId (Id): oppId
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String getUserRole(Id oppId){

		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		if (opportunities[0].OwnerId == UserInfo.getUserId()){
			//Is Adviser
			return 'Adviser';
		} else{
			List<OpportunityTeamMember> oppMemberList = [SELECT Advisor__c, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId
			                                             FROM OpportunityTeamMember
			                                             WHERE OpportunityId = :oppId];
			Boolean isAssistant = false;

			for (OpportunityTeamMember oppMember : oppMemberList){
				if (oppMember.UserId == UserInfo.getUserId()){
					if (oppMember.TeamMemberRole == 'Assistant'){
						isAssistant = true;
					}
				}
			}
			if (isAssistant){
				//Is Assistant
				return 'Assistant';
			} else{
				//Not Access
				return 'No Access';
			}
		}
	}

	/**
	 * @description getDocs
	 * @param opportunityId
	 * @return List<string>
	 */
	@AuraEnabled
	public static List<string> getDocs(Id opportunityId){
		return DocumentManagementControler.getDocs(opportunityId);
	}

	/**
	 * @description getAllMandatoryDocuments description
	 *
	 * @param Entitytype (string): Entitytype
	 * @return List<Mandatory_Doc__mdt>: Return description
	 */
	@AuraEnabled
	public static List<Mandatory_Doc__mdt> getAllMandatoryDocuments(string Entitytype){
		return DocumentManagementControler.getAllMandatoryDocuments(Entitytype);
	}

	/**
	 * @description updateOpportunity description
	 *
	 * @param recordId (String): recordId
	 * @param docFlag (String): docFlag
	 * @return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> updateOpportunity(String recordId, String docFlag){
		return DocumentManagementControler.updateOpportunity(recordId, docFlag);
	}

	/**
	 * @description getPrimaryClientMandatoryDocuments
	 * @param Entitytype
	 * @param OppId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getPrimaryClientMandatoryDocuments(String Entitytype, String OppId){
		return DocumentManagementControler.getPrimaryClientMandatoryDocuments(Entitytype, OppId);
	}

	/**
	 * @description track description
	 *
	 * @param wfid (String): wfid
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String track(String wfid){
		String results = ImpressionsController.track2(wfid);
		return results;
	}

	/**
	 * @description ignNow
	 * @param SignatureRequestId
	 */
	@AuraEnabled
	public static void signNow(String SignatureRequestId){
		new Impressions_IH_v1().createAuthenticationIntent(SignatureRequestId);
	}

	/**
	 * @author Anka Ganta
	 * @description Method that gets a list of selected signatories for a document : W-012954
	 * @param documentId
	 * @param acrRecs
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getSignatoriesDataSelected(Id documentId, List<Id> acrRecs){
		Set<Id> acrRecsSet = new Set<Id>();
		acrRecsSet.addAll(acrRecs);

		Document__c doc = new DocumentsSelector().selectById(documentId);
		String documentType = doc.Type__c;
		String documentName = doc.Name;
		Id opportunityId = doc.Opportunity__c;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		string oppRecordTypeName = opportunities.get(0).RecordType.Name;
		List<Digital_Signature_Admin__c> admin = new DigitalSignatureAdminsSelector().selectDigitalSignatureAdminByType(documentType);
		Id adminId; // validation added in case Admin not setup
		//  W-004546 - Tinashe Shoko
		if (!admin.isEmpty() && admin.size() > 0 && admin != null){
			adminId = admin.get(0).Id;
		} else{
			return null;
		}
		List<Digital_Signature_Signatory__c> signatories = new DigitalSignatorySignatoriesSelector().selectSignatoryByRecordType(adminId,oppRecordTypeName);
		if (signatories.isEmpty() || signatories.size() <= 0 || signatories == null){
			// validation added in case Admin not setup
			//W-004546 - Tinashe Shoko
			return null;
		}
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		for (Integer i = 0; i < signatories.size(); i++){
			Map<String, String> mapObj = new Map<String, String>();

			if (signatories[i].Signatory_Type__c == 'Parent Owner'){
				User adviser = new UsersSelector().selectById(opportunities.get(0).OwnerId);
				mapObj.put('Id', adviser.Id);
				mapObj.put('Title', 'Advisor.');
				mapObj.put('Last_Name', adviser.LastName);
				String phoneNumber = adviser.MobilePhone;
				//Verify User's mobile number format is compatible with Impression format. Salesforce User's mobile number format is '+27 0600000000', so remove space and 0
				if (phoneNumber != null && phoneNumber != ''){
					if (phoneNumber.substring(0, 4) == '+27 '){
						phoneNumber = phoneNumber.substring(0, 3)+phoneNumber.substring(5, 14);
					}
				}
				mapObj.put('Mobile_Phone', phoneNumber);
				mapObj.put('Email', adviser.Email);
				mapObj.put('Order', String.valueOf(signatories[i].Order__c));
				mapObj.put('Role', 'Adviser');
				mapObj.put('Method', signatories[i].Preferred_Method__c);
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Parent Customer'){
				Account client = new AccountsSelector().selectById(opportunities.get(0).AccountId);
				List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.PersonContactId, 1);
				mapObj.put('Id', client.PersonContactId);
				if (client.Salutation != null){
					mapObj.put('Title', client.Salutation);
				} else{
					mapObj.put('Title', '');
				}
				mapObj.put('Last_Name', client.LastName);
				//Mobile Phone, Email and Method
				String mobile;
				if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList.size() > 0 && signatoryPartyOveridesList != null){
					if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
						if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
							mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
						}
						mapObj.put('Mobile_Phone', mobile);
					} else{
						if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null){
							mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
							mapObj.put('Mobile_Phone', mobile);
						}
					}

					if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
						mapObj.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
					} else{
						mapObj.put('Email', client.PersonEmail);
					}

					if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
						mapObj.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
					} else{
						mapObj.put('Method', signatories[i].Preferred_Method__c);
					}
				} else{
					if (client.PersonMobilePhone != '' && client.PersonMobilePhone != null){
						mobile = '+27' + client.PersonMobilePhone.substring(1, 10);
						mapObj.put('Mobile_Phone', mobile);
					} else{
						mapObj.put('Mobile_Phone', '');
					}
					if (client.PersonEmail != ''){
						mapObj.put('Email', client.PersonEmail);
					} else{
						mapObj.put('Email', '');
					}
					mapObj.put('Method', signatories[i].Preferred_Method__c);
				}
				mapObj.put('Order', String.valueOf(signatories[i].Order__c));
				mapObj.put('Role', 'Client');
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Authorised Signatory'){
				//String roles = '\'Individual with Authority to Act\'';
				List<OpportunityLineItem> oppLineList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunities.get(0).Id, 1);
				if (oppLineList != null && !oppLineList.isEmpty() && oppLineList.size() > 0){
					// check if there are contacts found
					// below line chnaged to search by and get details of identified Contact Person W-004546 - Tinashe Shoko
					//List<AccountContactRelation> acrList =  new AccountContactRelationSelector().selectRelationByAcctIdAndRoles(opportunities.get(0).AccountId, roles);
					AccountContactRelationSelector acrselector = new AccountContactRelationSelector();
					List<AccountContactRelation> acrList = acrselector.selectById(acrRecsSet);
					List<merchantOnboardingAuthSignatoryCtrl.contactPerson> cpList = new List<merchantOnboardingAuthSignatoryCtrl.contactPerson>();
					// changes made here to cater for person account if there is not ACR record
					if (acrList != null && !acrList.isEmpty() && acrList.size() > 0){
						for (AccountContactRelation acr : acrList){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = acr.Id;
							cp.salutation = acr.Contact.Salutation;
							cp.initials = acr.Contact.Initials__c;
							cp.lastName = acr.Contact.LastName;
							cp.mobilePhone = acr.Contact.MobilePhone;
							cp.email = acr.Contact.Email;
							cp.roles = acr.Roles;
							cpList.add(cp);
						}
					} else{
						Account ac = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
						if (ac != null){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = ac.Id;
							cp.salutation = ac.PersonTitle;
							cp.initials = ac.Initials__pc;
							cp.lastName = ac.LastName;
							cp.mobilePhone = ac.PersonMobilePhone;
							cp.email = ac.PersonEmail;
							cp.roles = 'Individual with Authority to Act';
							cpList.add(cp);
						}
					}
					for (merchantOnboardingAuthSignatoryCtrl.contactPerson client : cpList){
						Map<String, String> mapObjAuthSig = new Map<String, String>();

						List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
						mapObjAuthSig.put('Id', client.id);
						if (client.salutation != null){
							mapObjAuthSig.put('Title', client.salutation);
						} else{
							mapObjAuthSig.put('Title', '');
						}
						mapObjAuthSig.put('Last_Name', client.lastname);
						//Mobile Phone, Email and Method
						String mobile;

						if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
							if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
								if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
									mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
								}
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								if (client.mobilePhone != '' && client.mobilePhone != null){
									mobile = '+27' + client.mobilePhone.substring(1, 10);
									mapObjAuthSig.put('Mobile_Phone', mobile);
								}
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
								mapObjAuthSig.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
							} else{
								mapObjAuthSig.put('Email', client.email);
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
								mapObjAuthSig.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
							} else{
								mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
							}
						} else{
							if (client.mobilePhone != '' && client.mobilePhone != null){
								mobile = '+27' + client.mobilePhone.substring(1, 10);
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								mapObjAuthSig.put('Mobile_Phone', '');
							}
							if (client.email != ''){
								mapObjAuthSig.put('Email', client.email);
							} else{
								mapObjAuthSig.put('Email', '');
							}
							mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
						}
						mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
						mapObjAuthSig.put('Role', 'Client'); // this allows us to Overide e.g. the mobile number
						mapObjAuthSig.put('Document_Name', documentName);
						mapObjAuthSig.put('Document_Type', documentType);
						listTotal.add(mapObjAuthSig);
					}
					// } // ends here - marker
				}
			} else if (signatories[i].Signatory_Type__c == 'Related Party Signatory'){

				List<OpportunityLineItem> oppLineList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunities.get(0).Id, 1);
				if (oppLineList != null && !oppLineList.isEmpty() && oppLineList.size() > 0){
					// check if there are contacts found
					// below line chnaged to search by and get details of identified Contact Person W-004546 - Tinashe Shoko
					AccountContactRelationSelector acrselector = new AccountContactRelationSelector();
					List<AccountContactRelation> acrList = acrselector.selectById(acrRecsSet);
					List<merchantOnboardingAuthSignatoryCtrl.contactPerson> cpList = new List<merchantOnboardingAuthSignatoryCtrl.contactPerson>();
					// changes made here to cater for person account if there is not ACR record
					if (acrList != null && !acrList.isEmpty() && acrList.size() > 0){
						for (AccountContactRelation acr : acrList){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = acr.Id;
							cp.salutation = acr.Contact.Salutation;
							cp.initials = acr.Contact.Initials__c;
							cp.lastName = acr.Contact.LastName;
							cp.mobilePhone = acr.Contact.MobilePhone;
							cp.email = acr.Contact.Email;
							cp.roles = acr.Roles;
							cpList.add(cp);
						}
					} else{
						Account ac = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
						if (ac != null){
							merchantOnboardingAuthSignatoryCtrl.contactPerson cp = new merchantOnboardingAuthSignatoryCtrl.contactPerson();
							cp.id = ac.Id;
							cp.salutation = ac.PersonTitle;
							cp.initials = ac.Initials__pc;
							cp.lastName = ac.LastName;
							cp.mobilePhone = ac.PersonMobilePhone;
							cp.email = ac.PersonEmail;
							cp.roles = 'Individual with Authority to Act';
							cpList.add(cp);
						}
					}
					for (merchantOnboardingAuthSignatoryCtrl.contactPerson client : cpList){
						Map<String, String> mapObjAuthSig = new Map<String, String>();
						List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
						mapObjAuthSig.put('Id', client.id);
						if (client.salutation != null){
							mapObjAuthSig.put('Title', client.salutation);
						} else{
							mapObjAuthSig.put('Title', '');
						}
						mapObjAuthSig.put('Last_Name', client.lastname);
						//Mobile Phone, Email and Method
						String mobile;
						if (!signatoryPartyOveridesList.isEmpty() && signatoryPartyOveridesList != null && signatoryPartyOveridesList.size() > 0){
							if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c != '' && signatoryPartyOveridesList.get(0).Preferred_Mobile__c != null){
								if (signatoryPartyOveridesList.get(0).Preferred_Mobile__c.length() == 10){
									mobile = '+27' + signatoryPartyOveridesList.get(0).Preferred_Mobile__c.substring(1, 10);
								}
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								if (client.mobilePhone != '' && client.mobilePhone != null){
									mobile = '+27' + client.mobilePhone.substring(1, 10);
									mapObjAuthSig.put('Mobile_Phone', mobile);
								}
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Email__c != '' && signatoryPartyOveridesList.get(0).Preferred_Email__c != null){
								mapObjAuthSig.put('Email', signatoryPartyOveridesList.get(0).Preferred_Email__c);
							} else{
								mapObjAuthSig.put('Email', client.email);
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Method__c != '' && signatoryPartyOveridesList.get(0).Preferred_Method__c != null){
								mapObjAuthSig.put('Method', signatoryPartyOveridesList.get(0).Preferred_Method__c);
							} else{
								mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
							}

							if (signatoryPartyOveridesList.get(0).Preferred_Order__c != '' && signatoryPartyOveridesList.get(0).Preferred_Order__c != null){
								mapObjAuthSig.put('Order', signatoryPartyOveridesList.get(0).Preferred_Order__c);
							} else{
								mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
							}
						} else{
							if (client.mobilePhone != '' && client.mobilePhone != null){
								mobile = '+27' + client.mobilePhone.substring(1, 10);
								mapObjAuthSig.put('Mobile_Phone', mobile);
							} else{
								mapObjAuthSig.put('Mobile_Phone', '');
							}
							if (client.email != ''){
								mapObjAuthSig.put('Email', client.email);
							} else{
								mapObjAuthSig.put('Email', '');
							}
							mapObjAuthSig.put('Method', signatories[i].Preferred_Method__c);
						}

						//mapObjAuthSig.put('Order', String.valueOf(signatories[i].Order__c));
						mapObjAuthSig.put('Role', 'Client'); // this allows us to Overide e.g. the mobile number
						mapObjAuthSig.put('Document_Name', documentName);
						mapObjAuthSig.put('Document_Type', documentType);
						listTotal.add(mapObjAuthSig);
					}
					// } // ends here - marker
				}

			}
		}
		return listTotal;
	}

	/**
	 * @author Anka Ganta
	 * @description Method that gets an updated list of all signatory items for a document : W-012954
	 *
	 * @param opportunityId
	 * @param documentId
	 * @param signatoryId
	 * @param signatoriesInput
	 * @param method
	 * @param mobile
	 * @param email
	 * @param order
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getUpdatedSignatoriesDataSelected(Id opportunityId, Id documentId, Id signatoryId, String signatoriesInput, String method, String mobile, String email, String order){
		//Overide method, mobile, email for a signatory party
		if (email != '' || mobile != '' || method != ''){
			List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, signatoryId, 1);
			if (signatoryPartyOveridesList.isEmpty() || signatoryPartyOveridesList == null || signatoryPartyOveridesList.size() < 1){
				Signatory_Party_Overide__c signatoryPartyOveride = new Signatory_Party_Overide__c();
				signatoryPartyOveride.Opportunity__c = opportunityId;
				signatoryPartyOveride.Signatory_Party__c = signatoryId;
				if (email != ''){
					signatoryPartyOveride.Preferred_Email__c = email;
				}
				if (mobile != ''){
					signatoryPartyOveride.Preferred_Mobile__c = mobile;
				}
				if (method != ''){
					signatoryPartyOveride.Preferred_Method__c = method;
				}
				if (order != ''){
					signatoryPartyOveride.Preferred_Order__c = order;
				}
					insert signatoryPartyOveride;

			} else{
				if (email != ''){
					signatoryPartyOveridesList.get(0).Preferred_Email__c = email;
				}
				if (mobile != ''){
					signatoryPartyOveridesList.get(0).Preferred_Mobile__c = mobile;
				}
				if (method != ''){
					signatoryPartyOveridesList.get(0).Preferred_Method__c = method;
				}
				if (order != ''){
					signatoryPartyOveridesList.get(0).Preferred_Order__c = order;
				}
					update signatoryPartyOveridesList.get(0);

			}
		}

		Document__c doc = new DocumentsSelector().selectById(documentId);
		String documentType = doc.Type__c;
		String documentName = doc.Name;
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		List<JSON2ApexSignatories> signatoryList = JSON2ApexSignatories.parse(signatoriesInput);
		if (!signatoryList.isEmpty() && signatoryList != null && signatoryList.size() > 0){
			Integer ii = 0;
			for (JSON2ApexSignatories signatoryParty : signatoryList){
				Map<String, String> mapObj = new Map<String, String>();
				mapObj.put('Id', signatoryList.get(ii).Id);
				mapObj.put('Title', signatoryList.get(ii).Title);
				mapObj.put('Last_Name', signatoryList.get(ii).Last_Name);
				if (signatoryId == signatoryList.get(ii).Id && mobile != signatoryList.get(ii).Mobile_Phone && mobile != ''){
					//Verify mobile number format is compatible with Impression format.
					if (mobile != null)
						if (mobile.length() == 10){
							mobile = '+27' + mobile.substring(1, 10);
						mapObj.put('Mobile_Phone', mobile);
					}
				} else{
					mapObj.put('Mobile_Phone', signatoryList.get(ii).Mobile_Phone);
				}

				if (signatoryId == signatoryList.get(ii).Id && email != signatoryList.get(ii).Email && email != ''){
					mapObj.put('Email', email);
				} else{
					mapObj.put('Email', signatoryList.get(ii).Email);
				}
				//mapObj.put('Order', signatoryList.get(ii).Order);
				mapObj.put('Role', signatoryList.get(ii).Role);
				if (signatoryId == signatoryList.get(ii).Id && method != signatoryList.get(ii).Method && method != ''){
					mapObj.put('Method', method);
				} else{
					mapObj.put('Method', signatoryList.get(ii).Method);
				}
				//W-012954
				if (signatoryId == signatoryList.get(ii).Id && order != signatoryList.get(ii).Order && order != ''){
					mapObj.put('Order', order);
				} else{
					mapObj.put('Order', signatoryList.get(ii).Order);
				}
				mapObj.put('Document_Name', documentName);
				mapObj.put('Document_Type', documentType);
				listTotal.add(mapObj);
				ii += 1;
			}
		}

		return listTotal;
	}
}