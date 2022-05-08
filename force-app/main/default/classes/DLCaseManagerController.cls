/**
 * @description Controller class for DLVoucherDetails cmp
 * @author Jason Quevauvilliers
 * @created 2021-03-02
 */
public without sharing class DLCaseManagerController {
	/**
	 * @description gets the comments for this case as well as the attached vouchers and returns them in a map
	 * @param serviceType
	 * @param caseId
	 * @return Map<String, String>
	 */
	@AuraEnabled
	public static Map<String, String> getData(String serviceType, String caseId) {
		Map<String, String> dataMap = new Map<String, String>();
		//Get Picklist options from Static RestResource
		StaticResource dependentPicklistResource = [SELECT Body FROM StaticResource WHERE Name = 'DL_Rewards_Dependent_Picklist'];
		dataMap.put('picklistOptions', dependentPicklistResource.Body.toString());
		//Get vouchers attached to this case
		List<Voucher__c> voucherList = [
			SELECT Id, Name, Amount__c, Date_of_Purchase__c, Voucher_Expiry_Date__c, Order_Number__c, Purchase_Status__c, Case__c, Account_Number__c
			FROM Voucher__c
			WHERE Case__c = :caseId
		];
		if (voucherList != null && voucherList.size() > 0) {
			dataMap.put('voucherList', JSON.serialize(voucherList));
		}
		//Get existing Comments
		List<CaseComment> commentList = [SELECT CommentBody FROM CaseComment WHERE ParentId = :caseId];
		if (commentList != null && commentList.size() > 0) {
			dataMap.put('commentList', JSON.serialize(commentList));
		}
		return dataMap;
	}

	/**
	 * @description Transfers the Case to a new Service Group
	 * @param serviceGroupName
	 * @param serviceTypeName
	 * @param caseId
	 */
	@AuraEnabled
	public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId) {
		CaseTransferActionExt.transferCase(serviceGroupName, serviceTypeName, caseId);

		//Get Rewards Call Centre Queue
		List<Group> groupList = new GroupsSelector().selectByNameAndType(Label.Digital_Lifestyle_Rewards_Team_Call_Centre, 'Queue');
		//Get Current Case
		List<Case> caseList = new CasesSelector().selectById(new Set<Id>{caseId});
		if(groupList.size() > 0 && caseList.size() == 1){
			//Update Case Owner to the Rewards Call Centre Queue
			caseList[0].OwnerId = groupList[0].Id;
			update caseList;
		}

	}

	/**
	 * @description sends an email
	 * @param caseId
	 * @param emailAddress
	 * @param emailTemplateName
	 * @param voucherListString
	 * @param caseCommentsString
	 * @return String
	 */
	@AuraEnabled
	public static String sendEmail(String caseId, String emailAddress, String emailTemplateName, String voucherListString, String caseCommentsString) {
		OrgWideEmailAddress orgWideAddress = CloseCase.getOrgWideEmailAddress(caseId, null);
		if (orgWideAddress != null) {
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress, emailTemplateName);

			if (constructEmail != null && constructEmail.size() > 0) {
				Messaging.SingleEmailMessage email = constructEmail[0];
				string[] toAddress = new List<string>{ emailAddress };
				String subject = email.getSubject();
				String emailBody = email.getHtmlBody();
				//List of comments
				String htmlBody = '';
				List<CaseComment> commentList = (List<CaseComment>) JSON.deserialize(caseCommentsString, List<CaseComment>.class);
				if (commentList != null && commentList.size() > 0) {
					htmlBody = 'Case Comments: ';
					for (CaseComment comm : commentList) {
						htmlBody += comm.CommentBody + '<br/><br/>';
					}
				}
				//List of Vouchers
				List<Voucher__c> voucherList = (List<Voucher__c>) JSON.deserialize(voucherListString, List<Voucher__c>.class);
				if (voucherList != null && voucherList.size() > 0) {
					for (Voucher__c voucher : voucherList) {
						htmlBody += 'Voucher Name: ' + voucher.Name + '<br/>';
						htmlBody += 'Amount: R' + voucher.Amount__c + '<br/>';
						htmlBody += 'Date of Purchase: ' + Date.valueOf(voucher.Date_of_Purchase__c).format() + '<br/>';
						htmlBody += 'Voucher Expiry: ' + Date.valueOf(voucher.Voucher_Expiry_Date__c).format() + '<br/>';
						htmlBody += 'Order Number: ' + voucher.Order_Number__c + '<br/><br/>';
					}
				}
				emailBody = emailBody.replace('[apexData]', htmlBody);

				Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
				emailMessage.setOrgWideEmailAddressId(orgWideAddress.Id);
				emailMessage.setToAddresses(toAddress);
				emailMessage.setSubject(subject);
				emailMessage.setHtmlBody(emailBody);
				emailMessage.saveAsActivity = false;

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
}