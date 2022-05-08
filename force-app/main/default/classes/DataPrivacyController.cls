/**
 * @description Lightning Component Controller For Set/Reset Data Privacy Flag
 * @author  Ashish Goyal : Absa
 * @version v1.0
 * @date   2021-06-15
 **/
public class DataPrivacyController {
	/**
	 * @description getPrivacyFieldValue
	 * @param accountId
	 * @return AccountDataWrapper
	 **/
	@auraEnabled
	public static AccountDataWrapper getPrivacyFieldValue(string accountId) {
		List<String> list_DataPrivacyValue = new List<String>();
		List<String> list_AccDataPrivacy = new List<String>();

		// getting value from data privacy flag field
		if (accountId != null && accountId != '') {
			List<Account> list_Acc = new AccountsSelector().selectById(new Set<Id>{ accountId });
			for (Account acc : list_Acc) {
				if (acc.Data_Privacy_Flag__c != null && acc.Data_Privacy_Flag__c != '') {
					list_AccDataPrivacy = acc.Data_Privacy_Flag__c.split(';');
				}
			}
		}
		list_DataPrivacyValue = DataPrivacyController.getPiklistValues();
		AccountDataWrapper accWrapper = new AccountDataWrapper();
		accWrapper.list_DataPrivacy = list_AccDataPrivacy;
		accWrapper.list_SelectedData = list_AccDataPrivacy;
		return accWrapper;
	}

