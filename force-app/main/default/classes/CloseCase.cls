/**
 * @description Controller class for CloseCase cmp
 * @author Jason Quevauvilliers
 * @created 2020-11-12
 * @updated Koketso Mpshane 2021-03-18
 */
public class CloseCase {
	/**
	 * @author Jason Quevauvilliers
	 * @description send email
	 * @param caseId
	 * @param emailAddress
	 * @param emailTemplateName
	 * @param fromEmailAddress
	 * @return String
	 */
	@AuraEnabled
	public static String sendEmail(String caseId, String emailAddress, String emailTemplateName, String fromEmailAddress) {
		OrgWideEmailAddress orgWideAddress = getOrgWideEmailAddress(caseId, fromEmailAddress);
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
			/**
			 * @description Error - No OrgWideEmailAddress found
			 */
			return 'Error: Unable to find a matching Org Wide Email Address from the Email Address specified on the Service_Group__c of this Case. ';
		}
	}

	/**
	 * @author Srikanth N: 20201027
	 * @description get OrgWideEmailAddress
	 * @param caseId
	 * @param fromEmailAddress
	 * @return OrgWideEmailAddress
	 */
	public static OrgWideEmailAddress getOrgWideEmailAddress(String caseId, String fromEmailAddress) {
		String emailAddress;
		if (String.isNotBlank(fromEmailAddress)) {
			emailAddress = fromEmailAddress;
		} else {
			emailAddress = getServiceGroupResponseEmail(caseId);
		}

		List<OrgWideEmailAddress> oweaList = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :emailAddress LIMIT 1];
		if (oweaList?.size() > 0) {
			return oweaList[0];
		}
		return null;
	}

	/**
	 * @author Srikanth N: 20201027
	 * @description get Service Group Response Email
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
}