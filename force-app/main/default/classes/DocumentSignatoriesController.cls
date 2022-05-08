/**
 * @description DocumentSignatoriesController Description
 *
 */
public class DocumentSignatoriesController{
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
		try{
			ImpressionsController.updateImpressionRequests(opportunityId);
		} catch (Exception e){
			System.debug('An unexpected error has occurred: ' + e.getMessage());
		}

		List<Document__c> documents = new DocumentsSelector().getDocuments(opportunityId, 'Opportunity', 100);
		return documents;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets the name of the adviser (loged in user) for the documents share declaration
	 *
	 * @return String
	 */
	@AuraEnabled
	public static String fetchAdviserName(){
		return UserInfo.getName();
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets the name of the Opportunity Owner for the documents share declaration
	 *
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String fetchOppOwnerName(Id oppId){
		List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<User> userList = [SELECT Name
		                       FROM User
		                       WHERE Id = :opportunityList[0].OwnerId];
		return userList[0].Name;
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
	 * @description Method that gets a list of all signatories for a document
	 *
	 * @param documentId
	 * @param documentTemplateName
	 * @param oppId
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getSignatoriesData(Id documentId, String documentTemplateName, Id oppId){
		String documentType;
		String documentName;
		Id opportunityId;
		Document_Template__c selectedTemplate = new DocumentTemplateSelector().selectTemplateByType(documentTemplateName);

		if (documentId != null){
			Document__c doc = new DocumentsSelector().selectById(documentId);
			documentType = doc.Type__c;
			documentName = doc.Name;
			opportunityId = doc.Opportunity__c;
		}

		if (!String.IsEmpty(documentTemplateName)){
			documentType = documentTemplateName;
			documentName = documentTemplateName;
		}

		if (oppId != null){
			opportunityId = oppId;
		}
		List<Digital_Signature_Admin__c> admin = new DigitalSignatureAdminsSelector().selectDigitalSignatureAdminByType(documentType);

		Id adminId;
		if (!admin.isEmpty() && admin.size() > 0 && admin != null){
			adminId = admin.get(0).Id;
		} else{
			System.debug('Error! Please setup Digital Signature Admin records for ' + documentType);
			return null;
		}
		List<Digital_Signature_Signatory__c> signatories = new DigitalSignatorySignatoriesSelector().selectSignatory(adminId);
		if (signatories.isEmpty() || signatories.size() <= 0 || signatories == null){
			System.debug('Error! Please setup Digital Signature Signatories records for ' + documentType);
			return null;
		}

		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		for (Integer i = 0; i < signatories.size(); i++){
			Map<String, String> mapObj = new Map<String, String>();
			List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);

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
				mapObj.put('Designation', 'Adviser');
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Parent Customer'){
				Account client = new AccountsSelector().selectById(opportunities.get(0).AccountId);
				List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.PersonContactId, 1);
				mapObj.put('Id', client.Id);
				if (client.Salutation != null){
					mapObj.put('Title', client.Salutation);
				} else{
					if (client.PersonTitle != null) {
						mapObj.put('Title', client.PersonTitle);
					}
					else {
						mapObj.put('Title', '');
					}
				}
				if (client.Initials__pc != null){
					mapObj.put('Initials', client.Initials__pc);
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
				mapObj.put('Designation', 'Client');
				listTotal.add(mapObj);
			} else if (signatories[i].Signatory_Type__c == 'Related Party Signatory'){
				//if (accountRecord.Client_Type__c != 'Sole Trader' && accountRecord.Client_Type__c != 'Sole Proprietor'){
				String roles = '\'Individual with Authority to Act\'';
				List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectRelationByAcctIdAndRoles(opportunities.get(0).AccountId, roles);
				List<ContactPerson> cpList = new List<ContactPerson>();

				if (acrList != null && !acrList.isEmpty() && acrList.size() > 0){
					for (AccountContactRelation acr : acrList){
						ContactPerson cp = new ContactPerson();
						cp.id = acr.Id;
						cp.salutation = acr.Contact.Account.PersonTitle;
						cp.initials = acr.Contact.Account.Initials__pc;
						cp.lastName = acr.Contact.LastName;
						cp.mobilePhone = acr.Contact.MobilePhone;
						cp.email = acr.Contact.Email;
						cp.roles = acr.Roles;
						cp.designation = acr.Designation__c;
						cpList.add(cp);
					}

					for (ContactPerson client : cpList){
						Map<String, String> mapObjAuthSig = new Map<String, String>();
						List<Signatory_Party_Overide__c> signatoryPartyOveridesList = new SignatoryPartyOveridesSelector().getSignatoryPartyOverides(opportunityId, client.id, 1);
						mapObjAuthSig.put('Id', client.id);

						if (client.salutation != null){
							mapObjAuthSig.put('Title', client.salutation);
						} else{
							mapObjAuthSig.put('Title', '');
						}

						mapObjAuthSig.put('Last_Name', client.lastname);
						mapObjAuthSig.put('Initials', client.initials);
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
						mapObjAuthSig.put('Role', client.roles); // this allows us to Overide e.g. the mobile number
						mapObjAuthSig.put('Document_Name', documentName);
						mapObjAuthSig.put('Document_Type', documentType);
						mapObjAuthSig.put('Designation', client.designation);
						listTotal.add(mapObjAuthSig);
					}

				}
				//}
			}
		}
		return listTotal;
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
	 * @description Method that indicates if the document is restricted for digital signature (either In Progress, Signed or not eligible)
	 *
	 * @param opportunityId
	 * @param documentId
	 * @return boolean
	 */
	@AuraEnabled
	public static boolean documentRestricted(Id opportunityId, Id documentId){
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'In Progress');
		if (!impressionRequests.isEmpty() && impressionRequests != null && impressionRequests.size() > 0){
			return true;
		}
		List<ImpressionRequest__c> impressionRequests2 = new ImpressionRequestsSelector().selectInProgressRequestsByOpptyIdDocId(opportunityId, documentId, 'Signed');
		if (!impressionRequests2.isEmpty() && impressionRequests2 != null && impressionRequests2.size() > 0){
			return true;
		}
		Document__c doc = new DocumentsSelector().selectById(documentId);
		if (doc.Document_Status__c == 'Signed Manually' || doc.Document_Status__c == 'Signed Digitally'){
			return true;
		}
		return false;
	}