	/**
	 * @description updateDataPrivacyFlag
	 * @param caseId
	 * @param privacyData
	 * @return String
	 **/
	@auraEnabled
	public static String updateDataPrivacyFlag(string caseId, string privacyData) {
		Set<id> set_AttachmentIds = new Set<Id>();
		if (caseId != null && caseId != '') {
			boolean isChanged = false;
			List<Account> list_Account = new List<Account>();
			string accDataPrivacy = '';
			string accountId = '';

			// getting value from data privacy flag field on account and attachment ids from case
			for (Case caseObj : new CasesSelector().selectByIdWithAccountInfo(new Set<Id>{ caseId }, 1)) {
				accDataPrivacy = caseObj.Account.Data_Privacy_Flag__c;
				accountId = caseObj.AccountId;
			}

			for (contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid = :caseId]) {
				set_AttachmentIds.add(CDLink.ContentDocumentid);
			}

			string privacyDataStr;
			if (privacyData == null) {
				list_Account.add(new Account(Id = accountId, Data_Privacy_Flag__c = null));
			} else {
				privacyData = privacyData.removeEnd(',');
				for (string accDataStr : privacyData.split(',')) {
					if (accDataPrivacy != null && !accDataPrivacy.contains(accDataStr)) {
						accDataPrivacy = accDataStr + ';' + accDataPrivacy;
						isChanged = true;
					}
				}
				if (accDataPrivacy == null) {
					privacyDataStr = privacyData.replaceAll(',', ';');
					+isChanged = true;
				} else {
					privacyDataStr = accDataPrivacy;
				}
			}
			if (isChanged) {
				list_Account.add(new Account(Id = accountId, Data_Privacy_Flag__c = privacyDataStr));
				update list_Account;
				//Added Sandeep Golla on 7/1/2021 (W-013051)
				//Calling DPChildCaseCreation to create child case for RB SBU segements
				DPChildCaseCreation.createChildCaseRB(caseId, accountId);
			}
			// retrieve the list of receipient
			List<String> list_emailAddress = new List<String>();
			String emailAdd = Label.DataPrivacy_BU_EmailAddress;
			list_emailAddress = emailAdd.split(',');

			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			sendFlagNotificationEmail(accountId, targetObjectId, list_emailAddress, 'DataPrivacy_BU_FlagConfirmationTemplate', set_AttachmentIds);
			return 'Success';
		}
		return 'Failed';
	}

	/**
	 * @description updateDataPrivacyFlag
	 * @param accountId
	 * @param privacyData
	 * @return String
	 **/
	@auraEnabled
	public static String resetDataPrivacyFlag(string accountId, List<string> privacyData) {
		if (accountId != null && accountId != '') {
			List<Account> list_Account = new List<Account>();
			if (privacyData == null) {
				list_Account.add(new Account(Id = accountId, Data_Privacy_Flag__c = null));
			} else {
				string privacyDataStr;
				//string privacyDataStr = privacyData.replaceAll(',',';');
				for (string str : privacyData) {
					if (privacyDataStr == null) {
						privacyDataStr = str;
					} else {
						privacyDataStr = privacyDataStr + ';' + str;
					}
				}
				list_Account.add(new Account(Id = accountId, Data_Privacy_Flag__c = privacyDataStr));
			}
			update list_Account;
			return 'Success';
		}
		return 'Failed';
	}

	/**
	 * @description getPiklistValues
	 * @return List <String>
	 **/
	@AuraEnabled
	public static List<String> getPiklistValues() {
		List<String> plValues = new List<String>();
		Map<String, List<CustomSelectOptions>> map_FieldOptions = Sys_Utilities_General.getMultipleSelectOptions(
			new List<String>{ 'Account.Data_Privacy_Flag__c' }
		);
		for (CustomSelectOptions customSelectOption : map_FieldOptions.get('Account.Data_Privacy_Flag__c')) {
			plValues.add(customSelectOption.value);
		}
		plValues.sort();
		return plValues;
	}

	/**
	 * @description getDataPrivacyFlagIndiatorVal
	 * @param accountId
	 * @return string
	 **/
	@auraEnabled
	public static string getDataPrivacyFlagIndiatorVal(string accountId) {
		string dataFlag = '';
		if (accountId != null && accountId != '') {
			List<Account> list_Acc = new AccountsSelector().selectById(new Set<Id>{ accountId });
			for (Account acc : list_Acc) {
				if (acc.Data_Privacy_Flag__c != null && acc.Data_Privacy_Flag__c != '') {
					dataFlag = acc.Data_Privacy_Flag__c.replaceAll(';', ', ');
				}
			}
		}
		return dataFlag;
	}

	/**
	 * @description sendFlagNotificationEmail
	 * @param accountId
	 * @param contactId
	 * @param emailAddress
	 * @param templateName
	 * @param set_AttachmentId
	 **/
	public static void sendFlagNotificationEmail(String accountId, String contactId, List<String> emailAddress, String templateName, Set<id> set_AttachmentId) {
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'businessbanking@absa.africa'];

		List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(accountId, contactId, emailAddress[0], templateName);
		Messaging.SingleEmailMessage email = constructEmail.get(0);

		String htmlBody = email.getHTMLBody();
		email.setHtmlBody(htmlBody);
		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
		String emailBody = email.getHtmlBody();
		email.setOrgWideEmailAddressId(owea.get(0).Id);
		email.setToAddresses(emailAddress);
		email.setHtmlBody(htmlBody);
		email.setSaveAsActivity(true);

		List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
		for (ContentVersion cversion : [SELECT title, PathOnClient, FileType, versiondata FROM contentversion WHERE ContentDocumentId IN :set_AttachmentId]) {
			blob WOCFbody = cversion.versiondata;
			Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
			emailAttachment.setFileName(cversion.PathOnClient);
			emailAttachment.setBody(WOCFbody);
			attachments.add(emailAttachment);
		}
		email.setFileAttachments(attachments);

		List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
		for (Messaging.SendEmailResult emailRes : emailResults) {
			if (!emailRes.success) {
				throw new AuraHandledException('Email is not sent successfully.');
			}
		}
	}

	/**
	 * @description callC1VCreateAPI
	 * @param caseId
	 * @param privacyData
	 * @return string
	 **/
	@AuraEnabled
	public static string callC1VCreateAPI(string caseId, string privacyData) {
		string accountCIF = '';
		Map<String, String> map_FlagValues = new Map<String, String>();
		for (Case caseObj : new CasesSelector().selectByIdWithAccountInfo(new Set<Id>{ caseId }, 1)) {
			//[SELECT Id, Account.CIF__c FROM Case WHERE Id =: caseId]){
			accountCIF = caseObj.Account.CIF__c;
		}

		if (privacyData != null) {
			privacyData = privacyData.removeEnd(',');
			for (string flagVal : privacyData.split(',')) {
				map_FlagValues.put(flagVal, 'Yes');
			}
		}

		// invoking C1V API
		InvolvedParties_Resp_IB_v1 respObj = InvolvedParties_IH_v1.involvedPartiesFlagging(map_FlagValues, 'create', accountCIF);
		if (respObj.content != null) {
			return 'Success';
		} else {
			if (respObj.code != null && respObj.description != null) {
				return respObj.code + ' : ' + respObj.description;
			} else {
				return 'Unexcepted error code. Please contact system admin.';
			}
		}
	}

	/**
	 * @description updateDataPrivacyFlag
	 * @param accountId
	 * @param privacyData
	 * @return string
	 **/
	@AuraEnabled
	public static string callC1VUpdateAPI(string accountId, List<string> privacyData) {
		string accountCIF = '';
		string accountFlag;
		Map<String, String> map_FlagValues = new Map<String, String>();
		List<Account> list_Acc = new AccountsSelector().selectById(new Set<Id>{ accountId });
		for (Account accObj : list_Acc) {
			accountCIF = accObj.CIF__c;
			accountFlag = accObj.Data_Privacy_Flag__c;
		}

		if (privacyData == null) {
			for (string flagStr : accountFlag.split(';')) {
				map_FlagValues.put(flagStr, 'No');
			}
		} else if (privacyData != null) {
			for (string flagStr : accountFlag.split(';')) {
				boolean isMatch = false;
				for (string flagVal : privacyData) {
					if (flagVal == flagStr) {
						isMatch = true;
						break;
					}
				}
				if (!isMatch) {
					map_FlagValues.put(flagStr, 'No');
				}
			}
		}

		// invoking C1V API
		InvolvedParties_Resp_IB_v1 respObj = InvolvedParties_IH_v1.involvedPartiesFlagging(map_FlagValues, 'update', accountCIF);
		if (respObj.content != null) {
			return 'Success';
		} else {
			if (respObj.code != null && respObj.description != null) {
				return respObj.code + ' : ' + respObj.description;
			} else {
				return 'Unexcepted error code. Please contact system admin.';
			}
		}
	}

	/**
	 * @description Account Wrapper is used to Reset Data Privacy Flag
	 **/
	public class AccountDataWrapper {
		/**
		 * @description list_SelectedData
		 **/
		@auraEnabled
		public List<String> list_SelectedData { get; set; }
		/**
		 * @description list_DataPrivacy
		 **/
		@auraEnabled
		public List<String> list_DataPrivacy { get; set; }
	}
}