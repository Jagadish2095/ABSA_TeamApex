/**
 * @description Apex controller class for the Aura bundle Payments.
 * @author Simangaliso Mathenjwa
 * @since 2021-11-04
 */
public class AbsaRewardsCloseOrEscalateCTRL {
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
		List<Case> caseList = new CasesSelector().selectById(new Set<Id>{ caseId });
		if (groupList.size() > 0 && caseList.size() == 1) {
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
	 * @param caseComments
	 * @return String
	 */
	@AuraEnabled
	public static String sendEmail(String caseId, String emailAddress, String emailTemplateName, String caseComments) {
		OrgWideEmailAddress orgWideAddress = CloseCase.getOrgWideEmailAddress(caseId, null);
		if (orgWideAddress != null) {
			// workspace if there is an org wide email

			//construct Email
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress, emailTemplateName);

			//Construct an email
			if (constructEmail != null && constructEmail.size() > 0) {
				Messaging.SingleEmailMessage email = constructEmail[0];
				string[] toAddress = new List<string>{ emailAddress };
				String subject = email.getSubject();
				String emailBody = email.getHtmlBody();
				String htmlBody = '';

				List<Case> caseRecord = new CasesSelector().selectByIdWithRecordTypeDeveloperName(Id.valueOf(caseId));
				List<Voucher__c> voucherList = [
					SELECT
						Id,
						Name,
						Reward_Type__c,
						Amount__c,
						Reward_Status__c,
						Date_of_Purchase__c,
						Voucher_Issue_Date__c,
						Voucher_Type_Selected__c,
						Voucher_Pin__c,
						Voucher_Expiry_Date__c,
						Order_Number__c,
						Purchase_Status__c,
						Case__c,
						Account_Number__c,
						Pin_Claimed_In_Time__c
					FROM Voucher__c
					WHERE Case__c = :caseId
					ORDER BY CreatedDate DESC
				];

				htmlBody = 'Case Comments: ';
				htmlBody += caseRecord[0].comments + '<br/><br/>';

				if (!voucherList.isEmpty()) {
					htmlBody += 'Voucher: ' + voucherList[0].Reward_Type__c + '<br/>';
					htmlBody += 'Amount: R' + voucherList[0].Amount__c + '<br/>';
					htmlBody += 'Reward Status: ' + voucherList[0].Reward_Status__c + '<br/>';
					htmlBody += 'Voucher Expiry: ' + Date.valueOf(voucherList[0].Voucher_Expiry_Date__c).format() + '<br/>';
					htmlBody += 'Voucher Issue Date: ' + Date.valueOf(voucherList[0].Voucher_Issue_Date__c).format() + '<br/>';
					htmlBody += 'Voucher Type Selected: ' + voucherList[0].Voucher_Type_Selected__c + '<br/>';
					htmlBody += 'Voucher Pin: ' + voucherList[0].Voucher_Pin__c + '<br/>';
					htmlBody += 'Pin Claimed In Time: ' + voucherList[0].Pin_Claimed_In_Time__c + '<br/>';
					emailBody = emailBody.replace('[apexData]', htmlBody);
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
				caseRecord[0].Status = 'Awaiting External';
				update caseRecord[0];
				return 'Email sent Successfully to';
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
	 * @description sends an email
	 * @param caseId
	 * @return String
	 */
	@AuraEnabled
	public static List<Voucher__c> getAttachedVoucher(String caseId) {
		return [
			SELECT
				Id,
				Name,
				Reward_Type__c,
				Amount__c,
				Reward_Status__c,
				Date_of_Purchase__c,
				Voucher_Issue_Date__c,
				Voucher_Type_Selected__c,
				Voucher_Pin__c,
				Voucher_Expiry_Date__c,
				Order_Number__c,
				Purchase_Status__c,
				Case__c,
				Account_Number__c,
				Pin_Claimed_In_Time__c
			FROM Voucher__c
			WHERE Case__c = :caseId
			ORDER BY CreatedDate DESC
		];
	}

	/**
	 * @description sends an email
	 * @param txnReference
	 * @return GetAvailableVouchers_Resp_IB_v1
	 */
	@AuraEnabled
	public static GetAvailableVouchers_Resp_IB_v1 getAvailableVouchers(String txnReference) {
		GetAvailableVouchers_Resp_IB_v1 responseBean = GetAvailableVouchers_IH_IB_v1.callGetAvailableVouchers(txnReference);
		return responseBean;
	}

	/**
	 * @description sends an email
	 * @param requestFieldsMap
	 * @return ReIssueVoucher_Resp_IB_v1
	 */
	@AuraEnabled
	public static ReIssueVoucher_Resp_IB_v1 reissueVoucherApex(Map<String, String> requestFieldsMap) {
		ReIssueVoucher_Resp_IB_v1 responseBean = ReIssueVoucher_IH_IB_v1.callReissueVoucher(requestFieldsMap);
		return responseBean;
	}

	/**
	 * @description sends an email
	 * @param requestFieldsMap
	 * @return String
	 */
	@AuraEnabled
	public static String scheduleVoucherReissueApex(Map<String, String> requestFieldsMap) {
		String hour = String.valueOf(Datetime.now().addHours(2).hour());
		String min = String.valueOf(Datetime.now().minute());
		String ss = String.valueOf(Datetime.now().second());

		//parse to cron expression
		String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
		ScheduleVoucherReIssue reissueVoucher = new ScheduleVoucherReIssue(requestFieldsMap);
		String jobId = System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, reissueVoucher);

		return jobId;
	}

	/**
	 * @description sends an email
	 * @param caseIdP
	 * @param reissueVoucherFieldValue
	 */
	@AuraEnabled
	public static void closeCaseApex(String caseIdP, String reissueVoucherFieldValue ) {
		Case cse = new Case(Id = caseIdP, Status='Closed', Reissue_Voucher__c =reissueVoucherFieldValue);
		update cse;
	}
}