	/**
	 * @description createDocumentSignatureRequests description
	 * @param opportunityId (Id): opportunityId
	 * @param documentTemplateName (String): documentTemplateName
	 * @param selectedIds (List<Id>): selectedIds
	 * @return List<SignatureRequest__c>: Return description
	 */
	@AuraEnabled
	public static List<SignatureRequest__c> createDocumentSignatureRequests(Id opportunityId, String documentTemplateName, List<Id> selectedIds){
		List<SignatureRequest__c> createdSR = new List<SignatureRequest__c>();
		String email;
		String fullName;
		String title;
		String mobile;
		String phone;
		String designation;
		String signatureType;
		String idNumber;
		String signatoryId;
		String capacity;

		try{
			if (opportunityId != null && String.isEmpty(documentTemplateName) == false){
				for (Integer i = 0; i < selectedIds.size(); i++){
					signatoryId = String.valueof(selectedIds[i]);
					if (signatoryId.StartsWith('005')){
						User signatory = new UsersSelector().selectById(signatoryId);
						email = signatory.Email;
						fullName = signatory.Name;
						title = signatory.Title;
						mobile = signatory.MobilePhone;
					} else{
						// Tinashe - W-004395 - Document Management OptimisationR1
						// Related parties can be either via a ACR record Id or a Person Account Id
						id recId = (id)signatoryId;
						String sObjName = recId.getSObjectType().getDescribe().getName();
						if (sObjName == 'AccountContactRelation'){
							AccountContactRelation signatory = new AccountContactRelationSelector().selectbyAccountContactRelationId(signatoryId);
							email = signatory.Contact.Email;
							fullName = signatory.Contact.FirstName + ' ' + signatory.Contact.LastName;
							title = signatory.Contact.Title;
							mobile = signatory.Contact.MobilePhone;
							phone = signatory.Contact.Phone;
							idNumber = signatory.Contact.Id_number__c;
							designation = signatory.Roles;
							capacity = signatory.Designation__c;
						}
						if (sObjName == 'Account'){
							Account signatory = new AccountsSelector().selectAllById(signatoryId);
							email = signatory.PersonEmail;
							fullName = signatory.FirstName + ' ' + signatory.LastName;
							title = signatory.PersonTitle;
							mobile = signatory.PersonMobilePhone;
							phone = signatory.Phone;
							idNumber = signatory.ID_Number__pc;
							if (signatory.Client_Type__c == 'Sole Trader') {
								capacity = 'Sole Trader';
							}
						}
					}

					SignatureRequest__c newSignatureReq = new SignatureRequest__c();
					newSignatureReq.ContactID__c = selectedIds[i];
					newSignatureReq.Email__c = email;
					newSignatureReq.Fullname__c = fullName;
					newSignatureReq.Title__c = title;
					newSignatureReq.Mobile__c = mobile;
					newSignatureReq.Phone__c = phone;
					newSignatureReq.Role__c = designation;
					newSignatureReq.ID_Passport_Number__c = idNumber;
					newSignatureReq.Step__c = 1;
					newSignatureReq.Capacity__c = capacity;
					createdSR.add(newSignatureReq);
				}
			}
			insert createdSR;
			return createdSR;
		} catch (Exception e){
			System.debug('Exception Occured' + e.getMessage()+' At Line number ' + e.getLineNumber());
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}

	/**
	 * @description getApplicationId description Added by Tinashe
	 *
	 * @param oppId (Id): oppId
	 * @return Id: Return description
	 */
	@AuraEnabled
	public static Id getApplicationId(Id oppId){
		return DocumentManagementControler.getApplicationId(oppId);
	}

/**
 * @description ContactPerson Description
 *
 */
	public class ContactPerson {
/**
 * @description id
 */
		public String id { get; set; }
/**
 * @description salutation
 */
		public String salutation { get; set; }
/**
 * @description initials
 */
        public String initials { get; set; }
/**
 * @description lastName
 */
		public String lastName { get; set; }
/**
 * @description mobilePhone
 */
		public String mobilePhone { get; set; }
/**
 * @description email
 */
		public String email { get; set; }
/**
 * @description roles
 */
		public String roles { get; set; }
/**
 * @description designation
 */
		public String designation { get; set; }
	}
}